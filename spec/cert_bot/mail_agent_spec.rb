require "spec_helper"
require "rss"

require_relative "../../lib/cert_bot/mail_agent"

describe CertBot::MailAgent do

  describe "#send_mail" do
    context "given an advisory item and a config_file" do
      it "create the mail text for a new advisory without an error" do
        File.open(TEST_DATA.join("rss_sample").expand_path) do |rss|
          feed = RSS::Parser.parse(rss)
          allow(CertBot::MailAgent).to(receive(:call_smtp))
          CertBot::MailAgent.send_mail(feed.items[3], TEST_DATA.join("config.json").expand_path)
        end
      end
    end
  end

end
