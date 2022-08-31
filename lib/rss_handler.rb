require "rss"
require "open-uri"
require "pathname"

require_relative "csv_accessor"
require_relative "cert_bot/data"

# This class handles the fetching, reading and parsing of the BSI rss feed
class RssHandler

  # initialization
  # @param [String] rss_feed the url to the rss feed
  # @param [String] config_file the file path to the configuration file
  # @param [Array] severities the list of severities that should be parsed from the feed
  def initialize(rss_feed, config_file, severities)
    @config_path = Pathname.new(config_file).dirname.expand_path
    @debug_log = File.open(@config_path.join("debug.log"), mode="a")
    @debug_log.puts("Starting rss parsing at #{Time.now}.")
    read_feed(rss_feed, config_file, severities)
    @debug_log.puts("Finishing rss parsing at #{Time.now}.")
    @debug_log.puts
    @debug_log.close
  end

  private

  # @return [Pathname] the pathname to the configuration file
  attr_accessor :config_path
  # @return [File] the file object to where debug output is written
  attr_accessor :debug_log

  # method to parse the feed and generate mails for the required items
  # @param [String] rss_feed the url to the rss feed
  # @param [String] config_file the file path to the configuration file
  # @param [Array] severities the list of severities that should be parsed from the feed
  def read_feed(rss_feed, config_file, severities)
    csv_accessor = init_csv_accessor(Pathname.new(@config_path).join("meta_info").expand_path)

    URI.open(rss_feed) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each { |item|
        item_wid = item.link.split("=")[1]
        item_timestamp = item.pubDate.localtime
        @debug_log.puts("Checking #{item_wid} (#{item.category.content}) at #{Time.now}")        
        if (!contains_values?(item_wid, item_timestamp, csv_accessor.data))
          if (contains_severity?(severities, item.category.content))
            @debug_log.puts("Creating entry for #{item_wid} (#{item.category.content}) at #{Time.now}")
            csv_accessor.append_row( [ item_wid, item_timestamp ])
            MailAgent.send_mail(item, config_file)
          end
        end
      }
    end
    nil
  end

  # method to check if a advisory already has been mailed
  # @param [String] item_wid the id of the advisory
  # @param [Time] item_timestamp the creation time of the advisory
  # @param [Array] data the list of items that already have been processed in previous script calls
  def contains_values?(item_wid, item_timestamp, data)
    data.each { |line|
      return true if (line[0].eql?(item_wid) && Time.parse(line[1]).eql?(item_timestamp))
    }
    false
  end

  # method to initialize the csv and read the data from the meta data filepath
  # @param [Strig] meta_path the file path to the meta data
  # @return [Array] an array containing the data within the file
  def init_csv_accessor(meta_path)
    csv_accessor = CsvAccessor.new(meta_path, ";")
    csv_accessor.read_csv if meta_path.file?
    csv_accessor
  end

  # method to determine if severity is contained in the severity list
  # @param [Array] categories the list of severities that needs to be sent
  # @param [String] severity_string the severity string from the rss item
  # @return [Boolean] true, if the given severity is contained within the categories
  def contains_severity?(categories, severity_string)
    categories.include?(CertBot::Data::Severity.get_mapping_for(severity_string))
  end

end

# Helper data class to store identifying information for a advisory into an object
class MetaData

  # @return [String] the id of the advisory
  attr_accessor :wid
  # @return [Time] the timestamp when the advisory was created
  attr_accessor :timestamp

  # initialization
  # @param [String] wid the id of the advisory
  # @param [Time] timestamp the creation time of the advisory
  def initialize(wid = nil, timestamp = nil)
    @wid = wid
    @timestamp = timestamp
  end

end
