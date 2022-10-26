require "spec_helper"
require_relative "../../lib/cert_bot/advisory_parser"

describe CertBot::AdvisoryParser do

  describe "#get_and_parse_advisory" do
    context "(internet) given a wid number for a advisory" do
      it "call rest apis and get the json object for the advisory" do
        advisory_json = CertBot::AdvisoryParser.get_and_parse_advisory("WID-SEC-2022-0666")
        expect(advisory_json.class).to eq(Hash)
      end
    end
  end

  describe "#retrieve_cves" do
    context "(internet) given a wid number for a advisory" do
      it "call rest apis and get the cve hash for the advisory" do
        cve_list = CertBot::AdvisoryParser.retrieve_cves("WID-SEC-2022-0666")
        expect(cve_list.length).to eq(1)
        expect(cve_list[0]["cveId"]).to eq("CVE-2022-2211")
      end
    end
  end

  describe "#retrieve_affected_products" do
    context "(internet) given a wid number for a advisory" do
      it "call rest apis and get the product hash for the advisory" do
        product_list = CertBot::AdvisoryParser.retrieve_affected_products("WID-SEC-2022-0666")
        expect(product_list.length).to eq(2)
        expect(product_list[1]["name"]).to eq("Open Source libguestfs < 1.48")
        expect(product_list[0]["name"]).to eq("SUSE Linux")
      end
    end
  end

  describe "#retrieve_update_status" do
    context "(internet) given a wid number for a advisory" do
      it "call rest apis and get the update status for the advisory" do
        update_status = CertBot::AdvisoryParser.retrieve_update_status("WID-SEC-2022-0666")
        expect(update_status).to eq("Update")
      end
    end
  end

end
