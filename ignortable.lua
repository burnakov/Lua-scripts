dofile(getinstalldir().."scripts/Kal In Ex/FindItems.lua")

local ignore = {}
 
local function IgnoreItems(itemid, size)
    if itemid ~= nil then
       if #ignore > size then
          table.remove(ignore, 1)
       end
       table.insert(ignore, itemid)
    end
end
  
local filename = "ignortable.txt"
local ts = 1500

local file = openfile(filename, "a+")
local n = file:read("*n")
while n do
      table.insert(ignore, n)
      n = file:read("*n")
end
while file ~= nil do
      repeat
            local items = ScanItems(true, {Kind = 1, Dist = 10}, {ID=ignore})
            local cnt = ts - #ignore - #items < 0 and ts - #ignore or #items
            for i = 1, cnt do
                if items[i].Type ~= 400 and items[i].Type ~= 401 then
                   IgnoreItems(items[i].ID, ts)
                   if #ignore == ts then
                      file:write(items[i].ID)
                   else
                      file:write(items[i].ID.."\n")
                   end
                end
            end
      until #ignore == ts 
      file:close()
      file = nil
end
print(#ignore)