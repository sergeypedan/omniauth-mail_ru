# Auth hash

https://api.mail.ru/docs/reference/rest/users.getInfo/#result

```json
[
  {
    "uid": "15410773191172635989",
    "first_name": "Евгений",
    "last_name": "Маслов",
    "nick": "maslov",
    "email": "emaslov@mail.ru", // только в users.getInfo и только для внешних сайтов
    "sex": 0, // 0 - мужчина, 1 - женщина
    "birthday": "15.02.1980", // дата рождения в формате dd.mm.yyyy
    "has_pic": 1, // есть ли аватар у пользователя (1 - есть, 0 - нет)
    "pic": "http://avt.appsmail.ru/mail/emaslov/_avatar",
    // уменьшенный аватар - размер по большей стороне не более 45px
    "pic_small": "http://avt.appsmail.ru/mail/emaslov/_avatarsmall",
    // большой аватар - размер по большей стороне не более 600px
    "pic_big": "http://avt.appsmail.ru/mail/emaslov/_avatarbig",
    "link": "http://my.mail.ru/mail/emaslov/",
    "referer_type": "", // тип реферера (см. ниже)
    "referer_id": "", // идентификатор реферера (см. ниже)
    "is_online": 1, // 1 - онлайн, 0 - не онлайн
    "friends_count": 145, // количество друзей у пользователя
    "is_verified": 1, //статус верификации пользователя (1 – телефон подтвержден, 0 – не подтвержден)
    "vip" : 0, // 0 - не вип, 1 - вип
    "app_installed": 1, // установлено ли у пользователя текущее приложение
    "location": {
      "country": {
        "name": "Россия",
        "id": "24"
      },
      "city": {
        "name": "Москва",
        "id": "25"
      },
      "region": {
        "name": "Москва",
        "id": "999999"
      }
    }
  },
  ...
]
```