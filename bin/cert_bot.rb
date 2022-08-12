require 'ruby_utils/string'
require_relative '../lib/cert_bot'

begin
  CertBot.initialize(ARGV)
  parameter_handler = CertBot.parameter_handler
  
  if (parameter_handler.repository.parameters[:help])
    CertBot.print_help
  elsif (parameter_handler.repository.parameters[:version])
    CertBot.print_version
  else
    CertBot.parse_rss
  end

rescue StandardError, NotImplementedError => e
  CertBot.print_error(e.message)
end
