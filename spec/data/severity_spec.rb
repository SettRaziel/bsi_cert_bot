require "spec_helper"
require_relative "../../lib/cert_bot/data"

describe CertBot::Data::Severity do

  CertBot::Data::Severity.initialize

  describe "#get_mapping" do
    context "given a severity string low" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::Severity.get_mapping_for("low")).to eq(:low)
      end
    end
  end

  describe "#get_mapping" do
    context "given a severity string niedrig" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::Severity.get_mapping_for("niedrig")).to eq(:low)
      end
    end
  end

  describe "#get_mapping" do
    context "given a severity string medium" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::Severity.get_mapping_for("medium")).to eq(:medium)
      end
    end
  end

  describe "#get_mapping" do
    context "given a severity string mittel" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::Severity.get_mapping_for("mittel")).to eq(:medium)
      end
    end
  end

  describe "#get_mapping" do
    context "given a severity string high" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::Severity.get_mapping_for("high")).to eq(:high)
      end
    end
  end

  describe "#get_mapping" do
    context "given a severity string hoch" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::Severity.get_mapping_for("hoch")).to eq(:high)
      end
    end
  end

  describe "#get_mapping" do
    context "given a severity string critical" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::Severity.get_mapping_for("critical")).to eq(:critical)
      end
    end
  end

  describe "#get_mapping" do
    context "given a severity string kritisch" do
      it "give string to data class an retrive corresponding symbol" do
        expect(CertBot::Data::Severity.get_mapping_for("kritisch")).to eq(:critical)
      end
    end
  end

  describe "#values" do
    context "given a severity low" do
      it "give symbol to values hash an retrive severity array" do
        expect(CertBot::Data::Severity.values[:low]).to eq([:low, :medium, :high, :critical])
      end
    end
  end

  describe "#values" do
    context "given a severity medium" do
      it "give symbol to values hash an retrive severity array" do
        expect(CertBot::Data::Severity.values[:medium]).to eq([:medium, :high, :critical])
      end
    end
  end

  describe "#values" do
    context "given a severity high" do
      it "give symbol to values hash an retrive severity array" do
        expect(CertBot::Data::Severity.values[:high]).to eq([:high, :critical])
      end
    end
  end

  describe "#values" do
    context "given a severity critical" do
      it "give symbol to values hash an retrive severity array" do
        expect(CertBot::Data::Severity.values[:critical]).to eq([:critical])
      end
    end
  end

end
