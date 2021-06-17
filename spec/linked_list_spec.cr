require "./spec_helper"

class BasicList
  include LinkedList(Int32)
end

def build_basic_list(count = 5)
  head = BasicList.new(1)
  list = head
  (2..(count)).each do |i|
    list = list.insert(i)
  end
  head
end

describe LinkedList do
  context "#<=>" do
    (BasicList.new(1) <=> BasicList.new(1)).should eq 0
    (BasicList.new(1) <=> BasicList.new(2)).should eq -1
    (BasicList.new(2) <=> BasicList.new(1)).should eq 1
  end

  context "Iterator" do
    it "#each" do
      list = build_basic_list
      values = [] of Int32

      list.each { |l| values << l.value }

      values.should eq [1, 2, 3, 4, 5]
    end
  end

  context "Enumerable" do
    it "#map" do
      list = build_basic_list

      result = list.map { |n| n.value }

      result.should eq [1, 2, 3, 4, 5]
    end

    it "#minmax" do
      list = build_basic_list
      
      result = list.minmax

      result.map(&.value).should eq({1, 5})
    end
  end
end
