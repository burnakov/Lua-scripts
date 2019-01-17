local tPathToBank = {{1974, 1713, 0},
{1966, 1712, 0},
{1963, 1712, 10},
{1960, 1712, 10},
{1957, 1712, 20},
{1939, 1712, 20},
{1933, 1707, 22}}
local tPathToFarm = {{1974, 1713, 0},
{1974, 1742, 0},
{1957, 1756, -5},
{1948, 1757, -15},
{1928, 1759, -15},
{1919, 1767, -15}}
local nBuffTimer = 550000
local nTicksDump = 0

local function KindlingSearch(nSearchedContID)
	local nCnt = UO.ScanItems(true)
	for i = 0, nCnt-1 do
		local nID,nType,nKind,nContID,nX,nY,nZ,nStack,nRep,nCol = UO.GetItem(i)
		if nType == 3553 and nContID == nSearchedContID then
			return nID, nStack
		end
	end
	return 0, 0
end

local function GetKindling ()
	for i = 1, #tPathToBank do
		UO.Pathfind(tPathToBank[i][1], tPathToBank[i][2], tPathToBank[i][3])
		while not (UO.CharPosX == tPathToBank[i][1] and UO.CharPosY == tPathToBank[i][2]) do
			wait(100)
		end
	end   
																											
	UO.Macro(4, 4, "bank")
	local nBankID = 1137283204
	while UO.ContID ~= nBankID do
		wait(100)
	end
	local nKindlingID, nKindlingQty = KindlingSearch(nBankID)
	if nKindlingQty > 0 then
		if nKindlingQty > 100 then
			UO.Drag(nKindlingID, 100)
			UO.DropC(UO.BackpackID)
		else
			UO.Drag(nKindlingID, nKindlingQty)
			UO.DropC(UO.BackpackID)
		end
	else
		stop()
	end
																											
	for i = #tPathToBank, 1, -1 do
		UO.Pathfind(tPathToBank[i][1], tPathToBank[i][2], tPathToBank[i][3])
		while not (UO.CharPosX == tPathToBank[i][1] and UO.CharPosY == tPathToBank[i][2]) do
			wait(100)
		end
	end
end

local function GetSkillGainBonus()
	for i = 1, #tPathToFarm do
		UO.Pathfind(tPathToFarm[i][1], tPathToFarm[i][2], tPathToFarm[i][3])
		while not (UO.CharPosX == tPathToFarm[i][1] and UO.CharPosY == tPathToFarm[i][2]) do
			wait(100)
		end
	end
																									                        
	local nFoundItemsQty = UO.ScanItems(true)
	for i = 0, nFoundItemsQty - 1 do
		local nID,nType,nKind,nContID,nX,nY,nZ,nStack,nRep,nCol = UO.GetItem(i)
		if nType == 3 then
			UO.LTargetID = nID			
			break
		end	
	end
	UO.Macro(27, 0)
	wait(1000)
	local nTicksDump = getticks()
	while UO.EnemyHits > 0 and UO.EnemyID == UO.LTargetID do
		wait(200)
		local nTimer = getticks() - nTicksDump
		if nTimer > 30000 then
			local nFoundItemsQty = UO.ScanItems(true)
			for i = 0, nFoundItemsQty - 1 do
				local nID,nType,nKind,nContID,nX,nY,nZ,nStack,nRep,nCol = UO.GetItem(i)
				if nID == UO.LTargetID then
					local nRelX = math.abs(UO.CharPosX - nX)
					local nRelY = math.abs(UO.CharPosY - nY)
					local nDist = math.max(nRelX, nRelY)
					if nDist > 1 then
						UO.Pathfind(nX, nY, nZ)
					end
					break
				end
			end
		end
	end										        										                        
	for i = #tPathToFarm, 1, -1 do
		UO.Pathfind(tPathToFarm[i][1], tPathToFarm[i][2], tPathToFarm[i][3])
		while not (UO.CharPosX == tPathToFarm[i][1] and UO.CharPosY == tPathToFarm[i][2]) do
			wait(100)
		end
	end
end

--- MAIN SCRIPT ---
while true do
	local nKindlingID, nKindlingQty = KindlingSearch(UO.BackpackID)
	UO.LObjectID = nKindlingID
	-- Go to Bank and grab some kidling
	if nKindlingQty == 0 then
		GetKindling()			
	end			
	while nKindlingQty ~= 0 do
		-- Kill a sheep to get Skill Gain Bonus    
		local nTimePass = getticks() - nTicksDump
		print(nTimePass)
		if nTimePass >= nBuffTimer then
			GetSkillGainBonus()        
			nTicksDump = getticks()						
		end
		UO.Macro(17, 0)
		wait(4000)
		local nNorm, nReal, nCap, nLock = UO.GetSkill("Camp")
		if nNorm == 1200 then
			stop()
		end
		_, nKindlingQty = KindlingSearch(UO.BackpackID)
	end
end
---
























