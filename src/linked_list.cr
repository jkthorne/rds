module LinkedList(T)
  macro included
    include Enumerable({{@type}})

    getter next : {{@type}} | Nil
    @next : {{@type}} | Nil
  end

  getter value : T
  @next : T | Nil

  def initialize(@value : T, @next = nil)
  end

  def <=>(other)
    value <=> other.try &.value
  end

  def each
    ListIterator.new(self)
  end

  def each
    ListIterator.new(self).each { |n| yield n }
  end

  def insert(value : T) : self
    new_next = {{@type}}.new(value)
    @next = new_next
    new_next
  end

  def unsafe_fetch(n)
    node = self
    n.times do |i|
      node = node.try &.next
    end
    node
  end

  private class ListIterator(T)
    include Iterator(T)

    @at_start = true

    def initialize(@node : T | Nil)
    end

    def next
      node = @node
      return stop if node.nil?

      if @at_start
        @at_start = false
        return node
      else
        node = node.next
        if node
          @node = node
          return node
        end
        stop
      end
    end
  end
end
