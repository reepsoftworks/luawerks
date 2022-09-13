--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------
import "Scripts/Luawerks/Functions/LoadAssets.lua"
import "Scripts/Luawerks/Functions/Actions.lua"

import "Scripts/Luawerks/UI/GameMenu.lua"

if LGraphicsWindow~=nil then return end
LGraphicsWindow={}
LGraphicsWindow.gui=nil

window=nil
context=nil

LGraphicsWindow.Font=Font:Load("Fonts/arial.ttf",10,Font.Smooth)

-----------------------------
-- Global functions
-----------------------------
function GetWindow()
    if window == nil then return nil end
    return window
end

function GetContext()
    if context == nil then return nil end
    return context
end

function GraphicsWidth()
    if context == nil then return 0 end
    return context:GetWidth()
end

function GraphicsHeight()
    if context == nil then return 0 end
    return context:GetHeight()
end

function GetScreenRes()
	local gfxmode = System:GetGraphicsMode(System:CountGraphicsModes()-1)
	gfxmode.x = math.min(1280,gfxmode.x)
	gfxmode.y = Math:Round(gfxmode.x * 9 / 16)
    local x = (System:GetProperty(PROPERTY_SCREENWIDTH, gfxmode.x)) --1024
    local y = (System:GetProperty(PROPERTY_SCREENHEIGHT, gfxmode.y)) --768
    return Vec2(x,y)
end

function GetCurrentMonitorSize()
    return Vec2(System:GetGraphicsMode(System:CountGraphicsModes() - 1).x, System:GetGraphicsMode(System:CountGraphicsModes() - 1).y)
end

function GetWindowStyle()
	local windowstyle = 0
	if System:GetProperty(PROPERTY_FULLSCREEN)=="1" then return Window.FullScreen end
	if System:GetProperty(PROPERTY_BOARDERLESS)~="1" then windowstyle = Window.Titlebar end
	if System:GetProperty(PROPERTY_CENTERWINDOW)=="1" or LSystem:IsDev() then windowstyle=windowstyle+Window.Center end
	return windowstyle
end

-----------------------------
-- LGraphicsWindow functions
-----------------------------
function LGraphicsWindow:CenterMouse()
    window:SetMousePosition(GraphicsWidth()/2,GraphicsHeight()/2)
end

function LGraphicsWindow:Create(title)	
	-- Set this up for Windowed mode...
    local x = GetScreenRes().x
    local y = GetScreenRes().y
    local style = GetWindowStyle()

	-- Don't allow Fullscreen from editor.
	if LSystem:LaunchedFromEditor() and not ignoreeditorlaunchsettings then
		x = math.min(1280,x)
		y = Math:Round(x * 9 / 16)
		style = Window.Titlebar+Window.Center
	else
		if style == Window.FullScreen then
			x = GetCurrentMonitorSize().x
			y = GetCurrentMonitorSize().y
		end
	end

    -- Need this for the AppData Folder.
    gametitle = title

    -- If it's a debug build, add additonal text to the window title
	if LSystem:IsDebug() then
		title = title .." [Debug]"
	end

	window=Window:Create(title,0,0,x,y,style)
    context = Context:Create(window, 0)
    context:SetFont(self.font)

	if useuisystem==true then
		self.gamemenu = BuildMenu(context)
	end

    self:CenterMouse()
	PrecacheJunkyard()
    LTime:Pause()
end

function LGraphicsWindow:IsFullScreen()
	if GetWindowStyle() == Window.FullScreen then return true else return false end
end

function LGraphicsWindow:IsVSync()
	if System:GetProperty(PROPERTY_VSYNC)=="1" then return true else return false end
end

function LGraphicsWindow:Update()
	if Action:TogglePause() then 
		LTime:Toggle()
	end

	if self.gamemenu~=nil then self.gamemenu:Update() end

    LTime:Update()

    if GetWorld() == nil then
        context:SetColor(0, 0, 0, 1)
        context:Clear()
    end

    LWorld:Update()

    if GetWorld() ~= nil then
        context:SetBlendMode(Blend.Alpha)
        context:SetColor(1, 1, 1, 1)
        if System:GetProperty("stats","0")=="1" then
            context:DrawText("FPS: "..Math:Round(Time:UPS()),2,2)
        elseif System:GetProperty("stats","0")=="2" then
            context:DrawStats(2,2)
        elseif System:GetProperty("stats","0")=="3" then
            context:DrawStats(2,2,true)
        end
    end

	if not LWorld:Connected() and backgroundimage ~= nil then
		context:SetBlendMode(Blend.Alpha)
		context:SetColor(1,1,1,1)
		context:DrawImage(backgroundimage, 0, 0, context:GetWidth(), context:GetHeight())
		context:SetBlendMode(Blend.Solid)
	end

	context:SetColor(1, 1, 1, 1)
    context:SetBlendMode(Blend.Solid)

    -- Save a screenshot to the GetAppDataPath.
    if window:KeyHit(Key.F5) and not LSystem:IsSandbox() then
		local screensfolder = "Screenshots"
        --local screenssdir = FileSystem:GetAppDataPath() .. "/" .. title
        local screenssdir = "./"
        screenssdir = screenssdir .. "/" .. screensfolder
        if FileSystem:GetFileType(screenssdir) == 0 then FileSystem:CreateDir(screenssdir) end
        local filename = screenssdir .. "/" .. os.date('%d_%m_%y_%H_%M_%S') .. ".tga"
        if context:Screenshot(filename) then
            Msg("Screenshot:" ..filename " was saved!")
        end
    end

	-- A temp fix for refreshing the game.
	-- I have this problem where when vsync is enabled,
	-- the framecap is stuck at 30. 
	if not LTime:Paused() then Time:Resume() end
	
	if LSystem:IsVR() == false then
		--Refresh the screen
		local framecap = (System:GetProperty(PROPERTY_FRAMECAP,"0"))
		context:Sync(self:IsVSync(),framecap)
	else
		VR:MirrorDisplay(context)
		context:Sync(false)
	end
end

function LGraphicsWindow:RenderLoadingScreen()
	--Never draw the loading screen with VR games.
	--The Screen gets caught in the context and the player's view on the 
	--monitor stops rendering..
	if LSystem:IsVR() == false then
		-- Hide GUI while loading
		if self.gamemenu~=nil then
			if self.gamemenu:IsActive() then self.gamemenu:SetActive(false) end
		end

		-- Draw black screen.
		context:SetBlendMode(Blend.Alpha)

		if loadingscreen ~= nil then
			context:SetColor(1,1,1,1)
			context:DrawImage(loadingscreen, 0, 0, context:GetWidth(), context:GetHeight())
		else
			context:SetColor(0,0,0,1)
			context:DrawRect(0, 0, context:GetWidth(), context:GetHeight())
		end

		-- If loading icon isn't set, return.
		if loadingicon ~= nil then 
			--Draw the logo.
			context:SetColor(1,1,1,1)
			local x = (window:GetWidth() / 2) - (loadingicon:GetWidth() / 2)
			local y = (window:GetHeight() / 2) - (loadingicon:GetHeight() / 2)
			context:DrawImage(loadingicon,x,y,loadingicon:GetWidth(),loadingicon:GetHeight() )	
			context:SetColor(1,1,1,1)
		end

		context:SetBlendMode(Blend.Solid)
		context:Sync(false)
	end
end

function ConCommand_Stats(arg)
	System:SetProperty("stats",arg)
	Msg("stats has been set to " ..System:GetProperty("stats"))
end
LSystem:RegisterConCommand("stats",ConCommand_Stats)

function ConCommand_Framecap(arg)
	System:SetProperty(PROPERTY_FRAMECAP,arg)
	Msg(PROPERTY_FRAMECAP .." has been set to " ..System:GetProperty(PROPERTY_FRAMECAP))
end
LSystem:RegisterConCommand(PROPERTY_FRAMECAP, ConCommand_Framecap)

function ConCommand_VSync(arg)
	System:SetProperty(PROPERTY_VSYNC,arg)
	Msg(PROPERTY_VSYNC .." has been set to " ..System:GetProperty(PROPERTY_VSYNC))
end
LSystem:RegisterConCommand(PROPERTY_VSYNC ,ConCommand_VSync)