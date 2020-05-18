# frozen_string_literal: true

class UserInfoFetcher

  class FetchError < StandardError; end

  require "digest"
  require "faraday"
  require "uri"

  REST_ENDPOINT = "https://www.appsmail.ru/platform/api".freeze
  # https://api.mail.ru/docs/guides/restapi/

  def initialize(access_token:, app_id:, secret_key:)
    @access_token, @app_id, @secret_key = access_token, app_id.to_i, secret_key
  end

  def call
    response = Faraday.get(
      REST_ENDPOINT,
      params.merge({ sig: build_signature }),
      {
        "Accept"          => "application/json",
        "Accept-Charset"  => "utf-8",
        "Accept-Language" => "ru"
      }
    )

    puts "response.headers:"
    puts response.headers

    return response.body.force_encoding(Encoding::UTF_8) if response.success?
    puts "Failed response:"
    puts response.to_hash
    raise FetchError, "Fetching user info failed"
  end

  private

  def params
    {
      app_id:      @app_id,
      format:      "json",
      method:      "users.getInfo",
      secure:      1, # Если вы хотите использовать схему клиент-сервер, то передайте в параметрах запроса secure=0
      session_key: @access_token
    }.sort.to_h # Must be sorted for signature build
  end
  #
  # app_id        int     идентификатор приложения; обязательный параметр
  # method        string  название вызываемого метода, например, users.getInfo; обязательный параметр
  # session_key   string  сессия текущего пользователя. Мы рекомендем вам всегда использовать session_key, когда это возможно. Используйте uid только когда вы выполняете запросы пока пользователь не использует ваше приложение или сайт.
  # sig           string  подпись запроса; обязательный параметр
  # uid           uint64  идентификатор пользователя, для которого вызывается метод; данный аргумент должен быть указан, если не указан session_key
  #
  # В ответ на этот запрос вы получите примерно такой результат:
  # {
  #   "access_token":  "56a59ff5d5cf9645b872750454d8a27b",
  #   "expires_in":     86400,
  #   "refresh_token": "a45529ac9bf6b32be761975c043ef9e3",
  #   "x_mailru_vid":  "1324730981306483817"
  # }
  #
  # Значение access_token — это идентификатор сессии, необходимый для работы с REST API.
  #
  # Итоговый запрос:
  # http://www.appsmail.ru/platform/api?method=friends.get&app_id=423004&session_key=be6ef89965d58e56dec21acb9b62bdaa&sig=5073f15c6d5b6ab2fde23ac43332b002


  def build_signature
    Digest::MD5.hexdigest string_for_signature
  end

  def string_for_signature
    [clamped_params, @secret_key].map(&:to_s).join
  end

  def clamped_params
    URI.encode_www_form(params).gsub("&", "")
  end
  #
  # Расчитайте sig по следующему алгоритму:
  #
  #   sig = md5(uid + params + private_key)
  #
  # Значение uid — идентификатор текущего пользователя приложения.
  # Значение private_key вы можете взять из настроек приложения.
  #
  # Пусть uid=1324730981306483817 и private_key=7815696ecbf1c96e6894b779456d330e
  #
  # Запрос, который вы хотите выполнить:
  # http://www.appsmail.ru/platform/api?method=friends.get&app_id=423004&session_key=be6ef89965d58e56dec21acb9b62bdaa
  #
  # Тогда:
  # params = app_id=423004method=friends.getsession_key=be6ef89965d58e56dec21acb9b62bdaa
  # sig = md5(1324730981306483817app_id=423004method=friends.getsession_key=be6ef89965d58e56dec21acb9b62bdaa7815696ecbf1c96e6894b779456d330e)
  #     = 5073f15c6d5b6ab2fde23ac43332b002
  #
  # Итоговый запрос:
  # http://www.appsmail.ru/platform/api?method=friends.get&app_id=423004&session_key=be6ef89965d58e56dec21acb9b62bdaa&sig=5073f15c6d5b6ab2fde23ac43332b002
  #

end

