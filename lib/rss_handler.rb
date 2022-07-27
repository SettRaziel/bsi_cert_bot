require "rss"
require "open-uri"
require "pathname"

class RssHandler

  def initialize(rss_feed, config_path)
    read_feed(rss_feed, config_path)    
  end

  private

  def read_feed(rss_feed, config_path)
    URI.open(rss_feed) do |rss|
      meta_path = Pathname.new(config_path).join("meta_info").expand_path
      meta_data = read_meta_data(meta_path)

      feed = RSS::Parser.parse(rss)
      puts "Title: #{feed.channel.title}"
      feed.items.each { |item|
        item_wid = item.link.split("=")[1]
        if (!item_wid.eql?(meta_data.wid) && !item.pubDate.eql?(meta_data.timestamp))
          if (item.category.content.eql?("hoch") || item.category.content.eql?("kritisch"))
            puts "Item: #{item.title}"
            puts "Item description: #{item.description}"
            puts "Item link: #{item.link}"
            puts "Item date: #{item.pubDate}"
            puts "Item category: #{item.category.content}"
            puts "Item WID: #{item_wid}"
            MailAgent.send_mail(item, config_path)
          end
        else
          break
        end
      }

      write_meta_data(meta_path, feed.items.first)
    end
  end

  def read_meta_data(meta_path)
    if (meta_path.exist?)
      input = File.readlines(meta_path)
      return MetaData.new(input[0].split(":")[1].strip,
                   Time.parse(input[1].split(":")[1]))
    end
    MetaData.new()
  end
  
  def write_meta_data(meta_path, item)
    output = File.open(meta_path, mode="w+")
    output.puts("Item WID: #{item.link.split("=")[1]}")
    output.puts("Item date: #{item.pubDate.localtime}")
    output.close
    puts "Saved WID: #{item.link.split("=")[1]}"
    puts "Saved Date: #{item.pubDate.localtime}"
    nil
  end

end

class MetaData

  attr_accessor :wid
  attr_accessor :timestamp

  def initialize(wid = nil, timestamp = nil)
    @wid = wid
    @timestamp = timestamp
  end

end
