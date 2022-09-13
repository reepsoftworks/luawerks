--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------
if Action~=nil then return end
Action={}
Action.suspend=false

-- Convert a key via int to it's string value.
function GetKeyString(int)
	if int == nil then return "<INVAILD>" end
	if int == Key.A then return "a" end
    if int == Key.B then return "b" end
	if int == Key.C then return "c" end
    if int == Key.D then return "d" end
    if int == Key.E then return "e" end
    if int == Key.F then return "f" end
    if int == Key.G then return "g" end
    if int == Key.H then return "h" end
    if int == Key.I then return "i" end
	if int == Key.J then return "j" end
    if int == Key.K then return "k" end
	if int == Key.L then return "l" end
    if int == Key.M then return "m" end
    if int == Key.N then return "n" end 
	if int == Key.O then return "o" end 
    if int == Key.P then return "p" end
    if int == Key.Q then return "q" end
    if int == Key.R then return "r" end
	if int == Key.S then return "s" end
    if int == Key.T then return "t" end
    if int == Key.U then return "u" end
    if int == Key.V then return "v" end 
    if int == Key.W then return "w" end 
    if int == Key.X then return "x" end
    if int == Key.Y then return "y" end 
    if int == Key.Z then return "z" end 

------------------------------------------------------

    if int == Key.D0 then return "0" end
    if int == Key.D1 then return "1" end
    if int == Key.D2 then return "2" end
    if int == Key.D3 then return "3" end
    if int == Key.D4 then return "4" end
    if int == Key.D5 then return "5" end
    if int == Key.D6 then return "6" end
    if int == Key.D7 then return "7" end
    if int == Key.D8 then return "8" end
    if int == Key.D9 then return "9" end

------------------------------------------------------

    if int == Key.F1 then return "F1" end  
    if int == Key.F2 then return "F2" end  
    if int == Key.F3 then return "F3" end 
    if int == Key.F4 then return "F4" end   
    if int == Key.F5 then return "F5" end  
    if int == Key.F6 then return "F6" end  
    if int == Key.F7 then return "F7" end  
    if int == Key.F8 then return "F8" end 
    if int == Key.F9 then return "F9" end   
    if int == Key.F10 then return "F10" end 
    if int == Key.F11 then return "F11" end   
    if int == Key.F12 then return "F12" end 

------------------------------------------------------

    if int == Key.NumPad0 then return "num0" end 
	if int == Key.NumPad1 then return "num1" end 
	if int == Key.NumPad2 then return "num2" end 
	if int == Key.NumPad3 then return "num3" end 
	if int == Key.NumPad4 then return "num4" end 
	if int == Key.NumPad5 then return "num5" end 
	if int == Key.NumPad6 then return "num6" end 
	if int == Key.NumPad7 then return "num7" end 
	if int == Key.NumPad8 then return "num8" end 
	if int == Key.NumPad9 then return "num9" end 

------------------------------------------------------
	
    if int == Key.NumPadPeriod then return "numperiod" end   
    if int == Key.NumPadDivide then return "numdivide" end 
    if int == Key.NumPadSubtract then return "numsubtract" end 
    if int == Key.NumPadAddition then return "numadd" end 

------------------------------------------------------

    if int == Key.Alt then return "alt" end   
    if int == Key.BackSpace then return "backspace" end   
    if int == Key.CapsLock then return "capslock" end 
    if int == Key.ControlKey then return "ctrl" end 
    if int == Key.Delete then return "delete" end 
    if int == Key.Down then return "down" end 
    if int == Key.Enter then return "enter" end 
    if int == Key.Escape then return "enter" end 
    if int == Key.Home then return "enter" end 
    if int == Key.Insert then return "insert" end
    if int == Key.Left then return "left" end
    if int == Key.NumLock then return "numlock" end
    if int == Key.PageDown then return "pagedown" end
    if int == Key.PageUp then return "pageup" end
    if int == Key.RControlKey then return "rctrl" end 
    if int == Key.Right then return "right" end 
    if int == Key.Shift then return "shift" end  
    if int == Key.Space then return "space" end   
    if int == Key.Subtract then return "-" end 
    if int == Key.Tab then return "tab" end 
    if int == Key.Up then return "up" end 
    if int == Key.Tilde then return "`" end 
    if int == Key.Equals then return "=" end 
    if int == Key.OpenBracket then return "[" end 
    if int == Key.CloseBracket then return "]"  end 
    if int == Key.Slash then return "backslash" end
    if int == Key.Semicolon then return ";" end 
    if int == Key.Quotes then return "quotes" end 
    if int == Key.Comma then return "," end 
    if int == Key.Slash then return "slash" end
    if int == Key.WindowsKey then return "command" end
    if int == Key.Period then return "." end 
	if int == Key.End then return "end" end

	return "<INVAILD>"
end

-- Convert a key via string to it's int value.
function GetKeyInt(str)
	if str == nil then return "<INVAILD>" end
    if str == "a" then return Key.A end
    if str == "b" then return Key.B end
    if str == "c" then return Key.C end
    if str == "d" then return Key.D end
    if str == "e" then return Key.E end
    if str == "f" then return Key.F end
    if str == "g" then return Key.G end
    if str == "h" then return Key.H end
    if str == "i" then return Key.I end
    if str == "j" then return Key.J end    
    if str == "k" then return Key.K end
    if str == "l" then return Key.L end
    if str == "m" then return Key.M end
    if str == "n" then return Key.N end
    if str == "o" then return Key.O end
    if str == "p" then return Key.P end
    if str == "q" then return Key.Q end
    if str == "r" then return Key.R end
    if str == "s" then return Key.S end
    if str == "t" then return Key.T end  
    if str == "u" then return Key.U end
    if str == "v" then return Key.V end
    if str == "w" then return Key.W end
    if str == "x" then return Key.X end
    if str == "y" then return Key.Y end
    if str == "z" then return Key.Z end    

    if str == "0" then return Key.D0 end 
    if str == "1" then return Key.D1 end 
    if str == "2" then return Key.D2 end 
    if str == "3" then return Key.D3 end     
    if str == "4" then return Key.D4 end 
    if str == "5" then return Key.D5 end 
    if str == "6" then return Key.D6 end 
    if str == "7" then return Key.D7 end 
    if str == "8" then return Key.D8 end 
    if str == "9" then return Key.D9 end           

------------------------------------------------------

    if str == "F1" then return Key.F1 end  
    if str == "F2" then return Key.F2 end  
    if str == "F3" then return Key.F3 end 
    if str == "F4" then return Key.F4 end   
    if str == "F5" then return Key.F5 end  
    if str == "F6" then return Key.F6 end  
    if str == "F7" then return Key.F7 end  
    if str == "F8" then return Key.F8 end 
    if str == "F9" then return Key.F9 end  
    if str == "F10" then return Key.F10 end  
    if str == "F11" then return Key.F11 end   
    if str == "F12" then return Key.F12 end  

------------------------------------------------------

	if str == "mouse1" then return Mouse.Left end  
	if str == "mouse2" then return Mouse.Right end  
	if str == "mouse3" then return Mouse.Middle end 

------------------------------------------------------

    if str == "num0" then return Key.NumPad0 end 
    if str == "num1" then return Key.NumPad1 end 
    if str == "num2" then return Key.NumPad2 end 
    if str == "num3" then return Key.NumPad3 end     
    if str == "num4" then return Key.NumPad4 end 
    if str == "num5" then return Key.NumPad5 end 
    if str == "num6" then return Key.NumPad6 end 
    if str == "num7" then return Key.NumPad7 end 
    if str == "num8" then return Key.NumPad8 end 
    if str == "num9" then return Key.NumPad9 end     
    if str == "numperiod" then return Key.NumPadPeriod end   
    if str == "numdivide" then return Key.NumPadDivide end 
    if str == "numsubtract" then return Key.NumPadSubtract end 
    if str == "numadd" then return Key.NumPadAddition end 

------------------------------------------------------

    if str == "alt" then return Key.Alt end   
    if str == "backspace" then return Key.BackSpace end   
    if str == "capslock" then return Key.CapsLock end 
    if str == "ctrl" then return Key.ControlKey end 
    if str == "delete" then return Key.Delete end 
    if str == "down" then return Key.Down end 
    if str == "enter" then return Key.Enter end 
    if str == "escape" then return Key.Escape end 
    if str == "home" then return Key.Home end 
    if str == "insert" then return Key.Insert end
    if str == "left" then return Key.Left end
    if str == "numlock" then return Key.NumLock end
    if str == "pagedown" then return Key.PageDown end
    if str == "pageup" then return Key.PageUp end
    if str == "rctrl" then return Key.RControlKey end 
    if str == "right" then return Key.Right end 
    if str == "shift" then return Key.Shift end  
    if str == "space" then return Key.Space end   
    if str == "-" then return Key.Subtract end 
    if str == "tab" then return Key.Tab end 
    if str == "up" then return Key.Up end 
    if str == "`" then return Key.Tilde end 
    if str == "=" then return Key.Equals end 
    if str == "[" then return Key.OpenBracket end 
    if str == "]" then return Key.CloseBracket end 
    if str == "backslash" then return Key.Slash end
    if str == ";" then return Key.Semicolon end 
    if str == "quotes" then return Key.Quotes end 
    if str == "," then return Key.Comma end 
    if str == "slash" then return Key.Slash end
    if str == "windows" or str == "command" then return Key.WindowsKey end
    if str == "." then return Key.Period end 
	if str == "end" then return Key.End end
end

-------------------------------------------
-- Luawerks uses this for calling events -- 
-------------------------------------------

function Action:TogglePause()
	local key_pause = GetKeyInt(System:GetProperty("key_pause","escape"))
	if window:KeyHit(key_pause) then return true end
	return false
end

key_console = GetKeyInt(System:GetProperty("key_console","`")) -- Needs to be global to prevent this key from showing up in the text box.
function Action:ToggleConsole()
	key_console = GetKeyInt(System:GetProperty("key_console","`"))
	if window:KeyHit(key_console) then return true end
	return false
end

function Action:ToggleChat()
	local key_chat = GetKeyInt(System:GetProperty("key_chat","c"))
	if window:KeyHit(key_chat) then return true end
	return false
end

function Action:Abort()
	local key_abort = GetKeyInt(System:GetProperty("key_abort","end"))
	if window:KeyHit(key_abort) then return true end
	return false
end

------------------------------------------
-- Anything below here is sample inputs -- 
------------------------------------------
function Action:MoveForward()
	if self.suspend==true then return false end
	local key_forward = GetKeyInt(System:GetProperty("key_forward","w"))
	return window:KeyDown(key_forward)
end

function Action:MoveBackward()
	if self.suspend==true then return false end
	local key_backward = GetKeyInt(System:GetProperty("key_backward","s"))
	return window:KeyDown(key_backward)
end

function Action:MoveLeft()
	if self.suspend==true then return false end
	local key_left = GetKeyInt(System:GetProperty("key_left","a"))
	return window:KeyDown(key_left)
end

function Action:MoveRight()
	if self.suspend==true then return false end
	local key_right = GetKeyInt(System:GetProperty("key_right","d"))
	return window:KeyDown(key_right)
end

function Action:Use()
    if self.suspend==true then return false end
	local key_use = GetKeyInt(System:GetProperty("key_use","e"))
	return window:KeyHit(key_use)
end

function Action:Jump()
	if self.suspend==true then return false end
	local key_jump = GetKeyInt(System:GetProperty("key_jump","space"))
	return window:KeyHit(key_jump)
end

function Action:Duck()
	if self.suspend==true then return false end
	local key_duck = GetKeyInt(System:GetProperty("key_duck","ctrl"))
	return window:KeyDown(key_duck)
end

function Action:Throw()
	if self.suspend==true then return false end
	local key_fire1 = GetKeyInt(System:GetProperty("key_fire1","mouse1"))
	local key_fire2 = GetKeyInt(System:GetProperty("key_fire2","mouse2"))
	if window:MouseHit(key_fire1) or window:MouseHit(key_fire2) then return true end
	return false
end

function Action:Fire1(auto)
	if self.suspend==true then return false end
    if auto == nil then auto = nil end
	local key_fire1 = GetKeyInt(System:GetProperty("key_fire1","mouse1"))
    if auto then
        if window:MouseDown(key_fire1) then return true end
    else
        if window:MouseHit(key_fire1) then return true end
    end
	return false
end

function Action:Fire2()
	if self.suspend==true then return false end
	local key_fire2 = GetKeyInt(System:GetProperty("key_fire2","mouse2"))
	return window:MouseHit(key_fire2)
end

function Action:Reload()
	if self.suspend==true then return false end
	local key_reload = GetKeyInt(System:GetProperty("key_reload","r"))
	return window:KeyHit(key_reload)
end