--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------

function BuildMenu(context)
	local GameMenu={}
	local scale = 1.5
	
	--GUI
	local gui = GUI:Create(context)
	gui:Hide()
	gui:SetScale(scale)
	local widget
	
	gui:GetBase():SetScript("Scripts/GUI/Panel.lua")
	gui:GetBase():SetObject("backgroundcolor",Vec4(0,0,0,0.0))
	
	GameMenu.gui=gui
	GameMenu.context = context

	LBaseGUI:Build(context,GameMenu)

	function GameMenu:GetFontSize(text)
		-- TEMP
		local font = context:GetFont()
		local x = GameMenu.gui:GetTextWidth(text)
		local y = GameMenu.gui:GetFontHeight()
		return Vec2(x,y)
	end

	function GameMenu:BuildMenu()
		local indent = 70
		local centerY = gui:GetBase():GetSize().y/2
		local y = centerY

		-- I don't want to bloat the package with more materials or textures.
		-- Here's a sample snip of how to draw your game's logo to the menu.
		-- This is undocumented, so it might change...
		--[[
		local image = GameMenu.gui:LoadImage("Materials/error.tex")
		local imageH = 32
		GameMenu.imagePanel = Widget:Panel(indent,centerY-(GameMenu:GetFontSize(text).y+imageH) ,32,imageH, gui:GetBase())
		GameMenu.imagePanel:SetImage(image)
		--]]

		local text = "NEW GAME"
		GameMenu.newbutton = Widget:Button(text,indent,y,GameMenu:GetFontSize(text).x,GameMenu:GetFontSize(text).y,gui:GetBase())
		GameMenu.newbutton:SetStyle(BUTTON_LINK)
		GameMenu.newbutton:SetAlignment(1,0,0,0)

		text = "RESUME GAME"
		GameMenu.resume = Widget:Button(text,indent,y,GameMenu:GetFontSize(text).x,GameMenu:GetFontSize(text).y,gui:GetBase())
		GameMenu.resume:SetStyle(BUTTON_LINK)
		GameMenu.resume:SetAlignment(1,0,0,0)
		GameMenu.resume:Hide()
		y=y+GameMenu:GetFontSize(text).y

		text = "OPTIONS"
		GameMenu.options = Widget:Button(text,indent,y,GameMenu:GetFontSize(text).x,GameMenu:GetFontSize(text).y,gui:GetBase())
		GameMenu.options:SetStyle(BUTTON_LINK)
		GameMenu.options:SetAlignment(1,0,0,0)
		y=y+GameMenu:GetFontSize(text).y

		text = "RETURN TO MENU"
		GameMenu.rtntomenu = Widget:Button(text,indent,y,GameMenu:GetFontSize(text).x,GameMenu:GetFontSize(text).y,gui:GetBase())
		GameMenu.rtntomenu:SetStyle(BUTTON_LINK)
		GameMenu.rtntomenu:SetAlignment(1,0,0,0)

		text = "QUIT"
		GameMenu.quit = Widget:Button(text,indent,y,GameMenu:GetFontSize(text).x,GameMenu:GetFontSize(text).y,gui:GetBase())
		GameMenu.quit:SetStyle(BUTTON_LINK)
		GameMenu.quit:SetAlignment(1,0,0,0)
		y=y+GameMenu:GetFontSize(text).y
	end

	function GameMenu:HideAll()
		if not GameMenu.newbutton:Hidden() then GameMenu.newbutton:Hide() end
		if not GameMenu.resume:Hidden() then GameMenu.resume:Hide() end
		if not GameMenu.options:Hidden() then GameMenu.options:Hide() end
		if not GameMenu.rtntomenu:Hidden() then GameMenu.rtntomenu:Hide() end
		if not GameMenu.quit:Hidden() then GameMenu.quit:Hide() end
		--if not GameMenu.imagePanel:Hidden() then GameMenu.imagePanel:Hide() end
	end

	GameMenu:BuildMenu()

	function GameMenu:SetActive(bool)
		if bool==true then 
			GameMenu.gui:Show() 
		else 
			GameMenu.gui:Hide() 
		end		
	end

	function GameMenu:IsActive()
		if GameMenu.gui:Hidden() then return false end
		return true
	end

	function GameMenu:ProcessEvent(event)
		if event.id == Event.WindowSize then
		elseif event.id == Event.WidgetSelect then
		elseif event.id == Event.WidgetAction then
			if event.source == self.newbutton then
				if not LSystem:CanUseMapSelectUI() then
					System:SetProperty("map",startmap)
				else
					ConCommand_OpenMenu("mapselect")
				end
			elseif event.source == self.resume then
				LTime:Resume()
			elseif event.source == self.options then
				ConCommand_OpenMenu("options")
			elseif event.source == self.rtntomenu then
				LSystem:FireCommand("disconnect")
			elseif event.source == self.quit then
				LBaseGUI:CallPanel("quit")
			end
		end
		return true
	end

	function InPlayableWorld()
		if GetWorld()==nil then return false end
		return true
	end

	function GameMenu:Update()
		self:SetActive(LTime:Paused())
		if Action:ToggleConsole() then ConCommand_OpenMenu("console") end

		local overlaycolor = Vec4(0,0,0,0.5)

		if InPlayableWorld() then
			if not GameMenu.newbutton:Hidden() then GameMenu.newbutton:Hide() end -- Hide NEW GAME
			if GameMenu.resume:Hidden() then GameMenu.resume:Show() end -- Show RESUME

			if not GameMenu.quit:Hidden() then GameMenu.quit:Hide() end -- Hide QUIT
			if GameMenu.rtntomenu:Hidden() then GameMenu.rtntomenu:Show() end -- Show RETURN TO MENU

			overlaycolor = Vec4(overlaycolor.x,overlaycolor.y,overlaycolor.z,0.5)
		else
			if not GameMenu.resume:Hidden() then GameMenu.resume:Hide() end -- Hide RESUME
			if GameMenu.newbutton:Hidden() then GameMenu.newbutton:Show() end -- Show 

			if not GameMenu.rtntomenu:Hidden() then GameMenu.rtntomenu:Hide() end -- Hide RETURN TO MENU
			if GameMenu.quit:Hidden() then GameMenu.quit:Show() end -- Show QUIT

			overlaycolor = Vec4(overlaycolor.x,overlaycolor.y,overlaycolor.z,0.0)
		end

		if not LQuitDialog:Closed() then
			self:HideAll()
			overlaycolor = Vec4(0,0,0,0.8)
		else
			if not InPlayableWorld() then
			if GameMenu.newbutton:Hidden() then GameMenu.newbutton:Show() end
			else
			if GameMenu.resume:Hidden() then GameMenu.resume:Show() end
			end

			if GameMenu.options:Hidden() then GameMenu.options:Show() end

			if not InPlayableWorld() then
			if GameMenu.quit:Hidden() then GameMenu.quit:Show() end	
			else
			if GameMenu.rtntomenu:Hidden() then GameMenu.rtntomenu:Show() end
			end
		end
		
		LBaseGUI:SetColor(overlaycolor)

		while EventQueue:Peek() do
			local event = EventQueue:Wait()
			if self:ProcessEvent(event)==false then return false end
			if LBaseGUI:ProcessEvent(event)==false then return false end
		end

		LBaseGUI:Update()
	end

	return GameMenu
end