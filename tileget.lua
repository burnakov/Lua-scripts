local bsuccess = UO.TileInit(true)
local x, y = 0, 0
while true do
	if x ~= UO.CharPosX or y ~= UO.CharPosY then
	        x, y = UO.CharPosX, UO.CharPosY
		for i = 1, 3 do
			print("------------")
			--print("Facet: "..i)
			local ncnt = UO.TileCnt(x, y + i)
			print("Found: "..ncnt.." tiles with X: "..x..", Y: "..(y + i).." coords.")
			for j = 1, ncnt do
				print("***")
				print("#"..j.." tile:")
				local nType,nZ,sName,nFlags = UO.TileGet(x, y + i, j)
				print("Type: "..nType..", Z: "..nZ..", Name: "..sName..", Flags: "..nFlags)
				--pause()
			end
		end   
	end    
end

