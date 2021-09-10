struct SmallArray(T)
  include Indexable(T)
  include Comparable(SmallArray)

  CAPACITY = 8

  @size = 0
  @buffer : StaticArray(T?, CAPACITY)

  # Creates a new `SmallArray` with the given *args*. The type of the
  # small array will be the union of the type of the given *args*,
  # and its size will be the number of elements in *args*.
  #
  # ```
  # ary = SmallArray[1, 'a']
  # ary[0]    # => 1
  # ary[1]    # => 'a'
  # ary.class # => SmallArray(Char | Int32, 2)
  # ```
  macro [](*args)
    %array = uninitialized SmallArray(typeof({{*args}}))
    {% for arg, i in args %}
      %array.to_unsafe[{{i}}] = {{arg}}
    {% end %}
    %array.size = {{args.size}}
    %array
  end

  # Creates a new small array and invokes the
  # block once for each index of the array, assigning the
  # block's value in that index.
  #
  # ```
  # SmallArray(Int32, 3).new { |i| i * 2 } # => SmallArray[0, 2, 4]
  # ```
  def self.new(&block : Int32 -> T)
    array = uninitialized self
    CAPACITY.times do |i|
      array.to_unsafe[i] = yield i
    end
    array
  end

  # Creates a new small array filled with the given value.
  #
  # ```
  # SmallArray(Int32, 3).new(42) # => SmallArray[42, 42, 42]
  # ```
  def self.new(value : T)
    new { value }
  end

  def initialize(*args)
    # TODO: raise args
    @size = args.size
    @buffer = StaticArray(T?, CAPACITY).new { |i| args[i]? }
  end

  # Equality. Returns `true` if each element in `self` is equal to each
  # corresponding element in *other*.
  #
  # ```
  # array = SmallArray(Int32, 3).new 0  # => SmallArray[0, 0, 0]
  # array2 = SmallArray(Int32, 3).new 0 # => SmallArray[0, 0, 0]
  # array3 = SmallArray(Int32, 3).new 1 # => SmallArray[1, 1, 1]
  # array == array2                     # => true
  # array == array3                     # => false
  # ```
  def ==(other : SmallArray)
    return false unless size == other.size
    each_with_index do |e, i|
      return false unless e == other[i]
    end
    true
  end

  # :nodoc:
  def ==(other)
    false
  end

  @[AlwaysInline]
  def unsafe_fetch(index : Int)
    to_unsafe[index].as(T)
  end

  # Sets the given value at the given *index*.
  #
  # Negative indices can be used to start counting from the end of the array.
  # Raises `IndexError` if trying to set an element outside the array's range.
  #
  # ```
  # array = SmallArray(Int32, 3).new { |i| i + 1 } # => SmallArray[1, 2, 3]
  # array[2] = 2                                   # => 2
  # array                                          # => SmallArray[1, 2, 2]
  # array[4] = 4                                   # raises IndexError
  # ```
  @[AlwaysInline]
  def []=(index : Int, value : T)
    index = check_index_out_of_bounds index
    to_unsafe[index] = value
  end

  # Yields the current element at the given index and updates the value
  # at the given *index* with the block's value.
  # Raises `IndexError` if trying to set an element outside the array's range.
  #
  # ```
  # array = SmallArray(Int32, 3).new { |i| i + 1 } # => SmallArray[1, 2, 3]
  # array.update(1) { |x| x * 2 }                  # => 4
  # array                                          # => SmallArray[1, 4, 3]
  # array.update(5) { |x| x * 2 }                  # raises IndexError
  # ```
  def update(index : Int)
    index = check_index_out_of_bounds index
    to_unsafe[index] = yield to_unsafe[index]
  end

  # Returns the size of `self`
  #
  # ```
  # array = SmallArray(Int32, 3).new { |i| i + 1 }
  # array.size # => 3
  # ```
  def size : Int32
    @size
  end

  # Returns a slice that points to the elements of this small array.
  # Changes made to the returned slice also affect this small array.
  #
  # ```
  # array = SmallArray(Int32, 3).new(2)
  # slice = array.to_slice # => Slice[2, 2, 2]
  # slice[0] = 3
  # array # => SmallArray[3, 2, 2]
  # ```
  def to_slice : Slice(T)
    Slice.new(to_unsafe, size)
  end

  # Returns a pointer to this small array's data.
  #
  # ```
  # ary = SmallArray(Int32, 3).new(42)
  # ary.to_unsafe[0] # => 42
  # ```
  def to_unsafe
    @buffer
  end

  # Appends a string representation of this small array to the given `IO`.
  #
  # ```
  # array = SmallArray(Int32, 3).new { |i| i + 1 }
  # array.to_s # => "SmallArray[1, 2, 3]"
  # ```
  def to_s(io : IO) : Nil
    io << "SmallArray["
    join io, ", ", &.inspect(io)
    io << ']'
  end

  def pretty_print(pp)
    # Don't pass `self` here because we'll pass `self` by
    # value and for big static arrays that seems to make
    # LLVM really slow.
    # TODO: investigate why, maybe report a bug to LLVM?
    pp.list("SmallArray[", to_slice, "]")
  end

  # Returns a new `SmallArray` where each element is cloned from elements in `self`.
  def clone
    array = uninitialized self
    CAPACITY.times do |i|
      array.to_unsafe[i] = to_unsafe[i].clone
    end
    array
  end

  # :nodoc:
  def size=(size : Int)
    @size = size.to_i
  end

  # Combined comparison operator.
  #
  # Returns `-1`, `0` or `1` depending on whether `self` is less than *other*, equals *other*
  # or is greater than *other*.
  #
  # It compares the elements of both arrays in the same position using the
  # `<=>` operator. As soon as one of such comparisons returns a non-zero
  # value, that result is the return value of the comparison.
  #
  # If all elements are equal, the comparison is based on the size of the arrays.
  #
  # ```
  # SmallArray.new(8) <=> SmallArray.new(1, 2, 3) # => 1
  # SmallArray.new(2) <=> SmallArray.new(4, 2, 3) # => -1
  # SmallArray.new(1, 2) <=> SmallArray.new(1, 2) # => 0
  # ```
  def <=>(other : SmallArray) # TODO: work with Array
    min_size = Math.min(size, other.size)
    0.upto(min_size - 1) do |i|
      n = self[i] <=> other[i]
      return n if n != 0
    end
    size <=> other.size
  end

  # Set intersection: returns a new `Array` containing elements common to `self`
  # and *other*, excluding any duplicates. The order is preserved from `self`.
  #
  # ```
  # SmallArray[1, 1, 3, 5] & SmallArray[1, 2, 3]               # => SmallArray[ 1, 3 ]
  # SmallArray['a', 'b', 'b', 'z'] & SmallArray['a', 'b', 'c'] # => SmallArray[ 'a', 'b' ]
  # ```
  #
  # See also: `#uniq`.
  def &(other : SmallArray(U)) forall U
    return SmallArray(T).new if self.empty? || other.empty?

    ary = SmallArray(T).new
    each do |elem|
      ary << elem if !ary.includes?(elem) && other.includes?(elem)
    end
    ary
  end

  # Set union: returns a new `Array` by joining `self` with *other*, excluding
  # any duplicates, and preserving the order from `self`.
  #
  # ```
  # SmallArray["a", "b", "c"] | SmallArray["c", "d", "a"] # => SmallArray[ "a", "b", "c", "d" ]
  # ```
  #
  # See also: `#uniq`.
  def |(other : SmallArray(U)) forall U
    ary = SmallArray(T | U).new
    each do |elem|
      ary << elem unless ary.includes?(elem)
    end
    other.each do |elem|
      ary << elem unless ary.includes?(elem)
    end
    ary
  end

  # Concatenation. Returns a new `SmallArray` built by concatenating `self` and *other*.
  # The type of the new array is the union of the types of both the original arrays.
  #
  # ```
  # SmallArray[1, 2] + SmallArray["a"]  # => SmallArray[1,2,"a"] of (Int32 | String)
  # SmallArray[1, 2] + SmallArray[2, 3] # => SmallArray[1,2,2,3]
  # ```
  def +(other : SmallArray(U)) forall U
    ary = SmallArray(T | U).new
    # TODO make this more performant
    ary = ary | self
    ary = ary | other
    ary
  end

  # Difference. Returns a new `Array` that is a copy of `self`, removing any items
  # that appear in *other*. The order of `self` is preserved.
  #
  # ```
  # SmallArray[1, 2, 3] - SmallArray[2, 1] # => SmallArray[3]
  # ```
  def -(other : SmallArray(U)) forall U
    ary = SmallArray(T).new
    each do |elem|
      ary << elem unless other.includes?(elem)
    end
    ary
  end

  def <<(obj : T) : (self | Array(T))
    # TODO: check to upgrade
    @buffer[@size] = obj
    @size += 1
    self
  end

  def push(obj : T) : (self | Array(T))
    self.<<(obj)
  end

  # Optimized version of `Enumerable#map`.
  def map(&block : T -> U) forall U
    SmallArray(U).new { |i| yield self[i] }
  end
end
