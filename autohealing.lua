dofile(getinstalldir().."scripts/Kal In Ex/Journal.lua")
local oJournal = journal:new()
local nBandageTimer = 10500
local nTicksDump = getticks()
local nTimePass = 0
repeat
	if UO.Hits < UO.MaxHits or UO.Hits < 100 then
		nTimePass = getticks() - nTicksDump
		if nTimePass >= nBandageTimer then
			oJournal:clear()
			repeat
				UO.Macro(58, 0)
				wait(1000)
			until oJournal:find("Who will you use the bandages on?") ~= nil	
			nTicksDump = getticks()
		end
	end
	wait(1)
until false
	
	
	


