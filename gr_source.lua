require "gr_source_base"
require "gr_source_bytes"
require "gr_source_file"
require "gr_source_str"

local mt = { __index = source }

setmetatable(source.bytes, mt)
setmetatable(source.file,  mt)
setmetatable(source.str,   mt)
