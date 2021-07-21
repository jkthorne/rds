require "./spec_helper"

describe "SmallArray" do
  it "smoke test" do
    arr = SmallArray(Int32, 8).new

    arr << 1
    arr << 2
    arr << 3

    arr.should eq SmallArray(Int32, 8).new(1, 2, 3)
  end

  # describe "#<=>" do
  #   it "returns 0 for match" do
  #     (SmallArray(Int32, 8).new(1) <=> SmallArray(Int32, 8).new(1)).should eq 0
  #   end

  #   it "returns -1 for left side less then" do
  #     (SmallArray(Int32, 8).new(1) <=> SmallArray(Int32, 8).new(2)).should eq -1
  #   end

  #   it "returns 1 for right side less then" do
  #     (SmallArray(Int32, 8).new(2) <=> SmallArray(Int32, 8).new(1)).should eq 1
  #   end
  # end

  # describe "#size" do
  #   it "returns a count off the elements populated" do
  #     SmallArray(Int32, 8).new(0).size.should eq 1
  #     SmallArray(Int32, 8).new(0, 1, 2, 3, 4, 5).size.should eq 6
  #     SmallArray(Int32, 8).new(0, 1, 2, 3, 4, 5, 6, 7).size.should eq 8
  #   end
  # end

  # describe "#[]" do
  #   it "returns the indexed element" do
  #     arr = SmallArray(Int32, 8).new(0, 1, 2, 3, 4, 5, 6, 7)
  #     arr[0].should eq 0
  #     arr[1].should eq 1
  #     arr[2].should eq 2
  #     arr[3].should eq 3
  #     arr[4].should eq 4
  #     arr[5].should eq 5
  #     arr[6].should eq 6
  #     arr[7].should eq 7
  #   end
  # end
end
