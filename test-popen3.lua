local popen3 = require"pipe".popen3
local posix = require"posix"

local pid, i, o, e = popen3("echo", "hello", "world")
local out = posix.read(o, 100000)
assert(out == "hello world\n")
local pid, stat, code = posix.wait(pid)
assert(code == 0)
