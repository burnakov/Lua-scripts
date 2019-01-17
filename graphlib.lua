if not UO.TileInit(true) then
	print("Tile initialization failed!")
	stop()
end

local tbl_offset = {
	[1] = {0, 1}, 
	[2] = {1, 0}, 
	[3] = {0, -1}, 
	[4] = {-1, 0}
}

local tbl_cacheTilesIndexes = {}
local tbl_cacheTiles = {}
local tbl_findTilesCache = {} 
local n_counter = 1

local function PairsByKeys (tbl_keysToSort, f_sortFunc)
	local tbl_sortedKeys = {}
	for n_key in pairs(tbl_keysToSort) do table.insert(tbl_sortedKeys, n_key) end
	table.sort(tbl_sortedKeys, f_sortFunc)
	local n_iterator = 0 -- iterator variable
	local Iterator = function () -- iterator function
		n_iterator = n_iterator + 1
		if tbl_sortedKeys[n_iterator] == nil then return nil
		else return tbl_sortedKeys[n_iterator], tbl_keysToSort[tbl_sortedKeys[n_iterator]]
		end
	end
	return Iterator
end

function IsIndexExist(tbl_checkTbl, ...)
	local tbl_indexes = {...}
	if tbl_checkTbl == nil or #tbl_indexes == 0 then
		return nil
	elseif type(tbl_checkTbl) == "table" then
		local n_index = table.remove(tbl_indexes, 1)
		if #tbl_indexes == 0 then
			return tbl_checkTbl[n_index] and true or false
		end
		return (tbl_checkTbl[n_index] and IsIndexExist(tbl_checkTbl[n_index], unpack(tbl_indexes)) or false)
	end
	return false
end

function TileToString(tbl_tile)
	local s_tile = "Type: "..tbl_tile.Type..", Z: "..tbl_tile.Z..", Name: "..tbl_tile.Name..", Flags: "..tbl_tile.Flags
	return s_tile 
end

function ClearCache()
	tbl_cacheTilesIndexes = {}
	tbl_cacheTiles = {}
	n_counter = 1
	collectgarbage()
end

function GetTiles(n_x, n_y)
	local tbl_tiles = {}
	local n_tileCnt = UO.TileCnt(n_x, n_y)
	for n_iTile = 1, n_tileCnt do
		local n_type, n_z, s_name, n_flags = UO.TileGet(n_x, n_y, n_iTile)
		tbl_tiles[n_iTile] = {Type = n_type, Z = n_z, Name = s_name, Flags = n_flags}
	end
	return tbl_tiles
end

function GetCacheTiles(n_index)
	return tbl_cacheTiles[n_index]
end

function IsImpassable(...)
	local tbl_params = {...}
	local n_paramCnt = #tbl_params
	local tbl_tiles = {}
	if n_paramCnt == 1 then
		tbl_tiles = GetCacheTiles(tbl_params[1])
	elseif n_paramCnt == 2 then
		tbl_tiles = GetTiles(tbl_params[1], tbl_params[2])
	else
		print("Wrong parameters count. IsImpassable(n_index), IsImpassable(n_x, n_y)")
		return nil
	end
	local n_tileCnt = #tbl_tiles
	local n_minZ = tbl_tiles[n_tileCnt].Z
	for n_iTile = n_tileCnt, 1, -1 do
		if tbl_tiles[n_iTile].Z == n_minZ then
			if Bit.And(tbl_tiles[n_iTile].Flags, 64) == 64 then
				return true
			end        
		end				   
	end
	return false
end	

function CacheTiles(n_startX, n_startY, tbl_regionSize, b_saveCache)
	if not b_saveCache == true then 
		ClearCache() 
	end
	local n_endX, n_endY = n_startX, n_startY
	if tbl_regionSize ~= nil then
		if tbl_regionSize.X ~= nil and tbl_regionSize.Y ~= nil then
			n_endX = tbl_regionSize.X
			n_endY = tbl_regionSize.Y
		elseif tbl_regionSize.W ~= nil and tbl_regionSize.H ~= nil then
			n_endX = n_startX + tbl_regionSize.W
			n_endY = n_startY + tbl_regionSize.H
		end
	end
	local n_xStep = (n_startX < n_endX) and 1 or -1
	local n_yStep = (n_startY < n_endY) and 1 or -1
	for n_iX = n_startX, n_endX, n_xStep do 
		if IsIndexExist(tbl_cacheTilesIndexes, n_iX) ~= true then
			tbl_cacheTilesIndexes[n_iX] = {}
		end
		for n_iY = n_startY, n_endY, n_yStep do
			if IsIndexExist(tbl_cacheTilesIndexes[n_iX], n_iY) ~= true then
				tbl_cacheTilesIndexes[n_iX][n_iY] = n_counter
				tbl_cacheTiles[n_counter] = GetTiles(n_iX, n_iY)
				n_counter = n_counter + 1
			end
		end
	end
	return tbl_cacheTilesIndexes				
end																

function FindCacheTiles(tbl_tileProp)
	if tbl_tileProp ~= nil then
		local tbl_foundTiles = {}
		-- Iteration through all elements in "tbl_cacheTilesIndexes" and all cached tiles in "tbl_cacheTiles"
		-- Then through each cached tile key to find matching with "tbl_tileProp" values. SICK!
		for n_iX, tbl_iY in PairsByKeys(tbl_cacheTilesIndexes) do
			for n_iY, n_index in PairsByKeys(tbl_iY) do
				for n_iTile = #tbl_cacheTiles[n_index], 1, -1 do
					local b_isMatch = true
					for s_iPropKey, var_iPropVal in pairs(tbl_tileProp) do
						local s_tileValue = tostring(tbl_cacheTiles[n_index][n_iTile][s_iPropKey])
						local s_propValue = tostring(var_iPropVal)
						if string.match(s_tileValue, s_propValue) == nil then
							b_isMatch = false
							break
						end
					end
					if b_isMatch == true then
						table.insert(tbl_foundTiles, {n_iX, n_iY})
					end
				end
			end
		end
		return #tbl_foundTiles > 0 and tbl_foundTiles or nil
	end
	return nil
end

function FindTiles(tbl_tileProp, n_startX, n_startY, n_tileCnt, b_saveCache) --!!!!!!!!!
	n_tileCnt = n_tileCnt or 1
	n_startX = n_startX or UO.CharPosX
	n_startY = n_startY or UO.CharPosY
	local tbl_queue = {}
	local tbl_foundTiles = {}
	table.insert(tbl_queue, {n_startX, n_startY})
	while #tbl_queue > 0 do
		local tbl_tileCoords = table.remove(tbl_queue, 1)
		for n_iOffsetIndex = 1, #tbl_offset do
			local n_nextX = tbl_tileCoords[1] + tbl_offset[n_iOffsetIndex][1]
			local n_nextY = tbl_tileCoords[2] + tbl_offset[n_iOffsetIndex][2]
			if IsIndexExist(tbl_findTilesCache, n_nextX) ~= true then 
				tbl_findTilesCache[n_nextX] = {}
			end
			if IsIndexExist(tbl_findTilesCache, n_nextX, n_nextY) ~= true then
				tbl_findTilesCache[n_nextX][n_nextY] = 1
				table.insert(tbl_queue, {n_nextX, n_nextY})
				local tbl_tiles = GetTiles(n_nextX, n_nextY)
				for n_itileindex = #tbl_tiles, 1, -1 do
					local b_isMatch = true
					for s_iPropKey, var_iPropVal in pairs(tbl_tileProp) do
						if string.match(tbl_tiles[n_itileindex][s_iPropKey], var_iPropVal) == nil then
							b_isMatch = false
							break
						end
					end
					if b_isMatch == true then
						tbl_foundTiles = {n_nextX, n_nextY}
						if tbl_foundTiles == n_tileCnt then
							return tbl_foundTiles
						end
					end
				end
			end
		end
	end
	return tbl_foundTiles
end


local function test()
	pause()
	local tbl_cache1 = CacheTiles(1284, 1333, {W = 0, H = -2})
	for n_iX, tbl_iY in pairs(tbl_cache1) do
		for n_iY, n_index in pairs(tbl_iY) do
			local tbl_tiles = GetCacheTiles(n_index)
			for n_itileindex, n_iTile in pairs(tbl_tiles) do
				print(n_iX.." "..n_iY.." "..TileToString(n_iTile)) -- GetCacheTiles return table!!!
			end
		end
	end
	local tbl_cache2 = CacheTiles(1284, 1333, {W = 0, H = -3}, true)
	for n_iX, tbl_iY in pairs(tbl_cache1) do
		for n_iY, n_index in pairs(tbl_iY) do
			local tbl_tiles = GetCacheTiles(n_index)
			for n_itileindex, n_iTile in pairs(tbl_tiles) do
				print(n_iX.." "..n_iY.." "..TileToString(n_iTile)) -- GetCacheTiles return table!!!
			end
		end
	end
end

--test()


