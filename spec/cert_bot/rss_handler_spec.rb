require "spec_helper"

require_relative "../../lib/cert_bot/rss_handler"

describe CertBot::RssHandler do

  describe ".read_feed" do
    context "given an rss feed, severities and a config_file" do
      it "create the mail text for the rss feed without an error" do
        allow(CertBot::MailAgent).to(receive(:call_smtp))
        rss_handler = CertBot::RssHandler.new(TEST_DATA.join("rss_sample").expand_path, 
                                TEST_DATA.join("config.json").expand_path)
        rss_handler.read_feed([:high, :critical], nil)
        csv_accessor = CertBot::CsvAccessor.new(TEST_DATA.join("meta_info"), ";")
        csv_accessor.read_csv
        expect(csv_accessor.data.length).to eq(2)

        
        # clean up data from the test and catch errors since they should not let the test fail
        File.delete(TEST_DATA.join("debug.log"))
        File.delete(TEST_DATA.join("meta_info"))
      end
    end
  end

  describe ".read_feed" do
    context "given an rss feed, severities, a config_file and the flag to parse all advisories" do
      it "create the mail text for the rss feed without an error" do
        allow(CertBot::MailAgent).to(receive(:call_smtp))
        rss_handler = CertBot::RssHandler.new(TEST_DATA.join("rss_sample").expand_path, 
                                TEST_DATA.join("config.json").expand_path)
        rss_handler.read_feed([:high, :critical], true)
        csv_accessor = CertBot::CsvAccessor.new(TEST_DATA.join("meta_info"), ";")
        csv_accessor.read_csv
        expect(csv_accessor.data.length).to eq(15)

        
        # clean up data from the test and catch errors since they should not let the test fail
        File.delete(TEST_DATA.join("debug.log"))
        File.delete(TEST_DATA.join("meta_info"))
      end
    end
  end


end
