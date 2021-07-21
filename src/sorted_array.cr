class SortedArray(T) < Array(T)
  # Set intersection: returns a new `SortedArray` containing elements common to `self`
  # and *other*, excluding any duplicates.
  #
  # ```
  # [1, 1, 3, 5] & [1, 2, 3]               # => [ 1, 3 ]
  # ['a', 'b', 'b', 'z'] & ['a', 'b', 'c'] # => [ 'a', 'b' ]
  # ```
  #
  # See also: `#uniq`.
  def &(other : SortedArray(U)) forall U
    ary = SortedArray(T).new
    return ary if self.empty? || other.empty?

    each do |elem|
      ary << elem if !ary.includes?(elem) && other.includes?(elem)
    end

    return ary
  end
end
