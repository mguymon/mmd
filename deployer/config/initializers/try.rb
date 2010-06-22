
class Object
  def try(*args)
    options = {:default => nil}.merge(args.last.is_a?(Hash) ? args.pop : {})
    target = self # Initial target is self.
    while target && mtd = args.shift
      target = target.send(mtd) if target.respond_to?(mtd)
    end

    return target || options[:default]
  end
end
