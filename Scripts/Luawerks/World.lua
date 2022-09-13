--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------
if LWorld~=nil then return end
LWorld={}

world=nil
LWorld.currentmap=nil

function GetWorld()
    if world == nil then return nil end
    return world
end

function Restart()
	LoadMap(LWorld.currentmap)
end

function LWorld:Create()
    if GetWorld() ~= nil then
        DevMsg("Reusing existing world...")
        self:ClearWorld()
    else
        world = World:Create()
        World:SetCurrent(world)
        self:ApplySettings()
        LTime:Pause()
    end
end

function LWorld:ApplySettings()
	local quality

	-- World Settings
	if world~=nil then
		quality = tonumber((System:GetProperty(PROPERTY_LIGHTQUALITY)))
		if quality~=nil then world:SetLightQuality(quality) end
		
		quality = tonumber((System:GetProperty(PROPERTY_WATERQUALITY)))
		if quality~=nil then world:SetWaterQuality(quality) end
		
		quality = tonumber((System:GetProperty(PROPERTY_TERRAIN)))
		if quality~=nil then world:SetTerrainQuality(quality) end

		quality = tonumber((System:GetProperty(PROPERTY_TESSELLATION)))
		if quality~=nil then world:SetTessellationQuality(quality) end
	end

	--Texture detail
	quality = tonumber((System:GetProperty(PROPERTY_TEXTUREQUALITY)))
	if quality~=nil then Texture:SetDetail(quality) end
	
	--Anisotropic filter
	quality = tonumber((System:GetProperty(PROPERTY_TEXTURETRILINEAR)))
	if quality~=nil then Texture:SetAnisotropy(quality) end

	-- Texture Streaming
	quality = tonumber((System:GetProperty(PROPERTY_TEXTURESTREAM)))
	if quality~=nil then Texture:SetLoadingMode(quality) end
	
	--TriLinear Filter
	quality = tonumber((System:GetProperty(PROPERTY_TEXTURETRILINEAR)))
	if quality~=nil then
		if quality>0 then
			quality=true
		else
			quality=false
		end
		Texture:SetTrilinearFilterMode(quality)
	end
end

function LWorld:GetCamera()
	if world~=nil then
		-- If the user didn't set up the camera, do this loop to find one!
		local count = world:CountEntities()
		for n=0,count-1 do
			local entity=world:GetEntity(n)
			if entity:GetClass()==Object.CameraClass then
				local tcamera = tolua.cast(entity,"Camera")
				return tcamera
			end
		end
		ErrorMsg("Failed to find camera.")
	end	
end

-- Called after PostStart() and Menu
function LWorld:ApplyCameraSettings(camera)
	if camera~=nil then
		--MSAA
		local aa = tonumber((System:GetProperty(PROPERTY_MUTISAMPLE)))
		if aa==0 or aa==nil then aa=1 end
		if aa~= camera:GetMultisampleMode() then
			aa=tonumber(aa)
			DevMsg("Correcting MSAA Setting.")
			camera:SetMultisampleMode(aa)
		end

		--FOV
		local FOV = tonumber((System:GetProperty(PROPERTY_FOV, "70")))
		if FOV~=camera:GetFOV() then
			FOV=tonumber(FOV)
			DevMsg("Correcting FOV Setting.")
			camera:SetFOV(FOV)
		end	
	end
end

function ConCommand_Multisample(arg)
	if LWorld:GetCamera() ~= nil then LWorld:GetCamera():SetMultisampleMode(arg) Msg(PROPERTY_MUTISAMPLE .." has been set to " ..LWorld:GetCamera():GetMultisampleMode()) end
	System:SetProperty(PROPERTY_MUTISAMPLE,tostring(arg))
end
LSystem:RegisterConCommand(PROPERTY_MUTISAMPLE, ConCommand_Multisample)

function ConCommand_FOV(arg)
	if LWorld:GetCamera() ~= nil then LWorld:GetCamera():SetFOV(arg) Msg(PROPERTY_FOV .." has been set to " ..LWorld:GetCamera():GetFOV()) end
	System:SetProperty(PROPERTY_FOV,tostring(arg))
end
LSystem:RegisterConCommand(PROPERTY_FOV, ConCommand_FOV)

function ConCommand_Physics(arg)
	if LWorld:GetCamera() ~= nil then 
        if arg == "1" then arg = LWorld:GetCamera():SetDebugPhysicsMode(true) else LWorld:GetCamera():SetDebugPhysicsMode(false) end
    end
end
LSystem:RegisterConCommand("physics", ConCommand_Physics)

function LWorld:ClearWorld(force)
    if GetWorld() == nil then return false end
	if not LTime:Paused() then LTime:Pause() end
    if force==true then
        DevMsg("Deleting World...")
        world:Clear(true)
        world:Release()
        world=nil
    else
        DevMsg("Clearing World...")
        world:SetSkybox(nil)
        world:Clear(false)
    end
    return true
end

function LWorld:Free()
    if GetWorld() == nil then
        Msg("Can't delete the world because one does not exist.")
        return
    end
    if self:ClearWorld(true) then 
		Msg("Disconnected from "..'"'..self.currentmap..'"')
		self.currentmap=""
		if not LTime:Paused() then LTime:Pause() end
	end 
end

function LWorld:Update()
	-- Level loading works by checking the map property.
	if System:GetProperty("map") ~= "" then
		local t = System:GetProperty("map")
		--Msg("World not nil: " ..t)
		local tempname = FileSystem:StripAll(t)
		--Msg(tempname)
		local fixedpath = "Maps/" ..tempname..".map";
		--Msg(fixedpath)
		--Test if the map exists...
		local message = "All is good!"
        if FileSystem:GetFileType(fixedpath) == nil then
			message = "Failed to load: \"" .. fixedpath .. "\""
			ConCommand_Disconnect()
        end	

		if self:Connect(tempname)==false then
			message = "Failed to load: \"".. tempname.."\""
		else
			Analytics:SendProgressEvent("Start",tempname)
			message = "Connected to \""..self.currentmap.."\""
			LTime:Resume()
		end
	
		Msg(message)
		System:SetProperty("map","")
	end

	-- Hack: If a C++ actor needs to restart
	-- (eg: Player is dead) do this trick.
	if System:GetProperty("needtorestart") ~= "" then
		if window:MouseHit(1) then
			System:SetProperty("needtorestart","")
			window:FlushMouse()
			Restart()
		end
	end

	if world ~= nil then
		world:Render()
	end
end

function MapHook(entity,object)
end

function CallPostStart()
    local e
    for i=0,world:CountEntities()-1 do
        e = world:GetEntity(i)
        if e.script ~= nil and type(e.script.PostStart) == "function" then
			if e:GetKeyValue("PostStart") ~= "1" then
				DevMsg("Firing PostStart() on " ..e:GetKeyValue("name"))
				e.script:PostStart()
				e:SetKeyValue("PostStart","1")
			end
         end
     end
end

function LWorld:Connect(mapname)
	if mapname == nil then return false end
	local fullpath = "Maps/" .. mapname .. ".map"
    if fullpath==nil then return false end
    if FileSystem:GetFileType(fullpath) == 0 then return false end
	LGraphicsWindow:RenderLoadingScreen()
    LTime:Pause()	
	System:GCSuspend()
    self:Create()
    if GetWorld()~=nil then
		local tm = Time:Millisecs()
        if Map:Load(fullpath, "MapHook") == false then return end
		tm = Time:Millisecs() - tm
		Analytics:SendGenericEvent("Map Load Time:"..mapname, tm)
		DevMsg("Map Load Time: "..tm.."ms")
        self.currentmap = fullpath
    end

	if GameRules~=nil then
		if type(GameRules.SpawnPlayer)=="function" then
			GameRules:SpawnPlayer()
		end
	end
	
	System:GCResume()
	CallPostStart()
	local camera = self:GetCamera()
	self:ApplyCameraSettings(camera)
	return true
end

function LWorld:Connected()
	if GetWorld()==nil then return false end
	if self.currentmap==nil then return false end
	return true
end

function ConCommand_Fire(arg1,arg2)
	if arg1==nil or arg2==nil then return end
	if world~=nil then
		-- If the user didn't set up the camera, do this loop to find one!
		local count = world:CountEntities()
		for n=0,count-1 do
			local entity=world:GetEntity(n)
			if entity:GetClass()==Object.EntityClass then
				local ent = tolua.cast(entity,"Entity")
				if ent:GetKeyValue("name") == arg1 then
					if ent.script then
						if type(entity.script.arg2)=="function" then
							entity.script.arg2()
						end
					end
				end
			end
		end
	end
end
LSystem:RegisterConCommand("fire",ConCommand_Fire)

function ConCommand_Map(arg)
end
LSystem:RegisterConCommand("map",ConCommand_Map)

function ConCommand_Restart(arg)
	Restart()
end
LSystem:RegisterConCommand("restart",ConCommand_Restart)

function ConCommand_LightQuality(arg)
	-- if arg null, return.
	if arg==nil then return end

	-- Set the property.
	System:SetProperty(PROPERTY_LIGHTQUALITY,arg)
	
	-- Change the setting.
	if world~=nil then world:SetLightQuality(arg) end

	-- Report
	if world~=nil then
		Msg(PROPERTY_LIGHTQUALITY .." has been set to " ..world:GetLightQuality())
	else
		Msg(PROPERTY_LIGHTQUALITY .." has been set to " ..System:GetProperty(PROPERTY_LIGHTQUALITY))
	end
end
LSystem:RegisterConCommand(PROPERTY_LIGHTQUALITY,ConCommand_LightQuality)

function ConCommand_TerrainQuality(arg)
	if arg==nil then return end
	System:SetProperty(PROPERTY_TERRAIN,tostring(arg))
	if world~=nil then world:SetTerrainQuality(arg) end
	if world~=nil then
		Msg(PROPERTY_TERRAIN .." has been set to " ..world:GetTerrainQuality())
	else
		Msg(PROPERTY_TERRAIN .." has been set to " ..System:GetProperty(PROPERTY_TERRAIN))
	end
	
end
LSystem:RegisterConCommand(PROPERTY_TERRAIN,ConCommand_TerrainQuality)

function ConCommand_TessellationQuality(arg)
	if arg==nil then return end
	System:SetProperty(PROPERTY_TESSELLATION,tostring(arg))
	if world~=nil then world:SetTessellationQuality(arg) end
	-- Report
	if world~=nil then
		Msg(PROPERTY_TESSELLATION .." has been set to " ..world:GetTessellationQuality())
	else
		Msg(PROPERTY_TESSELLATION .." has been set to " ..System:GetProperty(PROPERTY_TESSELLATION))
	end
end
LSystem:RegisterConCommand(PROPERTY_TESSELLATION,ConCommand_TessellationQuality)

function ConCommand_WaterQuality(arg)
	if arg==nil then return end
	--if arg > 2 then arg = 2 end
	System:SetProperty(PROPERTY_WATERQUALITY,tostring(arg))
	if world~=nil then world:SetWaterQuality(arg) end

	-- Report
	if world~=nil then
		Msg(PROPERTY_WATERQUALITY .." has been set to " ..world:GetWaterQuality())
	else
		Msg(PROPERTY_WATERQUALITY .." has been set to " ..System:GetProperty(PROPERTY_WATERQUALITY))
	end
end

LSystem:RegisterConCommand(PROPERTY_WATERQUALITY, ConCommand_WaterQuality)

function ConCommand_TextureQuality(arg)
	if arg==nil then return end
	System:SetProperty(PROPERTY_TEXTUREQUALITY,tostring(arg))
	Texture:SetDetail(arg)
	Msg(PROPERTY_TEXTUREQUALITY .." has been set to " ..Texture:GetDetail())
end
LSystem:RegisterConCommand(PROPERTY_TEXTUREQUALITY, ConCommand_TextureQuality)

function ConCommand_TextureAFilter(arg)
	if arg==nil then return end
	System:SetProperty(PROPERTY_TEXTUREANISOTROPY,tostring(arg))
	Texture:SetAnisotropy(tonumber(arg))
	Msg(PROPERTY_TEXTUREANISOTROPY .." has been set to " ..Texture:GetAnisotropy())
end
LSystem:RegisterConCommand(PROPERTY_TEXTUREANISOTROPY, ConCommand_TextureAFilter)

-- 6/19/17: Done last minuite before 4.4 release.
-- Done to test the new offical fog shaders.
function ConCommand_Fog(arg)
	if arg==nil then return end
	System:SetProperty(PROPERTY_FOG,tostring(arg))
	Msg(PROPERTY_FOG .." has been set to " ..arg)	
end
LSystem:RegisterConCommand(PROPERTY_FOG, ConCommand_Fog)

function ConCommand_FogEnable(arg)
	if arg==nil then return end
	System:SetProperty(PROPERTY_FOG_ENABLE,tostring(arg))
	local camera = LWorld:GetCamera()
	local b = tonumber(arg)
	if b==1 then b=true else b=false end
	camera:SetFogMode(b)
	--Msg(PROPERTY_FOG_ENABLE .." has been set to " ..camera:GetFogMode())	
end
LSystem:RegisterConCommand(PROPERTY_FOG_ENABLE, ConCommand_FogEnable)

function ConCommand_FogAngle(arg1,arg2)
	if arg1==nil or arg2==nil then return end
	local camera = LWorld:GetCamera()
	camera:SetFogAngle(tonumber(arg1),tonumber(arg2))

	Msg(PROPERTY_FOG_ANGLE .." has been set to " ..tostring(camera:GetFogAngle().x) ..", " .. tostring(camera:GetFogAngle().y))	
end
LSystem:RegisterConCommand(PROPERTY_FOG_ANGLE, ConCommand_FogAngle)

function ConCommand_FogRange(arg1,arg2)
	if arg1==nil or arg2==nil then return end
	local camera = LWorld:GetCamera()
	camera:SetFogRange(tonumber(arg1),tonumber(arg2))

	Msg(PROPERTY_FOG_RANGE .." has been set to " ..tostring(camera:GetFogRange().x) ..", " .. tostring(camera:GetFogRange().y))	
end
LSystem:RegisterConCommand(PROPERTY_FOG_RANGE, ConCommand_FogRange)

function ConCommand_FogColor(arg1,arg2,arg3,arg4)
	if arg1==nil or arg2==nil then return end
	if arg3==nil or arg4==nil then return end
	local camera = LWorld:GetCamera()

	arg1 = tonumber(arg1)
	arg2 = tonumber(arg2)
	arg3 = tonumber(arg3)
	arg4 = tonumber(arg4)

	if arg1>1 then arg1 = arg1/255 end
	if arg2>1 then arg2 = arg2/255 end
	if arg3>1 then arg3 = arg3/255 end
	if arg4>1 then arg4 = arg4/255 end

	camera:SetFogColor(tonumber(arg1),tonumber(arg2),tonumber(arg3),tonumber(arg4))

	Msg(PROPERTY_FOG_COLOR .." has been set to " ..tostring(camera:GetFogColor().x) ..", " .. tostring(camera:GetFogColor().y) ..", " .. tostring(camera:GetFogColor().z) ..", " .. tostring(camera:GetFogColor().w))	
end
LSystem:RegisterConCommand(PROPERTY_FOG_COLOR, ConCommand_FogColor)