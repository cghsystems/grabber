# Grabber

A tool to export account information from Lloyds TSB Online.

This tool has rough edges and is not ready for production use.

### Usage

Add a file called `private.yml` into `config` in the format:
```
---
user_id: $your_account user_id
password: $your_account_password
secret: $your_account_secret
```

Run `bundle exec ruby lib/grabber.rb`
