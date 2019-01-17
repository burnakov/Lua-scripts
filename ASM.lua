local function paramCheck(param)
	local err = ""
	if param ~= nil and param ~= 0 then
		if type(param) ~= "number" then
			err = " parameter must be a number. Passed: "..tostring(type(param))
		elseif param < 0 then
			err = " parameter must be greater than or equal to zero. Passed: "..tostring(type(param))
		elseif math.ceil(param) - param ~= 0 then
			err = " parameter must be an integer. Passed: "..tostring(type(param))
		elseif param > asmTabCount() then
			err = " parameter value is greater than number of tabs. Passed: "..tostring(type(param))
		else
			return param - 1, err -- Tabs index starts from zero
		end
		return false, err
	end
	return nil, err       
end
---
function asmStop(nScript)
	local val, err = paramCheck(nScript)
	if val then
		setatom("asm.stopscript", true)
		setatom("asm.$"..tostring(val), val)
		local st = getticks()
		local timer
		repeat 
			timer = getticks() - st
		until getatom("asm.stopscript") == nil or timer > 400
		--print(tostring(timer))
	elseif val == nil then
		stop() 
	else
		local msg = "!asmStop()"..err
		print(msg)
		--stop()
	end	
end
---
function asmStopAll(nScript)
	local val, err = paramCheck(nScript)
	if val ~= false then
		setatom("asm.stopscript", true)
		local tabs = asmTabCount()
		for i = 0, tabs - 1 do
			if val ~= i then
				setatom("asm.$"..tostring(i), i)
			end	                    
		end
		local st = getticks()
		local timer
		repeat 
			timer = getticks() - st
		until getatom("asm.stopscript") == nil or timer > 400
		--print(tostring(timer))
	else
		local msg = "!asmStopAll()"..err
		print(msg)
		--stop()
	end	
end
---
function asmStart(nScript)
	local val, err = paramCheck(nScript)
	if val then
		setatom("asm.startscript", true)
		setatom("asm.@"..tostring(val), val)
		local st = getticks()
		local timer
		repeat 
			timer = getticks() - st
		until getatom("asm.startscript") == nil or timer > 400
		--print(tostring(timer))
	elseif val == nil then
		print("!asmStart() requaire a parameter. Passed: "..type(val))
		--stop()  
	else
		local msg = "!asmStart()"..err
		print(msg)
		--stop()
	end
																						
end
---
function asmStartAll(nScript)
	local val, err = paramCheck(nScript)
	if val ~= false then
		setatom("asm.startscript", true)
		local tabs = asmTabCount()
		for i = 0, tabs - 1 do
			if val ~= i then
				setatom("asm.@"..tostring(i), i)
			end	                    
		end
		local st = getticks()
		local timer
		repeat 
			timer = getticks() - st
		until getatom("asm.startscript") == nil or timer > 400
		--print(tostring(timer))
	else
		local msg = "!asmStartAll()"..err
		print(msg)
		--stop()
	end
																						
end
---
function asmPause(nScript)
	local val, err = paramCheck(nScript)
	if val then
		setatom("asm.pausescript", true)
		setatom("asm.#"..tostring(val), val)
		local st = getticks()
		local timer
		repeat 
			timer = getticks() - st
		until getatom("asm.pausescript") == nil or timer > 400
		--print(tostring(timer))
	elseif val == nil then
		pause() 
	else
		local msg = "!asmPause()"..err
		print(msg)
		--stop()
	end
end
---
function asmPauseAll(nScript)
	local val, err = paramCheck(nScript)
	if val ~= false then
		setatom("asm.pausescript", true)
		local tabs = asmTabCount()
		for i = 0, tabs - 1 do
			if val ~= i then
				setatom("asm.#"..tostring(i), i)
			end	                    
		end
		local st = getticks()
		local timer
		repeat 
			timer = getticks() - st
		until getatom("asm.pausescript") == nil or timer > 400
		--print(tostring(timer))
	else
		local msg = "!asmPauseAll()"..err
		print(msg)
		--stop()
	end
end
---
function asmTabCount()
	return getatom("asm.tabcount") and getatom("asm.tabcount") or 0
end
---
function asmExecute(path, param)
	if path then
		if type(path) == "string" then
			setatom("asm.execute", path)
	                setatom("asm.executeparam", param)
			local st = getticks()
			local timer
			repeat 
				timer = getticks() - st
			until getatom("asm.execute") == nil or timer > 400
			--print(tostring(timer))
		end
	end
end
---
local function asmDel()
	local t = listatoms("asm")
	for k, v in pairs(t) do
		setatom(v, nil)
	end 
end
---
function asmAtoms()
	local t = listatoms("asm")
	local res = ""
	for k, v in pairs(t) do
		res = res..v.." "..tostring(getatom(v)).."\n"
	end 
	return res
end
---
local function test()
	asmDel()                    
	wait(300)       
												              
	local tf = {paramCheck, asmStop, asmStopAll, asmStart, asmPause}
	local tv = {0, 2, -1, 1.5, -1.5, 999, "1", {1}, true}							
	for i = 1, #tf do                                 
		print(i.." function:")
		for j = 0, #tv do -- 0 index for nil check
			if i == i then
				local val, err = tf[i](tv[j])
				print("Parameter: "..tostring(tv[j])..", Returned value: "..tostring(val).. ", Error:"..tostring(err))
				print("***")
				local t = listatoms("asm")
				for k, v in pairs(t) do
					print(k.." "..v.." "..tostring(getatom(v)))
				end
				asmDel()                    
				wait(300)
				print("---")
			end
		end                                     
		print("-----------------")
	end
	print("Tabs count: "..asmTabCount())														
end
---

--test()
--asmDel()
		
	






















