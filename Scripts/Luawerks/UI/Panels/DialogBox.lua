if DialogBox~=nil then return end
DialogBox={}

function DialogBox:Create(title,message,x,y,gui)
	local box = Widget:Panel(gui:GetBase():GetClientSize().x/2-150,gui:GetBase():GetClientSize().y/2-50,x,y,gui:GetBase())
	box:SetAlignment(0,0,0,0)
	box:SetFloat("radius",4)
	box:SetBool("border",true)
	--Widget:Label(title,8,8,x,20,box)
	Widget:Label(message,20,20,x,20,box)
	box.ok = Widget:Button("OK",box:GetClientSize().x/2-2-72,box:GetClientSize().y-26-4,72,26,box)
	box.cancel = Widget:Button("Cancel",box:GetClientSize().x/2+2,box:GetClientSize().y-26-4,72,26,box)
	box.ok:SetStyle(BUTTON_OK)	
	box.cancel:SetStyle(BUTTON_CANCEL)	
	box:Hide()
	return box
end