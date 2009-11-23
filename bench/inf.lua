local bench = {}

bench.e309 = function()
  local inf = 1e309
end

bench.huge = function()
  local inf = math.huge
end

bench.divide = function()
  local inf = 1/0
end

bench.tonumber = function()
  local inf = tonumber("inf")
end

return bench
