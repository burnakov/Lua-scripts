local NUM = 10

local que = {}
local vert = {}
local graph = {}
local dir = {{0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}}
local counter = 0

function AddVert(x, y)
	counter = counter + 1
	if not vert[x] then
		vert[x] = {}
	end
	vert[x][y] = counter
	return counter
end

function GetVert(x, y)
	if vert[x] then
		return vert[x][y]
	end 
	return nil
end
--pause()
table.insert(que, {1, 1})
local v = AddVert(1, 1)
while #que ~= 0 do
	local point = table.remove(que, 1)
	v = GetVert(point[1], point[2])
	graph[v] = {}
	for i = 1, #dir do
		local x = point[1] + dir[i][1]
		local y = point[2] + dir[i][2]
		if x > 0 and y > 0 and x <= NUM and y <= NUM then
			local nv = GetVert(x, y)
			if not nv then
				table.insert(que, {x, y})
				nv = AddVert(x, y) 
			end   			
			graph[v][nv] = 1
		end
	end
end

local file, e = openfile("g.txt", "w+")
if file then
	file:write(tostring(counter).."\n")
	for i = 1, counter do
		local plot = ""
		for j = 1, counter do
			if not graph[i][j] then
				plot = plot.." "..tostring(0)
			else 
				plot = plot.." "..tostring(graph[i][j])
			end    
		end
		file:write(plot.."\n")
	end
end
file:close()
file = nil

for k1, v1 in pairs(vert) do
    for k2, v2 in pairs(v1) do
        print(v2.." x: "..k1.." y: "..k2)
    end
end


