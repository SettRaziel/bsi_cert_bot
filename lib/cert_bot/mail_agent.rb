require "net/smtp"

require_relative "configuration"
require_relative "advisory_parser"

module CertBot

  # Module to handle the mail creation and propagation of the message for a given rss item
  module MailAgent

    # method to generate a mail for a given item of the rss feed
    # @param [RSS:Item] item the rss item for a feed entry
    # @param [String] config_file the file path to the configuration file
    # @return [String] them mail message
    def self.send_mail(item, config_file)
      wid = item.link.split("=")[1]
      timestamp = item.pubDate.localtime
      config = CertBot::Configuration.new(Pathname.new(config_file))
      update_status = CertBot::AdvisoryParser.retrieve_update_status(wid)
      
      message = "From: CERT RSS <#{config.config_hash["from"]}>\n"
      message.concat("To: #{config.config_hash["to"]}\n")
      message.concat("Subject: CERT Report (#{wid}) - #{item.title.split(":")[0]}\n\n")
      message.concat(create_introduction_string(update_status))
      message.concat("Title: #{item.title}\n")
      message.concat("Description: #{item.description}\n")
      message.concat("Link: #{item.link}\n")
      message.concat("Date: #{timestamp}\n")
      message.concat("Status: #{update_status}\n")
      message.concat("#{retrieve_cves(wid)}")
      message.concat("\n#{retrieve_affected_products(wid)}")
      message.concat("Severity: #{item.category.content}\n")
      message.concat("WID: #{wid}\n\n")
      message.concat("Best wishes,\n")
      message.concat("Your CERT Bot.")

      call_smtp(message, config)
      message
    end

    # private method to create the mail introduction based on the update state of the advisory
    # @param [Symbol] update_status the update status of the advisory
    # @return [String] the output string for the mail text
    private_class_method def self.create_introduction_string(update_status)
      if (CertBot::Data::UpdateStatus.get_mapping_for(update_status) == :new)
        return "Our CERT RSS Feed received a new security advisory:\n\n"
      end
      "Our CERT RSS Feed received an updated security advisory:\n\n"
    end

    # private method to retrieve the cves and put them into the output string to the mail
    # @param [String] wid the id of the advisory
    # @return [String] the output string for the mail text
    private_class_method def self.retrieve_cves(wid)
      cve_list = CertBot::AdvisoryParser.retrieve_cves(wid)

      cves = "CVEs:"
      counter = 0
      cve_list.each { |cve_id|
        cves.concat(" ").concat(cve_id["cveId"])
        counter += 1

        # write only 5 cve per line then make linebreak
        if (counter == 5)
          cves.concat("\n")
          5.times { cves.concat(" ") }
          counter = 0
        end
      }
      cves
    end 

    # private method to retrieve the affected products and put them into the output string to the mail
    # @param [String] wid the id of the advisory
    # @return [String] the output string for the mail text
    private_class_method def self.retrieve_affected_products(wid)
      product_list = CertBot::AdvisoryParser.retrieve_affected_products(wid)

      affected_products = "Affected versions:\n"
      product_list.each { |product|
        6.times { affected_products.concat(" ") }
        affected_products.concat(product["name"]).concat("\n")
      }
      affected_products
    end

    private_class_method def self.call_smtp(message, config)
      Net::SMTP.start(config.config_hash["address"], config.config_hash["port"], config.config_hash["helo"], 
                      config.config_hash["user"], config.config_hash["password"], :plain) do |smtp|
        smtp.send_message(message, config.config_hash["from"], config.config_hash["to"])
      end
      nil
    end

  end

end
