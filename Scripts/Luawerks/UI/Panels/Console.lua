--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------

if LConsole~=nil then return end
LConsole={}

LConsole.panel={}

LConsole.userhistory={}
LConsole.userindex=0
LConsole.gui=nil

function LConsole:CreatePanel(gui)
	self.gui=gui

	local sizeX = 600
	local sizeY = 600

	self.panel = Widget:Panel(gui:GetBase():GetClientSize().x-sizeX,0,sizeX,sizeY,self.gui:GetBase())
	self.panel:SetAlignment(1,0,0,0)
	self.panel:SetObject("backgroundcolor",Vec4(0.15,0.15,0.15,1))
	self.panel:SetFloat("radius",4)

	local indent = 8
	self.tabber = Widget:Tabber(indent,indent,self.panel:GetClientSize().x-indent*2,self.panel:GetClientSize().y-indent*2,self.panel)
	self.tabber:AddItem("Console",true)
	
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

	local text = "Luawerks " ..Luawerks.version
	Widget:Label(text,self.panel:GetClientSize().x-GetFontSize(text).x-8,4,GetFontSize(text).x,GetFontSize(text).y,self.panel)

	self.logbox = Widget:TextArea(4,4,self.panel.general:GetClientSize().x-8,self.panel.general:GetClientSize().y-30-8,self.panel.general)
	self.textbox = Widget:TextField("",4,self.panel.general:GetClientSize().y-30,self.panel.general:GetClientSize().x-8-72-4,26,self.panel.general)
	self.textbox:SetScript("Scripts/Luawerks/UI/Widgets/TextFieldConsole.lua")
	self.sendbutton = Widget:Button("Send",self.panel.general:GetClientSize().x-4-72,self.panel.general:GetClientSize().y-30,72,26,self.panel.general)
	self.sendbutton:SetStyle(BUTTON_OK)	
	self:Close()
end

function LConsole:Exists()
	if self.panel==nil then return false end
	return true
end

function LConsole:Open()
	if not self:ShouldDraw() then return end
	self.panel:Show()
	self.gui:SetFocus(self.textbox)
end

function LConsole:Close()
	self.panel:Hide()
end

function LConsole:Closed()
	return self.panel:Hidden()
end

function LConsole:ProcessEvent(event)
	--if self:ShouldDraw()==true then
		if event.id == Event.WidgetAction then
			if event.source == self.sendbutton or event.source==self.textbox then
				local s = self.textbox:GetText()
				if s=="" or s==nil then self.gui:SetFocus(self.textbox) return end
				self:Log("] " ..s)
				LSystem:FireCommand(s)
				table.insert(self.userhistory,s)
				self.userindex=GetTableLength(self.userhistory)
				self.textbox:SetText("")
				self.gui:SetFocus(self.textbox)
			end
		end
	--end
end

function LConsole:Log(text)
	if self:Exists() then 
		if self.logbox~=nil then self.logbox:AddText(text) end
		return 
	end
end

function LConsole:ShouldDraw()
	if LSystem:IsHeadless() then return true end
	if LSystem:AllowConsole() then return true end
	return false
end

function LConsole:Update()
	-- Cycle through the user's history
	if not self:Closed() then
		--self.gui:SetFocus(self.textbox)
		if GetTableLength(self.userhistory) >= 1 then 
			if Window:GetCurrent():KeyHit(Key.Up) then
				if self.userindex <= 0 then self.userindex=GetTableLength(self.userhistory) end
				if self.textbox:GetText() ~= self.userhistory[self.userindex] then
					self.textbox:SetText(self.userhistory[self.userindex])
					self.textbox.script:SetCursorPosition(self.userhistory[self.userindex])
					self.userindex=self.userindex-1
					self.textbox.script:GainFocus()
				end
			elseif Window:GetCurrent():KeyHit(Key.Down) then
				if self.userindex > GetTableLength(self.userhistory) then self.userindex=1 end
				if self.textbox:GetText() ~= self.userhistory[self.userindex] then
					self.textbox:SetText(self.userhistory[self.userindex])
					self.textbox.script:SetCursorPosition(self.userhistory[self.userindex])
					self.userindex=self.userindex+1
					self.textbox.script:GainFocus()
				end
			end
		end
	end

	if LSystem:IsHeadless() then
		while EventQueue:Peek() do
			local event = EventQueue:Wait()
			self:ProcessEvent(event)
		end
	end

	--LSystem:Update()
end

function LConsole:CreateWindow()
	consolewindow=Window:Create(title .." [Console]",300,100,550,500,Window.Titlebar)
	self.gui = GUI:Create(consolewindow)
	self.panel = self.gui:GetBase()

	self.panel:SetScript("Scripts/GUI/Panel.lua")
	self.panel:SetAlignment(0,0,0,0)

	local indent = 8
	self.tabber = Widget:Tabber(indent,indent,self.panel:GetClientSize().x-indent*2,self.panel:GetClientSize().y-indent*2,self.panel)
	self.tabber:AddItem("Console",true)
	self.panel:SetObject("backgroundcolor",Vec4(0.15,0.15,0.15,1))
	
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

	local text = "Luawerks " ..Luawerks.version
	Widget:Label(text,self.panel:GetClientSize().x-GetFontSize(text).x-8,4,GetFontSize(text).x,GetFontSize(text).y,self.panel)

	self.logbox = Widget:TextArea(4,4,self.panel.general:GetClientSize().x-8,self.panel.general:GetClientSize().y-30-8,self.panel.general)
	self.textbox = Widget:TextField("",4,self.panel.general:GetClientSize().y-30,self.panel.general:GetClientSize().x-8-72-4,26,self.panel.general)
	self.textbox:SetScript("Scripts/Luawerks/UI/Widgets/TextFieldConsole.lua")
	self.sendbutton = Widget:Button("Send",self.panel.general:GetClientSize().x-4-72,self.panel.general:GetClientSize().y-30,72,26,self.panel.general)
	self.sendbutton:SetStyle(BUTTON_OK)	
end