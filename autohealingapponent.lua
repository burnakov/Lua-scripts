function GetHP(n) 
	local i,nID,nHP,_ = 0 
	repeat 
		_,_,_,_,_,_,nID,_,nHP = UO.GetCont(i) 
		i = i + 1 
	until nID==n or nID==nil 
	return nHP 
end 


UO.TargCurs = true 
while UO.TargCurs do 
	wait(1) 
end    
local nTargetID = UO.LTargetID
local nBandageTimer = 5500
local nTicksDump = getticks()
local nTimePas = 0
repeat
	local hp = GetHP(nTargetID) 
	if hp == nil then 
		UO.StatBar(nTargetID) 
		wait(300) 
	elseif hp < 100 then
		nTimePass = getticks() - nTicksDump
		if nTimePass >= nBandageTimer then 
			UO.Macro(59, 0)  
			nTicksDump = getticks()
			wait(500)
		end
	end 
	wait(1)
until false




