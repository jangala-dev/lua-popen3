#!/usr/bin/env lua
--
-- Name: Lua 5.2 + popen3() implementation
-- Author: Kyle Manna <kyle [at] kylemanna.com>
-- License: MIT License <http://opensource.org/licenses/MIT>
-- Copyright (c) 2013 Kyle Manna
--
-- Description:
-- Open pipes for stdin, stdout, and stderr to a forked process
-- to allow for IPC with the process.  When the process terminates
-- return the status code.
--

local posix = require("posix")
 
--
-- Simple popen3() implementation
--
local function popen3(path, ...)
	local r0, w0 = posix.pipe()
	local r1, w1 = posix.pipe()
	local r2, w2 = posix.pipe()

	assert((w0 ~= nil and r1 ~= nil and r2 ~= nil), "pipe() failed")

	local pid, err = posix.fork()
	assert(pid ~= nil, "fork() failed")
	if pid == 0 then
		posix.close(w0)
		posix.close(r1)
		posix.close(r2)

		posix.dup2(r0, posix.fileno(io.stdin))
		posix.dup2(w1, posix.fileno(io.stdout))
		posix.dup2(w2, posix.fileno(io.stderr))

		local ret, err = posix.execp(path, ...)
		assert(ret ~= nil, "execp() failed")

		posix._exit(1)
		return
	end

	posix.close(r0)
	posix.close(w1)
	posix.close(w2)

	return pid, w0, r1, r2
end

local M = {
	popen3 = popen3,
}

-- allow to call the module like the popen3 function.
setmetatable(M, {__call = function(_, ...) return popen3(...) end})

return M
