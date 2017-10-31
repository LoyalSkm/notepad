
class Link < Post

  def initialize
    super           #копирует метод с таким же названием у родительского класса

    @url = ''          #адресс
  end

  def read_from_console

    puts "Адрес ссылки:"
    @url = STDIN.gets.chomp

    puts "Что за ссылка?"
    @text = STDIN.gets.chomp

  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return [@url, @text, time_string]

  end
  def to_db_hash
    return super.merge (
                           {
                               'text' => @text,
                               'url' => @url
                           }
                       )
  end
  def load_data(data_hash)
    super(data_hash) #сперва дергаем родительский метод для общих полей
    #теперь пропмсываем свое специфическое поле
    @url = data_hash['url']
  end

end