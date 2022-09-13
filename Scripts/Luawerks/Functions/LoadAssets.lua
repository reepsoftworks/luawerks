--------------------------------------------------------------------
-- Luawerks: A lua framework for Leadwerks Game Engine            --
-- Copyright (c) 2014-2019, Steven Ferriolo. All rights reserved. --	
-- Email: sferriolo@reepsoftworks.com							  --
--------------------------------------------------------------------
import "Scripts/Luawerks/Constants/AssetPaths.lua"

function Precache(entitypath)
	local ext = FileSystem:ExtractExt(entitypath)
	if ext == "mdl" or ext == "pfb" or ext == "tex" or ext == "mat" or ext == "wav" or ext == "ogg" then
		local asset
		if ext == "mdl" then
			asset = LoadModel(entitypath)
			DevMsg("Precached model " ..'"'..FileSystem:RealPath(entitypath)..'"'.."...")
			if asset ~= nil then asset:Hide() end
		elseif ext == "pfb" then
			asset = LoadPrefab(entitypath)
			if asset~=nil then 
				DevMsg("Precached prefab " ..'"'..FileSystem:RealPath(entitypath)..'"'.."...")
			end
			if asset ~= nil then asset:Hide() end
		elseif ext == "tex" then
			asset = LoadTexture(entitypath)
			DevMsg("Precached texture " ..'"'..FileSystem:RealPath(entitypath)..'"'.."...")
		elseif ext == "mat" then
			asset = LoadMaterial(entitypath)
			DevMsg("Precached material " ..'"'..FileSystem:RealPath(entitypath)..'"'.."...")
		elseif ext == "wav" or ext == "ogg" then
			asset = LoadSound(entitypath)
			DevMsg("Precached sound " ..'"'..FileSystem:RealPath(entitypath)..'"'.."...")
		end
	end
end

function PrecacheJunkyard()
	if FileSystem:GetFileType(PRECACHE_TXT) ~= 0 then
		DevMsg("Creating Junkyard...")

		local oldworld = world
		local junkyard = World:Create()
		World:SetCurrent(junkyard)

		LGraphicsWindow:RenderLoadingScreen()

		-- Read Test
		local stream = FileSystem:ReadFile(PRECACHE_TXT) 
		if (stream~=nil) then
			while (not stream:EOF()) do
			Precache(stream:ReadLine()) 
			end
			stream:Release()
		end
		if oldworld ~= nil then World:SetCurrent(oldworld) else  World:SetCurrent(nil) end
	end
end

function CheckAsset(n)
	if FileSystem:GetFileType(n) == 0 then
		local ext = FileSystem:ExtractExt(n)
		if ext == nil then return Debug:Assert("Extention is nil!") end

		if ext == "mdl" then 
			WarnMsg("Failed to load model \"" .. n .. "\"...")
			return ERROR_MODEL
		end

		if ext == "wav" then 
			WarnMsg("Failed to load sound \"" .. n .. "\"...")
			return ERROR_SOUND
		end

		if ext == "ogg" then 
			WarnMsg("Failed to load sound \"" .. n .. "\"...")
			return ERROR_SOUND
		end

		if ext == "tex" then 
			WarnMsg("Error: Failed to load texture \"" .. n .. "\"...")
			return ERROR_TEX 
		end

		if ext == "mat" then 
			WarnMsg("Failed to load material \"" .. n .. "\"...")
			return ERROR_MAT
		end

		if ext == "pfb" then 
			WarnMsg("Failed to load prefab \"" .. n .."\"...")
			return nil
		end
	end
	return n
end

function IsErrorAsset(n)
	if n == ERROR_MODEL or n == ERROR_SOUND or n == ERROR_TEX or n == ERROR_MAT then return true end
	return false
end

function LoadModel(mdl,unique)
	if unique == true then
		-- This code here makes a model unique to the rest of the references.
		-- This is great for a model in which you want to change it's materials. (skins)
		DevMsg("Creating unique model from \"" .. mdl .. "\"...")
		local org = Model:Load(CheckAsset(mdl))
		local copy = org:Copy()
		org:Release()
		if copy==nil then 
			WarnMsg("Error: Failed to create unique model from \"" .. mdl .. "\"...")
			return Model:Load(ERROR_MDL)
		end
		return copy
	else
		return Model:Load(CheckAsset(mdl))
	end	
end

function LoadSound(snd)
	return Sound:Load(CheckAsset(snd))
end

function LoadTexture(tex)
	return Texture:Load(CheckAsset(tex))
end

-- Beta feature: LOD model support!
-- best to use it for static models for now!
import "Scripts/Functions/ReleaseTableObjects.lua"
function ModelLOD(path)
	mTable = {}
	mTable.entity = LoadModel(path,false)
	mTable.lod={}
	mTable.current=0
	mTable.lodcount=0

	mTable.camera=nil
	
	function mTable:AddLOD(path,distance)
		if distance == nil then distance = 0 end
		self.lodcount = self.lodcount + 1
		self.lod[self.lodcount]={}
		self.lod[self.lodcount].entity = LoadModel(path,false)
		self.lod[self.lodcount].entity:SetMatrix(self.entity:GetMatrix())
		self.lod[self.lodcount].entity:SetKeyValue("name","lod"..self.lodcount)
		self.lod[self.lodcount].entity:Hide()
		--self.lod[self.lodcount].entity:SetMass(self.entity:GetMass())
		self.lod[self.lodcount].distance = distance
	end

	function mTable:HideAllLods()
		if table.getn(self.lod) > 0 then 
			local key,value
			for key,value in pairs(self.lod) do
				if value ~= nil then 
					value.entity:Hide()
				end
			end
		end
	end

	function mTable:Swap(index)
		if self.current == index then return end

		-- Swap back to our base model
		if index == 0 then
			DevMsg("Swapped Lod to base model")
			self:HideAllLods()
			self.entity:Show()
			--self.entity[self.lodcount].SetMass(self.lod[self.current].entity:GetMass())
			self.entity:SetMatrix(self.lod[self.current].entity:GetMatrix())
			--self.entity:SetVelocity(self.lod[self.current].entity:GetVelocity())
			self.current=index
			return
		end

		-- Swap to Lod
		if index > 0 then
			DevMsg("Swapping Lod to " ..index)
			self.entity:Hide()
			self:HideAllLods()
			--self.lod[self.lodcount].entity:SetMass(self.entity:GetMass())
			self.lod[index].entity:SetMatrix(self.entity:GetMatrix())
			--self.lod[index].entity:SetVelocity(self.entity:GetVelocity())
			self.lod[index].entity:Show()
			self.current=index
		end
	end

	function mTable:Get()
		local returnval = self.entity

		if self.current > 1 then
			if not self.lod[self.current].entity:Hidden() then returnval = self.lod[self.current].entity end
		end

		return returnval
	end

	function mTable:IsLOD()
		if self.current == 0 then return false else return true end
	end

	-- Call this from UpdatePhysics or UpdateWorld.
	function mTable:Update()
		if GetTableLength(self.lod) <= 0 then return end

		if self.camera == nil then
			self.camera = LWorld:GetCamera()
		end
		if self.camera == nil then return end

		local obj = self:Get()

		if obj ~= nil then
			local distance = obj:GetDistance(self.camera)
			local n = obj:GetKeyValue("name")
			
			local currentlod = self.current
			if currentlod ~= 0 then
				if distance < self.lod[currentlod].distance then
					if self:Get() ~= self.lod[currentlod-1] then self:Swap(currentlod-1) end
				end
			end

			local nextlod = self.current+1
			if self.lod[nextlod]==nil then return end
			if distance >= self.lod[nextlod].distance then
				if self:Get() ~= self.lod[nextlod] then self:Swap(nextlod) end
			end

			--System:Print(self.current)
		else
			DevMsg("ModelLOD is nil!")
		end
	end

	function mTable:Release()
		ReleaseTableObjects(self.lod)
	end

	return mTable
end

function LoadMaterial(mat)
	return Material:Load(CheckAsset(mat))
end

function LoadPrefab(pfb)
	return Prefab:Load(CheckAsset(pfb))
end