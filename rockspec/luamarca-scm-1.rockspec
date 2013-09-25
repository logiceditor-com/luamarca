package = "luamarca"
version = "scm-1"
source = {
   url = "git://github.com/agladysh/luamarca.git",
   branch = "master"
}
description = {
   summary = "Lua benchmarking tool with a set of silly benchmarks",
   homepage = "http://github.com/agladysh/luamarca",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1",
   "luasocket >= 2.0.2",
   "lua-nucleo >= 0.0.7",
   "lua-aplicado >= 1.0.3"
}
build = {
   type = "none",
   install = {
      bin = {
         ["luamarca"] = "bin/luamarca";
      },
      lua = {
         ["luamarca.benchmark"] = "src/lua/luamarca/benchmark.lua";
         ["luamarca.formatter"] = "src/lua/luamarca/formatter.lua";
         ["luamarca.cli"] = "src/lua/luamarca/cli.lua";
      }
   }
}
