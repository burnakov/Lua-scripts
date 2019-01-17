dofile(getinstalldir().."scripts/Kal In Ex/FindItems.lua")
dofile(getinstalldir().."scripts/Kal In Ex/Journal.lua")

local weaponID = 1073880369
local lootBag = UO.BackpackID
local delay = 400
local butcherType = 5110
local corpse = {8190, 8191, 8192, 8193, 8194, 8195, 8196, 8197, 8198, 8199}

ignore = {}

local function IgnoreItems(itemid)
    if itemid ~= nil then
       if #ignore >= 30 then
          table.remove(ignore, 1)
       end
       table.insert(ignore, itemid)
    end
end

local function lootFrom(loot)
    for i=1, #loot do
        UO.Drag(loot[i].ID, loot[i].Stack)
        UO.DropC(lootBag)
        wait(delay)
    end
end

local function Type2ID(type)
    local items = ScanItems(true, {ContID = UO.BackpackID, Type = type, Kind = 0})
    return items[1].ID
end

local function Carve(id)
      UO.LTargetID = id
      local J = journal:new()
      while not J:find("You carve", "You pluck", "You are too far away.") do
            UO.LObjectID = Type2ID(butcherType)
            UO.Macro(17, 0)
            UO.Macro(25, 0)                 
            UO.Macro(22, 0)
            wait(delay)
      end
end

local function LookForCorpse()
       local t = ScanItems(true,{Type=corpse,Dist=3,Kind=1},{ID=ignore})
       if #t > 0 then 
           UO.SysMessage(#t.." corpses where found!")
           for i=1, #t do
               Carve(t[i].ID) 
               UO.LObjectID = t[i].ID
               IgnoreItems(t[i].ID)
               UO.NextCPosX= 100
               UO.NextCPosY= 100
               UO.Macro(17,0)
               while not UO.ContType == corpse and UO.ContName == "container gump" do end
               wait(delay)
               local loot = ScanItems(true,{ContID=t[i].ID, Kind=0})
               if #loot ~= 0 then 
                  lootFrom(loot)
               end
               UO.Click(150, 150 ,false,true,true,false)
           end
           UO.LObjectID = weaponID
           UO.Macro(17, 0)
       end
end

while true do
    LookForCorpse()
    wait(1000)
end