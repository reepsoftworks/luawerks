--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------
if LQuitDialog~=nil then return end
LQuitDialog={}

LQuitDialog.panel={}

function LQuitDialog:Create(gui)
	self.gui=gui

	local sizeX = 300
	local sizeY = 150

	self.panel = Widget:Panel(gui:GetBase():GetClientSize().x/2-150,gui:GetBase():GetClientSize().y/2-50,sizeX,sizeY,gui:GetBase())
	self.panel:SetAlignment(0,0,0,0)
	self.panel:SetObject("backgroundcolor",Vec4(0.15,0.15,0.15,1))
	self.panel:SetFloat("radius",4)

	local indent = 8
	self.tabber = Widget:Tabber(indent,indent,self.panel:GetClientSize().x-indent*2,self.panel:GetClientSize().y-indent*2,self.panel)
	self.tabber:AddItem("Quit",true)
	
	-- Create Tab
	indent = 12
	local panel=Widget:Panel(indent,indent,self.tabber:GetClientSize().x-indent*2,self.tabber:GetClientSize().y-indent*2,self.tabber)
	panel:SetBool("border",true)
	self.panel.general = panel

	-- TEMP
	
	function GetFontSize(text)
		local x = self.gui:GetTextWidth(text)
		local y = self.gui:GetFontHeight()
		return Vec2(x,y)
	end

	local txt = "Are you sure you want to quit?"
	Widget:Label(txt,20,20,GetFontSize(txt).x,GetFontSize(txt).y,self.panel.general)
	self.confirm = Widget:Button("OK",self.tabber:GetClientSize().x/2-2-72,self.tabber:GetClientSize().y-26-4,72,26,self.tabber)
	self.cancel = Widget:Button("Cancel",self.tabber:GetClientSize().x/2+2,self.tabber:GetClientSize().y-26-4,72,26,self.tabber)
	self.confirm:SetStyle(BUTTON_OK)	
	self.cancel:SetStyle(BUTTON_CANCEL)	
	self:Close()
end

function LQuitDialog:Open()
	LBaseGUI:CloseAllPanels()
	self.panel:Show()
end

function LQuitDialog:Close()
	self.panel:Hide()
end

function LQuitDialog:Closed()
	return self.panel:Hidden()
end

function LQuitDialog:Toggle()
	if self:Closed() then self:Open() else self:Close() end
end

function LQuitDialog:ProcessEvent(event)
	if event.id == Event.WidgetAction then
		if event.source == self.confirm then
			ConCommand_Quit()
		elseif event.source == self.cancel then
			self:Close()
		end
	end
end

function ConCommand_OpenQuit(arg)
	LQuitDialog:Toggle()
end
LSystem:RegisterConCommand("quitdialog",ConCommand_OpenQuit)