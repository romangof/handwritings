# get_handwritings

# id = list_handwritings
# render = select_render
# text = set_text

require_relative 'service.rb'
require_relative 'handwriting.rb'

class Main

  @@path = File.expand_path(File.dirname(__FILE__))
  @@dbpath = @@path + '/db'
  @@render = ['render']

  def self.create_db_dir
    unless File.directory?(@@dbpath)
      FileUtils.mkdir_p(@@dbpath)
    end
  end

  def self.list_handwritings
    unless File.exists?(@@dbpath+'/hws.msdb')
      get_handwritings
    end

    list = Marshal.load(File.read(@@dbpath+'/hws.msdb'))
    list.each_with_index{ |hw, i| puts "#{i}. #{hw.title}" }

    opt = -1
    while opt <= -1 || opt >= list.size
      print "Option: "
      opt = gets.chomp.to_i
      puts
      if opt <= -1 || opt >= list.size
        puts "Invalid option."
      end
    end
    # ToDo: Fix bug when text is introduced
    #       Add pagination

    list[opt]
  end

  def self.set_render
    opt = 0

    while (opt < 1 || opt > 2)
      puts "Render mode: 1. PNG  2. PDF"
      opt = gets.chomp.to_i
      if (opt < 1 || opt > 2)
        puts "Invalid number"
      elsif opt == 1
        @@render[1] = 'png'
      elsif opt == 2
        @@render[1] = 'pdf'
      end
    end
  end

  def self.set_params
    params = {}

    if @@render[1] == 'png'
      unit = 'px'
    elsif @@render[1] == 'pdf'
      unit = 'in'
    end

    puts "Text: "
    params["text"] = gets.chomp

    puts
    puts "From here you can press enter to skip and use default"
    puts

    puts "Width:"
    w = gets.chomp  
    if w.to_i > 1
      params["width"] = w.to_i.to_s + unit
    end

    puts "Height:   (Can be set to auto)"
    h = gets.chomp
    if h == 'auto'
      params["height"] = h
    elsif h > 0
      params["height"] = h.to_i.to_s + unit 
    end

    if @@render[1] == 'pdf'
      unit = 'pt'
    end
    puts "Size:"
    size = gets.chomp
    if size.to_i > 1
      params["handwriting_size"] = size.to_i.to_s + unit 
    end

    puts "Color"
    params["handwriting_color"] = gets.chomp
    
    
    if @@render[1] == 'pdf'
      unit = 'pt'
    end



    puts "Line spacing"
    params["line_spacing"] = gets.chomp
    puts ""
    params[""] = gets.chomp
    puts ""
    params[""] = gets.chomp
    
  end


  private
  def self.get_handwritings
    json = Service.call_service(['handwritings'])
    list = []
    
    json.each do |hw|
      a = Handwriting.new(hw)
      list.push(a)
    end

    File.open(@@dbpath + '/hws.msdb', 'w') do |f|
      f.write( Marshal.dump(list) )
    end
  end

  # def self.paginate(list, n=5)

  #   for i in (0..list.size-1)
  #     for j in (i..i+n)
  #       print "#{j+1}. #{list[j].title}  "
  #     end
  #     puts "p = Previous  - n = Next"
  #     print "Option: "
  #     opt = gets.chomp
  #   end

  # end
  
end



# https://api.handwriting.io/
# RestClient.get 'https://0AWR69S8CZC60709:31ZEG6S3V9V34EAX@api.handwriting.io/handwritings'

# open('hello_world.png', 'wb') do |file|
#   file.write(res.body)
# end

# # Quick way of opening the file, writing it and closing it
# File.open('/path/to/file.extension', 'w') {|f| f.write(YAML.dump(m)) }
# File.open('/path/to/file.extension', 'w') {|f| f.write(Marshal.dump(m)) }

# # Now to read from file and de-serialize it:
# m = YAML.load(File.read('/path/to/file.extension'))
# m = Marshal.load(File.read('/path/to/file.extension'))


