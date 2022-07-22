require_relative "mail_agent"
require_relative "rss_handler"

# What feed are we parsing?
rss_feed = "https://wid.cert-bund.de/content/public/securityAdvisory/rss"

config_path ="../config/"

RssHandler.new(rss_feed, config_path)
