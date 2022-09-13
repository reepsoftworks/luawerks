import "Scripts/Luawerks/Luawerks.lua"

--Initialize Steamworks (optional)
--LSystem:InitSteamworks()

--Initialize analytics (optional).  Create an account at www.gameamalytics.com to get your game keys
--[[if DEBUG==false then
	Analytics:SetKeys("GAME_KEY_xxxxxxxxx", "SECRET_KEY_xxxxxxxxx")
	Analytics:Enable()
end]]

--Set the application title
title="$PROJECT_TITLE" 

-- The start map that'll load when pressing "NEW GAME"
startmap="start"

-- Uncomment me if you want the game to still load the start map on run.
--LoadMap(startmap)

-- Enable and call the menu system This should be disabled for VR.
useuisystem = true

-- Use map selection menu for "NEW GAME" (Sandboxing must be disabled)
usemapselectui = true

-- Enable this if you wish for your app to use the settngs defined when launching from the editor.
ignoreeditorlaunchsettings = false

-- Set the background loading screen texture (optional). 
--loadingscreen = LoadTexture("thumb.tex")

-- Set the loading icon. Ideally a texture that says "LOADING".
loadingicon = LoadTexture("Materials/Common/splash.tex")

-- The default background image used when no map is loaded.
backgroundimage = LoadTexture("Materials/Common/splash.tex")

-- This will initialize Luawerks and make the game loop.
Luawerks:Initialize(title)
