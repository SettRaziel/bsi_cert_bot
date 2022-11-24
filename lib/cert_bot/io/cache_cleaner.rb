require "time"
require_relative "csv_accessor"

module CertBot

  # This module keeps the list with already processed advisories clean by checking the content
  # of the file with this information and deleting entries that are older than 14 days. 
  # Normally the entries go back up to three days, so with regard to weekends and holidays a week
  # should suffice that entries older than that are already removed from the rss feed.
  module CacheCleaner

    # method to read a given file and clean up entries older than seven days
    # @param [Filepath] filepath the path to the file with the csv formatted advisory information
    def self.delete_old_entries(filepath)
      cache_data = read_data(filepath)
      entries = Array.new()
      last_week = Time.now() - (3600 * 24 * 14) # substract 14 days
      cache_data.each { |entry|
        if (!entry.nil? && entry.length == 2)
          entries << entry if (last_week < Time.parse(entry[1]))
        end
      }
      write_data(entries, filepath)
      nil
    end

    # method to read and return the data of the given file
    # @param [Filepath] filepath the path to the file with the csv formatted advisory information
    # @return [Array] the array with the advisory data
    def self.read_data(filepath)
      csv_accessor = CertBot::CsvAccessor.new(filepath, ";")
      csv_accessor.read_csv if filepath.file?
      csv_accessor.data
    end

    # method to write the checked data back into the file, csv formatted
    # @param [Array] entries the entries younger than 14 days, that should be stored
    # @param [Filepath] filepath the path to the file for the output
    def self.write_data(entries, filepath)
      CSV.open(filepath, "w", col_sep: ";") do |csv|
        entries.each { |entry| 
          csv << entry
        }
        nil
      end
    end

  end

end
