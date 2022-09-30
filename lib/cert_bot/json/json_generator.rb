require "rss"
require "json"
require_relative "../advisory_parser"

module CertBot

  module JsonGenerator

    def self.generate_json(item, config_path)
      wid = item.link.split("=")[1]
      timestamp = item.pubDate.localtime
      update_status = CertBot::AdvisoryParser.retrieve_update_status(wid)
      cve_list = CertBot::AdvisoryParser.retrieve_cves(wid)
      product_list = Array.new() 
      CertBot::AdvisoryParser.retrieve_affected_products(wid).each { |product|
        product_list << product["name"]
      }
      
      json_hash = Hash.new()
      json_hash[:wid] = wid
      json_hash[:title] = item.title
      json_hash[:description] = item.description
      json_hash[:hash] = item.link
      json_hash[:release] = timestamp
      json_hash[:status] = update_status
      json_hash[:cves] = cve_list
      json_hash[:affected] = product_list
      json_hash[:severity] = item.category.content

      output_string = JSON.pretty_generate(json_hash)
      if (config_path != nil)
        file = File.open(File.join(config_path,"#{wid}_#{timestamp.strftime("%Y_%m_%d_%H")}.json"), "w")
        file.write(output_string)
        file.close
      end
    end

  end

end