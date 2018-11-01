require 'benchmark'
include Benchmark

a = "Hello, World!"

bm(9) do |x|
  x.report("indirect") { 10_000_000.times { b = "#{a}" } }
  x.report("ind-case") { 10_000_000.times { b = "#{a.upcase}" } }
  x.report("direct")   { 10_000_000.times { b = "Hello, World!" } }
  x.report("litdirect") { 10_000_000.times { b = 'Hello, World!' } }
end