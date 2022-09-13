Script.caretposition=0
Script.sellen=0
Script.doubleclickrange = 1
Script.doubleclicktime = 500
Script.offsetx = 0
Script.textindent = 4
Script.text=""

function Script:SetText()
	self.text = self.widget:GetText()
end

function Script:Draw(x,y,width,height)
	local gui = self.widget:GetGUI()
	local pos = self.widget:GetPosition(true)
	local sz = self.widget:GetSize(true)
	local scale = gui:GetScale()
	local item = self.widget:GetSelectedItem()
	local text = self.widget:GetText()
	
	self:UpdateOffset()
	
	--Draw the widget background
	gui:SetColor(0.15,0.15,0.15)
	gui:DrawRect(pos.x,pos.y,sz.width,sz.height,0)
	
	--Draw text
	gui:SetColor(0.75,0.75,0.75)
	if text~="" then
		gui:DrawText(text,scale * self.textindent + pos.x+self.offsetx,pos.y,math.max(sz.width,sz.width-self.offsetx),sz.height,Text.Left+Text.VCenter)
	end

	gui:SetColor(0,0,0)
	gui:DrawRect(pos.x,pos.y,sz.width,sz.height,1)
	
end

--Find the character position for the given x coordinate
function Script:GetCharAtPosition(pos,clickonchar)
end

--Get the x coordinate of the current caret position
function Script:GetCaretCoord(caret)
end

--Blink the caret cursor on and off
function Script:CursorBlink()
end

function Script:TripleClick(button,x,y)
end

function Script:DoubleClick(button,x,y)
end

function Script:SetSetting(key)
	self.widget.text = key
	self.readyforinput=false
	self.focused=false
	self.widget:Redraw()
	Window:GetCurrent():FlushKeys()
	Window:GetCurrent():FlushMouse()
end

function Script:MouseDown(button,x,y)
	self.focused=true
	if button==Mouse.Left then	
		if not self.readyforinput then
			Window:GetCurrent():FlushKeys()
			Window:GetCurrent():FlushMouse()
			self.widget.text = "<ENTER KEY>"
			self.readyforinput=true
			self.widget:Redraw()
		elseif self.readyforinput == true then
			self:SetSetting("mouse1")
		end
	elseif button==Mouse.Right then	
		if self.readyforinput==true then
			self:SetSetting("mouse2") 
		end
	elseif button==Mouse.Middle then	
		if self.readyforinput==true then
			self:SetSetting("mouse3") 
		end
	end
end

function Script:MouseUp(button,x,y)
	if button==Mouse.Left then
		self.pressed=false
	end
end

function Script:GetSelectedText()
end

function Script:UpdateOffset()
end

function Script:MouseMove(x,y)
end

function Script:GainFocus()
	self.focused = true
end

function Script:LoseFocus()
	self.focused=false
	self.sellen=0
	self.widget:Redraw()
	local s = self.widget:GetText()
	if self.text~=s then
		EventQueue:Emit(Event.WidgetAction,self.widget)
		self.text=s
	end
end

function Script:MouseEnter(x,y)
	self.hovered = true
	self.widget:Redraw()
end

function Script:MouseLeave(x,y)
	self.hovered = false
	self.widget:Redraw()
end

function Script:KeyUp(keycode)
	if keycode==Key.Shift then
		self.shiftpressed=false
	end
end

function Script:KeyDown(keycode)
	if self.readyforinput then 
		self:SetSetting(GetKeyString(keycode))
	end
end

function Script:KeyChar(charcode)
end