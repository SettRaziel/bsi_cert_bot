require "net/http"
require "json"
require_relative "data"

module CertBot

  # This module queries the advisories to a given id from the rss feed to extract the 
  # additional information which are stored in the json object that is return from the api
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

    # method to retrieve the list of cves from the advisory json
    # @return [Array] an array with key-value pairs {"cveId"=>"<CVE-number>"}
    def self.retrieve_cves(wid)
      cert_json = AdvisoryParser.get_and_parse_advisory(wid)
      filter_flat_map(cert_json, "cveIdListe") {|cve_id_list| filter_flat_map(cve_id_list, "cveId") {|note| note["properties"] } }
    end

    # method to retrieve the list of affected products from the advisory json
    # @return [Array] an array with key-value pairs {"productReference"=>"<product>"}
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

    # method to retrieve the cvss values of the advisory
    # @param[String] wid the wid of the advisory
    # @return [Hash] the hash with the cvss score values
    def self.retrieve_cvss_score(wid)
      cert_json = AdvisoryParser.get_and_parse_advisory(wid)
      filter_flat_map(cert_json, "scoreListe") {|score_list|  filter_flat_map(score_list, "score") {|note| note["properties"] } }[0]
    end

    # private helper method the traverse the json and find the entries of the given type in the list
    # @param [Hash] list the subtree of the json that need to be checked to entries of the given type
    # @param [String] type the keyword that is searched for
    # @return [Array] the list with the results
    private_class_method def self.filter_flat_map(list, type) 
      list["children"].flat_map {|child| 
        yield child if (child["type"] == type) 
      }.compact
    end

  end

end
