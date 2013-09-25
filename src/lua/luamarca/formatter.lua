--------------------------------------------------------------------------------
-- formatter.lua: benchmark results printing utillity
-- This file is a part of luamarca library
-- Copyright (c) luamarca authors (see file `COPYRIGHT` for the license)
--------------------------------------------------------------------------------

--Prints raw data
local dump_raw_data = function(data)
  for method, method_data in pairs(data) do
    for i, v in ipairs(method_data) do
      print(
          method,
          v.name,
          v.timing,
          v.iterations
        )
    end
  end
end

--Prints data for bargraph.pl tool
local print_bargraph = function(data)
  for method, method_data in pairs(data) do
    io.write("# begin method ", method, "\n")

    local groups = setmetatable({ }, { 
        __index = function(t, k) 
            local v = {} 
            rawset(t, k, v) 
            return v 
          end 
        }
      )

    local benches = {}

    local max_timing = 0

    for i, v in ipairs(method_data) do
      v.group, v.bench = v.name:match("(.-)@(.*)")
      v.group = v.group ~= "" and (v.group or v.name) or "(?)"
      v.bench = v.bench ~= "" and v.bench or "(?)"
      v.bench = tonumber(v.bench) or v.bench

      local g = groups[v.group]
      assert(not g[v.bench])
      g[v.bench] = v

      benches[v.bench] = true

      max_timing = math.max(max_timing, v.timing)
    end

    --max_timing = 65

    local old_benches = benches
    benches = {}
    for bench, _ in pairs(old_benches) do
      benches[#benches + 1] = bench
    end
    table.sort(benches)

    io.write("=cluster")
    for _, bench in ipairs(benches) do
      io.write(";", bench)
    end
    io.write("\n")

    --io.write("colors=black,yellow,red,med_blue,light_gray\n")
    io.write("=table\n")
    io.write("yformat=%4.3f\n")
    io.write("max=", max_timing, "\n")
    io.write("=norotate\n")
    io.write("ylabel=Time (sec)\n")
    io.write("title=Benchmark results\n")
    --io.write("extraops=set yrange [0:", max_timing, "]\n")
    --io.write("extraops=set logscale y\n")
    io.write("\n")

    for group, group_data in pairs(groups) do
      io.write(group)
      for _, bench in ipairs(benches) do
        io.write("\t", assert(group_data[bench]).timing)
      end
      io.write("\n")
    end

    io.write("# end method ", method, "\n")
  end
end

local print_table = function(data)
  print("Results:")

  for method, method_data in pairs(data) do
    print(method)
    print("-------------------------------------------------------------------")
    print(
        ("%20s | %7s | %s s / %s = %s"):format(
            "name", "rel", "abs", "iter", "us (1e-6 s) / iter"
          )
      )
    print("-------------------------------------------------------------------")

    if #method_data == 0 then
      print("-- empty --")
    else
      table.sort(method_data, function(lhs, rhs) return lhs.timing < rhs.timing end)

      local fastest = method_data[1].timing

      for i, v in ipairs(method_data) do
        print(
            ("%20s | %7.4f | %6.2f / %10d = %f us"):format(
                v.name,
                v.timing / fastest,
                v.timing,
                v.iterations,
                (v.timing * 1e6) / v.iterations -- microseconds
              )
          )
      end
    end
  end
end

--------------------------------------------------------------------------------
local format = function(data, mode) 
  mode = mode or 'table'

  if mode == "raw" then
    dump_raw_data(data)
  elseif mode == "bargraph" then
    print_bargraph(data)
  elseif mode == "table" then
    print_table(data)
  else
    print("Unknown mode: " .. mode)
  end
end

return {
  format = format;
}