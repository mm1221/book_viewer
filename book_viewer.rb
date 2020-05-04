require "tilt/erubis"
require "sinatra"
require "sinatra/reloader" if development?

before do
  @contents = File.readlines("data/toc.txt")
end

helpers do  
  def in_paragraphs(input_string)
    count = 0
    output = input_string.split("\n\n").map do |el|
             count += 1
             "<p id=#{count}> #{el}</p>"    
             end
    output
  end
end

get "/" do
  @chp_num = params[:number].to_i
  @index = 1
  @title = "name of a book"
  @title = "Chapter #{@chp_num}: #{@contents[@chp_num - 1]}"
  erb :home
end

get "/chapters/:number" do
  @chp_num = params[:number].to_i
  @title = "Chapter #{@chp_num}: #{@contents[@chp_num - 1]}"
  @chapter =  File.read("data/chp#{@chp_num}.txt")
  erb :chapter
end

get "/show/:name" do
  params[:name]
end

get "/search" do 
  @results = {}
  @query = params[:query]
  if !@query.nil?
    chp_count = 1
    loop do 
      current_chapter = in_paragraphs(File.read("data/chp#{chp_count}.txt"))
      current_chapter.each do |paragraph|
        if paragraph.include?(@query)
          if @results[chp_count].nil?
            @results[chp_count] = [paragraph]
          else
            @results[chp_count] << [paragraph]
          end
        end
      end
      chp_count += 1
      break if chp_count > 12
    end
  end
  erb :search
end

not_found do
  redirect "/"
end
