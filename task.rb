if (Gem.win_platform?) #ДЛЯ РАБОТЫ В КОНСОЛИ РУБИМАЙН ДЛЯ ВИНДОУС
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_external = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)

  end
end

require 'date' #будит привязываться к датам

class Task < Post
  def initialize
    super
    @due_date = Time.now
  end

  def read_from_console

    puts "Что надо сделать?"

    @text = STDIN.gets.chomp

    puts "К какому числу? Укажите дату в форме ДД.ММ.ГГГГ, например 12.05.2018"
    input = STDIN.gets.chomp

    @due_date = Date.parse(input) #статический метод parse на переменную input

  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    deadline = "Крайний срок: #{@due_date}"

    return [deadline, @text, time_string]

  end

  def to_db_hash
    return super.merge (   #с помощью этого ключа полоучается доступ к родительскому классу
    {
        'text' => @text,
        'due_date' => @due_date.to_s
    }
                       )
  end
  def load_date(data_hash)
    super(data_hash) # сперва дергаем родительскией метод для общих полей
    # теперь прописываем свое специфичное поле
    @due_date = Date.parse(data_hash['due_date'])
  end

end
