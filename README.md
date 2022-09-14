# BSI CERT RSS Bot
Simple Mailbot that checks the BSI CERT RSS feed and parses CERT 
reports to be send to the given mail address.

Current version: v0.1.0

## Installation
* check for ruby and bundler on the target machine
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
 -s, --severity  argument: <severity>; specifies the severity threshold when a severity should sent an e-mail
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

Title: Linux Kernel: Schwachstelle ermöglicht nicht spezifizierten Angriff
Description: Ein Angreifer kann eine Schwachstelle im Linux Kernel ausnutzen, um einen nicht näher spezifizierten Angriff durchzuführen.
Link: https://wid.cert-bund.de/portal/wid/securityadvisory?name=WID-SEC-2022-1360
Date: Fri, 09 Sep 2022 10:11:37 +0200
Status: New
CVEs: CVE-2022-40307
Affected versions:
      Open Source Linux Kernel <= 5.19.8
Severity: hoch
WID: WID-SEC-2022-1360

Best wishes,
Your CERT Bot.
```

## Used Version
Written with Ruby >= 3.1

## License
see LICENSE

created by: Benjamin Held
