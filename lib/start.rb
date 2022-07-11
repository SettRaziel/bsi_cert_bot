require "rss"
require "open-uri"
require "net/smtp"
require "pathname"

require_relative "configuration"

# What feed are we parsing?
rss_feed = "https://wid.cert-bund.de/content/public/securityAdvisory/rss"

config_path="../config/"

def send_mail(item, config_path)

  wid = item.link.split("=")[1]
  timestamp = item.pubDate.localtime
  config = Configuration.new(Pathname.new(config_path).join("config.json").expand_path)
  
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

  meta_path = Pathname.new(config_path).join("meta_info").expand_path
  input_wid = nil
  input_time = nil

  # fetch the timestamp and wid from the file to check when to stop
  if (meta_path.exist?)
    input = File.readlines(meta_path)
    input_wid = input[0].split(":")[1].strip
    input_time = Time.parse(input[1].split(":")[1])
  end

  feed = RSS::Parser.parse(rss)
  puts "Title: #{feed.channel.title}"
  feed.items.each { |item|
    item_wid = item.link.split("=")[1]
    if (!item_wid.eql?(input_wid) && !item.pubDate.eql?(input_time))
      if (item.category.content.eql?("hoch") || item.category.content.eql?("kritisch"))
        puts "Item: #{item.title}"
        puts "Item description: #{item.description}"
        puts "Item link: #{item.link}"
        puts "Item date: #{item.pubDate}"
        puts "Item category: #{item.category.content}"
        puts "Item WID: #{item_wid}"
        send_mail(item, config_path)
      end
    else
      break
    end
  }

  # write the youngest item in a file with its timestamp and wid to remember for the next run
  output = File.open(meta_path, mode="w+")
  first_item = feed.items.first
  output.puts("Item WID: #{first_item.link.split("=")[1]}")
  output.puts("Item date: #{first_item.pubDate.localtime}")
end
