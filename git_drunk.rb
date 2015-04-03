def list_version_controlled_files
  git_files = `git ls-files`
  git_files.split(/\n/)
end

def count_version_controlled_files(files)
  files.size
end

def select_random_version_controlled_file(files, file_count)
  files[Random.rand(file_count)]
end

def count_file_lines(file_path)
  File.read(file_path).lines.size
end

def select_random_line_number(line_count)
  Random.rand(1..line_count)
end

def blame(file_path, line_number)
  `git blame -w -L #{line_number},#{line_number} #{file_path}`
end


def extract_author(string)
  output = string.encode!('UTF-8', invalid: :replace)
  output.scan(/^[\w|\d]{8}\s\(([a-z]+)\s([a-z]*).*$/i) do |first_name, last_name|
    @first_name = first_name
    @last_name = last_name
  end
end


@git_files ||= list_version_controlled_files
@file_count ||= count_version_controlled_files(@git_files)

until @first_name
  line_count = 0
  until line_count > 0
    file_path = select_random_version_controlled_file(@git_files, @file_count)
    line_count = count_file_lines(file_path)
  end
  line_num = select_random_line_number(line_count)
  extract_author blame(file_path, line_num)
end
puts "#{@first_name} #{@last_name}"
