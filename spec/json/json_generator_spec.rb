require "spec_helper"
require "rss"
require_relative "../../lib/cert_bot/json/json_generator"

describe CertBot::JsonGenerator do
  
  describe ".generate_json" do
    context "given an advisory item" do
      it "read it and create the correct json output" do
        File.open(TEST_DATA.join("rss_sample").expand_path) do |rss|
          feed = RSS::Parser.parse(rss)
          CertBot::JsonGenerator.generate_json(feed.items[3], TEST_DATA.expand_path)
        end
        expect(FileUtils.compare_file(File.join(TEST_DATA.expand_path,"WID-SEC-2022-1251_2022_09_01_13.json"), 
                                      File.join(TEST_DATA.expand_path,"expected_output.json"))).to be_truthy

        # clean up data from the test and catch errors since they should not let the test fail
        File.delete(File.join(TEST_DATA.expand_path,"WID-SEC-2022-1251_2022_09_01_13.json"))
      end
    end
  end

end
