require "./spec_helper"

def build_basic_list(count = 5)
  head = LinkedList.new(1, nil)
  list = head
  (2..(count)).each do |i|
    list = list.next = LinkedList.new(i, nil)
    # list.append(i)
    # list = list.insert(i)
  end
  head
end

describe LinkedList do
  context "#<=>" do
    it "returns 0 for match" do
      (LinkedList.new(1, nil) <=> LinkedList.new(1, nil)).should eq 0
    end

    it "returns -1 for left side less then" do
      (LinkedList.new(1, nil) <=> LinkedList.new(2, nil)).should eq -1
    end

    it "returns 1 for right side less then" do
      (LinkedList.new(2, nil) <=> LinkedList.new(1, nil)).should eq 1
    end
  end

  context "Iterator" do
    it "#each" do
      list = build_basic_list
      values = [] of Int32

      list.each { |v| values << v }

      values.should eq [1, 2, 3, 4, 5]
    end
  end

  context "Enumerable" do
    it "#map" do
      list = build_basic_list

      result = list.map { |v| v * 10 }

      result.should eq [10, 20, 30, 40, 50]
    end

    it "#minmax" do
      list = build_basic_list

      result = list.minmax

      result.map(&.itself).should eq({1, 5})
    end
  end
end
