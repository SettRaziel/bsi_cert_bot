require "rss"
require "open-uri"
require "pathname"

require_relative "mail_agent"
require_relative "io"
require_relative "data"
require_relative "advisory_parser"
require_relative "json/json_generator"

module CertBot

  # This class handles the fetching, reading and parsing of the BSI rss feed
  class RssHandler

    # initialization
    # @param [String] rss_feed the url to the rss feed
    # @param [String] config_file the file path to the configuration file
    def initialize(rss_feed, config_file)
      @config_path = Pathname.new(config_file).dirname.expand_path
      @rss_feed = rss_feed
      @config_file = config_file

      if (CertBot.parameter_handler != nil && CertBot.parameter_handler.repository.parameters[:debug])
        @debug_log = File.open(@config_path.join("debug.log"), mode="a")
      end
    end

    # method to parse the feed and generate mails for the required items
    # @param [Array] severities the list of severities that should be parsed from the feed
    # @param [Bool] is_updated true if the parameter was set, nil otherwise
    def read_feed(severities, is_updated)
      write_debug_log("Starting rss parsing at #{Time.now}.")
      meta_path = Pathname.new(@config_path).join("meta_info").expand_path
      csv_accessor = init_csv_accessor(meta_path)

      URI(@rss_feed).open do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each { |item|
          item_wid = item.link.split("=")[1]
          write_debug_log("Checking #{item_wid} (#{item.category.content}) at #{Time.now}")        
          if (contraints_fulfilled(item, csv_accessor.data, severities, is_updated))
            write_debug_log("Creating entry for #{item_wid} (#{item.category.content}) at #{Time.now}")
            csv_accessor.append_row([ item_wid, item.pubDate.localtime ])
            process_item(item, config_file)
          end
        }

        days_oldest_entry = ((Time.now - feed.items.last.pubDate.localtime)/ (3600 *24)).ceil
        CertBot::CacheCleaner.delete_old_entries(meta_path, days_oldest_entry)
      end

      write_debug_log("Finishing rss parsing at #{Time.now}.\n")
      if (CertBot.parameter_handler != nil && CertBot.parameter_handler.repository.parameters[:debug])
        @debug_log.close
      end
      nil
    end

    private

    # @return [Pathname] the pathname to the configuration file
    attr_accessor :config_path
    # @return [File] the file object to where debug output is written
    attr_accessor :debug_log
    # @return [String] the URI to the rss feed
    attr_accessor :rss_feed
    # @return [String] the string path to the config.json
    attr_accessor :config_file

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
    # @return [CertBot::CsvAccessor] the CsvAccessor object that wrapps the read data
    def init_csv_accessor(meta_path)
      csv_accessor = CertBot::CsvAccessor.new(meta_path, ";")
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

    # method to determine if all constraints for sending a mail are fulfilled
    # @param [RSS:Item] item the current rss item
    # @param [Array] csv_data the list of items that already have been processed in previous script calls
    # @param [Array] severities the list of severities that needs to be sent
    # @param [Bool] is_updated true if the parameter was set, nil otherwise
    # @return [Bool] the boolean that shows if the contraints are fulfilled of not
    def contraints_fulfilled(item, csv_data, severities, is_updated)
      item_wid = item.link.split("=")[1]
      return false if (contains_values?(item_wid, item.pubDate.localtime, csv_data))
      return false if (!contains_severity?(severities, item.category.content))
      if (is_updated == nil)
        update_status = CertBot::AdvisoryParser.retrieve_update_status(item_wid)
        return false if (CertBot::Data::UpdateStatus.get_mapping_for(update_status) != :new)
      end
      true
    end

    # method to generate the required output for a given item of the rss feed
    # @param [RSS:Item] item the rss item for a feed entry
    # @param [String] config_file the file path to the configuration file
    def process_item(item, config_file)
      if (CertBot.parameter_handler != nil && CertBot.parameter_handler.repository.parameters[:json] != nil)
        output_dir = Pathname.new(CertBot.parameter_handler.repository.parameters[:json])
        CertBot::JsonGenerator.generate_json(item, output_dir.expand_path)
      else
        CertBot::MailAgent.send_mail(item, config_file)      
      end
      nil
    end

    # method to write a given debug text into the logfile if the debug parameter is set
    # @param [String] log_text the logging string
    def write_debug_log(log_text)
      if (CertBot.parameter_handler != nil && CertBot.parameter_handler.repository.parameters[:debug])
        @debug_log.puts(log_text)
      end
      nil
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

end
