require "rss"
require "open-uri"
require "pathname"

require_relative "csv_accessor"

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
    meta_path = Pathname.new(config_path).join("meta_info").expand_path
    csv_accessor = init_csv_accessor(meta_path)

    URI.open(rss_feed) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each { |item|
        item_wid = item.link.split("=")[1]
        item_timestamp = item.pubDate.localtime
        @debug_log.puts("Checking #{item_wid} (#{item.category.content}) at #{Time.now}")        
        if (!contains_values?(item_wid, item_timestamp, csv_accessor.data))
          if (item.category.content.eql?("hoch") || item.category.content.eql?("kritisch"))
            @debug_log.puts("Creating entry for #{item_wid} (#{item.category.content}) at #{Time.now}")
            csv_accessor.append_row( [ item_wid, item_timestamp ])
            MailAgent.send_mail(item, config_path)
          end
        end
      }

    end
  end

  def contains_values?(item_wid, item_timestamp, data)
    data.each { |line|
      return true if (line[0].eql?(item_wid) && Time.parse(line[1]).eql?(item_timestamp))
    }
    false
  end

  def init_csv_accessor(meta_path)
    csv_accessor = CsvAccessor.new(meta_path, ";")
    csv_accessor.read_csv if meta_path.file?
    csv_accessor
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
