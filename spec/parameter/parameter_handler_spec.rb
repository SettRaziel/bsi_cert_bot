require "spec_helper"
require_relative "../../lib/cert_bot/parameter"

describe CertBot::Parameter::ParameterHandler do

  describe ".new" do
    context "given the date flag" do
      it "create the repository and pass the parameter contrains" do
        arguments = ["--file", "filename"]
        parameter_handler = CertBot::Parameter::ParameterHandler.new(arguments)
      end
    end
  end

end
