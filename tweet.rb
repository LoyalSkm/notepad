
require 'twitter'


class Tweet < Post
  @@CLIENT = Twitter::REST::Client.new do |config| #переменная класса
    config.consumer_key = 'Ol5c4zzrMkmKCYAJgFtDdwPND'
    config.consumer_secret = 'qsnY7qyFJ3javxXCGhQ9rtZjBq3fniqFG17Vs8LvdxuNVrCthJ'
    config.access_token = '926055256638869504-nUk4FAvhj4zasdFY9My9znUfSsT5WUW'
    config.access_token_secret = 'hpmHKlkE3dMpxA1hYZLG59rQy4VkAoSXJrGtwKCWd9Sz2'
  end
  def read_from_console
    puts 'Новый твит (140 символов!):'

    @text = STDIN.gets.chomp[0..140]
    puts"отправляем ваш текст #{@text.encode('utf-8')}"
    @@CLIENT.update(@text.encode('utf-8'))
    puts "Твит отправлен"
  end


  #Массив из даты создания + тело твита
  def to_strings

    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return @text.unshift(time_string)
  end

  def to_db_hash
    return super.merge(
        {
            'text' => @text #массив строк делаем одновременно,
        }
    )
  end

  def load_date(data_hash)
    super(data_hash) #сперва дергаем родительский метод для инициализации общих полей

    #теперь прописываем свое специфическое поле
    @text = data_hash['text'].split('\n\r')
  end

end
