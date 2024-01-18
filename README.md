# BSI CERT RSS Bot
Simple Mailbot that checks the BSI (Bundesamt für Sicherheit in der Informationstechnik; 
govermental institution for information security in germany) 
CERT [RSS feed](https://wid.cert-bund.de/content/public/securityAdvisory/rss) and 
parses CERT reports to be send to the given mail address.

Current version: v0.4.0

## Installation
* check for installed git
* check for installed ruby programming language and installed bundler gem on the target machine
* clone the repository
* run `bundle install` to get the required gems
* setup config.json
* run main script `ruby cert_bot.rb -f <path_to_config.json>` in the bin directory

## Usage
```
script usage: ruby <script> [parameters] -f <filename>
help usage :              ruby <script> (-h | --help)
help usage for parameter: ruby <script> <parameter> (-h | --help)
CERT bot help:
 -h, --help      show help text
 -v, --version   prints the current version of the project
 -f, --file      argument: <filename>; parameter that indicates a filepath to the config json file
 -u, --updated   also sends an e-mail for updated advisories
 -d, --debug     script call does additional debug logging
 -s, --severity  argument: <severity>; specifies the severity threshold when a severity should sent an e-mail
 -j, --json      argument: <filepath>; writes advisories as json objects into a file instead of sending an e-mail to the given directory
 ```

### Severity Ratings
The BSI gives a severity for the published advisories with different levels and input for the 
[severity rating](https://wid.cert-bund.de/portal/wid/fragenundantworten). The entries in the bracket
are the possible values for the severity parameter:
* low: ["low", "niedrig"]
* medium: ["medium", "mittel"]
* high: ["high", "hoch"]
* critical: ["critical", "kritisch"]

So an example call for sending only messages for high or critical advisories can look as:
```
ruby cert_bot.rb -s high -f <path_to_config.json>
```

### CVSS Score
The CERT Advisories from the BSI show two ratings for CVSS score:
* base score: score for qualities intrinsic to a vulnerability
* temporal score: score evolvement over the lifetime of a vulnerability

The CVSS score used in the current mail and json output states the temporal score of a vulnerability in sync with the rating of the BSI severity rating.

### Updated Advisories
Published advisories change over time. They can get additional affected products, vulnerabilities or information links. 
In that case an advisory gets updated and republished in the rss feed. That leeds to duplicated notifications for advisories.
For that case the update status is noted within the mail text to mark if this is a new or updated advisory.
The BSI differs between three states: `new`, `update`, `silent-update`. In the default behavior the script will only send notifications
for advisories with the status `new`. If you consume these notifications to review the advisories for your own assets, getting
updated advisories lead to duplicated notifications or tickets that need to be reviewed and connected to already existing ones.
If you still want to recieve notifications for updated advisories you can add the flag `-u` or `--updated` to get mails for
updated advisories.

## Configuration
Specify JSON parameters for usage in config.json
```
{
  "address":"sender mail domain",
  "port":"587",
  "helo":"sender mail helo",
  "user":"user", # optional
  "password":"password", # optional
  "from":"sender address",
  "to":"recipient address",
  "authtype":"plain", # optional
  "tls_verify":"true", # optional
  "tls_hostname":"nil" # optional
}
```
and set the path for the configuration class to get your values set. A few parameter are optional and will be set with default values if not present.

Additionally if the script runs into trouble there are some basic debug information that can be used to check for bugs and anormal behavior. To use this debug
output that is stored in the same directory as the config.json can be activated by using the debug flag `-d` oder `--debug`. This will add which advisory is
read and which does generate a new entry based on the script parameter.

### Automated usage
* via cronjob (hourly): `00 *  * * * ruby /path/to/bin/cert_bot.rb -d -s high -f /path/to/config.json`
* systemd-timer (in preparation): --

## Example Mail
```
Our CERT RSS Feed received a new security advisory:

Title: Linux Kernel: Schwachstelle ermöglicht nicht spezifizierten Angriff
Description: Ein Angreifer kann eine Schwachstelle im Linux Kernel ausnutzen, um einen nicht näher spezifizierten Angriff durchzuführen.
Link: https://wid.cert-bund.de/portal/wid/securityadvisory?name=WID-SEC-2022-1360
Date: Fri, 09 Sep 2022 10:11:37 +0200
Status: New
Severity: hoch
CVSS Score (3.1): 7.2
CVEs: CVE-2022-40307
Affected versions:
      Open Source Linux Kernel <= 5.19.8
WID: WID-SEC-2022-1360

Best wishes,
Your CERT Bot.
```

## JSON Output
Instead of an e-mail the flag `-j` or `--json` creates a JSON formatted output file for a given advisory. This file can be written to a given location. An example can look like this:
```
{
  "wid": "WID-SEC-2022-1251",
  "title": "Xerox FreeFlow Print Server: Mehrere Schwachstellen",
  "description": "Ein entfernter, anonymer Angreifer kann mehrere Schwachstellen in Xerox FreeFlow Print Server ausnutzen, um die Vertraulichkeit, Verfügbarkeit und Integrität des Systems zu gefährden.",
  "link": "https://wid.cert-bund.de/portal/wid/securityadvisory?name=WID-SEC-2022-1251",
  "release": "Thu, 01 Sep 2022 13:11:37 +0200",
  "status": "New",
  "cves": [
    "CVE-2020-0689",
    "CVE-2022-35822"
  ],
  "cvss": 8.5,
  "affected": [
    {
      "name": "Xerox FreeFlow Print Server v2",
      "cpeversion": "v2",
      "cpeproduct": "cpe:/a:xerox:freeflow_print_server"
    }
  ],
  "severity": "hoch"
}
```

## Used Version
Written with Ruby >= 3.1

## License
see LICENSE

created by: Benjamin Held
