local weights = {}
local opened = {}
local reverced = {}
local matrix = {}
local queue = {}
local map = {}
local counter = 0
local dir = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}

function AddVert(x, y)
	counter = counter + 1
	if opened[x] == nil then
		opened[x] = {}
	end
	opened[x][y] = counter
	reverced[counter] = {x, y}
	return counter
end

function AddWght(v1, v2, wght)
	if weights[v1] == nil then
		weights[v1] = {}
	end
	weights[v1][v2] = wght
end

function GetVert(x, y)
	if opened[x] ~= nil then
		return opened[x][y]
	end 
	return nil
end

function Maped(x, y)
	if map[y] ~= nil then
		return map[y][x] -- Reverse coord for plot
	end 
	return nil
end

function AddToMap(x, y, val)
	if not map[y] then
		map[y] = {}
	end
	map[y][x] = val -- Reverse coord for plot
end

function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

--pause()
local bsuccess = UO.TileInit(true)
table.insert(queue, {UO.CharPosX, UO.CharPosY})
local vert = AddVert(UO.CharPosX, UO.CharPosY)
local minX, maxX = 9999999, 0	
while #queue ~= 0 do
	local tile = table.remove(queue, 1)
	vert = GetVert(tile[1], tile[2])
	matrix[vert] = {}
	for i = 1, #dir do
		local x = tile[1] + dir[i][1]
		local y = tile[2] + dir[i][2]
		local ncnt = UO.TileCnt(x, y)
		if ncnt == 2 then
			local nType,nZ,sName,nFlags = UO.TileGet(x, y , 2)
			if sName == "cave floor" then       
				if x < minX then
					minX = x
				elseif x > maxX then 
					maxX = x   
				end
				local nvert = GetVert(x, y)
				if not nvert then
					table.insert(queue, {x, y})
					nvert = AddVert(x, y) 
				end   			
				matrix[vert][nvert] = 1
				if not Maped(x, y) then
					--local nType,nZ,sName,nFlags = UO.TileGet(x, y , 1)
					AddToMap(x, y, nType)
				end	
			end		   
		end
	end
end

local file, e = openfile("graph.txt", "w+")
if file then
	file:write(tostring(counter).."\n")
	for i = 1, counter do
		local plot = ""
		for j = 1, counter do
			if not matrix[i][j] then
				plot = plot.." "..tostring(0)
			else 
				plot = plot.." "..tostring(matrix[i][j])
			end    
		end
		file:write(plot.."\n")
	end
end
file:close()
file = nil

file, e = openfile("map.txt", "w+")
if file then
	local plot = ""
	for i = minX, maxX do
		plot = plot.." "..tostring(i)
	end
	file:write(plot.."\n")
	for y, xtbl in pairsByKeys(map) do
		plot = tostring(y)
		for x = minX, maxX do
			if not map[y][x] then
				plot = plot.." "..tostring(0)
			else 
				plot = plot.." "..map[y][x]   
			end    
		end
		plot = plot.."\n"
		file:write(plot)
	end		
end
file:close()
file = nil

file, e = openfile("verts.txt", "w+")
if file then
	local plot = ""
	for i = 1, counter do
		plot = tostring(i).." "..tostring(reverced[i][1]).." "..tostring(reverced[i][2])
		plot = plot.."\n"
		file:write(plot)
	end		
end
file:close()
file = nil

weights = nil
opened = nil
reverced = nil
matrix = nil
queue = nil
map = nil
counter = nil
dir = nil
			
			
			
			
			
			
			
			
			
		
		
	
	










