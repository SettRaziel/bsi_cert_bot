require "spec_helper"
require_relative "../../lib/cert_bot/help/help_output"

describe CertBot::HelpOutput do

  describe "#print_help_for" do
    context "given a simple help entry" do
      it "print the help text for :json" do
        expect { 
          CertBot::HelpOutput.print_help_for(:json) 
        }.to output("CERT bot help:".light_yellow + "\n" + \
                    " -j, --json      ".light_blue +  \
                    "writes advisories as json objects into a file instead of sending an e-mail\n").to_stdout
      end
    end
  end

  describe "#print_help_for" do
    context "given a simple help entry" do
      it "print the help text for :debug" do
        expect { 
          CertBot::HelpOutput.print_help_for(:debug) 
        }.to output("CERT bot help:".light_yellow + "\n" + \
                    " -d, --debug     ".light_blue +  \
                    "script call does additional debug logging\n").to_stdout
      end
    end
  end

  describe "#print_help_for" do
    context "given a simple help entry" do
      it "print the help text for :updated" do
        expect { 
          CertBot::HelpOutput.print_help_for(:updated) 
        }.to output("CERT bot help:".light_yellow + "\n" + \
                    " -u, --updated   ".light_blue +  \
                    "also sends an e-mail for updated advisories\n").to_stdout
      end
    end
  end

  describe "#print_help_for" do
    context "given a one element help entry" do
      it "print the help text for :severity" do
        expect { 
          CertBot::HelpOutput.print_help_for(:severity) 
        }.to output("CERT bot help:".light_yellow + "\n" + \
                    " -s, --severity  ".light_blue + "argument:".red + " <severity>".yellow  + \
                    "; specifies the severity threshold when a severity should sent an e-mail\n").to_stdout
      end
    end
  end

  describe "#print_help_for" do
    context "given a one element help entry" do
      it "print the help text for :file" do
        expect { 
          CertBot::HelpOutput.print_help_for(:file) 
        }.to output("CERT bot help:".light_yellow + "\n" + \
                    " -f, --file      ".light_blue + "argument:".red + " <filename>".yellow  + \
                    "; parameter that indicates a filepath to the config json file\n").to_stdout
      end
    end
  end

  describe "#print_help_for" do
    context "given a to whole help text" do
      it "print the help text for the script" do
        expect { 
          CertBot::HelpOutput.print_help_for(true)
        }.to output("script usage:".red + " ruby <script> [parameters] -f <filename>\n" + \
                    "help usage :".green + "              ruby <script> (-h | --help)\n" + \
                    "help usage for parameter:".green + " ruby <script> <parameter> (-h | --help)\n" + \
                    "CERT bot help:".light_yellow + "\n" + \
                    " -h, --help      ".light_blue + "show help text\n" + \
                    " -v, --version   ".light_blue + "prints the current version of the project\n" + \
                    " -f, --file      ".light_blue + "argument:".red + " <filename>".yellow + \
                    "; parameter that indicates a filepath to the config json file\n" + \
                    " -u, --updated   ".light_blue +  \
                    "also sends an e-mail for updated advisories\n" + \
                    " -j, --json      ".light_blue +  \
                    "writes advisories as json objects into a file instead of sending an e-mail\n" + \
                    " -d, --debug     ".light_blue +  \
                    "script call does additional debug logging\n" + \
                    " -s, --severity  ".light_blue + "argument:".red + " <severity>".yellow  + \
                    "; specifies the severity threshold when a severity should sent an e-mail\n").to_stdout
      end
    end
  end  

end
