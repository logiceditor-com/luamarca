package = "luamarca"
version = "scm-1"

source =
{
  url = "git://github.com/logiceditor-com/luamarca.git";
  branch = "master";
}

description =
{
  summary = "Lua benchmarking tool with a set of silly benchmarks";
  homepage = "http://github.com/logiceditor-com/luamarca";
  license = "MIT/X11";
  maintainer = "LogicEditor Team <team@logiceditor.com>";
}

dependencies =
{
  "lua >= 5.1";
  "luasocket >= 2.0.2";
  "lua-nucleo >= 0.0.7";
  "lua-aplicado >= 1.0.3";
  "le-tools.le-lua-interpreter >= 1.0.3";
}

build =
{
  type = "none";
  install =
  {
    bin =
    {
      ["luamarca"] = "bin/luamarca";
    };

    lua =
    {
      ["luamarca.formatter"] = "src/lua/luamarca/formatter.lua";
    };
  }
}
