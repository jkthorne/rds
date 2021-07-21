require "../src/small_array"
require "benchmark"

Benchmark.ips do |x|
  x.report("Array") do
    arr = [] of Symbol
    arr << :zero
    arr << :one
    arr << :two
  end

  x.report("StaticArray") do
    arr = StaticArray(Symbol, 3).new { :nil }
    arr.update(0) { :zero }
    arr.update(1) { :one }
    arr.update(2) { :two }
  end
end
