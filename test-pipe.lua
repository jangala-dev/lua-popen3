#!/usr/bin/env lua
local os = require("os")
local io = require("io")
local posix = require("posix")
local pipe = require("pipe")

local popen3 = pipe.popen3
local pipe_multi = pipe.pipes

--
-- Feed spam messages to sa-learn to teach the bayesian classifier
--
-- Note: this won't scale well as all the input emails will be buffered
-- in memory
--
local function test_single(cnt, out)
	local str = ("a"):rep(cnt)

	local status = pipe_multi({str}, 1, 'tee', out)
end

local function test_popen3(cnt, out)
	local str = ("a"):rep(cnt)

	local lpid, lstdin_fd, lstdout_fd, lstderr_fd = popen3('tee', out)
	assert(lpid ~= nil, "filter() unable to popen3()")


	local nbytes, err = posix.write(lstdin_fd, str)
	local nbytes, err = posix.write(lstdin_fd, str)
	posix.close(lstdin_fd)

	--posix.close(lstdout_fd)
	--posix.close(lstderr_fd)

	local str, err = posix.read(lstdout_fd, 100000)
	local errstr, err = posix.read(lstderr_fd, 100000)

	local wait_pid, wait_cause, wait_status = posix.wait(lpid)

end

test_single(65536, 'small.txt')
test_single(65537, 'big.txt')
--test_popen3(65536, 'small.txt')
--test_popen3(65537, 'small+1.txt')
--test_popen3(40000, 'small.txt')
