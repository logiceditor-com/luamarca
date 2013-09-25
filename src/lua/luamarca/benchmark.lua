--------------------------------------------------------------------------------
-- benchmark.lua: benchmarking utillity
-- This file is a part of luamarca library
-- Copyright (c) luamarca authors (see file `COPYRIGHT` for the license)
--------------------------------------------------------------------------------

require "socket"

local split_by_char
      = import 'lua-nucleo/string.lua'
      {
        'split_by_char'
      }

--------------------------------------------------------------------------------

local benchmark = { 
    --Comma separatd list of methods allowed for benchmarking. Empty list means 
    --all methods will be benchmarked
    methods = '';
  }

--Run single method with a specified number of times.
--@param method Method name
--@param handler Method function
--@param number_iterations Number of iterations
local execute_method = function(method, handler, number_iterations)
  local t0 = socket.gettime()
  
  for i = 1, number_iterations do
    handler()
  end
  
  local t1 = socket.gettime()

  return {
      name = method;
      iterations = number_iterations;
      timing = t1 - t0;
    }
end

--Run all methods in a single benchmark suite. 
--Note: this method can run only filtered methods if benchmark.filtered methods
--is specified
--@param number_iterations Number of iterations
local execute = function(self, number_iterations)
  local results = { }

  if self.methods ~= '' then
    local methods = split_by_char(self.methods, ',')
    for i = 1, #methods do
      local method = methods[i]
      local handler = self.handlers[method]
      table.insert(results, execute_method(method, handler, number_iterations))
    end
  else
    for method, handler in pairs(self.handlers) do
      table.insert(results, execute_method(method, handler, number_iterations))
    end
  end

  return results
end

--Load benchmark suite from file
--@param filename benchmark suite file name
local load_benchmark = function(filename) 
  local res, err = loadfile(filename)
  if not res then
    return nil, "Failed to load file " .. filename .. ":\n" .. tostring(err)
  end

  local status, res = pcall(res)
  
  if not status then
    return nil, "Failed to run file " .. filename .. ":\n" .. tostring(res)
  end
  
  if type(res) ~= "table" then
    return nil, "Bad file " .. filename 
        .. " result: handler_map table expected, got " .. tostring(res)
  end

  return {
    handlers = res;
    filename = filename;
    execute = execute;
  }
end

return {
  load_benchmark = load_benchmark;
}
