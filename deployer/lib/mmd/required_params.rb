module MMD
  module RequiredParams
    def required_params( params, required, ignore_nil = true )
      missing = []
      required.each do |requirement|
        if params.keys.select do |key|
            if key.to_s == requirement.to_s
              if not ignore_nil
                !params[key].nil?
              else
                true
              end
            end
        end.size == 0
          missing << requirement
        end
      end

      if missing.size > 0
        raise RequiredParamsError.new( "#{self.class.name} requires #{missing.inspect} parameters" )
      end
    end

    # TODO: instead of jnjecting instance variables, return an OpenStruct?
    #       Otherwise, if param contains a key that overwrites an existing
    #       unrelated val on the class
    #
    def set_instance_variables( params )
      params.each do |key,val|
        #self.instance_eval("@#{key.to_s} = '#{val}'")
        self.class.class_eval %(
                  class << self; attr_accessor :#{key} end
        )

        self.instance_variable_set( "@#{key}", val )
      end
    end
  end

  class RequiredParamsError < RuntimeError

  end
end
