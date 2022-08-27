require "spec_helper"
require_relative "../../lib/cert_bot/data"

describe CertBot::Data::UpdateStatus do

  CertBot::Data::UpdateStatus.initialize

  describe "#get_mapping" do
    context "given an update status string New" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::UpdateStatus.get_mapping_for("New")).to eq(:new)
      end
    end
  end

  describe "#get_mapping" do
    context "given an update status string Update" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::UpdateStatus.get_mapping_for("Update")).to eq(:update)
      end
    end
  end

  describe "#get_mapping" do
    context "given an update status string Silent-Update" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::UpdateStatus.get_mapping_for("Silent-Update")).to eq(:silent_update)
      end
    end
  end

end
