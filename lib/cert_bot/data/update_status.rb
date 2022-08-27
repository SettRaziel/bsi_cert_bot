module CertBot

  module Data

    module UpdateStatus

      class << self

        def initialize
          initialize_mapping
        end

        private

        attr_accessor :string_mapping

        def initialize_mapping
          @string_mapping = Hash.new
          @string_mapping["New"] = :new
          @string_mapping["Update"] = :update
          @string_mapping["Silent-Update"] = :silent_update
        end

      end

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
