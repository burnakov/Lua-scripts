--- Script options
local onceInTale = true -- Dig only once in tale, otherwise dig all ore in tale: Yes - 1; No - 0
local delay = 200       -- Delay between command
local timer = 3000      -- Brake loops timer
local digKey = "F9"     -- Macros key in FWAssist: Use pickaxe(ItemType or ItemID) -> Target on floor under feet(RelativeTarget)
local recallKey = "F7"  -- Macros key in FWAssist: Use invisibility potion (ItemType) -> Use recall scroll (ItemType) -> Target on rune (ItemID)
local path = getinstalldir().."scripts\\Antimacros.exe"
---

--- Script constants
local gameMsg = {
	noOre = "There is no ore",
	tryMining = "Try mining in rock.",
	youLoosen = "You loosen some rocks",
	youPut = "You put the",
	stat = "changed",
	skill = "increased",
	damaged = "Your pickaxe damaged",
	broke = "You broke the pickaxe",
	noPickaxe = "Object type to use not found in backpack.",
	atHome = "You can't use"
}
---

--- Libraries
dofile(getinstalldir().."scripts\\Kal In Ex\\FindItems.lua")
dofile(getinstalldir().."scripts\\Kal In Ex\\Journal V2.lua")
dofile(getinstalldir().."scripts\\ASM.lua")
---

--- Functions
function AntiMacros()
	if UO.ContKind == 22304 then
		for i = 1, 2 do    
			while UO.ContKind ~= 22304 do
				wait(1)
			end  
			local sTimer, eTimer = getticks()    
			repeat
				local color = UO.GetPix(UO.ContSizeX - 30, UO.ContSizeY - 30)
				eTimer = getticks() - sTimer
			until color == 6528198 or eTimer >= timer 
			if eTimer >= timer then
				print("Antimacros gump hasn't appeared")
				UO.Macro(8, 7) -- Open backpack to change top container
				break
			end
			UO.Click(UO.ContSizeX - 30, UO.ContSizeY - 30, true, true, true, false)
			asmExecute(path, i)
			wait(200)
			local f, e = openfile(getinstalldir().."scripts\\antimacros.txt", "r+")
			if f ~= nil then
				local coords = {}
				for line in f:lines() do
					table.insert(coords, tonumber(line))
				end
				f:close()
				if #coords == nil or #coords <= 0 then
					print("Antimacros file is empty")
					stop()
				elseif coords[1] == i then	         
					local x = coords[2] + 10
					local y = coords[3] + 10    
					UO.Click(x, y, true, true, true, false)
				else
					print("Wrong coords file")				    
				end
			else
				print(e)
				stop()
			end
		end
	end
end
---

--- Main
function Main()
	local J=NewJournal()
	local tileInit = UO.TileInit(true)
	while UO.Weight < UO.MaxWeight do
		UO.Key(digKey)
		wait(delay) 
		local stopScript = J:Find(gameMsg.noPickaxe, gameMsg.tryMining, gameMsg.atHome, gameMsg.noOre) 
		if stopScript ~= nil then
			if     stopScript == 1 then 
				UO.ExMsg(UO.CharID, 3, 1101, "There are no pickaxe in your backpack!")
				break
			elseif stopScript == 2 or stopScript == 3 then 
				UO.ExMsg(UO.CharID, 3, 1101, "You can't mine here!")
				break
			end
			-- There is no ore here to mine. Procced executing.                                                                  
		elseif UO.ContKind == 22304 then
			AntiMacros()
		elseif getatom("recall") then
			Recall(recallKey)
			print("recall")
			stop()
		else
			local stopDiging = nil
			local sTimer, eTimer = getticks()
			repeat
				stopDiging = J:Find(gameMsg.noOre, gameMsg.youPut, gameMsg.youLoosen)
				eTimer = getticks() - sTimer
			until stopDiging ~= nil or eTimer >= timer    
			print("Msg:"..stopDiging.." Timer:"..timer)
			if onceInTale then
				print("Making step")
				stop()
			end
		end
	end
	print("end")
end
---

Main()	
	
	
	
	






