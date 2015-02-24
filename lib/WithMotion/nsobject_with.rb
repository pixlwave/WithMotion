class NSObject

  def self.with(args = {})
    args.count == 0 ? method = "init" : method = "initWith"
    objc_args = []

    args.each do |a|
      a[0] = a[0][0].capitalize + a[0][1..-1] if objc_args.size < 1

      method << a[0] << ":"
      objc_args << a[1]
    end

    method_signature = instanceMethodSignatureForSelector(method)
    if method_signature.nil?
      raise NoMethodError, "with - invalid init method #{method}"
    end

    if method_signature.numberOfArguments - 2 != objc_args.length
      raise ArgumentError, "with - invalid number of arguments: #{objc_args.length} for #{method_signature.numberOfArguments - 2}"
    end

    rv = Pointer.new(:object)
    NSInvocation.invocationWithMethodSignature(method_signature).tap do |invocation|
      invocation.setSelector(method)
      objc_args.each_index do |i|
        p = Pointer.new(method_signature.getArgumentTypeAtIndex(i + 2))
        p[0] = objc_args[i]
        invocation.setArgument(p, atIndex:i + 2)
      end
      invocation.invokeWithTarget(self.alloc)
      invocation.getReturnValue(rv)
    end
    rv[0]
  end

end

