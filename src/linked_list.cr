class LinkedList(T)
  include Indexable(T)
  include Comparable(LinkedList)

  class Node(T)
    property next : self | Nil
    property value : T

    def initialize(@value : T, @next = nil)
    end  
  end

  getter root : Node(T)

  def initialize(value : T)
    @root = Node.new(value)
  end

  def <=>(other)
    min_size = Math.min(size, other.size)

    0.upto(min_size - 1) do |i|
      n = self[i] <=> other[i]
      return n if n != 0
    end

    size <=> other.size
  end

  def each
    ListIterator.new(root)
  end

  def each
    ListIterator.new(root).each { |n| yield n }
  end

  def size : Int32
    count = 1
    node = root

    while node = node.try &.next
      count += 1
    end

    count
  end

  def <<(value : T)
    node = root

    while next_node = node.try &.next
      node = next_node
    end
    node.next = Node.new(value)

    self
  end

  # TODO: add #insert_at and #delete_at

  def unsafe_fetch(n) : T
    node : Node(T) = root

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

  private class ListIterator(N)
    include Iterator(N)

    @node : N | Nil
    @started = true

    def initialize(@node : N)
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
