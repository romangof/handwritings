# get_handwritings

# id = list_handwritings
# render = select_render
# text = set_text




require_relative 'service.rb'
require_relative 'handwriting.rb'

class Main

  @@path = File.expand_path(File.dirname(__FILE__))
  @@dbpath = @@path + '/db'

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
    list[opt]
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