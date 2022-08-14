require_relative "mail_agent"
require_relative "cert_bot/parameter"
require_relative "rss_handler"

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

    end

    private

    # method the check if the given parameter has been set
    def contains_parameter?(symbol)
      @parameter_handler.repository.parameters[symbol] != nil
    end

  end

  def self.parse_rss
      if (!parameter_handler.repository.parameters[:help] && 
          !parameter_handler.repository.parameters[:version])
        rss_feed = "https://wid.cert-bund.de/content/public/securityAdvisory/rss"
        config_file = @parameter_handler.repository.parameters[:file]
        RssHandler.new(rss_feed, config_file)
      end
  end

  # call to print the help text
  def self.print_help
    if (@parameter_handler != nil && @parameter_handler.repository.parameters[:help] != nil)
      WrfForecast::HelpOutput.print_help_for(@parameter_handler.repository.parameters[:help])
    else
      print_error("Error: Module not initialized. Run WrfForecast.new(ARGV)")
    end
    nil
  end

  # call to print version number and author
  def self.print_version
    puts "cert_bot version 0.1.0".yellow
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

  private_class_method def self.determine_json_output
   ## todo
  end

end
