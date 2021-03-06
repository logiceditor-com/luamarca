local noop = function() end
local plain_call = function(a) noop() end
local if_call = function(a)
  if a == "a1" then
    noop()
  elseif a == "a2" then
    noop()
  elseif a == "a3" then
    noop()
  elseif a == "a4" then
    noop()
  elseif a == "a5" then
    noop()
  elseif a == "a6" then
    noop()
  elseif a == "a7" then
    noop()
  elseif a == "a8" then
    noop()
  elseif a == "a9" then
    noop()
  elseif a == "a10" then
    noop()
  end
end

local map = { }
for i = 1, 10 do
  map["a"..i] = noop
end
local map_call = function(a) map[a]() end

local bench = function(fn)
  return function()
    fn("a"..1)
  end
end

return
{
  noop = bench(noop);
  plain_call = bench(plain_call);
  if_call = bench(if_call);
  map_call = bench(map_call);
}
