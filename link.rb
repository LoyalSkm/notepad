
class Link < Post

  def initialize
    super           #копирует метод с таким же названием у родительского класса

    @url = ''
  end

  def read_from_console
  end

  def to_strings
  end

end