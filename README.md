# BSI CERT RSS Bot
Simple Mailbot that checks the BSI CERT RSS feed and parses CERT 
reports to be send to the given mail address.

## Help & Usage
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

## Used Version
Written with Ruby >= 3.1

## License
see LICENSE

created by: Benjamin Held
