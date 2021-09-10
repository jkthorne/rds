require "./spec_helper"

describe "SmallArray" do
  it "smoke test" do
    arr = SmallArray(Int32).new

    arr << 1
    arr << 2
    arr << 3

    arr.should eq SmallArray(Int32).new(1, 2, 3)
  end

  describe "==" do
    it "compares empty" do
      (SmallArray(Int32).new).should eq(SmallArray(Int32).new)
      SmallArray[1].should_not eq(SmallArray(Int32).new)
      (SmallArray(Int32).new).should_not eq(SmallArray[1])
    end

    it "compares elements" do
      SmallArray[1, 2, 3].should eq(SmallArray[1, 2, 3])
      SmallArray[1, 2, 3].should_not eq(SmallArray[3, 2, 1])
    end

    it "compares other" do
      a = SmallArray[1, 2, 3]
      b = SmallArray[1, 2, 3]
      c = SmallArray[1, 2, 3, 4]
      d = SmallArray[1, 2, 4]
      (a == b).should be_true
      (b == c).should be_false
      (a == d).should be_false
    end
  end

  describe "&" do
    it "small arrays" do
      (SmallArray[1, 2, 3] & SmallArray(Int32).new).should eq(SmallArray(Int32).new)
      (SmallArray(Int32).new & SmallArray[1, 2, 3]).should eq(SmallArray(Int32).new)
      (SmallArray[1, 2, 3] & SmallArray[3, 2, 4]).should eq(SmallArray[2, 3])
      (SmallArray[1, 2, 3, 1, 2, 3] & SmallArray[3, 2, 4, 3, 2, 4]).should eq(SmallArray[2, 3])
      (SmallArray[1, 2, 3, 1, 2, 3, nil, nil] & SmallArray[3, 2, 4, 3, 2, 4, nil]).should eq(SmallArray[2, 3, nil])
    end

    # it "big arrays" do
    #   a1 = (1..64).to_a
    #   a2 = (33..96).to_a
    #   (a1 & a2).should eq((33..64).to_a)
    # end
  end

  describe "|" do
    it "small arrays" do
      (SmallArray[1, 2, 3, 2, 3] | SmallArray(Int32).new).should eq(SmallArray[1, 2, 3])
      (SmallArray(Int32).new | SmallArray[1, 2, 3, 2, 3]).should eq(SmallArray[1, 2, 3])
      (SmallArray[1, 2, 3] | SmallArray[5, 3, 2, 4]).should eq(SmallArray[1, 2, 3, 5, 4])
      (SmallArray[1, 1, 2, 3, 3] | SmallArray[4, 5, 5, 6]).should eq(SmallArray[1, 2, 3, 4, 5, 6])
    end

    # it "large arrays" do
    #   a = [1, 2, 3] * 10
    #   b = [4, 5, 6] * 10
    #   (a | b).should eq([1, 2, 3, 4, 5, 6])
    # end
  end

  describe "+" do
    it "small array" do
      a = SmallArray[1, 2, 3]
      b = SmallArray[4, 5]
      c = a + b
      c.size.should eq(5)
      0.upto(4) { |i| c[i].should eq(i + 1) }
    end

    it "does * with Int" do
      # (SmallArray(Int32).new) * 10).empty?.should be_true
      # (SmallArray[1, 2, 3] * 0).empty?.should be_true
      # (SmallArray[1] * 3).should eq(SmallArray[1, 1, 1])
      # (SmallArray[1, 2, 3] * 3).should eq(SmallArray[1, 2, 3, 1, 2, 3, 1, 2, 3])
      # (SmallArray[1, 2] * 10).should eq(SmallArray[1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2])
    end
  end

  describe "-" do
    it "does it" do
      (SmallArray[1, 2, 3, 4, 5] - SmallArray[4, 2]).should eq(SmallArray[1, 3, 5])
    end

    it "does with larger array coming second" do
      (SmallArray[4, 2] - SmallArray[1, 2, 3]).should eq(SmallArray[4])
    end

    # it "does with even larger arrays" do
    #   ((1..64).to_a - (1..32).to_a).should eq((33..64).to_a)
    # end
  end

  describe "#<=>" do
    it "smoke test" do # taken from stdlib array specs
      a = SmallArray[1, 2, 3]
      b = SmallArray[4, 5, 6]
      c = SmallArray[1, 2]

      (a <=> b).should be < 0
      (a <=> c).should be > 0
      (b <=> c).should be > 0
      (b <=> a).should be > 0
      (c <=> a).should be < 0
      (c <=> b).should be < 0
      (a <=> a).should eq(0)

      ([8] <=> [1, 2, 3]).should be > 0
      ([8] <=> [8, 1, 2]).should be < 0
    end

    it "returns 0 for match" do
      (SmallArray[1] <=> SmallArray[1]).should eq 0
    end

    it "returns -1 for left side less then" do
      (SmallArray[1] <=> SmallArray[2]).should eq -1
    end

    it "returns 1 for right side less then" do
      (SmallArray[2] <=> SmallArray[1]).should eq 1
    end
  end

  describe "#size" do
    it "returns a count off the elements populated" do
      SmallArray[0].size.should eq 1
      SmallArray[0, 1, 2, 3, 4, 5].size.should eq 6
      SmallArray[0, 1, 2, 3, 4, 5, 6, 7].size.should eq 8
    end
  end

  describe "#[]" do
    it "returns the indexed element" do
      arr = SmallArray[0, 1, 2, 3, 4, 5, 6, 7]
      arr[0].should eq 0
      arr[1].should eq 1
      arr[2].should eq 2
      arr[3].should eq 3
      arr[4].should eq 4
      arr[5].should eq 5
      arr[6].should eq 6
      arr[7].should eq 7
    end
  end
end
