#!/data/data/com.termux/files/usr/bin/bash

# Default configuration
PORT=3939
CERT_DIR="certs"
CA_CERT_FILE="$CERT_DIR/ca_cert.pem"
CA_KEY_FILE="$CERT_DIR/ca_key.pem"
SERVER_CERT_FILE="$CERT_DIR/server_cert.pem"
SERVER_KEY_FILE="$CERT_DIR/server_key.pem"
SERVER_CSR_FILE="$CERT_DIR/server_csr.pem"
OPENSSL_CNF="$CERT_DIR/openssl.cnf"

# Check for provided port
if [ ! -z "$1" ]; then
  PORT=$1
else
  echo "No port specified. Using default port $PORT."
fi

# Ensure system is up to date
echo "Updating system..."
pkg update && pkg upgrade -y

# Install required packages
echo "Installing dependencies..."
pkg install -y nodejs openssl

# Generate OpenSSL configuration file
echo "Creating OpenSSL configuration file..."
mkdir -p $CERT_DIR
cat > "$OPENSSL_CNF" << 'EOF'
[req]
default_bits       = 2048
default_md         = sha256
distinguished_name = req_distinguished_name
x509_extensions    = v3_ca
prompt             = no

[req_distinguished_name]
C  = US
ST = State
L  = City
O  = Organization
OU = Unit
CN = Custom CA

[v3_ca]
subjectAltName = @alt_names
basicConstraints = critical,CA:true
keyUsage = critical,keyCertSign,cRLSign

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
EOF

# Generate CA certificate
echo "Checking for CA certificates..."
if [ ! -f "$CA_CERT_FILE" ] || [ ! -f "$CA_KEY_FILE" ]; then
  echo "Generating self-signed CA certificate..."
  openssl genrsa -out "$CA_KEY_FILE" 2048
  openssl req -new -x509 -days 365 -key "$CA_KEY_FILE" -out "$CA_CERT_FILE" -config "$OPENSSL_CNF" -extensions v3_ca
  echo "CA certificate generated."
else
  echo "CA certificates already exist. Skipping generation."
fi

# Generate server certificate
if [ ! -f "$SERVER_CERT_FILE" ] || [ ! -f "$SERVER_KEY_FILE" ]; then
  echo "Generating server certificate..."
  openssl req -new -nodes -newkey rsa:2048 -keyout "$SERVER_KEY_FILE" -out "$SERVER_CSR_FILE" -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"
  openssl x509 -req -in "$SERVER_CSR_FILE" -CA "$CA_CERT_FILE" -CAkey "$CA_KEY_FILE" -CAcreateserial -out "$SERVER_CERT_FILE" -days 365 -extfile <(printf "subjectAltName=DNS:localhost,IP:127.0.0.1") -extensions v3_req
  echo "Server certificate generated and signed by CA."
else
  echo "Server certificates already exist. Skipping generation."
fi

# Create simple HTTPS proxy server
IP_ADDRESS="localhost"
PROXY_SCRIPT="https-proxy.js"
cat <<EOL > https-proxy.js
const fs = require('fs');
const https = require('https');
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

app.use('/', createProxyMiddleware({
    target: 'http://localhost:$PORT',
    changeOrigin: true,
    secure: false,
}));

const httpsOptions = {
    key: fs.readFileSync('./certs/server_key.pem'),
    cert: fs.readFileSync('./certs/server_cert.pem'),
    ca: fs.readFileSync('./certs/ca_cert.pem')
};

https.createServer(httpsOptions, app).listen(9999, '0.0.0.0', () => {
    console.log('Put this address inside barHandler settings $IP_ADDRESS:9999');
});
EOL

echo "Installing Node.js dependencies..."
npm install http-proxy http-proxy-middleware express

# Start the HTTPS proxy server
echo "Starting HTTPS proxy server on port $PORT..."
node $PROXY_SCRIPT
