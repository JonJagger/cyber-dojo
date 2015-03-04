
module ExternalOneSelf # mixin
  
  def one_self
    Class.new do
      include External
      def method_missing(symbol,*args) 
        begin
          return external(:one_self).send(symbol,*args)
        rescue StandardError => error
          p error.message
        end
      end
    end.new
  end

end

