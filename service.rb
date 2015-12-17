require "rest-client"

class Service
  
  @@key = '0AWR69S8CZC60709'
  @@secret = '31ZEG6S3V9V34EAX'

  # def initialize(link, params)
  #   @link = link
  #   @params = params    
  # end

  def self.call_service(args, params='')

    response = RestClient.get( direction(args), {params:params} )
    
    if params == ''
      JSON.parse( response )
    else
      response
    end
  end

  private
  def self.direction(args)
    'https://'+@@key+':'+@@secret+'@api.handwriting.io/'+args.join("/")    
  end

end
