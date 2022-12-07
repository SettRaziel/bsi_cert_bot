require "spec_helper"
require_relative "../../lib/cert_bot/parameter"

describe CertBot::Parameter::ParameterRepository do

  describe ".new" do
    context "given only the filename" do
      it "create the repository with the correct filename" do
        arguments = ["--file", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:file]).to eq("filename")
      end
    end
  end

  describe ".new" do
    context "given the json flag" do
      it "create the repository with the correct flags" do
        arguments = ["-j", "--file", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:json]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the json flag" do
      it "create the repository with the correct flags" do
        arguments = ["--json", "--file", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:json]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the debug flag" do
      it "create the repository with the correct flags" do
        arguments = ["-d", "--file", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:debug]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the debug flag" do
      it "create the repository with the correct flags" do
        arguments = ["--debug", "--file", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:debug]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the updated flag" do
      it "create the repository with the correct flags" do
        arguments = ["-u", "--file", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:updated]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the updated flag" do
      it "create the repository with the correct flags" do
        arguments = ["--updated", "--file", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:updated]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given no arguments for the initialization" do
      it "raise an argument error" do
        arguments = [ ]
        expect { 
          CertBot::Parameter::ParameterRepository.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given an invalid parameter" do
      it "raise an argument error" do
        arguments = ["test", "-f", "filename"]
        expect { 
          CertBot::Parameter::ParameterRepository.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given an invalid parameter" do
      it "raise an argument error" do
        arguments = ["-1", "--file", "filename"]
        expect { 
          CertBot::Parameter::ParameterRepository.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given an invalid parameter" do
      it "raise an argument error" do
        arguments = ["--error", "-f", "filename"]
        expect { 
          CertBot::Parameter::ParameterRepository.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the version flag as parameter" do
      it "set the flag for version output" do
        arguments = ["-v", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:version]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the version flag as parameter" do
      it "set the flag for version output" do
        arguments = ["--version", "-f", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:version]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the help flag as parameter" do
      it "set the flag for help output" do
        arguments = ["-h", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:help]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the help flag with the date parameter" do
      it "set the flag for help output with the date" do
        arguments = ["-s", "-h", "--file", "filename"]
        parameter_repository = CertBot::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:help]).to eq(:severity)
      end
    end
  end

end
