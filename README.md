# OmniAuth Shootproof
### Based off OmniAuth OAuth2

[![Gem Version](http://img.shields.io/gem/v/omniauth-shootproof.svg)][gem]
[![Build Status](https://travis-ci.org/SavvySoftWorksLLC/omniauth-shootproof.svg?branch=master)](https://travis-ci.org/SavvySoftWorksLLC/omniauth-shootproof)
[![Dependency Status](http://img.shields.io/gemnasium/SavvySoftWorksLLC/omniauth-shootproof.svg)][gemnasium]

[gem]: https://rubygems.org/gems/omniauth-shootproof
[travis]: http://travis-ci.org/SavvySoftWorksLLC/omniauth-shootproof
[gemnasium]:https://gemnasium.com/github.com/SavvySoftWorksLLC/omniauth-shootproof

This gem contains an OmniAuth strategy for Shootproof. It relies on the OAuth2 and OmniAuth-OAuth2 gems. Shootproof API does not conform exactly to the standard set forth with the base OAuth2 Client so some changes include:
- Access Tokens require the same params as the original Authorization request. The confusing part is the Token request is required POST so query string params are not included by default.
- The Access token requires the `redirect_uri` to match the `callback_url` from the Authorization request. Omniauth by default provides the query params from the Authorization callback in future `redirect_uri` params. This will no longer match so the query string is ditched.
- The Authorization endpoint does not pass-through any params os CSRF protection using the `state` param is not possible.

## Configuring the Shootproof Strategy

```ruby

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shootproof, <SHOOTPROOF_APP_ID>, 
    scope: 'sp.event.get_list sp.event.get_photos sp.photo.info'
end
```
That's pretty much it!

Like normal you will have to interpret the authenticaion response in your OmniAUth Session Controller.

The `info` response will contain the following hash
```
{
  token: <ACCESS TOKEN>,
  refresh_token: <REFRESH TOKEN>,
  expires_at: <WHEN THE TOKEN AND REFRESH EXPIRE>,
  expires_in: <TIME LEFT UNTIL EXPIRATION>
}
```

For convenience the `uid` will be populated with the Access Token

Paul Scarrone paul@savvysoftworks.com
Gary Newsome gary@savvysoftworks.com
SavvySoftWorks LLC.
