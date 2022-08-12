# BSI CERT RSS Bot
Simple Mailbot that checks the BSI CERT RSS feed and parses CERT 
reports to be send to the given mail address.

## Help & Usage
### Installation
* clone the repository
* run `bundle install` to get the required gems
* setup config.json
* run main script `ruby cert_bot.rb -f <path_to_config.json>` in the bin directory

### Configuration
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

Title: Oracle Communications: Mehrere Schwachstellen
Description: Ein entfernter, anonymer, authentisierter oder lokaler Angreifer kann mehrere Schwachstellen in Oracle Communications ausnutzen, um die Vertraulichkeit, Integrität und Verfügbarkeit zu gefährden.
Link: https://wid.cert-bund.de/portal/wid/securityadvisory?name=WID-SEC-2022-0767
Date: Wed, 20 Jul 2022 14:06:25 +0200
CVEs: CVE-2018-25032 CVE-2019-20916 CVE-2020-14343 CVE-2020-36518 CVE-2021-22119 
      CVE-2021-3177 CVE-2021-34141 CVE-2021-3572 CVE-2021-37750 CVE-2022-0778 
      CVE-2022-1154 CVE-2022-1271 CVE-2022-22947 CVE-2022-22963 CVE-2022-22965 
      CVE-2022-23219 CVE-2022-23308 CVE-2022-24329 CVE-2022-24407 CVE-2022-24735 
      CVE-2022-25636 CVE-2022-25845 
Severity: hoch
WID: WID-SEC-2022-0767

Best wishes,
Your CERT Bot.
```

## Used Version
Written with Ruby >= 3.1

## License
see LICENSE

created by: Benjamin Held
