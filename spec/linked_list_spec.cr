require "./spec_helper"

def build_list(count = 5)
  list = LinkedList.new(1)
  (2..(count)).each{ |i| list << i }
  list
end

describe LinkedList do
  context "#<=>" do
    it "returns 0 for match" do
      (LinkedList.new(1) <=> LinkedList.new(1)).should eq 0
    end

    it "returns -1 for left side less then" do
      (LinkedList.new(1) <=> LinkedList.new(2)).should eq -1
    end

    it "returns 1 for right side less then" do
      (LinkedList.new(2) <=> LinkedList.new(1)).should eq 1
    end
  end

  context "#size" do
    it "returns the size of the list" do
      build_list(3).size.should eq 3
      build_list(10).size.should eq 10
      build_list(25).size.should eq 25
    end
  end

  context "Iterator" do
    it "#each" do
      list = build_list
      values = [] of Int32

      list.each { |v| values << v }

      values.should eq [1, 2, 3, 4, 5]
    end
  end

  context "Enumerable" do
    it "#map" do
      list = build_list

      result = list.map { |v| v * 10 }

      result.should eq [10, 20, 30, 40, 50]
    end

    it "#minmax" do
      list = build_list

      result = list.minmax

      result.map(&.itself).should eq({1, 5})
    end
  end

  context "Indexable" do
    context "#[]" do
      it "returns a value with a positive index" do
        list = build_list

        list[0].should eq 1
        list[1].should eq 2
        list[2].should eq 3
      end

      it "returns a value with a negative index" do
        list = build_list

        list[-1].should eq list.last
        list[-2].should eq 4
        list[-3].should eq 3
        list[-4].should eq 2
      end
    end
  end

  context "#<<" do
    it "adds a value to the end of the list" do
      list = build_list
      expected_value = 10

      list << expected_value

      list.first.should_not eq expected_value
      list.last.should eq expected_value
    end
  end
end
