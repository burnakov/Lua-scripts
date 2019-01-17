function fib(n)
	return n < 2 and 1 or fib(n - 1) + fib(n - 2)
end

local t = {}
for i = 1, 10 do
	local start = getticks()
	fib(30)
	t[#t + 1] = getticks() - start
end

local sum = 0
for i = 1, #t do
	sum = sum + t[i]
end

local avg = sum / #t
print(avg)