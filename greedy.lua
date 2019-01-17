dofile(getinstalldir().."scripts/Kal In Ex/FindItems.lua")

local filename = "ignortable.txt"
local ts = 1600

local ignore = {}

local function IgnoreItems(itemid, size)
    if itemid ~= nil then
       size = size and size or 100
       if #ignore > size then
          table.remove(ignore, 1)
       end
       table.insert(ignore, itemid)
    end
end

local file = openfile(filename, "a+")
local n = file:read("*n")
while n do
      table.insert(ignore, n)
      n = file:read("*n")
end
print(#ignore)
local grab = true
while grab do
      local items = ScanItems(true, {Kind = 1, Dist = 3}, {ID=ignore})
      for i = 1, #items do
          local addIgnorTbl = true
          if items[i].Type ~= 400 and items[i].Type ~= 401 then
             addIgnorTbl = false
             local cX, cY, cZ = UO.CharPosX, UO.CharPosY, UO.CharPosZ
             UO.Pathfind(items[i].X, items[i].Y, items[i].Z)
             UO.ExMsg(items[i].ID, tostring(items[i].Type))
             if items[i].Stack > 1 then
                wait(1000)
                UO.Drag(items[i].ID, items[i].Stack)
             else
                wait(1000)
                UO.Drag(items[i].ID)
             end
             UO.DropC(UO.BackpackID)
             wait(2000)
             UO.Key("F12")
             UO.Pathfind(cX, cY, cZ)
             local timer = getticks()
             while UO.CharPosX ~= cX and UO.CharPosY ~= cY or getticks() - timer > 3000 do end 
             grab = false
             --stop()
          end
          if addIgnorTbl then IgnoreItems(items[i].ID, ts) end
      end
      --print(#ignore)
      --wait(500) 
end