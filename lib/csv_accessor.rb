require "csv"

# Simple file reader using the csv library to read a csv file
# requires csv
# @raise [IOError] if csv throws an exception
class CsvAccessor

  # @return [Array] an array containing the read data
  attr_reader :data

  # initialization
  # @param [String] filename filepath of the file which should be read
  # @param [String] delimiter the column delimiter that is need to read the file
  def initialize(filename, delimiter)
    @filename = filename
    @delimiter = delimiter
    @data = Array.new
  end

  # @raise [IOError] if an error occurs while the file is read
  def read_csv
    begin
      @data = CSV.read(@filename, col_sep: @delimiter)
      # remove nil entries
      @data.each { |line|
        line.compact!
      }
    rescue StandardError => e
      raise IOError, e.message.concat(".")
    end
  end

  # method to append a row at the end of the data file
  # @param [Array] row_entries the entries for the csv file
  def append_row(row_entries)
    CSV.open(@filename, "a", col_sep: @delimiter) do |csv|
      csv << row_entries
    end
  end

  private

  attr_reader :filename
  # @return [String] the delimiter character
  attr_reader :delimiter

end
