while true do
	if UO.ContKind == 22304 then
		for i = 0, 1 do      
			do
				local timer = 3000
				local startTimer, currTimer = getticks(), 0   
				repeat
					local color = UO.GetPix(UO.ContSizeX - 30, UO.ContSizeY - 30)
					currTimer = getticks() - startTimer
				until color == 6528198 or currTimer >= timer
				
				if currTimer >= timer then
					print("Antimacros gump hasn't appeared")
					UO.Macro(8, 7) -- Open backpack to change top container
					break
				end
			end
			
			UO.Click(UO.ContSizeX - 30, UO.ContSizeY - 30, true, true, true, false) -- Click antimacros gump to bring it on a top
			wait(500)
			
			local file, openFileError = openfile(getinstalldir().."scripts\\antimacros.txt", "r+")
			if file ~= nil then
				local coords = {}
				for line in file:lines() do
					table.insert(coords, tonumber(line))
				end
				file:close()
				file = nill
				
				-- Erasing data in file
				file, openFileError = openfile(getinstalldir().."scripts\\antimacros.txt", "w+b")
				file:close()
				--
				
				if #coords == nil or #coords <= 0 then
					print("Antimacros file is empty")
					stop()
				end  
				
				local x = coords[i*2+1] + 10
				local y = coords[i*2+2] + 10
				UO.Click(x, y, true, true, true, false)
				while UO.ContKind ~= 22304 do
					wait(1)
				end
			else
				print(openFileError)
				stop()
			end
		end
	end
	wait(10)  
end

