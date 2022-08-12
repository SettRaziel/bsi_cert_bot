require "net/smtp"

require_relative "configuration"
require_relative "advisory_parser"

module MailAgent

  def self.send_mail(item, config_file)
    wid = item.link.split("=")[1]
    timestamp = item.pubDate.localtime
    config = Configuration.new(Pathname.new(config_file))
    
    message = "From: CERT RSS <#{config.config_hash["from"]}>\n"
    message.concat("To: #{config.config_hash["to"]}\n")
    message.concat("Subject: CERT Report (#{wid}) - #{item.title.split(":")[0]}\n\n")
    message.concat("Our CERT RSS Feed received a new security advisory:\n\n")
    message.concat("Title: #{item.title}\n")
    message.concat("Description: #{item.description}\n")
    message.concat("Link: #{item.link}\n")
    message.concat("Date: #{timestamp}\n")
    message.concat("#{retrieve_cves(wid)}\n")
    message.concat("#{retrieve_affected_products(wid)}")
    message.concat("Severity: #{item.category.content}\n")
    message.concat("WID: #{wid}\n\n")
    message.concat("Best wishes,\n")
    message.concat("Your CERT Bot.")

    Net::SMTP.start(config.config_hash["address"], config.config_hash["port"], config.config_hash["helo"], 
                    config.config_hash["user"], config.config_hash["password"], :plain) do |smtp|
      smtp.send_message(message, config.config_hash["from"], config.config_hash["to"])
    end
    nil
  end

  private_class_method def self.retrieve_cves(wid)
    cve_list = AdvisoryParser.retrieve_cves(wid)

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

  private_class_method def self.retrieve_affected_products(wid)
    product_list = AdvisoryParser.retrieve_affected_products(wid)

    affected_products = "Affected versions:\n"
    product_list.each { |product|
      6.times { affected_products.concat(" ") }
      affected_products.concat(product["name"]).concat("\n")
    }
    affected_products
  end 

end
