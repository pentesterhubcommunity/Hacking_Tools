require 'open-uri'
require 'nokogiri'
require 'uri'
require 'net/http'

def collect_parameters(url)
  uri = URI(url)
  response = open(uri)
  document = Nokogiri::HTML(response)
  
  forms = document.css('form')
  forms.each do |form|
    form.attributes.each do |_, attr|
      next unless attr.name == 'action' && !attr.value.start_with?('http')
      
      action_url = URI.join(uri, attr.value).to_s
      form_uri = URI(action_url)
      
      puts "Form action URL: #{action_url}"
      puts "Form method: #{form['method']}"
      
      form.css('input[type="text"], input[type="hidden"]').each do |input|
        parameter = input['name']
        puts "Parameter: #{parameter}"
        
        # Inject additional parameter
        inject_parameter(form_uri, parameter)
      end
    end
  end
end

def inject_parameter(form_uri, parameter)
  uri = URI(form_uri)
  
  # Create a new HTTP POST request with the injected parameter
  request = Net::HTTP::Post.new(uri)
  request.set_form_data({ parameter => "injected_value" })
  
  # Send the request and print the response
  response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(request)
  end
  
  puts "Injected parameter response: #{response.code} #{response.message}"
end

puts "Enter the URL of the target website:"
target_url = gets.chomp

collect_parameters(target_url)
