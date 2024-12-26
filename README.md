# bar-handler-proxy
Proxy from http to https to work with VchasnoKasa and Checkbox DeviceManager

# HTTPS Proxy Setup Script

This script sets up an HTTPS proxy server for local development, allowing you to access a local HTTP server over HTTPS. It automatically generates a self-signed certificate and configures the environment for:
- Linux
- Windows (via WSL)
- Android (via Termux)

## Installation and Usage

### For Android (via Termux)

1. **Install Termux**:
   - Download Termux from https://play.google.com/store/apps/details?id=com.termux

2. **Update Termux Packages**:
   ```bash
   pkg update && pkg upgrade
   ```

3. **Install Required Packages**:
   ```bash
   pkg install git
   ```

4. **Clone the Repository**:
   ```bash
   git clone https://github.com/goodpesik/bar-handler-proxy.git
   cd bar-handler-proxy
   ```

5. **Make the Script Executable**:
   ```bash
   chmod +x android-setup.sh
   ```

6. **Run the Script**:
   ```bash
   ./android-setup.sh
   ```
   - Replace `[port]` with the port your local server is running on (default: `3939`).

7. **Add the Certificate to Trusted Stores**:
   - Install the certificate via **Settings → Security → Install Certificate**.

---

### For Windows (via WSL)

1. **Install WSL**:
   - Open PowerShell (as Administrator) and run:
     ```bash
     wsl --install
     ```
   - Restart your system if prompted.

2. **Install Required Packages**:
   - Launch Ubuntu (or another WSL distribution) and run:
     ```bash
     sudo apt update && sudo apt upgrade -y
     sudo apt install git nodejs npm openssl -y
     ```

3. **Clone the Repository**:
   ```bash
   git clone https://github.com/goodpesik/bar-handler-proxy.git
   cd bar-handler-proxy
   ```

4. **Make the Script Executable**:
   ```bash
   chmod +x setup-bar-handler-proxy.sh
   ```

5. **Run the Script**:
   ```bash
   ./setup-bar-handler-proxy.sh [port]
   ```
   - Replace `[port]` with the port your local server is running on (default: `3939`).

6. **Add the Certificate to Windows Trusted Store**:
   - The script attempts to add the certificate automatically via PowerShell. If it fails:
     1. Locate the certificate: `./certs/cert.pem`.
     2. Copy it to your Windows system:
        ```bash
        cp ./certs/cert.pem /mnt/c/Users/<YourUsername>/Desktop/cert.pem
        ```
     3. Open the certificate file on Windows and install it:
        - Click **Install Certificate**.
        - Choose **Local Machine**.
        - Select **Trusted Root Certification Authorities** as the destination.

7. **Access the Proxy**:
   Open your browser and navigate to:
   ```
   https://<your-WSL-IP>
   ```
   - The script detects and displays the WSL IP during execution.

---

## Troubleshooting

### Common Issues
1. **Browser Warning (Certificate Invalid):**
   - Ensure the certificate was added to the trusted store on your device.
   - Verify the correct IP address is used during the certificate generation.

2. **ERR_SSL_KEY_USAGE_INCOMPATIBLE:**
   - Ensure the script generates the certificate with proper `keyUsage` and `extendedKeyUsage` fields.

3. **Windows Certificate Not Recognized:**
   - Manually install the certificate as described in the "Add the Certificate to Trusted Stores" section.

### Verifying the Proxy
Test the HTTPS proxy from your terminal:
```bash
curl -k https://<your-ip-address>
```

---
