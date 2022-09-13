--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------

-- Panels
import "Scripts/Luawerks/UI/Panels/Console.lua"
import "Scripts/Luawerks/UI/Panels/MapSelect.lua"
import "Scripts/Luawerks/UI/Panels/OptionsMenu.lua"
import "Scripts/Luawerks/UI/Panels/QuitDialog.lua"

if LBaseGUI~=nil then return end
LBaseGUI={}

LBaseGUI.gui=nil
LBaseGUI.scale=1
LBaseGUI.child=nil
LBaseGUI.color=Vec4(0,0,0,0.5)

function LBaseGUI:SetColor(color)
	if self.color == color then return end
	LBaseGUI.gui:GetBase():SetObject("backgroundcolor",color)
	self.color = color
end

function LBaseGUI:GetColor(color)
	return self.color
end

function LBaseGUI:Build(context,child)
	local gui = GUI:Create(context)
	gui:SetScale(self.scale)
	gui:GetBase():SetScript("Scripts/GUI/Panel.lua")
	gui:GetBase():SetObject("backgroundcolor",self.color)
	LBaseGUI.gui = gui

	-- Create Panels
	LMapDialog:Create(LBaseGUI.gui)
	LOptionsMenu:Create(LBaseGUI.gui)
	LQuitDialog:Create(LBaseGUI.gui)

	-- Always last so it always shows on top!
	LConsole:CreatePanel(LBaseGUI.gui)

	LBaseGUI:SetChild(child)
	LBaseGUI:Hide()
end

function LBaseGUI:SetChild(child)
	self.child = child
end
function LBaseGUI:Hide()
	if not self:Hidden() then LBaseGUI.gui:Hide() end
end

function LBaseGUI:Show()
	if self:Hidden() then LBaseGUI.gui:Show() end
end

function LBaseGUI:Hidden()
	return LBaseGUI.gui:Hidden() 
end

function LBaseGUI:Toggle(T)
	if T==true then self:Show() else self:Hide() end
end

function LBaseGUI:ProcessEvent(event)
	LConsole:ProcessEvent(event)
	LMapDialog:ProcessEvent(event)
	LOptionsMenu:ProcessEvent(event)
	LQuitDialog:ProcessEvent(event)
	return true
end

function LBaseGUI:Update()
	if self.child:IsActive()==false then self:Hide() else self:Show() end
	LConsole:Update()
	return true
end

function LBaseGUI:CallPanel(panel)
	LBaseGUI:Show()
	if panel == "mapselect" then LMapDialog:Toggle() end
	if panel == "options" then LOptionsMenu:Toggle() end
	if panel == "quit" then LQuitDialog:Toggle() end
	if panel == "console" then 
		if LConsole:Closed() then 
			LConsole:Open() 
		else 
			LConsole:Close() 
		end 
	end
end

function LBaseGUI:CloseAllPanels()
	LMapDialog:Close()
	LOptionsMenu:Close()
	LConsole:Close()
end

function LBaseGUI:CloseAllPanelsAndHide()
	self:CloseAllPanels()
	LBaseGUI:Hide()
end

function ConCommand_OpenMenu(arg)
	LBaseGUI:CallPanel(arg)
end
LSystem:RegisterConCommand("open",ConCommand_OpenMenu)