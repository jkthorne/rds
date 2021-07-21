require "./spec_helper"

def build_arr(*elements)
  # arr = SortedArray(typeof()).new
  # (1..(count)).each{ |i| arr << elements[i]? || i }
  # arr
  elements.to_a.unsafe_as(SortedArray(Int32))
end

describe SortedArray do
  describe "#<=>" do
    it "returns 0 for match" do
      (build_arr(1) <=> build_arr(1)).should eq 0
    end

    it "returns -1 for left side less then" do
      (build_arr(1) <=> build_arr(2)).should eq -1
    end

    it "returns 1 for right side less then" do
      (build_arr(2) <=> build_arr(1)).should eq 1
    end
  end

  describe "&" do
    it "SortedArray intersection" do
      (build_arr(1, 2, 3) & SortedArray(Int32).new).should eq(SortedArray(Int32).new)
      (SortedArray(Int32).new & build_arr(1, 2, 3)).should eq(SortedArray(Int32).new)
      (build_arr(1, 2, 3) & build_arr(3, 2, 4)).should eq(build_arr(2, 3))
      (build_arr(1, 2, 3, 1, 2, 3) & build_arr(3, 2, 4, 3, 2, 4)).should eq(build_arr(2, 3))
      (build_arr(1, 2, 3, 1, 2, 3, nil, nil) & build_arr(3, 2, 4, 3, 2, 4, nil)).should eq(build_arr(2, 3, nil))
    end

    #   it "Array Intersection" do
    #   end
  end
end
