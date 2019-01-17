local verts = {}
local file, e = openfile("verts.txt", "r+")
if file then 
	local n = file:read("*n")
	while n do
		verts[n] = {file:read("*n"), file:read("*n")}
		n = file:read("*n")
	end
end
file:close()
for i = 523, 533 do
    print(i..": "..verts[i][1]..", "..verts[i][2])
end 
verts = nil







