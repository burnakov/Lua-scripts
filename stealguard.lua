dofile(getinstalldir().."scripts/Kal In Ex/Journal.lua")
myjournal = journal:new()
while true do
	if myjournal:find("steal") ~= nil then
		UO.Macro(4, 4, "guards")
		myjournal:clear()
	end
	wait(1000)
end