require "rss"
require "json"
require_relative "../advisory_parser"

module CertBot

  # Simple module to generate a JSON object with the relvevant information of an advisory item
  module JsonGenerator

    # Method to generate a JSON Object for the advisory item and write it to the config path
    # @param [RSS:Item] item an advisory item from the rss feed
    # @param [Pathname] output_path the path where the json object should be stored
    def self.generate_json(item, output_path)
      wid = item.link.split("=")[1]
      timestamp = item.pubDate.localtime
      update_status = CertBot::AdvisoryParser.retrieve_update_status(wid)
      cve_list = CertBot::AdvisoryParser.retrieve_cves(wid)
      cvss_entry = CertBot::AdvisoryParser.retrieve_cvss_score(wid)
      product_list = Array.new() 
      CertBot::AdvisoryParser.retrieve_affected_products(wid).each { |product|
        product_attributes = Hash.new()
        product_attributes["name"] = product["name"]
        product_attributes["cpeversion"] = product["cpeversion"]
        product_attributes["cpeproduct"] = product["cpeproduct"]
        product_list << product_attributes
      }
      
      json_hash = Hash.new()
      json_hash[:wid] = wid
      json_hash[:title] = item.title
      json_hash[:description] = item.description
      json_hash[:link] = item.link
      json_hash[:release] = timestamp
      json_hash[:status] = update_status
      json_hash[:cves] = cve_list
      json_hash[:cvss] = cvss_entry["temporalscore"]/10.0
      json_hash[:affected] = product_list
      json_hash[:severity] = item.category.content

      output_string = JSON.pretty_generate(json_hash)
      if (output_path != nil)
        file = File.open(File.join(output_path,"#{wid}_#{timestamp.strftime("%Y_%m_%d_%H")}.json"), "w")
        file.write(output_string)
        file.close
      end
      nil
    end

  end

end
