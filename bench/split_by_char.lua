--
-- Which way of splitting a string with a 1-byte separator is the fastest?
--

local split_by_char_orig = function(str, sep)
  local result = { }
  local pos = 0
  for st, sp in function() return str:find(sep, pos, true) end do
    result[#result + 1] = str:sub(pos, st - 1)
    pos = sp + 1
  end
  result[#result + 1] = str:sub(pos)
  return result
end

-- NB: sloppy: doesn't escape separator and doesn't check boundary conditions
local split_by_char_gsub = function(str, sep)
  local result = { }
  str:gsub("[^" .. sep .. "]+", function(v)
    result[#result + 1] = v
  end)
  return result
end

-- NB: sloppy: doesn't escape separator and doesn't check boundary conditions
local split_by_char_gmatch = function(str, sep)
  local result = { }
  for v in str:gmatch("[^" .. sep .. "]+") do
    result[#result + 1] = v
  end
  return result
end

local split_by_char_sub = function(str, sep)
  local result = { }
  local pos = 1
  for i = 1, #str do
    if str:sub(i, i) == sep then
      result[#result + 1] = str:sub(pos, i - 1)
      pos = i + 1
    end
  end
  result[#result + 1] = str:sub(pos)
  return result
end

-- NB: this seems to be the winner
local split_by_char_byte = function(str, sep)
  local lim = str:byte()
  local result = { }
  local pos = 1
  for i = 1, #str do
    if str:byte(i) == lim then
      result[#result + 1] = str:sub(pos, i - 1)
      pos = i + 1
    end
  end
  result[#result + 1] = str:sub(pos)
  return result
end

---------------------------------------

local bench = { }

local str = ("123456789012345678901"):rep(10)
local sep = "1"

bench.split_by_char_orig = function()
  return split_by_char_orig(str, sep)
end

bench.split_by_char_gsub = function()
  return split_by_char_gsub(str, sep)
end

bench.split_by_char_gmatch = function()
  return split_by_char_gmatch(str, sep)
end

bench.split_by_char_sub = function()
  return split_by_char_sub(str, sep)
end

bench.split_by_char_byte = function()
  return split_by_char_byte(str, sep)
end

return bench
