class BinaryTree(T)
  include Indexable(T)

  class Node(T)
    property left : Node(T)?
    property right : Node(T)?
    getter value : T

    def initialize(@value : T)
    end
  end

  getter root : Node(T)

  def initialize(value : T)
    @root = Node.new(value)
  end

  def <=>(other : self)
    min_size = Math.min(size, other.size)

    0.upto(min_size - 1) do |i|
      n = self[i] <=> other[i]
      return n if n != 0
    end

    size <=> other.size
  end

  def <<(value : T)
    iter = TreeNodeIterator.new(root)

    while node = iter.next
      next_node = iter.next

      if next_node.is_a?(Iterator::Stop)
        break
      else
        node = next_node
      end
    end

    working_node = node.as(Node)
    if working_node.right.nil?
      working_node.right = Node.new(value)
    else
      working_node.left = Node.new(value)
    end

    self
  end

  # TODO: add #insert_at and #delete_at

  def unsafe_fetch(n) : T
    iter = each
    value = iter.next

    n.times do |i|
      value = iter.next

      if value.is_a?(Iterator::Stop)
        raise IndexError.new
      else
        node = value
      end
    end

    value.as(T)
  end

  def each
    TreeIterator.new(root)
  end

  def each
    TreeIterator.new(root).each { |n| yield n }
  end

  private class TreeIterator(N)
    include Iterator(N)

    @stack = Array(N).new
    @started = false

    def initialize(node : N)
      while !node.nil?
        @stack.push(node)
        node = node.left
      end
    end

    def next
      if @started
        node = @stack.last.right
        @stack.pop
         
        while !node.nil?
          @stack.push(node)
          node = node.left
        end
      else
        @started = true
      end
  
      node = @stack.last?
      node ? node.value : stop
    end
  end

  private class TreeNodeIterator(N)
    include Iterator(N)

    @stack = Array(N).new
    @started = false

    def initialize(node : N)
      while !node.nil?
        @stack.push(node)
        node = node.left
      end
    end

    def next
      if @started
        node = @stack.last.right
        @stack.pop
         
        while !node.nil?
          @stack.push(node)
          node = node.left
        end
      else
        @started = true
      end
  
      node = @stack.last?
      node ? node : stop
    end
  end
end
