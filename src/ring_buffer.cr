class RingBuffer(T)
  include Indexable(T)

  @size : Int32
  @buffer : Pointer(T)
  @writer : Int32 = 0
  @reader : Int32 = 0

  def initialize(@size : Int32 = 64)
    if @size < 0
      raise ArgumentError.new("Negative array size: #{@size}")
    end
    @buffer = Pointer(T).malloc(@size)
  end

  def write(value : T)
    new_writer = (@writer + 1) % @size

    if new_writer != @reader
      @writer = new_writer
    else
      raise ReaderWriterColision.new
    end

    @buffer[@writer] = value
    self
  end

  def read
    if @reader != @writer
      @reader = (@reader + 1) % @size
    else
      raise ReaderWriterColision.new
    end

    @buffer[@reader]
  end

  def inspect(io)
    count = 0

    io << "RingBuffer("
    while count < @size
      io << ", " unless count == 0
      io << "W" if count == @writer
      io << "R" if count == @reader
      io << "->" if count == @writer || count == @reader
      
      @buffer[count].as(T).inspect(io)
      count = count + 1
    end
    io << ")"
  end

  @[AlwaysInline]
  private def unsafe_fetch(index : Int)
    @buffer[index]
  end

  class ReaderWriterColision < Exception
    def initialize(message = "reader has not caught up to writer")
      super(message)
    end
  end
end