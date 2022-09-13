--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------
if LTime~=nil then return end
LTime={}

LTime.paused=false

function LTime:Pause()
    if self.paused then return end

    Time:Pause()
    self.paused=true

    if window ~= nil then
        window:FlushKeys()
        window:FlushMouse()
		window:ShowMouse()
    end
end

function LTime:Paused()
    return self.paused
end

function LTime:Resume()
    if not self.paused then return end

	-- Unhide console if showing
	if LConsole.consolemode==true then consolemode=false end

    if window ~= nil then
        window:FlushKeys()
        window:FlushMouse()
		window:HideMouse()
		LGraphicsWindow:CenterMouse()	
    end

	if LSystem:IsVR() then VR:CenterTracking() end

    Time:Resume()
    self.paused=false
end

function LTime:Toggle()
    if GetWorld() == nil then return end

    if self.paused then
        self:Resume()
    else
        self:Pause()
    end
end

function LTime:Update()
    -- Just update the time normally...
    Time:Update()

	if world ~= nil then
		if LTime:Paused() == false then
			world:Update()
		end
	end
end

function ConCommand_Pause()
    if GetWorld() == nil then return end
    LTime:Pause()
end
LSystem:RegisterConCommand("pause",ConCommand_Pause)

function ConCommand_Resume()
    if world == nil then return end
    LTime:Resume()
end
LSystem:RegisterConCommand("resume",ConCommand_Resume)