require "../src/small_array"
require "benchmark"
require "colorize"

std_array = [0, 1, 2, 3, 4, 5, 6, 7]
static_array = StaticArray[0, 1, 2, 3, 4, 5, 6, 7]
small_array = SmallArray[0, 1, 2, 3, 4, 5, 6, 7]

puts "#push".colorize(:yellow)
Benchmark.ips do |x|
  x.report("Array") do
    arr = [] of Symbol
    arr << :zero
    arr << :one
    arr << :two
  end

  x.report("SmallArray") do
    arr = SmallArray(Symbol).new
    arr << :zero
    arr << :one
    arr << :two
  end
end

puts "#fetch".colorize(:yellow)
Benchmark.ips do |x|
  x.report("Array") do
    std_array.fetch(0, :default_value)
    std_array.fetch(2, :default_value)
  end

  x.report("SmallArray") do
    small_array.fetch(0, :default_value)
    small_array.fetch(2, :default_value)
  end
end

puts "#map".colorize(:yellow)
Benchmark.ips do |x|
  x.report("Array") do
    std_array.map { |i| i * 10 }
  end

  x.report("SmallArray") do
    small_array.map { |i| i * 10 }
  end
end

puts "#values_at".colorize(:yellow)
Benchmark.ips do |x|
  x.report("Array") do
    std_array.values_at(0, 2)
  end

  x.report("SmallArray") do
    small_array.values_at(0, 2)
  end
end
