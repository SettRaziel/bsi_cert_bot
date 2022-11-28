require "spec_helper"

require_relative "../../lib/cert_bot/configuration"

describe CertBot::Configuration do

  describe ".new" do
    context "given a file with config data" do
      it "read the json data and set the attributes without an error" do
        json_hash = Hash.new()
        json_hash["address"]  = "example.com"
        json_hash["port"]     = "587"
        json_hash["helo"]     = "me@example.com"
        json_hash["user"]     = "me"
        json_hash["password"] = "password"
        json_hash["from"]     = "me@example.com"
        json_hash["to"]       = "you@example.com"
        json_hash["authtype"] = "md5"

        JSON.pretty_generate(json_hash)
        file = File.open("configuration.json", "w")
        file.write(JSON.pretty_generate(json_hash))
        file.close

        configuration = CertBot::Configuration.new("configuration.json")
        expect(configuration.config_hash["authtype"]).to eq(:cram_md5)

        File.delete("configuration.json")
      end
    end
  end

end
