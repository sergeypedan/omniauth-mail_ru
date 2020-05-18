# Receiving token

```ruby
opts # {
  :body => {
    "client_id"     => "772584",
    "client_secret" => "8f0a9b735f2eb3c421c715819d68bbcd",
    "code"          => "5a092c24b2bd844e21cb1e77a3175ae8",
    "grant_type"    => "authorization_code",
    :redirect_uri   => "http://localhost:3000/users/auth/mail_ru/callback"
  },
  :headers      => { "Content-Type"=>"application/x-www-form-urlencoded" },
  :parse        => nil,
  :raise_errors => true
}
url  # "https://connect.mail.ru/oauth/token"
verb # :post
```
