
require 'sqlite3'

class Post

  @@SQLITE_DB_FILE = 'notepad.sqlite' #переменная класса в save_to_db которая хранит название базы данных (она должна лежать в папке)

  def self.post_types

    {'Memo' => Memo, 'Link' => Link, 'Task' => Task}
  end

  def self.create (type)
    return post_types[type].new
  end

  def self.find(limit, type, id)

    db = SQLite3::Database.open(@@SQLITE_DB_FILE) #доступ к базе данных которая находится в папке с прогой

# 1. конкретная запист

    if !id.nil?                        #обязательно восклицательный знак перед !id если параметр переданный в метод не равен нулю
      db.results_as_hash = true

      result = db.execute("SELECT * FROM posts WHERE rowid = ?", id) #выполняем запрос зелёный это плейс фолдер id - значение execute должен возвращать массивы

      result = result[0] if result.is_a? Array #если результат - массив то в переменной резалт будим хранить первый елемент массива

      db.close #закрываем базу данных

      if result.empty?

        puts "Такой id #{id} не найден в базе *((("
        return nil
      else
        post = create(result['type']) #статический метод create из другого метода этогоже класса
        post.load_date(result)
        return post

        end
    else
#2. вернуть таблицу записей
      db.results_as_hash = false
      # формируем в базу с нужными условиями
      query = "SELECT rowid, * FROM posts "

      query += "WHERE type = :type " unless type.nil?
      query += "ORDER by rowid DESC "

      query += "LIMIT :limit " unless limit.nil?

      statement = db.prepare(query) #обьект который готовый к выполнению

      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute! #выполнение переменной (возвращение массива результатов всех полей)

      statement.close
      db.close

      return result

    end
  end

  def initialize
    @created_at = Time.now
    @text = nil                  #сначала пустое, потом заполняется по мере прохождения проги
  end

  def read_drom_console
 #to_do
  end

  def to_strings
 #to_do
  end

  def save                               #сохранение в отдельный файл
    file = File.new(file_path, "w:UTF-8")
    for item in to_strings do
      file.puts(item)
    end

    file.close

  end

  def file_path                    #путь к файлу сохранения

    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    return current_path + "/" +file_name
  end

  def save_to_db #метод сохранения в базу данных

    db = SQLite3::Database.open(@@SQLITE_DB_FILE) #открыть соединение к базе данных

    db.results_as_hash = true #результаты возвращались как ассоциативный массив в руби
    db.execute(
        "INSERT INTO posts (" +            #
            to_db_hash.keys.join(',') + # вставляемое поле (',') в запросе
        ")" +
        " VALUES (" +
        ('?,'*to_db_hash.keys.size).chomp(',') + #плейсхолдеры должны выглядить как (?, ?, ?,) должно совпадать колисеству полей в запросе
        ")",
        to_db_hash.values
               )

    insert_row_id = db.last_insert_row_id #возвращение идентификатора новой строки

    db.close #закрыть базу данных

    return insert_row_id

  end

  def to_db_hash #метод который будит возвразать ассоциативный массив со всеми полями данной записи keys & values
    {
        'type' => self.class.name,
        'created_at' => @created_at.to_s
    }
  end
  def load_date(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end

end