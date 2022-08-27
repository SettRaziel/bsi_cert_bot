require "net/http"
require "json"
require_relative "data"

module CertBot

  module AdvisoryParser

    # method to retrieve the json object of the advisory
    # @param[String] wid the wid of the advisory
    # @return [Hash] the json hash of the advisory
    def self.get_and_parse_advisory(wid)
      uuid_url = "https://wid.cert-bund.de/content/public/securityAdvisory/kurzinfo-uuid-by-name/#{wid}"
      wid_request = Net::HTTP.get(URI(uuid_url))
      cert_url = "https://wid.cert-bund.de/content/public/content/#{JSON.parse(wid_request)}"
      cert_request = Net::HTTP.get(URI(cert_url))
      JSON.parse(cert_request)
    end

    def self.retrieve_cves(wid)
      cert_json = AdvisoryParser.get_and_parse_advisory(wid)
      filter_flat_map(cert_json, "cveIdListe") {|cve_id_list| filter_flat_map(cve_id_list, "cveId") {|note| note["properties"] } }
    end

    def self.retrieve_affected_products(wid)
      cert_json = AdvisoryParser.get_and_parse_advisory(wid)
      filter_flat_map(cert_json, "productReferenceListe") {|cve_id_list| filter_flat_map(cve_id_list, "productReference") {|note| note["properties"] } }
    end

    # method to retrieve the update status of the advisory
    # @param[String] wid the wid of the advisory
    # @return [String] the string of the property update type
    def self.retrieve_update_status(wid)
      cert_json = AdvisoryParser.get_and_parse_advisory(wid)
      cert_json["properties"]["updatetype"]
    end

    private_class_method def self.filter_flat_map(list, type) 
      list["children"].flat_map {|child| 
        yield child if (child["type"] == type) 
      }.compact
    end

  end

end
