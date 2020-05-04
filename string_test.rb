
def string_test
  string = File.read("data/chp2.txt")
  p string
end


def in_paragraphs
  input_string = File.read("data/chp2.txt").to_s
  puts input_string.include?("stout")
end

in_paragraphs