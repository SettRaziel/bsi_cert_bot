require "json"

module CertBot

  # Simple data class to store the json parameter
  class Configuration

    # @return [Hash] the hash with the hashes of the given json file  
    attr_reader :config_hash

    # initialization
    # @param [Pathname] config_path the filepath the the json configuration file
    def initialize(config_path)
      @config_hash = JSON.load(File.read(config_path))
      check_config_keys
    end

    private

    # method to check if the given keys are available in the json hash
    # @raise KeyError if a given key is missing in the config hash
    def check_config_keys
      raise KeyError, "JSON key address missing"   if (@config_hash["address"] == nil)
      raise KeyError, "JSON key port missing"      if (@config_hash["port"]  == nil)
      raise KeyError, "JSON key helo missing"      if (@config_hash["helo"]  == nil)
      raise KeyError, "JSON key user missing"      if (@config_hash["user"]  == nil)
      raise KeyError, "JSON key password missing"  if (@config_hash["password"]  == nil)
      raise KeyError, "JSON key from missing"      if (@config_hash["from"]  == nil)
      raise KeyError, "JSON key to missing"        if (@config_hash["to"]  == nil)
    end

  end

end
