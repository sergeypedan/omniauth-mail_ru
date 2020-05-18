# Access token

Значение access_token — это идентификатор сессии, необходимый для работы с [REST API](https://api.mail.ru/docs/reference/rest).

```ruby
def raw_info
  access_token
end
```

```json
{
  "access_token":  "618ba337f31fc931ad694b1ae7290306",
  "expires_at":     1589798202,
  "refresh_token": "0c88bbafc50d60ed24fa1cc05aaf79ce",
  "token_type":    "bearer",
  "x_mailru_vid":  "12900285598278158001"
}
```

## Methods

### Getters

```ruby
to_json  # "{\"token_type\":\"bearer\",\"x_mailru_vid\":\"12900285598278158001\",\"access_token\":\"618ba337f31fc931ad694b1ae7290306\",\"refresh_token\":\"0c88bbafc50d60ed24fa1cc05aaf79ce\",\"expires_at\":1589798202}"
to_hash  # {"token_type"=>"bearer", "x_mailru_vid"=>"12900285598278158001", :access_token=>"618ba337f31fc931ad694b1ae7290306", :refresh_token=>"0c88bbafc50d60ed24fa1cc05aaf79ce", :expires_at=>1589798202}
```

```ruby
[]
client         # #<OAuth2::AccessToken:0x00007fd5ec038710
expired?       # true
expires?       # true
expires_at     # 1589798202
expires_in     # 86400
headers        # {"Authorization"=>"Bearer 618ba337f31fc931ad694b1ae7290306"}
options        # {:mode=>:header, :header_format=>"Bearer %s", :param_name=>"access_token"}
params         # {"token_type"=>"bearer", "x_mailru_vid"=>"12900285598278158001"}
refresh_token  #{ }"0c88bbafc50d60ed24fa1cc05aaf79ce"
token          # "618ba337f31fc931ad694b1ae7290306"
```

### Setters

```ruby
options=
refresh_token=
```

### Commands

```ruby
request
get
patch
post
put
delete
refresh!  # делает вызов и возвращает #<OAuth2::AccessToken:0x00007fd5ec038710
```
