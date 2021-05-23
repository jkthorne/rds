require "./spec_helper"

describe RingBuffer do
  context "#inspect" do
    it "initial inspect" do
      io = IO::Memory.new
      ring = RingBuffer(Int32).new(3)

      ring.inspect(io)

      io.to_s.should eq "RingBuffer(WR->0, 0, 0)"
    end

    it "with object inserted" do
      io = IO::Memory.new
      ring = RingBuffer(Int32).new(3)

      ring.write(1)
      ring.inspect(io)

      io.to_s.should eq "RingBuffer(R->0, W->1, 0)"
    end

    it "with multiple object inserted" do
      io = IO::Memory.new
      ring = RingBuffer(Int32).new(3)

      ring.write(1)
      ring.write(2)
      ring.inspect(io)

      io.to_s.should eq "RingBuffer(R->0, 1, W->2)"
    end

    it "with object consumed" do
      io = IO::Memory.new
      ring = RingBuffer(Int32).new(3)

      ring.write 1
      ring.write 2
      ring.read.should eq 1
      ring.inspect(io)

      io.to_s.should eq "RingBuffer(0, R->1, W->2)"
    end
  end

  context "#write" do
    it "insert a value into the buffer" do
      ring = RingBuffer(Int32).new(3)

      ring.write(1)
      
      ring.read.should eq 1
    end

    it "raises if it goes past the reader" do
      ring = RingBuffer(Int32).new(3)

      ring.write(1)
      ring.write(2)

      expect_raises RingBuffer::ReaderWriterColision, "reader has not caught up to writer" do
        ring.write(3)
      end
    end
  end
end
