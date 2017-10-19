class Post

  def self.post_types

    [Memo, Link, Task]

  end

  def self.create (type_index)
    return post_types[type_index].new
  end



  def initialize
    @created_at = Time.now
    @text = nil                  #2 базовых поля
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


end