#!/data/data/com.termux/files/usr/bin/bash

# Default configuration
PORT=3939
CERT_DIR="certs"
CERT_FILE="$CERT_DIR/cert.pem"
KEY_FILE="$CERT_DIR/key.pem"

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
x509_extensions    = v3_req
prompt             = no

[req_distinguished_name]
C  = US
ST = State
L  = City
O  = Organization
OU = Unit
CN = localhost

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
EOF

# Generate self-signed certificate with SAN
echo "Checking for certificates..."
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
  echo "Generating self-signed certificate with SAN..."
  openssl genrsa -out "$KEY_FILE" 2048
  openssl req -new -x509 -days 365 -key "$KEY_FILE" -out "$CERT_FILE" -config "$OPENSSL_CNF"
  echo "Certificate generated. Please add it to your Android trusted store."
  echo "1. Copy $CERT_FILE to your Android storage:"
  echo "   cp $CERT_FILE /storage/emulated/0/cert.pem"
  echo "2. Go to Settings > Security > Install certificate and select cert.pem."
else
  echo "Certificates already exist. Skipping generation."
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
    key: fs.readFileSync('${CERT_DIR}/key.pem'),
    cert: fs.readFileSync('${CERT_DIR}/cert.pem'),
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
