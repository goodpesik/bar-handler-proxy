# Bar Handler Proxy
Проксі для роботи з ВчасноКаса Device Manager

# Вастановити ВчасноКаса Device Manager
Завантажте та встановіть VchasnoKasa DeviceManager для вашої операційної системи з [офіційного сайту](https://wiki-kasa.vchasno.ua/uk/DeviceManager/Start/intallation).

# Налаштування POS-термінала
Дотримуйтесь інструкцій з [офіційного сайту](https://wiki-kasa.vchasno.ua/uk/DeviceManager/Functionality/Devices/Terminals).

## Встановлення Bar Handler Proxy
Після встановлення VchasnoKasa DeviceManager та налаштування POS-термінала, необхідно встановити Bar Handler Proxy.

### Для Android (через Termux)

1. **Встановіть Termux:**:
   - Завантажте Termux з https://play.google.com/store/apps/details?id=com.termux

2. **Оновити пакети**:
   ```bash
   pkg update && pkg upgrade
   ```

3. **Встановити git**:
   ```bash
   pkg install git
   ```

4. **Клонуємо репозиторій**:
   ```bash
   git clone https://github.com/goodpesik/bar-handler-proxy.git
   cd bar-handler-proxy
   ```

5. **Зробіть скрипт виконуваним:**:
   ```bash
   chmod +x android-setup.sh
   ```

6. **Запустіть скрипт:**:
   ```bash
   ./android-setup.sh
   ```

7. **Додайте сертифікат до довірених**:
   - Встановіть сертифікат через **Settings → Security → Install Certificate → CA Certificate**.
   - Сертифікат має бути розташований у сховищі Termux: `bar-handler-proxy/certs/cert.pem`.

8. **Додайте адресу проксі до налаштувань в Bar Handler**:
   - Відкрийте **Bar Handler**.
   - Перейдіть в **Налаштування → Інтеграції**.
   - Увімкніть тоггл **Використовувати ВчасноКаса Device Manager**.
   - У поле **DeviceManager Url** вкажіть адресу проксі, яку вказано в Termux після запуску скріпта /android-setup.sh. Наприклад: `http://localhost:9999`.
   - Увімкніть тоггл **Увімкнути POS термінал** та натисніть кнопку **Перевірка статусу**, якщо все добре, покажчик поруч з **
Увімкнути POS термінал** повинен стати зеленим.
   - Після цього збережіть налаштування.
   - Тоггл **Увімкнути прінтер** наразі не працює та знаходиться в розробці.

---

### Для Windows (через WSL)

1. **Встановіть WSL**:
   - Відкрийте PowerShell (від імені адміністратора) та виконайте:
     ```bash
     wsl --install
     ```
   - Перезавантажте систему, якщо це потрібно.

2. **Встановлення пакетів**:
   - Запустіть Ubuntu (або іншу WSL-дистрибутиву) і виконайте:
     ```bash
     sudo apt update && sudo apt upgrade -y
     sudo apt install git nodejs npm openssl -y
     ```

3. **Клонуємо репозиторій**:
   ```bash
   git clone https://github.com/goodpesik/bar-handler-proxy.git
   cd bar-handler-proxy
   ```

4. **Зробіть скрипт виконуваним:**:
   ```bash
   chmod +x setup-bar-handler-proxy.sh
   ```

5. **Запустіть скрипт:**:
   ```bash
   ./setup-bar-handler-proxy.sh
   ```

6. **Додайте сертифікат до довірених у Windows**:
   - Скрипт намагається додати сертифікат автоматично через PowerShell. Якщо це не вдається:
     1. Знайдіть сертифікат: `./certs/cert.pem`.
     2. Скопіюйте його на вашу систему Windows:
        ```bash
        cp ./certs/cert.pem /mnt/c/Users/<YourUsername>/Desktop/cert.pem
        ```
     3. Відкрийте сертифікат на Windows і встановіть його:
        - Натисніть **Встановити сертифікат**.
        - Оберіть **Локальна машина**.
        - Вкажіть **Trusted Root Certification Authorities** як місце встановлення..

7. **Додайте адресу проксі до налаштувань в Bar Handler**:
   - Відкрийте **Bar Handler**.
   - Перейдіть в **Налаштування → Інтеграції**.
   - Увімкніть тоггл **Використовувати ВчасноКаса Device Manager**.
   - У поле **DeviceManager Url** вкажіть адресу проксі, яку вказано в Termux після запуску скріпта /android-setup.sh. Наприклад: `http://localhost:9999`.
   - Увімкніть тоггл **Увімкнути POS термінал** та натисніть кнопку **Перевірка статусу**, якщо все добре, покажчик поруч з **
Увімкнути POS термінал** повинен стати зеленим.
   - Після цього збережіть налаштування.
   - Тоггл **Увімкнути прінтер** наразі не працює та знаходиться в розробці.

---

# bar-handler-proxy English
Proxy from http to https to work with VchasnoKasa DeviceManager

# Install VchasnoKasa DeviceManager
Download and install VchasnoKasa DeviceManager for your OS from [official site](https://wiki-kasa.vchasno.ua/uk/DeviceManager/Start/intallation).

# Setup Pos Terminal
Please follow the instructions from [official site](https://wiki-kasa.vchasno.ua/uk/DeviceManager/Functionality/Devices/Terminals).

## Install Bar Handler Proxy
After you have installed VchasnoKasa DeviceManager and setup Pos Terminal, you need to install Bar Handler Proxy.

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

7. **Add the Certificate to Trusted Stores**:
   - Install the certificate via **Settings → Security → Install Certificate → CA Certificate**.
   - Certificate should be located at Tremux storage: `bar-handler-proxy/certs/cert.pem`.

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
   ./setup-bar-handler-proxy.sh
   ```

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

7. **Add the proxy address to the settings in Bar Handler**:
   - Open **Bar Handler**.
   - Got to **Settings → Integrations**.
   - Enable the toggle **Use VchasnoKasa Device Manager**.
   - In the **DeviceManager Url**  field, specify the proxy address provided in Termux after running the /android-setup.sh script. For example: `http://localhost:9999`.
   - Enable the toggle  **Enable POS terminal** and click the **Check Status**, button. If everything is configured correctly, the indicator next to **Enable POS terminal** should turn green.
   - After this, save the settings.
   - The toggle **Enable printer** is currently not functional and is under development.
   
---
