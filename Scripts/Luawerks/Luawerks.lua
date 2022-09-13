--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------

-- Constants
import "Scripts/Luawerks/Constants/AssetPaths.lua"
import "Scripts/Luawerks/Constants/Properties.lua"

-- Base API
import "Scripts/Luawerks/System.lua"
import "Scripts/Luawerks/Time.lua"
import "Scripts/Luawerks/GraphicsWindow.lua"
import "Scripts/Luawerks/World.lua"
import "Scripts/Luawerks/UI/BaseGUI.lua"

-- Functions
import "Scripts/Luawerks/Functions/EntityFunc.lua"
import "Scripts/Luawerks/Functions/GetTableLength.lua"

-- Define the version of the engine the application is using
LEADWERKS_VER = 460

-- Define Luawerks
LUAWERKS=true
if Luawerks~=nil then return end
Luawerks={}
Luawerks.version=128

if GameRules~=nil then
	if type(GameRules.Initialize)=="function" then
		GameRules:Initialize()
	end
end

function Luawerks:Initialize(wintitle)
    -- If wintitle is nil, fill it in with a fallback
    if wintitle == nil or wintitle =="$PROJECT_TITLE" then wintitle="Luawerks" end
	
	if not LSystem:IsHeadless() then
		-- Create a window
		LGraphicsWindow:Create(wintitle)

		-- Check VR
		if System:GetProperty(PROPERTY_VR)=="1" then
			LSystem:InitVR(VR.Seated)
		end

		-- Main loop
		while AppTerminate()==0 do
			if LSystem:IsDev()==true and Action:Abort() then return end
			LGraphicsWindow:Update()
		end
	else
		LConsole:CreateWindow()
		while AppTerminate()==0 do
			LConsole:Update()
		end
	end

	--collectgarbage()

	LSystem:Shutdown()
end

-- Print functions
function Msg(msg)
    LSystem:Print(msg)
end

function DevMsg(msg)
    if not LSystem:IsDev() then return end
    LSystem:Print(msg)
end

function WarnMsg(msg)
    LSystem:Print("Warning: " ..msg, 1)
end

function ErrorMsg(msg)
    LSystem:Print("Error: " ..msg, 2)
end