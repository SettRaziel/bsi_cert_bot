require "spec_helper"

require_relative "../../lib/cert_bot/rss_handler"

describe CertBot do

  describe "#print_error" do
    context "given the module" do
      it "print the error text for the uninitialized arguments" do
        expect {
          arguments = ["-s", "high", "--file", TEST_DATA.join("config.json").to_s]
          CertBot.initialize(arguments)
          CertBot.print_help
        }.to output("Error: Module not initialized. Run CertBot.new(ARGV)".red + "\n" + \
                    "For help type: ruby <script> --help".green + "\n").to_stdout
      end
    end
  end

  describe "#parse_rss" do
    context "(internet) given runtime parameters for the script" do
      it "start the script and create messages without an error" do
        arguments = ["-s", "high", "--file", TEST_DATA.join("config.json").to_s]
        CertBot.initialize(arguments)
        allow(CertBot::MailAgent).to(receive(:call_smtp))

        CertBot.parse_rss

        # clean up data from the test and catch errors since they should not let the test fail
        File.delete(TEST_DATA.join("meta_info"))
      end
    end
  end

  describe "#parse_rss" do
    context "(internet) given runtime parameters for the script with json parameter" do
      it "start the script and create messages without an error" do
        arguments = ["-s", "high", "--json", TEST_DATA.expand_path, "--file", TEST_DATA.join("config.json").to_s]
        CertBot.initialize(arguments)
        CertBot.parse_rss

        # clean up data from the test and catch errors since they should not let the test fail
        File.delete(TEST_DATA.join("meta_info"))
        Dir[File.join(TEST_DATA, 'WID-SEC-*.json')].each { |file| File.delete(file) }
      end
    end
  end

  describe "#print_version" do
    context "given the module" do
      it "print the version text" do
        expect {
          arguments = ["--version"]
          CertBot.initialize(arguments)
          CertBot.print_version
        }.to output("cert_bot version 0.3.0".yellow + "\n" + \
                    "Created by Benjamin Held (Juli 2022)".yellow + "\n").to_stdout
      end
    end
  end

  describe "#print_help" do
    context "given the module" do
      it "print the help text for the given argument" do
        expect {
          arguments = ["-s", "--help"]
          CertBot.initialize(arguments)
          CertBot.print_help
        }.to output("CERT bot help:".light_yellow + "\n" + \
                    " -s, --severity  ".light_blue + "argument:".red + " <severity>".yellow  + \
                    "; specifies the severity threshold when a severity should sent an e-mail\n").to_stdout
      end
    end
  end

end
