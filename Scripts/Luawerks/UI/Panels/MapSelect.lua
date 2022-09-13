--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------

if LMapDialog~=nil then return end
LMapDialog={}

LMapDialog.panel={}

function LMapDialog:Create(gui)
	if not LSystem:CanUseMapSelectUI() then return end

	self.gui=gui

	local sizeX = 300
	local sizeY = 150

	self.panel = Widget:Panel(gui:GetBase():GetClientSize().x/2-250,gui:GetBase():GetClientSize().y/2-300,450,600,gui:GetBase())
	self.panel:SetAlignment(0,0,0,0)
	self.panel:SetObject("backgroundcolor",Vec4(0.15,0.15,0.15,1))
	self.panel:SetFloat("radius",4)

	local indent = 8
	self.tabber = Widget:Tabber(indent,indent,self.panel:GetClientSize().x-indent*2,self.panel:GetClientSize().y-indent*2,self.panel)
	self.tabber:AddItem("Map",true)
	
	-- Create Tab
	indent = 12
	local panel=Widget:Panel(indent,indent,self.tabber:GetClientSize().x-indent*2,self.tabber:GetClientSize().y-indent*2-30,self.tabber)
	panel:SetBool("border",true)
	self.panel.general = panel

	self.panel.mapselect = Widget:Panel(indent,indent,panel:GetClientSize().x-indent*2,panel:GetClientSize().y-indent*2-30,panel)
    self.panel.mapselect:SetScript("Scripts/GUI/ListBox.lua")

    -- Add all maps in the map directory to the list..
    local mapdir  = FileSystem:GetDir().."/Maps"
    local p 
	if LSystem:IsLinux() then
	-- This doesn't sort the map names as well as the win ulternative.
		p = io.popen('find "'..mapdir..'" -type f')
	else
		p = io.popen('dir "'..mapdir..'" /b')
	end

    for file in p:lines() do
        local ext = FileSystem:ExtractExt(file)
        if ext == "map" then
			file = FileSystem:StripAll(file)
            self.panel.mapselect:AddItem(file)
        end
    end

	-- Autoselect last map...
	if self.panel.mapselect:CountItems()>0 then
		self.panel.mapselect:SelectItem(0)
		local defaultmap = self.panel.mapselect:GetSelectedItem()
		defaultmap = self.panel.mapselect:GetItemText(0)
		mapdir = System:GetProperty("lastmap","Maps/"..defaultmap..".map")
		mapdir = FileSystem:StripAll(mapdir)

		for n=0, self.panel.mapselect:CountItems()-1 do
			if mapdir == self.panel.mapselect:GetItemText(n) then
				self.panel.mapselect:SelectItem(n)
				break
			end
		end	
	end

	self.confirm = Widget:Button("Go",self.tabber:GetClientSize().x-72*2-4-indent,self.tabber:GetClientSize().y-28-5,72,28,self.tabber)
	self.cancel = Widget:Button("Cancel",self.tabber:GetClientSize().x-72-indent,self.tabber:GetClientSize().y-28-5,72,28,self.tabber)
	self.confirm:SetStyle(BUTTON_OK)	
	self.cancel:SetStyle(BUTTON_CANCEL)	

	self:Close()
end

function LMapDialog:Open()
	if not LSystem:CanUseMapSelectUI() then return end
	LBaseGUI:CloseAllPanels()
	self.panel:Show()
end

function LMapDialog:Close()
	if not LSystem:CanUseMapSelectUI() then return end
	self.panel:Hide()
end

function LMapDialog:Closed()
	if not LSystem:CanUseMapSelectUI() then return true end
	return self.panel:Hidden()
end

function LMapDialog:Toggle()
	if self:Closed() then self:Open() else self:Close() end
end

function LMapDialog:ProcessEvent(event)
	if not self:Closed() then
		if not LSystem:CanUseMapSelectUI() then return end
		if event.id == Event.WidgetAction then
			if event.source == self.confirm then
				self:Close()
				local mapfile = self.panel.mapselect:GetSelectedItem()
				mapfile = self.panel.mapselect:GetItemText(mapfile)
				System:SetProperty("map",mapfile)
				System:SetProperty("lastmap",mapfile)
			elseif event.source == self.cancel then
				self:Close()
			end
		end
	end
end

function ConCommand_OpenMapSelect(arg)
	LMapDialog:Toggle()
end
LSystem:RegisterConCommand("mapdialog",ConCommand_OpenMapSelect)