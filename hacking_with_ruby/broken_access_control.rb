#!/usr/bin/env ruby

# Prompt user for target URL
print "Enter your target URL: "
target_url = gets.chomp

# Define additional test commands
test_commands = [
    "curl -s -o /dev/null -w '%{http_code}' #{target_url}",
    "curl -X POST -s -o /dev/null -w '%{http_code}' #{target_url}",
    "curl -X PUT -s -o /dev/null -w '%{http_code}' #{target_url}",
    "curl -X DELETE -s -o /dev/null -w '%{http_code}' #{target_url}",
    "curl -X OPTIONS -s -o /dev/null -w '%{http_code}' #{target_url}",
    "curl -X TRACE -s -o /dev/null -w '%{http_code}' #{target_url}",
    "curl -X HEAD -s -o /dev/null -w '%{http_code}' #{target_url}",
    "curl -X CONNECT -s -o /dev/null -w '%{http_code}' #{target_url}",
    "wget -q --method=HEAD -O /dev/null #{target_url}",
    "nc -z -v #{target_url} 80",
    "sqlmap -u #{target_url} --batch --random-agent",
    "nmap -p 1-65535 #{target_url}",
    "nikto -h #{target_url}",
    "dirb #{target_url}",
    "wpscan --url #{target_url}",
    "gobuster dns -d #{target_url} -w /usr/share/wordlists/dirbuster/dns-Jhaddix.txt",
    "amass enum -d #{target_url}",
    "wfuzz -c --hc 404 -w /usr/share/wordlists/wfuzz/general/common.txt #{target_url}/FUZZ",
    "hydra -L /usr/share/wordlists/metasploit/http_default_userpass.txt -P /usr/share/wordlists/metasploit/http_default_pass.txt #{target_url} http-get /",
    "git clone --recursive #{target_url}",
    "svn checkout #{target_url}",
    "testssl.sh #{target_url}",
    "nikto -host #{target_url}",
    "uniscan -u #{target_url} -qweds",
    "whatweb #{target_url}",
    "dotdotpwn -m http -h #{target_url}",
    "sslscan --no-failed #{target_url}",
    "nmap -sV --script=banner #{target_url}",
    "nmap --script=http-enum #{target_url}",
    "sqlmap -u #{target_url} --forms --batch --random-agent",
    "nikto -host #{target_url} -Tuning 10",
    "dirsearch -u #{target_url} -w /usr/share/wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt -e html,php,asp,aspx,jsp,do,action,xml",
    "wafw00f #{target_url}",
    "nuclei -target #{target_url} -t /path/to/nuclei-templates",
    "snmp-check #{target_url}",
    "smtp-user-enum -M VRFY -U /usr/share/wordlists/metasploit/unix_users.txt -t #{target_url}",
    "ike-scan #{target_url}"
]

# Perform tests
puts "Performing broken access control test..."
test_commands.each do |command|
    puts "Command: #{command}"
    system(command)
    puts
end

puts "Broken access control test completed."
