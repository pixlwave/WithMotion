class NSObject

  def self.with(args = {})
    args.count == 0 ? method = "init" : method = "initWith"
    objc_args = []

    args.each do |a|
      a[0] = a[0][0].capitalize + a[0][1..-1] if objc_args.size < 1

      method << a[0] << ":"
      objc_args << a[1]
    end

    self.alloc.send(method, *objc_args)
  end
  
end