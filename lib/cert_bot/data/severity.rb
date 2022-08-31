module CertBot

  module Data

    # This module holds the severity rating defined by the BSI
    module Severity

      # Data class to holds the values and the mapping from its string representation
      class << self

        # @return [Hash] the mapping severity to all rating higher of equal to the value
        attr_reader :values

        # initialization of the static mapping values
        def initialize
          initialize_values
          initialize_mapping
        end

        private

        # @return [Hash] the mapping from severity to its string representation
        attr_accessor :string_mapping

        # initializes the value hash
        def initialize_values
          @values = Hash.new
          @values[:low] = [:low, :medium, :high, :critical]
          @values[:medium] = [:medium, :high, :critical]
          @values[:high] = [:high, :critical]
          @values[:critical] = [:critical]
          nil
        end

        # initializes the mapping hash
        def initialize_mapping
          @string_mapping = Hash.new
          @string_mapping[:low] = ["low", "niedrig"]
          @string_mapping[:medium] = ["medium", "mittel"]
          @string_mapping[:high] = ["high", "hoch"]
          @string_mapping[:critical] = ["critical", "kritisch"]
          nil
        end

      end

      # module method to retrieve the severity symbol to the given severity string
      # @return [Symbol] returns the severity symbol or nil if the string could not be found
      def self.get_mapping_for(severity_string)
        initialize if (@string_mapping.eql?(nil))
        @string_mapping.each_pair { |key, value|
          return key if (value.include?(severity_string))
        }
        nil
      end

    end

  end

end
