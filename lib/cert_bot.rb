require_relative "cert_bot/parameter"
require_relative "cert_bot/rss_handler"
require_relative "cert_bot/data"
require_relative "cert_bot/help/help_output"

# This module is the main entry point and will be called from the main forecast script
module CertBot
  
  # Dummy class to get access to the instance variables
  class << self

    # @return [Parameter::ParameterHandler] the handler controlling the parameters
    attr_reader :parameter_handler

    # main entry point and initialization
    # @param [Array] arguments the input values from the terminal input ARGV
    def initialize(arguments)
      @parameter_handler = Parameter::ParameterHandler.new(arguments)
      CertBot::Data::Severity.initialize
      CertBot::Data::UpdateStatus.initialize
    end

    private

    # method the check if the given parameter has been set
    # @param [Symbol] symbol the symbol representation of the parameter to check
    # @return [boolean] the boolean information if the symbol is in the repository
    def contains_parameter?(symbol)
      @parameter_handler != nil && @parameter_handler.repository.parameters[symbol] != nil
    end

  end

  # main entry point that requires the parameter repository to be filled
  # the method reads the required parameter and generates the mail
  def self.parse_rss
      if (!contains_parameter?(:help) && !contains_parameter?(:version))
        rss_feed = "https://wid.cert-bund.de/content/public/securityAdvisory/rss"
        config_file = @parameter_handler.repository.parameters[:file]
        severity = CertBot::Data::Severity.
                   get_mapping_for(@parameter_handler.repository.parameters[:severity])
        severity = :medium if (severity.nil?)
        severities = CertBot::Data::Severity.values[severity]
        rss_handler = CertBot::RssHandler.new(rss_feed, config_file)
        rss_handler.read_feed(severities, @parameter_handler.repository.parameters[:updated])
      end
  end

  # call to print the help text
  def self.print_help
    if (contains_parameter?(:help))
      CertBot::HelpOutput.print_help_for(@parameter_handler.repository.parameters[:help])
    else
      print_error("Error: Module not initialized. Run CertBot.new(ARGV)")
    end
    nil
  end

  # call to print version number and author
  def self.print_version
    puts "cert_bot version 0.4.0".yellow
    puts "Created by Benjamin Held (Juli 2022)".yellow
    nil
  end

  # call for standard error output
  # @param [String] message message string with error message
  def self.print_error(message)
    puts "#{message}".red
    puts "For help type: ruby <script> --help".green
    nil
  end

end
