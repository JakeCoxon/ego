class Array 
  # maps an array into a hash
  def to_h(&block)
    Hash[*self.map { |v| block.call(v) || [] }.flatten(1) ]
  end

  def drop_first(num=1)
    self.chain(:shift, num)
  end
  def drop_last(num=1)
    self.chain(:pop, num)
  end
end
class Object
  # alows you to chain method calls
  def chain(method, *args)
    send(method, *args); self
  end
end
class NilClass
  def to_h
    {}
  end
end