require "rss"
require "open-uri"
require "net/smtp"
require_relative "configuration"

# What feed are we parsing?
rss_feed = "https://wid.cert-bund.de/content/public/securityAdvisory/rss"

def send_mail(item)

  wid = item.link.split("=")[1]
  timestamp = item.pubDate.localtime
  config = Configuration.new("../config/config.json")
  
  message = "From: CERT RSS <#{config.config_hash["from"]}>\n"
  message.concat("To: #{config.config_hash["to"]}\n")
  message.concat("Subject: CERT Report (#{wid})\n\n")
  message.concat("Our CERT RSS Feed received a new security advisory:\n\n")
  message.concat("Title: #{item.title}\n")
  message.concat("Description: #{item.description}\n")
  message.concat("Link: #{item.link}\n")
  message.concat("Date: #{timestamp}\n")
  message.concat("Severity: #{item.category.content}\n")
  message.concat("WID: #{wid}\n\n")
  message.concat("Best wishes,\n")
  message.concat("Your CERT Bot.")
  
  Net::SMTP.start(config.config_hash["address"], config.config_hash["port"], config.config_hash["helo"], 
                  config.config_hash["user"], config.config_hash["password"], :plain) do |smtp|
    smtp.send_message(message, config.config_hash["from"], config.config_hash["to"])
  end
end

URI.open(rss_feed) do |rss|
  feed = RSS::Parser.parse(rss)
  puts "Title: #{feed.channel.title}"
  feed.items.each { |item|
    puts "Item: #{item.title}"
    puts "Item description: #{item.description}"
    puts "Item link: #{item.link}"
    puts "Item date: #{item.pubDate}"
    puts "Item category: #{item.category.content}"
    puts "Item WID: #{item.link.split("=")[1]}"
    send_mail(item)
  }
end
