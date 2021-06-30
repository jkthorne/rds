class LinkedList(T)
  include Indexable(T)
  include Comparable(LinkedList)

  property next : self | Nil
  property value : T

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

  def append(value : T)
    value_node = {{@type}}.new(value)
    node = self

    while next_node = node.try &.next
      node = next_node
    end
    node.next = value_node

    value_node
  end

  def insert(value : T)
    new_next = T.new(value, self.next)
    self.next = new_next
    new_next
  end

  def unsafe_fetch(n) : T
    node : self = self
    n.times do |i|
      next_node = node.next
      if next_node.nil?
        raise IndexError.new
      else
        node = next_node
      end
    end
    node.value
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
