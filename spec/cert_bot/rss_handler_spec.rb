require "spec_helper"

require_relative "../../lib/cert_bot/rss_handler"

describe CertBot::RssHandler do

  describe ".new" do
    context "given an rss feed, severities and a config_file" do
      it "create the mail text for the rss feed without an error" do
          allow(CertBot::MailAgent).to(receive(:call_smtp))
          CertBot::RssHandler.new(TEST_DATA.join("rss_sample").expand_path, 
                                  TEST_DATA.join("config.json").expand_path,
                                  [:high, :critical])
        
        # clean up data from the test and catch errors since they should not let the test fail
        File.delete(TEST_DATA.join("debug.log"))
        File.delete(TEST_DATA.join("meta_info"))
      end
    end
  end

end
