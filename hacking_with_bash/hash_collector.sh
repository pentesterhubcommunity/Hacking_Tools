#!/bin/bash
# This is a comment
rm hashes.txt
# ANSI color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to collect password hashes and files
collect_password_hashes() {
    echo "Collecting Password Hashes and Files..."
    # Create a new file to store hashes
    hash_file="hashes.txt"
    > "$hash_file" # Clear content or create if doesn't exist
    # Read each line (password hash) from the downloaded files
    while IFS= read -r hash; do
        echo "$hash" >> "$hash_file"
    done < "$1"
    # Append password files or lines to the hashes file
    cat "$@" >> "$hash_file"
}

# Function to determine hash mode based on hash length
get_hash_mode() {
    local hash_length=$1
    case $hash_length in
        32) echo 0 ;; # MD5
        40) echo 100 ;; # SHA1
        64) echo 1000 ;; # SHA-256
        96) echo 1400 ;; # SHA-384
        128) echo 1700 ;; # SHA-512
        56) echo 6000 ;; # HMAC-SHA-224
        80) echo 6100 ;; # HMAC-SHA-256
        112) echo 6300 ;; # HMAC-SHA-384
        144) echo 6400 ;; # HMAC-SHA-512
        16) echo 900 ;; # MD4
        64) echo 110 ;; # MySQL
        16) echo 130 ;; # MSSQL
        40) echo 132 ;; # MSSQL(2000)
        64) echo 135 ;; # MSSQL(2005)
        64) echo 131 ;; # MSSQL(2012)
        128) echo 136 ;; # MSSQL(2014)
        96) echo 1450 ;; # SHA-1(Base64)
        43) echo 1711 ;; # SIPHASH
        56) echo 1712 ;; # HMAC-SHA1 (SIPHASH)
        32) echo 1722 ;; # Django(SHA-1)
        60) echo 1722 ;; # Django(SHA-1)
        32) echo 1731 ;; # SIPHASH
        96) echo 1732 ;; # HMAC-SHA1 (SIPHASH)
        40) echo 1810 ;; # sha1(LinkedIn)
        128) echo 2100 ;; # Domain Cached Credentials
        20) echo 2200 ;; # Plaintext
        32) echo 2611 ;; # vBulletin < v3.8.5
        40) echo 2711 ;; # vBulletin >= v3.8.5
        64) echo 2811 ;; # IPMI2 RAKP HMAC-SHA1
        32) echo 3711 ;; # vBulletin < v3.8.5
        40) echo 3711 ;; # vBulletin >= v3.8.5
        10) echo 10000 ;; # bcrypt
        13) echo 10100 ;; # bcrypt
        20) echo 10200 ;; # bcrypt
        16) echo 10300 ;; # bcrypt
        16) echo 111 ;; # MSSQL(2012)
        20) echo 112 ;; # MSSQL(2012)
        24) echo 113 ;; # MSSQL(2012)
        16) echo 114 ;; # MSSQL(2012)
        32) echo 115 ;; # MSSQL(2012)
        40) echo 116 ;; # MSSQL(2012)
        56) echo 117 ;; # MSSQL(2012)
        32) echo 121 ;; # MSSQL(2012)
        48) echo 122 ;; # MSSQL(2012)
        64) echo 123 ;; # MSSQL(2012)
        80) echo 124 ;; # MSSQL(2012)
        96) echo 125 ;; # MSSQL(2012)
        112) echo 131 ;; # MSSQL(2012)
        128) echo 132 ;; # MSSQL(2012)
        144) echo 133 ;; # MSSQL(2012)
        160) echo 134 ;; # MSSQL(2012)
        176) echo 135 ;; # MSSQL(2012)
        192) echo 136 ;; # MSSQL(2012)
        16) echo 141 ;; # vBulletin < v3.8.5
        32) echo 142 ;; # vBulletin < v3.8.5
        40) echo 143 ;; # vBulletin < v3.8.5
        50) echo 144 ;; # vBulletin < v3.8.5
        64) echo 1711 ;; # SIPHASH
        *)
            echo "Unsupported hash algorithm."
            exit 1
            ;;
    esac
}

# Function to perform Weak Password Storage detection and cracking
detect_and_crack_weak_passwords() {
    echo "Detecting and Attempting to Crack Weak Passwords..."
    while IFS= read -r hash; do
        # Get hash mode based on hash length
        hash_length=${#hash}
        hash_mode=$(get_hash_mode "$hash_length")
        if [ "$hash_mode" = "Unsupported hash algorithm." ]; then
            echo "$hash_mode"
            continue
        fi
        # Check if the hash is too short to be secure (MD5 or SHA1)
        if [ $hash_mode -le 100 ]; then
            echo -e "${RED}Weak Password Storage detected:${NC} $hash (MD5 or SHA1)"
            # Attempt to crack the hash using hashcat
            hashcat -m $hash_mode "$hash_file" /usr/share/wordlists/rockyou.txt.gz
        else
            echo -e "${GREEN}Password Storage seems secure:${NC} $hash"
        fi
    done < "$hash_file"
}

# Main function
main() {
    echo "Weak Password Storage Detection and Password Cracking Tool"
    echo "-----------------------------------------------------------"

    # Prompt the user to enter the target website link
    read -p "Enter your target website link: " website

    # Validate input
    if [ -z "$website" ]; then
        echo "Website link cannot be empty."
        exit 1
    fi

    # Create a temporary directory to store downloaded files
    tmp_dir=$(mktemp -d)
    
    # Download the website recursively
    echo "Downloading website recursively..."
    wget --recursive --level=1 --no-directories --no-parent -P "$tmp_dir" "$website"

    # Collect password hashes and files
    collect_password_hashes "$tmp_dir"/*

    # Perform Weak Password Storage detection and cracking on collected hashes
    detect_and_crack_weak_passwords

    # Clean up temporary directory
    rm -rf "$tmp_dir"
}

# Call main function
main

cat hashes.txt
