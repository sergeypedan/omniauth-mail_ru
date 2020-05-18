# REST API user info

https://api.mail.ru/docs/reference/rest/users-getinfo/

Возвращает анкетную информацию о пользователях и/или группах.

Функция возвращает только информацию, доступную текущему пользователю. Информация, которую текущий пользователь не может увидеть на странице запрашиваемых пользователей/групп не будет возвращена.

## Request

Пример запроса:

```
http://www.appsmail.ru/platform/api
	? app_id      = 423004
	& method      = users.getInfo
	& session_key = be6ef89965d58e56dec21acb9b62bdaa
	& sig         = f82efdd230e45e58e4fa327fdf92135d
	// & uids     = 15410773191172635989,11425330190814458227
```

### Описание параметров запроса

https://api.mail.ru/docs/guides/restapi/#params

Param       | Type   | Description
:-----------|:-------|:-------------
app_id      | int    | идентификатор приложения; обязательный параметр
method      | string | название вызываемого метода, например, users.getInfo; обязательный параметр
session_key | string | сессия текущего пользователя. Мы рекомендем вам всегда использовать session_key, когда это возможно. Используйте uid только когда вы выполняете запросы пока пользователь не использует ваше приложение или сайт.
sig         | string | подпись запроса; обязательный параметр
uid         | uint64 | идентификатор пользователя, для которого вызывается метод; данный аргумент должен быть указан, если не указан session_key


## Пример результата

https://api.mail.ru/docs/reference/rest/users.getInfo/#result

```json
[
  {
    "app_installed": 1, // установлено ли у пользователя текущее приложение
    "birthday":      "15.02.1980", // дата рождения в формате dd.mm.yyyy
    "email":         "emaslov@mail.ru", // только в users.getInfo и только для внешних сайтов
    "first_name":    "Евгений",
    "friends_count": 145, // количество друзей у пользователя
    "has_pic":       1, // есть ли аватар у пользователя (1 - есть, 0 - нет)
    "is_online":     1, // 1 - онлайн, 0 - не онлайн
    "is_verified":   1, //статус верификации пользователя (1 – телефон подтвержден, 0 – не подтвержден)
    "last_name":     "Маслов",
    "link":          "http://my.mail.ru/mail/emaslov/",
    "location": {
      "country": {
        "name": "Россия",
        "id":   "24"
      },
      "city": {
        "name": "Москва",
        "id":   "25"
      },
      "region": {
        "name": "Москва",
        "id":   "999999"
      }
    },
    "nick":          "maslov",
    "pic":           "http://avt.appsmail.ru/mail/emaslov/_avatar",
    "pic_big":       "http://avt.appsmail.ru/mail/emaslov/_avatarbig",   // размер по большей стороне не более 600px
    "pic_small":     "http://avt.appsmail.ru/mail/emaslov/_avatarsmall", // размер по большей стороне не более 45px
    "referer_id":    "", // идентификатор реферера (см. ниже)
    "referer_type":  "", // тип реферера (см. ниже)
    "sex":           0, // 0 - мужчина, 1 - женщина
    "uid":           "15410773191172635989",
    "vip":           0, // 0 - не вип, 1 - вип
  },
  ...
]
```


## Подпись запроса

https://api.mail.ru/docs/guides/restapi/#sig

```ruby
def configure_authentication!(opts) # rubocop:disable MethodLength, Metrics/AbcSize
  case options[:mode]
  when :header
    opts[:headers] ||= {}
    opts[:headers].merge!(headers)
  when :query
    opts[:params] ||= {}
    opts[:params][options[:param_name]] = token
  when :body
    opts[:body] ||= {}
    if opts[:body].is_a?(Hash)
      opts[:body][options[:param_name]] = token
    else
      opts[:body] << "&#{options[:param_name]}=#{token}"
    end
    # @todo support for multi-part (file uploads)
  else
    raise("invalid :mode option of #{options[:mode]}")
  end
end
```

## Requesting

```ruby
opts # {
  :headers => { "Authorization"=>"Bearer 2615f71fa8fb566b7744f1037a5ceb11" },
  :params  => { :fields => "name,email" }
}
url  # "users.getInfo"
verb # :get

url = connection.build_url(url).to_s # "https://connect.mail.ru/users.getInfo"

# https://connect.mail.ru/users.getInfo?fields=name%2Cemail
# request_headers={"User-Agent"=>"Faraday v1.0.1", "Authorization"=>"Bearer 2615f71fa8fb566b7744f1037a5ceb11"}
```
