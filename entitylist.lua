EntityList = Class()

function EntityList:init()
	self.EntityPreviewImages = {}
	self:AddPreviewImages()
end

function EntityList:AddPreviewImages()
	self.EntityPreviewImages[1] = love.graphics.newImage("img/spike.png")
end

function EntityList:CreateEntity(id, x, y, blockSize, triggerPointsList)
	if triggerPointsList == nil then
		triggerPointsList = {}
	end
	if id == 1 then
		return SpikeEntity("spike.png", x, y, blockSize, 1, triggerPointsList)
	end
end

function EntityList:AmountOfEntitys()
	return 1
end

function EntityList:GetEntityPeviewImage(id)
	return self.EntityPreviewImages[id]
end

function EntityList:ContainsID(id)
	if id > 0 and id <= self.AmountOfEntitys() then
		return true
	else
		return false
	end
end