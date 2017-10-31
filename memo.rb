
class Memo < Post

  def read_from_console
    puts "Базовая заметка (все, что пишите лр строчки \"end\"):"

    @text = []  #массив который будит хранить записи
    line = nil

    while line != "end" do
      line = STDIN.gets.chomp
      @text << line
    end

    @text.pop #удаление последней строки "end"
  end

  def to_strings

    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return @text.unshift(time_string)
  end

  def to_db_hash
    return super.merge(
                           {
                               'text' => @text.join('\n\r') #массив строк делаем одновременно,
                           }
                       )
  end

  def load_date(data_hash)
    super(data_hash) #сперва дергаем родительский метод для инициализации общих полей

    #теперь прописываем свое специфическое поле
    @text = data_hash['text'].split('\n\r')
  end

end


