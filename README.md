# BSI CERT RSS Bot
Simple Mailbot that checks the BSI CERT RSS feed and parses CERT 
reports to be send to the given mail address.

## Installation
* check for ruby and bundler on the target machine
* clone the repository
* run `bundle install` to get the required gems
* setup config.json
* run main script `ruby cert_bot.rb -f <path_to_config.json>` in the bin directory

## Usage
```
script usage: ruby <script> [parameters] -f <filename>
Parameter:
 -f, --file      argument: <config_file>; file path to the json file with the required configuration parameter
 -s, --severity  argument: <severity>; optional string to define the severity from which advirsories should be send {"low", "medium", "high", "critical"}
```

## Configuration
Specify JSON parameters for usage in config.json
```
{
  "address":"sender mail domain",
  "port":"587",
  "helo":"sender mail helo",
  "user":"user",
  "password":"password",
  "from":"sender address",
  "to":"recipient address"
}
```
and set the path for the configuration class to get your values set.

## Example Mail
```
Our CERT RSS Feed received a new security advisory:

Title: Red Hat OpenShift Logging Subsystem: Mehrere Schwachstellen
Description: Ein entfernter, anonymer Angreifer kann mehrere Schwachstellen in Red Hat OpenShift Logging Subsystem ausnutzen, um Sicherheitsmechanismen zu umgehen und um einen Denial of Service Zustand herbeizuführen.
Link: https://wid.cert-bund.de/portal/wid/securityadvisory?name=WID-SEC-2022-0069
Date: Thu, 18 Aug 2022 14:06:14 +0200
CVEs: CVE-2022-0759 CVE-2022-21698
Affected versions:
      Red Hat Enterprise Linux
      SUSE Linux
      Oracle Linux
      Avaya Aura Communication Manager
      Red Hat OpenShift Logging Subsystem 5
Severity: hoch
WID: WID-SEC-2022-0069

Best wishes,
Your CERT Bot.
```

## Used Version
Written with Ruby >= 3.1

## License
see LICENSE

created by: Benjamin Held
