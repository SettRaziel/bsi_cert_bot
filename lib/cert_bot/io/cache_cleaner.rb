require "time"
require_relative "csv_accessor"

module CertBot

  module CacheCleaner

    def self.delete_old_entries(filepath)
      cache_data = read_data(filepath)
      entries = Array.new()
      last_week = Time.now() - (3600 * 24 * 7) # substract 7 days
      cache_data.each { |entry|
        entries << entry if (last_week < Time.parse(entry[1]))
      }
      write_data(entries, filepath)
    end

    def self.read_data(filepath)
      csv_accessor = CertBot::CsvAccessor.new(filepath, ";")
      csv_accessor.read_csv if filepath.file?
      csv_accessor.data
    end

    def self.write_data(entries, filepath)
      CSV.open(filepath, "w", col_sep: ";") do |csv|
        entries.each { |entry| 
          csv << entry
        }
      end
    end

  end

end
