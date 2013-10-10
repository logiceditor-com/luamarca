local string_sub = string.sub
local string_byte = string.byte

local split_by_char_byte = function(str, sep)
  local lim = string_byte(sep)
  local result = { }
  local pos = 1
  for i = 1, #str do
    if string_byte(str, i) == lim then
      result[#result + 1] = string_sub(str, pos, i - 1)
      pos = i + 1
    end
  end
  result[#result + 1] = string_sub(str, pos)
  return result
end

local split_by_char_byte_sugar = function(str, sep)
  local lim = sep:byte()
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

bench.split_by_char_byte = function()
  return split_by_char_byte(str, sep)
end

bench.split_by_char_byte_sugar = function()
  return split_by_char_byte_sugar(str, sep)
end

return bench
