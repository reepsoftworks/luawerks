function GetModelEntity(entity)
	while entity~=nil do
		if entity:GetClass()==Object.ModelClass then
			return entity
		end
		entity=entity:GetParent()
	end
	return nil
end

function IsBrush(entity)
	if entity:GetClass()==Object.ModelClass then
		local cast = tolua.cast(entity,"Model")
		return cast.collapsedfrombrushes
	end
	return false
end

function GetCenterPos(object)
	local x = object:GetAABB(Entity.LocalAABB).size.x/2
	local y = object:GetAABB(Entity.LocalAABB).size.y/2
	local z = object:GetAABB(Entity.LocalAABB).size.z/2
	return Vec3(x,y,z)
end

function GetEntityName(object)
	if entity:GetClass()==Object.EntityClass then
		return object:GetKeyValue("name")
	end
	return nil
end

function IsEntityScriptFunc(funcname, entity)
	if entity.script == nil then return false end
	if entity.script.funcname == nil then return false end
	if type(entity.script.funcname)=="function" then
		return true
	end	
	return false
end 

function FireEntityScriptFunc(funcname, entity)
	if entity.script == nil then return false end
	if entity.script.funcname == nil then return false end
	if type(entity.script.funcname)=="function" then
		entity.script:funcname()
		return true
	end	
	ErrorMsg("Failed to fire script function ("..funcname..") with entity: "..entity:GetKeyValue("name").."...")
	return false
end 	

-- Thanks to CrazyCarpet for this snippet!
function IsAABBOverlap(hostent, testent, usesizetest, global)
	if hostent == nil then return false end	
	if testent == nil then return false end	
	if global == nil then global = true end
	if testent:Hidden()==true then return false end
	if usesizetest == nil then usesizetest = false end
	if usesizetest then
		local aabb
		local eaabb 
		if global==true then
		aabb = hostent:GetAABB(Entity.GlobalAABB)
		eaabb = testent:GetAABB(Entity.GlobalAABB)
		else
		aabb = hostent:GetAABB(Entity.LocalAABB)
		eaabb = testent:GetAABB(Entity.LocalAABB)
		end
		if (eaabb.min.x > aabb.max.x) or (aabb.min.x > eaabb.max.x) then return false end
		if (eaabb.min.y > aabb.max.y) or (aabb.min.y > eaabb.max.y) then return false end
		if (eaabb.min.z > aabb.max.z) or (aabb.min.z > eaabb.max.z) then return false end
		return true
	else
		local aabb = hostent:GetAABB(Entity.GlobalAABB)
		local pos = testent:GetPosition(true)

		if pos.x < aabb.min.x then return false end
		if pos.y < aabb.min.y then return false end
		if pos.z < aabb.min.z then return false end

		if pos.x > aabb.max.x then return false end
		if pos.y > aabb.max.y then return false end
		if pos.z > aabb.max.z then return false end
		return true
	end
	return false
end