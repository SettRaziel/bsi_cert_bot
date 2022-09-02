require "ruby_utils/base_help_output"

module CertBot

  # Output class for help text
  class HelpOutput < RubyUtils::BaseHelpOutput

    private

    # method to specify and add the help entries with help text only
    def self.add_single_help_entries
      nil
    end

    # method to specify and add the help entries with help text and one argument
    def self.add_one_argument_help_entries
      add_single_argument_text(:file, " -f, --file      ", " <filename>",
            "; parameter that indicates a filepath to the config json file")
      add_single_argument_text(:severity, " -s, --severity  ", " <severity>",
            "; specifies the severity threshold when a severity should sent an e-mail")
      nil
    end

    # method to specify and add the help entries with help text and two arguments
    def self.add_two_argument_help_entries
      nil
    end

    # method to print the header of the help output
    def self.print_help_head
      puts "script usage:".red + " ruby <script> [parameters] -f <filename>"
      puts "help usage :".green + "              ruby <script> (-h | --help)"
      puts "help usage for parameter:".green +
           " ruby <script> <parameter> (-h | --help)"
      puts "#{get_script_name} help:".light_yellow
    end

    # method to print the invalid parameter combinations
    def self.print_invalid_combinations
      nil
    end

    # method to print the available configuration parameter
    def self.print_configuration_parameter
      nil
    end

      # method to set the name of the script project
    def self.get_script_name
      "CERT bot"
    end
    
  end

end
