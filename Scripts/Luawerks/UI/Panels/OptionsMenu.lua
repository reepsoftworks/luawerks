--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------
if LOptionsMenu~=nil then return end
LOptionsMenu={}

LOptionsMenu.tabber = nil
LOptionsMenu.panel={}

local indent=8
function LOptionsMenu:Create(gui)
	self.panel = Widget:Panel(gui:GetBase():GetClientSize().x/2-250,gui:GetBase():GetClientSize().y/2-300,450,600,gui:GetBase())
	self.panel:SetAlignment(0,0,0,0)
	self.panel:SetObject("backgroundcolor",Vec4(0.15,0.15,0.15,1))
	self.panel:SetFloat("radius",4)

	self.tabber = Widget:Tabber(indent,indent,self.panel:GetClientSize().x-indent*2,self.panel:GetClientSize().y-indent*2,self.panel)
	
	-- Create Tab
	function CreateGeneralTab()
		self.tabber:AddItem("Options",true)
		indent = 12
		local panel=Widget:Panel(indent,indent,self.tabber:GetClientSize().x-indent*2,self.tabber:GetClientSize().y-indent*2-30,self.tabber)
		panel:SetBool("border",true)
		self.panel.general = panel

		local y=20
		local sep=40

		--Graphics resolution
		local label = Widget:Label("Screen Resolution",20,y,200,16,panel)
		y=y+16
		self.panel.general.screenres = Widget:ChoiceBox(20,y,200,30,panel)
		local count = System:CountGraphicsModes()
		local window = context:GetWindow()
		for n=0,count-1 do
			local gfx = System:GetGraphicsMode(n)
			local selected=false
			if window:GetWidth()==gfx.x and window:GetHeight()==gfx.y then selected=true end
			self.panel.general.screenres:AddItem( gfx.x.."x"..gfx.y,selected)
		end
		if System:GetPlatformName() == "" then self.panel.general.screenres:Hide() label:Hide() else y=y+sep end --System:GetGraphicsMode() is fucked with linux.. :/
		
		
		--Antialias
		Widget:Label("Antialias",20,y,200,16,panel)
		y=y+16
		self.panel.general.antialias = Widget:ChoiceBox(20,y,200,30,panel)
		self.panel.general.antialias:AddItem("None")
		self.panel.general.antialias:AddItem("2x")
		self.panel.general.antialias:AddItem("4x")
		y=y+sep
		
		--Texture quality
		Widget:Label("Texture Detail",20,y,200,16,panel)
		y=y+16
		self.panel.general.texturequality = Widget:ChoiceBox(20,y,200,30,panel)
		self.panel.general.texturequality:AddItem("Low")
		self.panel.general.texturequality:AddItem("Medium")
		self.panel.general.texturequality:AddItem("High")
		self.panel.general.texturequality:AddItem("Very High")
		y=y+sep
		
		--Lighting quality
		Widget:Label("Lighting Quality",20,y,200,16,panel)
		y=y+16
		self.panel.general.lightquality = Widget:ChoiceBox(20,y,200,30,panel)
		self.panel.general.lightquality:AddItem("Low")
		self.panel.general.lightquality:AddItem("Medium")
		self.panel.general.lightquality:AddItem("High")
		y=y+sep
		
		--Terrain quality
		Widget:Label("Terrain Quality",20,y,200,16,panel)
		y=y+16
		self.panel.general.terrainquality = Widget:ChoiceBox(20,y,200,30,panel)
		self.panel.general.terrainquality:AddItem("Low")
		self.panel.general.terrainquality:AddItem("Medium")
		self.panel.general.terrainquality:AddItem("High")
		y=y+sep
		
		--Water quality
		Widget:Label("Water Quality",20,y,200,16,panel)
		y=y+16
		self.panel.general.waterquality = Widget:ChoiceBox(20,y,200,30,panel)
		self.panel.general.waterquality:AddItem("Low")
		self.panel.general.waterquality:AddItem("Medium")
		self.panel.general.waterquality:AddItem("High")
		y=y+sep
		
		--Anisotropy
		Widget:Label("Anisotropic Filter",20,y,200,16,panel)
		y=y+16
		self.panel.general.afilter = Widget:ChoiceBox(20,y,200,30,panel)
		self.panel.general.afilter:AddItem("None")
		self.panel.general.afilter:AddItem("2x")
		self.panel.general.afilter:AddItem("4x")
		self.panel.general.afilter:AddItem("8x")
		self.panel.general.afilter:AddItem("16x")
		self.panel.general.afilter:AddItem("32x")
		y=y+sep
		
		local row1X = 20
		local row2X = 160
		local row2Y = y

		--Create a checkbox
		self.panel.general.tfilter = Widget:Button("Trilinear Filter",row1X,y,200,30,panel)
		self.panel.general.tfilter:SetStyle(BUTTON_CHECKBOX)
		y=y+sep
		
		--Create a checkbox
		self.panel.general.vsync = Widget:Button("Vertical Sync",row1X,y,200,30,panel)
		self.panel.general.vsync:SetStyle(BUTTON_CHECKBOX)
		y=y+sep

		--Create a checkbox
		self.panel.general.tstream = Widget:Button("Texture Streaming",row2X,row2Y,200,30,panel)
		self.panel.general.tstream:SetStyle(BUTTON_CHECKBOX)
		row2Y=row2Y+sep

		--Create a checkbox
		self.panel.general.fullscreen = Widget:Button("Fullscreen (Requires Restart)",row2X,row2Y,200,30,panel)
		self.panel.general.fullscreen:SetStyle(BUTTON_CHECKBOX)

		self.panel.general:Show()
	end

	-- Create Tab
	function CreateControlsTab()
		self.tabber:AddItem("Controls",false)
		indent = 12
		local panel=Widget:Panel(indent,indent,self.tabber:GetClientSize().x-indent*2,self.tabber:GetClientSize().y-indent*2-30,self.tabber)
		panel:SetBool("border",true)
		self.panel.controls = panel

		local y=20
		local c = 12
		local widgetscript = "Scripts/Luawerks/UI/Widgets/TextFieldControls.lua"

		Widget:Label("Move Forward:",20,y+c,200,16,panel)
		local buttontxt = System:GetProperty("key_forward","w")
		local buttonX = 128
		local buttonY = 28
		self.panel.controls.forward = Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.forward:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Move Left:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_left","a")
		self.panel.controls.left  =Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.left:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Move Backward:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_backward","s")
		self.panel.controls.backward = Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.backward:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Move Right:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_right","d")
		self.panel.controls.right = Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.right:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Jump:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_jump","space")
		self.panel.controls.jump = Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.jump:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Interaction:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_use","e")
		self.panel.controls.use = Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.use:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Duck:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_duck","ctrl")
		self.panel.controls.duck = Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.duck:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Fire Primary:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_fire1","mouse1")
		self.panel.controls.fire1 = Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.fire1:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Fire Secondary:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_fire2","mouse2")
		self.panel.controls.fire2 =Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.fire2:SetScript(widgetscript)

		y=y+buttonY+4
		Widget:Label("Reload:",20,y+c,200,16,panel)
		buttontxt = System:GetProperty("key_reload","r")
		self.panel.controls.reload = Widget:TextField(buttontxt,panel:GetClientSize().x-buttonX-indent,y,buttonX,buttonY,panel)
		self.panel.controls.reload:SetScript(widgetscript)

		self.panel.controls:Hide()
	end

	CreateGeneralTab()
	CreateControlsTab()

	-- Create Buttons
	self.closeoptions = Widget:Button("Close",self.tabber:GetClientSize().x-72-indent,self.tabber:GetClientSize().y-28-5,72,28,self.tabber)
	self.applyoptions = Widget:Button("Apply",self.tabber:GetClientSize().x-72*2-4-indent,self.tabber:GetClientSize().y-28-5,72,28,self.tabber)
	self.applyoptions:SetStyle(BUTTON_OK)	
	self.closeoptions:SetStyle(BUTTON_CANCEL)	
	self:GetSettings()

	self:Close()
end

function LOptionsMenu:GetSettings()
	--Antialias
	local aa = (System:GetProperty(PROPERTY_MUTISAMPLE,"1")).."x"
	if aa=="0x" or aa=="1x" then aa="None" end
	for i=0,self.panel.general.antialias:CountItems()-1 do
		if self.panel.general.antialias:GetItemText(i)==aa then
			self.panel.general.antialias:SelectItem(i)
			break
		end
	end

	--Screen resolution
	local currentwindow = Window:GetCurrent()
	if currentwindow~=nil then
		local w = currentwindow:GetWidth()
		local h = currentwindow:GetHeight()	
		local gfxmode = tostring(w).."x"..tostring(h)
		self.panel.general.screenres:SelectItem(-1)
		for n=0,self.panel.general.screenres:CountItems()-1 do
			if self.panel.general.screenres:GetItemText(n)==gfxmode then
				self.panel.general.screenres:SelectItem(n)
				break
			end
		end
	end


	function to_number(command,val)
		local c = System:GetProperty(command, tostring(val))
		return tonumber(c)
	end

	function to_bool(command,val)
		local c = System:GetProperty(command, tostring(val))
		if c == 1 then return true end
		return false
	end

	local anisotropynumber = tonumber((System:GetProperty(PROPERTY_TEXTUREANISOTROPY,Texture:GetAnisotropy())))
	local anisotropy = tostring(anisotropynumber).."x"
	if anisotropy=="0x" then anisotropy="None" end
	for n=0,self.panel.general.afilter:CountItems()-1 do
		if anisotropy==self.panel.general.afilter:GetItemText(n) then
			self.panel.general.afilter:SelectItem(n)
			--self.panel.general.afilter:SelectItem(to_number(PROPERTY_TEXTUREANISOTROPY,tostring(n)))
			break
		end
	end		
	

	self.panel.general.lightquality:SelectItem(to_number(PROPERTY_LIGHTQUALITY,"1"))
	self.panel.general.terrainquality:SelectItem(to_number(PROPERTY_TERRAIN, "1"))
	self.panel.general.waterquality:SelectItem(to_number(PROPERTY_WATERQUALITY, "1"))
	
	local loadmode = tonumber((System:GetProperty(PROPERTY_TEXTURESTREAM)))
	self.panel.general.tstream:SetState(loadmode)
	self.panel.general.fullscreen:SetState(LGraphicsWindow:IsFullScreen())

	self.panel.general.texturequality:SelectItem(self.panel.general.texturequality:CountItems()-1-Texture:GetDetail())
	self.panel.general.tfilter:SetState(to_bool(PROPERTY_TEXTURETRILINEAR,"1"))
	self.panel.general.vsync:SetState(LGraphicsWindow:IsVSync())
end

function LOptionsMenu:ApplySettings()
	function splitstring(str,sep)
		local array = {}
		local reg = string.format("([^%s]+)",sep)
		for mem in string.gmatch(str,reg) do
			table.insert(array, mem)
		end
		return array
	end

	--Antialias
	local world = World:GetCurrent()
	local item=nil

	item = self.panel.general.antialias:GetSelectedItem()
	local aa = self.panel.general.antialias:GetItemText(item)
	aa = string.gsub(aa,"x","")
	if aa=="None" then aa="1" end
	aa = tonumber(aa)
	System:SetProperty(PROPERTY_MUTISAMPLE,aa)

	LWorld:ApplyCameraSettings(LWorld:GetCamera())

	--Graphics mode
	item=self.panel.general.screenres:GetSelectedItem()
	if item>-1 then
		local gfxmode = self.panel.general.screenres:GetItemText(item)
		gfxmode = splitstring(gfxmode,"x")
		local window = Window:GetCurrent()

		if GetWindowStyle()== Window.Titlebar+Window.Center or GetWindowStyle()== Window.Center then
			local usersscreen = Vec2(GetCurrentMonitorSize().x / 2,GetCurrentMonitorSize().y / 2)
			local windowpos = Vec2(usersscreen.x - gfxmode[1]/2, usersscreen.y - gfxmode[2]/2)
			window:SetLayout(windowpos.x,windowpos.y,gfxmode[1],gfxmode[2])

			--190309: We only save the screen settings when the game is windowed. Fullscreen will always return the native resoultion.
			System:SetProperty(PROPERTY_SCREENWIDTH,gfxmode[1])
			System:SetProperty(PROPERTY_SCREENHEIGHT,gfxmode[2])
		elseif GetWindowStyle()~= Window.FullScreen then 
			window:SetLayout(0,0,gfxmode[1],gfxmode[2]) 
		end
	end

	--Light quality
	local quality = self.panel.general.lightquality:GetSelectedItem()
	ConCommand_LightQuality(quality)

	--Water quality
	quality = self.panel.general.waterquality:GetSelectedItem()
	ConCommand_WaterQuality(quality)
		
	--Texture detail
	quality = self.panel.general.texturequality:CountItems()-1-self.panel.general.texturequality:GetSelectedItem()
	ConCommand_TextureQuality(quality)
		
	--Anisotropy
	item = self.panel.general.afilter:GetSelectedItem()
	if item>-1 then
		quality = self.panel.general.afilter:GetItemText(item)
		quality = string.gsub(quality,"x","")
		if quality=="None" then quality = "0" end
		ConCommand_TextureAFilter(quality)
	end
		
	--Trilinear filter
	quality = self.panel.general.tfilter:GetState()
	if quality then
		System:SetProperty(PROPERTY_TEXTURETRILINEAR,"1")
	else
		System:SetProperty(PROPERTY_TEXTURETRILINEAR,"0")
	end		
		
	--Terriain quality
	quality = self.panel.general.terrainquality:GetSelectedItem()
	ConCommand_TerrainQuality(quality)	

	--Fullscreen
	local v = self.panel.general.fullscreen:GetState()
	if v==true then v="1" else v="0" end
	System:SetProperty(PROPERTY_FULLSCREEN,v)

	--VSync
	local v = self.panel.general.vsync:GetState()
	if v==true then v="1" else v="0" end
	ConCommand_VSync(v)
	LWorld:ApplySettings()

	DevMsg("Saved Settings")
end

function LOptionsMenu:Open()
	if LOptionsMenu:Closed() then
		LBaseGUI:CloseAllPanels()
		self.panel:Show()
	end
end

function LOptionsMenu:Close()
	if not LOptionsMenu:Closed() then
		self.panel:Hide()
	end
end

function LOptionsMenu:Closed()
	return self.panel:Hidden()
end

function LOptionsMenu:Toggle()
	if self:Closed() then self:Open() else self:Close() end
end

function LOptionsMenu:ApplyControls()

	function SetValue(key,value)
		if value ~= "<ENTER KEY>" or value ~= "<INVAILD>" or value ~= "" or value ~= nil then
			System:SetProperty(key,value)
			DevMsg(key .." has been set to `" .. String:Lower(value) .. "`")
		else
			ErrorMsg(key .. "has an invaild value, skipping!")
		end
	end

	SetValue("key_forward",self.panel.controls.forward:GetText())
	SetValue("key_left",self.panel.controls.left:GetText())
	SetValue("key_backward",self.panel.controls.backward:GetText())
	SetValue("key_right",self.panel.controls.right:GetText())

	SetValue("key_jump",self.panel.controls.jump:GetText())
	SetValue("key_use",self.panel.controls.use:GetText())
	SetValue("key_duck",self.panel.controls.duck:GetText())
	
	SetValue("key_fire1",self.panel.controls.fire1:GetText())
	SetValue("key_fire2",self.panel.controls.fire2:GetText())
	SetValue("key_reload",self.panel.controls.reload:GetText())

	DevMsg("Saved Controls")
end

function LOptionsMenu:ProcessEvent(event)
	if not self:Closed() then
		if event.id == Event.WidgetAction then
			if event.source == self.tabber then	
				if event.data==0 then
					self.panel.general:Show()
					self.panel.controls:Hide()
				else
					self.panel.general:Hide()
					self.panel.controls:Show()
				end	
			end
		
			if event.source == self.applyoptions then
				self:ApplySettings()
				self:ApplyControls()
			elseif event.source == self.closeoptions then
				self:Close()
			end
		end
	end
end

function ConCommand_OpenOptions(arg)
	LOptionsMenu:Toggle()
end
LSystem:RegisterConCommand("optionsmenu",ConCommand_OpenOptions)