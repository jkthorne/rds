class LinkedList(T)
  include Enumerable(T)
  include Comparable(LinkedList)

  property next : self | Nil
  property value : T

  def initialize(@value : T, @next)
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

  def tail
    each.reduce(self) { |n| n }
  end

  # def append(value : T)
  #   new_next = T.new(value)
  #   last.next = new_next
  #   new_next
  # end

  # def insert(value : T)
  #   new_next = T.new(value)
  #   tail.next = new_next
  #   new_next
  # end

  def unsafe_fetch(n)
    node = self
    n.times do |i|
      node = node.try &.next
    end
    node
  end

  private class ListIterator(L)
    include Iterator(L)

    @node : L | Nil
    @started = true

    def initialize(@node : L)
    end

    def next
      node = @node
      return stop if node.nil?

      started = @started
      if started
        @started = false
        return node.value
      else
        node = node.next
        if node
          @node = node
          return node.value
        end
        stop
      end
    end
  end
end
