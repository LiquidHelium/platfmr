BGList = Class()

function BGList:init()
	self.backgroundDict = {}
	self:LoadBackgrounds()
end

function BGList:GetAmountOfBackgrounds()
	return table.getn(self.backgroundDict)
end

function BGList:LoadBackgrounds()
	self:AddBackground("background.png")
	self:AddBackground("background2.png")
	self:AddBackground("background3.png")
	self:AddBackground("background4.png")
end

function BGList:AddBackgroundToID(id, imageLocation)
	table.insert(self.backgroundDict, id, love.graphics.newImage("img/" .. imageLocation))
end

function BGList:AddBackground(imageLocation)
	table.insert(self.backgroundDict, self:GetAmountOfBackgrounds()+1, love.graphics.newImage("img/" .. imageLocation))
end

function BGList:GetBackgroundFromID(id)
	return self.backgroundDict[id]
end


function BGList:ContainsID(id)
	if self.backgroundDict[id] ~= nil then
		return true
	end
		return false
end