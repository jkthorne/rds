require "./spec_helper"

def build_tree(count = 5)
  tree = BinaryTree.new(4)

  tree.root.left = BinaryTree::Node.new(2)
  tree.root.left.not_nil!.left = BinaryTree::Node.new(1)
  tree.root.left.not_nil!.right = BinaryTree::Node.new(3)
  tree.root.right = BinaryTree::Node.new(6)
  tree.root.right.not_nil!.left = BinaryTree::Node.new(5)
  tree.root.right.not_nil!.right = BinaryTree::Node.new(7)

  tree
end

describe BinaryTree do
  context "#<=>" do
    it "returns 0 for match" do
      (BinaryTree.new(1) <=> BinaryTree.new(1)).should eq 0
    end

    it "returns -1 for left side less then" do
      (BinaryTree.new(1) <=> BinaryTree.new(2)).should eq -1
    end

    it "returns 1 for right side less then" do
      (BinaryTree.new(2) <=> BinaryTree.new(1)).should eq 1
    end
  end

  context "Iterator" do
    it "#each" do
      tree = build_tree
      values = [] of Int32

      tree.each { |v| values << v }

      values.should eq [1, 2, 3, 4, 5, 6, 7]
    end
  end

  context "Enumerable" do
    it "#map" do
      tree = build_tree

      result = tree.map { |v| v * 10 }

      result.should eq [10, 20, 30, 40, 50, 60, 70]
    end

    it "#minmax" do
      tree = build_tree

      result = tree.minmax

      result.map(&.itself).should eq({1, 7})
    end
  end

  context "Indexable" do
    context "#[]" do
      it "returns a value with a positive index" do
        tree = build_tree

        tree[0].should eq 1
        tree[1].should eq 2
        tree[2].should eq 3
      end

      it "returns a value with a negative index" do
        tree = build_tree

        tree[-1].should eq tree.last
        tree[-2].should eq 6
        tree[-3].should eq 5
        tree[-4].should eq 4
      end
    end
  end

  context "#append" do
    it "adds a value to the end of the tree" do
      tree = build_tree
      expected_value = 10

      tree << expected_value

      tree.first.should_not eq expected_value
      tree.last.should eq expected_value
    end
  end
end
