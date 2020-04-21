class AttrAccessorObject
  def self.my_attr_accessor(*names)
    # ...
    names.each do |name|
      reader = name # :name
      writer = name.to_s.concat("=").intern # :name=
      ivar = "@#{name}"

      # Define reader instance method
      define_method(reader) do
        self.instance_variable_get(ivar)
      end

      # Define writer instance method
      define_method(writer) do |new_val|
        self.instance_variable_set(ivar, new_val)
      end
    end
  end

  my_attr_accessor :name, :age

end
