--------------------------------------------------------------------------------
-- cli.lua: CLI interface
-- This file is a part of luamarca library
-- Copyright (c) luamarca authors (see file `COPYRIGHT` for the license)
--------------------------------------------------------------------------------

local LOG_LEVEL,
      wrap_file_sink,
      make_common_logging_config
      = import 'lua-nucleo/log.lua'
      {
        'LOG_LEVEL',
        'wrap_file_sink',
        'make_common_logging_config'
      }


local create_common_logging_system,
      get_current_logsystem_date_microsecond
      = import 'lua-aplicado/log.lua' 
      { 
        'create_common_logging_system', 
        'get_current_logsystem_date_microsecond' 
      }

do
  local LOG_LEVEL_CONFIG =
  {
    [LOG_LEVEL.ERROR] = true;
    [LOG_LEVEL.LOG]   = true;
    [LOG_LEVEL.DEBUG] = false;
    [LOG_LEVEL.SPAM]  = false;
  }

  local LOG_MODULE_CONFIG =
  {
    -- Empty; everything is enabled by default.
  }

  local logging_system_id = ""

  create_common_logging_system(
      logging_system_id,
      wrap_file_sink(io.stdout),
      make_common_logging_config(
          LOG_LEVEL_CONFIG,
          LOG_MODULE_CONFIG
        ),
      get_current_logsystem_date_microsecond
    )
end

local load_tools_cli_data_schema,
      load_tools_cli_config,
      print_tools_cli_config_usage,
      freeform_table_value
      = import 'lua-aplicado/dsl/tools_cli_config.lua'
      {
        'load_tools_cli_data_schema',
        'load_tools_cli_config',
        'print_tools_cli_config_usage',
        'freeform_table_value'
      }

--------------------------------------------------------------------------------

local create_config_schema = function()
  return load_tools_cli_data_schema(function()
    cfg:root
    {
      cfg:node "luamarca"
      {
        cfg:existing_path "benchmark_file";
        cfg:enum_value "output" { 
            default = "table";           
            values_set = {
                ["table"] = "table";
                ["raw"] = "raw";
                ["bargraph"] = "bargraph";
              };
          };
        cfg:string "methods" { default = '' };
        cfg:integer "iterations" { default = 1e6 };
        cfg:boolean "info";
      };
    }
  end)
end


local EXTRA_HELP = [[

luamarca: benchmarks runner

Usage:

    luamarca [benchmark_file] [options]

Examples:

    luamarca bench/benchmark.lua
    luamarca bench/benchmark.lua --methods=foo
    luamarca bench/benchmark.lua --iterations=1e7 --output=barchart

Options:

    --output            Benchmark results format. Possible values:
                        'raw' - raw data 
                        'table' - human-readable table
                        'barchart' - data file for gnuplot
                        Default: 'table
    --methods           Comma-separated list of methods to be benchmarked
    --info              Print list of available methods in the suite 
                        without running benchmarks
    --iterations        Number of iterations
                        Default: 1,000,000
]]

local CONFIG_SCHEMA = create_config_schema()

--------------------------------------------------------------------------------

local parse_arguments = function(tool_name, ...)
  local config, err
  config, err = load_tools_cli_config(
      function(args) -- Parse actions
        local param = { }

        param.benchmark_file = args[1]
        param.output = args["--output"]
        param.methods = args["--methods"]
        param.info = not not args["--info"]

        if args["--iterations"] then
          param.iterations = tonumber(args["--iterations"])
        end

        return
        {
          PROJECT_PATH = args["--root"] or "./";
          [tool_name] = param;
        }
      end,
      EXTRA_HELP,
      CONFIG_SCHEMA,
      nil, -- Specify primary config file with --base-config cli option
      nil, -- No secondary config file
      ...
    )

  if config == nil then
    print_tools_cli_config_usage(EXTRA_HELP, CONFIG_SCHEMA)

    io.stderr:write("Error in tool configuration:\n", err, "\n\n")
    io.stderr:flush()

    os.exit(1)
  end

  return config
end

--------------------------------------------------------------------------------

return {
  parse_arguments = parse_arguments;
}
