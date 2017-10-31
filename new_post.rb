
if (Gem.win_platform?) #ДЛЯ РАБОТЫ В КОНСОЛИ РУБИМАЙН ДЛЯ ВИНДОУС
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_external = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)

  end
end

require_relative 'post.rb'
require_relative 'link.rb'
require_relative 'memo.rb'
require_relative 'task.rb'

puts "yoyoyoy Niga V2 +Sqlite "
puts "Пиши свой бред"

choices = Post.post_types.keys

choice = -1

until choice >=0 && choice < choices.size          #опрос в цыкле пока choice не станет больше 0

  choices.each_with_index do |type, index|         # проходка по массиву методом .each_with_index метод организовывает цыкл по всем елементам масива choisec
    puts "\t#{index}. #{type}"
  end
  choice = STDIN.gets.chomp.to_i

end

entry = Post.create(choices[choice])

entry.read_from_console

id = entry.save_to_db

puts "ок лол, id = #{id}"