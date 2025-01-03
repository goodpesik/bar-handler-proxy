#!/bin/bash

if [ -z "$1" ]; then
    echo "No port specified. Using default port 3939."
    PORT=3939
else
    PORT=$1
    echo "Using specified port: $PORT"
fi

OS_TYPE=$(uname)
IS_ANDROID=false
IS_WSL=false
IP_ADDRESS="localhost"

if [[ "$OS_TYPE" == "Linux" ]]; then
    if [[ "$(uname -o)" == "Android" ]]; then
        IS_ANDROID=true
        echo "Detected Android system."
    elif grep -qE "Microsoft|WSL" /proc/version; then
        IS_WSL=true
        echo "Detected WSL system."
        # Отримання IP-адреси для WSL
        IP_ADDRESS=$(hostname -I | awk '{print $1}')
        echo "Detected WSL IP address: $IP_ADDRESS"
    else
        echo "Detected Linux system."
    fi
elif [[ "$OS_TYPE" == "Windows_NT" ]]; then
    echo "Detected Windows system via WSL."
else
    echo "Unsupported OS: $OS_TYPE"
    exit 1
fi

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing Node.js..."
sudo apt install -y nodejs npm openssl

echo "Generating self-signed certificate for $IP_ADDRESS..."
CERT_DIR="./certs"
mkdir -p $CERT_DIR

cat > cert_config.cnf <<EOL
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = $IP_ADDRESS

[v3_req]
keyUsage = critical, keyEncipherment, digitalSignature
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
IP.1 = $IP_ADDRESS
EOL

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $CERT_DIR/key.pem \
    -out $CERT_DIR/cert.pem \
    -config cert_config.cnf

if [[ "$IS_ANDROID" == true ]]; then
    echo "Android detected. Please manually add the certificate to your trusted store:"
    echo "1. Copy the cert.pem to your Android storage:"
    echo "   cp $CERT_DIR/cert.pem /storage/emulated/0/cert.pem"
    echo "2. Go to Settings > Security > Install certificate, and select cert.pem."
elif [[ "$IS_WSL" == true ]]; then
    echo "Adding certificate to Windows trusted store (via WSL)..."
    powershell.exe -Command "Start-Process powershell -Verb runAs -ArgumentList 'Import-Certificate -FilePath \"$(wslpath -w $PWD/$CERT_DIR/cert.pem)\" -CertStoreLocation Cert:\\LocalMachine\\Root'" 2>&1 | tee add_cert.log
    echo "Check add_cert.log for details if the operation fails."
elif [[ "$OS_TYPE" == "Linux" ]]; then
    echo "Adding certificate to trusted store on Linux..."
    sudo cp $CERT_DIR/cert.pem /usr/local/share/ca-certificates/localhost.crt
    sudo update-ca-certificates
else
    echo "Unsupported system for automatic certificate installation."
    exit 1
fi

echo "Setting up HTTPS proxy server..."

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
npm install express http-proxy-middleware

echo "Starting HTTPS proxy server..."
node https-proxy.js
