require "rss"
require "open-uri"
require "pathname"

class RssHandler

  def initialize(rss_feed, config_path)
    @debug_log = File.open(Pathname.new(config_path).join("debug.log").expand_path, mode="a")
    @debug_log.puts("Starting rss parsing at #{Time.now}.")
    read_feed(rss_feed, config_path)
    @debug_log.puts("Finishing rss parsing at #{Time.now}.")
    @debug_log.puts
    @debug_log.close
  end

  private

  attr_accessor :debug_log

  def read_feed(rss_feed, config_path)
    URI.open(rss_feed) do |rss|
      meta_path = Pathname.new(config_path).join("meta_info").expand_path
      meta_data = read_meta_data(meta_path)

      feed = RSS::Parser.parse(rss)
      feed.items.each { |item|
        item_wid = item.link.split("=")[1]
        @debug_log.puts("Checking #{item_wid} (#{item.category.content}) at #{Time.now}")        
        if (!item_wid.eql?(meta_data.wid) && !item.pubDate.eql?(meta_data.timestamp))
          if (item.category.content.eql?("hoch") || item.category.content.eql?("kritisch"))
            @debug_log.puts("Creating entry for #{item_wid} (#{item.category.content}) at #{Time.now}")
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
    @debug_log.puts("Writing meta data for delta at #{Time.now}:")
    @debug_log.puts("Saved WID: #{item.link.split("=")[1]}")
    @debug_log.puts("Saved Date: #{item.pubDate.localtime}")
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
