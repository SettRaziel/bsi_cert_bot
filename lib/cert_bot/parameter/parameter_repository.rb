module CertBot

  # Parent module which holdes the classes dealing with reading and validating
  # the provided input parameters
  module Parameter

    # Parameter repository to store the valid parameters of the script.
    # {#initialize} gets the provided parameters and fills a hash which
    # grants access to the provided parameters and arguments.
    class ParameterRepository < RubyUtils::Parameter::BaseParameterRepository

      private

      # method to read further argument and process it depending on its content
      # @param [String] arg the given argument
      def process_argument(arg)
        case arg
          when *@mapping[:debug] then @parameters[:debug] = true
          when *@mapping[:json] then create_argument_entry(:json)
          when *@mapping[:severity] then create_argument_entry(:severity)
          when *@mapping[:updated] then @parameters[:updated] = true
        else
          raise_invalid_parameter(arg)
        end
        nil
      end

      # method to define the input string values that will match a given paramter symbol
      def define_mapping
        @mapping[:debug] = ["-d", "--debug"]
        @mapping[:json] = ["-j", "--json"]
        @mapping[:severity] = ["-s", "--severity"]
        @mapping[:updated] = ["-u", "--updated"]
      end

    end

  end

end
