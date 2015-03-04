
module ExternalOneSelf # mixin
  
  def one_self
    Class.new do
      include External
      def method_missing(symbol,*args) 
        begin
          return external(:one_self).send(symbol,*args)
        rescue StandardError => error
          print error.message
        end
      end
    end.new
  end

end

