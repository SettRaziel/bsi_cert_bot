require "spec_helper"
require_relative "../../lib/cert_bot/io"

describe CertBot::CacheCleaner do

  describe "#delete_old_entries" do
    context "given a csv file path" do
      it "open the file, read its data and delete entries older then a week" do
        CertBot::CacheCleaner.delete_old_entries(TEST_DATA.join("meta_cache").expand_path)
        file = File.open(TEST_DATA.join("meta_cache").expand_path)
        expect(file.readlines.size).to eq(7)
      end
    end
  end

end
