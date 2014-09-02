# Grabber

A tool to export account information from Lloyds TSB Online.

This tool has rough edges and is not ready for production use. It was written for personal use. Grabber will export account infomation as CSV files, as per Lloyds TSB onlines 'export' function, into ~/Downloads, read each csv file, transform each line into JSON. The output of the process is a file called finances.json containing a JSON representation of the exported account.

### Usage

Add a file called `private.yml` into `config` in the format:
```
---
user_id: $your_account user_id
password: $your_account_password
secret: $your_account_secret
```

Run `bundle exec ruby lib/grabber.rb`

The output of the prgram will be a file called finances.json. The file contains an array of JSON objects. Each memeber of the array represents 1 line as taken from each CSV file exported.
