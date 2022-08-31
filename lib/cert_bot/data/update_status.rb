module CertBot

  module Data

    # This module holds the update status defined by the BSI
    module UpdateStatus

      # Data class to holds the mapping from update status to its string representation
      class << self

        # initialization of the static mapping values
        def initialize
          initialize_mapping
        end

        private

        # @return [Hash] the mapping from update status to its string representation
        attr_accessor :string_mapping

        # initializes the mapping hash
        def initialize_mapping
          @string_mapping = Hash.new
          @string_mapping["New"] = :new
          @string_mapping["Update"] = :update
          @string_mapping["Silent-Update"] = :silent_update
          nil
        end

      end

      # module method to retrieve the severity symbol to the given severity string
      # @return [Symbol] returns the severity symbol or nil if the string could not be found
      def self.get_mapping_for(update_status)
        initialize if (@string_mapping.eql?(nil))
        @string_mapping.each_pair { |key, value|
          return value if (key.eql?(update_status))
        }
        nil
      end

    end

  end

end
