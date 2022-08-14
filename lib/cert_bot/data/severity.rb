module CertBot

  module Data

    module Severity

      class << self

        attr_reader :values

        def initialize
          initialize_values
          initialize_mapping
        end

        private

        attr_accessor :string_mapping

        def initialize_values
          @values = Hash.new
          @values[:low] = [:low, :medium, :high, :critical]
          @values[:medium] = [:medium, :high, :critical]
          @values[:high] = [:high, :critical]
          @values[:critical] = [:critical]
        end

        def initialize_mapping
          @string_mapping = Hash.new
          @string_mapping[:low] = ["low", "niedrig"]
          @string_mapping[:medium] = ["medium", "mittel"]
          @string_mapping[:high] = ["high", "hoch"]
          @string_mapping[:critical] = ["critical", "kritisch"]
        end

      end

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
