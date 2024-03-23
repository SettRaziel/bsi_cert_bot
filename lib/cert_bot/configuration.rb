require "ruby_utils/configuration"

module CertBot

  # Simple data class to store the json parameter
  class Configuration < RubyUtils::Configuration::BaseConfigurationRepository

    private

    # method to check if the required keys are available in the json hash
    # and check for optional ones
    # @raise KeyError if a given key is missing in the config hash
    def check_config_keys
      required_config_key_available?("address")
      required_config_key_available?("port")
      required_config_key_available?("helo")
      required_config_key_available?("from")
      required_config_key_available?("to")
      determine_authtype
      determine_tls_veryfication
    end

    # method to determine if the authtype is set and set its value based on the input
    def determine_authtype
      case @config_hash["authtype"]
        when "login" then @config_hash["authtype"] = :login
        when "md5" then @config_hash["authtype"] = :cram_md5
      else 
        @config_hash["authtype"] = :plain
      end
    end

    # method to determine if the tls flag is set and set its value based on the input
    def determine_tls_veryfication
      case @config_hash["tls_verify"]
        when "false" then @config_hash["tls_verify"] = false
      else 
        @config_hash["tls_verify"] = true
      end
    end

  end

end
