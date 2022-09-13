--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------
if LSystem~=nil then return end
LSystem={}
LSystem.shutdown=0
LSystem.vr=false
LSystem.steamworks=false

-- Global function
function LoadMap(arg)
	System:SetProperty("map",arg)
end

-- ConCommand System.
LSystem.concommands={}
function LSystem:Split(command,pos)
    if pos==0 then pos = 1 end
    objProp = {}
    index = 1
    for value in command:gmatch("%S+") do 
        objProp [index] = value
        index = index + 1
    end
    return objProp[pos]
end

function LSystem:RegisterConCommand(name,func)
	if name == nil or func == nil then return end
    self.concommands[name] = func
end

function LSystem:FireCommand(name)
    local lookfor = LSystem:Split(name,1)
	if self.concommands[lookfor] == nil then ErrorMsg(lookfor .." is not a vaild command.",2) return end

	if lookfor=="map" then 
		local mapname = string.sub(name, 5)
		LoadMap(mapname)
	else
		local arg1 = LSystem:Split(name,2)
		local arg2 = LSystem:Split(name,3)
		local arg3 = LSystem:Split(name,4)
		local arg4 = LSystem:Split(name,5)
		if arg1 == nil then arg1 = "" end
		if arg2 == nil then arg2 = "" end
		if arg3 == nil then arg3 = "" end
		if arg4 == nil then arg4 = "" end
		self.concommands[lookfor](LSystem:Split(name,2),LSystem:Split(name,3),LSystem:Split(name,4),LSystem:Split(name,5))
	end
end

-- To be used at a later date..
function LSystem:Shutdown()
	System:SetProperty("map","")
	System:SetProperty("needtorestart","")
end

-- Print all available concommands.
function ConCommand_Help()
	Msg("---Printing All ConCommands---")
    for key,value in pairs(LSystem.concommands) do
        Msg(key)
    end
	Msg("---------End Of List----------")
end
LSystem:RegisterConCommand("help",ConCommand_Help)

function LSystem:IsDebug()
    return DEBUG
end

function LSystem:IsSandbox()
    if System:GetProperty("sandbox") == "1" then return true end
    return false
end

function LSystem:LaunchedFromEditor()
	if System:GetProperty("debuggerhostname") ~= "" then return true end
	return false
end

function LSystem:AllowConsole()
	if LSystem:IsDev() then return true end
    if System:GetProperty(PROPERTY_CONSOLE,"0") == "1" then return true end
    return false
end

function LSystem:IsDev()
	if System:GetProperty("devmode") == "1" then return true end
    if self:IsDebug() or self:LaunchedFromEditor() then return true end
    return false
end

function LSystem:IsHeadless()
	if System:GetProperty("headless") == "1" then return true end
    return false
end

function LSystem:IsLinux()
	if System:GetPlatformName() ~= "Windows" then return true end
	return false
end

function LSystem:CanUseMapSelectUI()
	if self:IsSandbox() then return false end 
	if usemapselectui == nil then usemapselectui = false end
	return usemapselectui
end

function LSystem:InitVR(mode)
	if VR:Enable()==false then
		ErrorMsg("VR failed to initialize.")
	else
		VR:SetTrackingSpace(mode)
		useuisystem = false
		self.vr = true
	end
end

function LSystem:IsVR()
	-- Only seated is supported at this time..
	--if System:GetProperty(PROPERTY_VR) == "1" then return true end
    return self.vr
end

function LSystem:InitSteamworks()
	if Steamworks:Initialize() then
		self.steamworks = true
	end
end

function LSystem:IsSteamworks()
    return self.steamworks
end

function LSystem:Print(msg,color)
	if color == nil then color = 0 end
	if LConsole~=nil then LConsole:Log(msg) end
    System:Print(msg)
end

function AppTerminate()
	local win = Window:GetCurrent()
	if win~=nil then
		if win:Closed() then return 1 end
	end
    return LSystem.shutdown
end

function ConCommand_Print(arg)
    Msg(arg)
end
LSystem:RegisterConCommand("print",ConCommand_Print)

function ConCommand_Set(arg1,arg2)
    System:SetProperty(arg1,arg2)
end
LSystem:RegisterConCommand("set",ConCommand_Set)

function ConCommand_Call(arg)
	if LSystem:IsDev() then
		Interpreter:ExecuteString(arg)
	end
end
LSystem:RegisterConCommand("call",ConCommand_Call)

if DEBUG then
	function ConCommand_PrintWarn(arg)
		WarnMsg(arg)
	end
	LSystem:RegisterConCommand("printwarn",ConCommand_PrintWarn)

	function ConCommand_PrintError(arg)
		ErrorMsg(arg)
	end
	LSystem:RegisterConCommand("printerror",ConCommand_PrintError)
end

function ConCommand_Disconnect()
	LWorld:Free()
end
LSystem:RegisterConCommand("disconnect",ConCommand_Disconnect)

function ConCommand_Quit()
    LSystem.shutdown=1
end
LSystem:RegisterConCommand("quit",ConCommand_Quit)