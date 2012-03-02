SpriteList = Class()

function SpriteList:init()
	self.spriteDict = {}
	self:LoadSprites()
end

function SpriteList:GetAmountOfBlocks()
	return table.getn(self.spriteDict)
end

function SpriteList:LoadSprites()
	self:AddSprite("block.png")
	self:AddSprite("block2.png")
	self:AddSprite("block3.png")
	self:AddSprite("block4.png")
	self:AddSprite("block5.png")
	self:AddSprite("brick1.png")
	self:AddSprite("brick2.png")
	self:AddSprite("ground1.png")
	self:AddSprite("ground2.png")
	self:AddSprite("ground3.png")
	self:AddSprite("ground4.png")
	self:AddSprite("ground5.png")
	self:AddSprite("ground6.png")
	self:AddSprite("ground7.png")
	self:AddSprite("ground8.png")
	self:AddSprite("ground9.png")
	self:AddSprite("ground10.png")
	self:AddSprite("ground11.png")
	self:AddSprite("bush1.png")
	self:AddSprite("bush2.png")
	self:AddSprite("bush3.png")
	self:AddSprite("pipe1.png")
	self:AddSprite("pipe2.png")
	self:AddSprite("pipe3.png")
	self:AddSprite("pipe4.png")
	self:AddSprite("mushroom1.png")
	self:AddSprite("mushroom2.png")
	self:AddSprite("mushroom3.png")
	self:AddSprite("mushroom4.png")
	self:AddSprite("mushroom5.png")
	self:AddSprite("cloud1.png")
	self:AddSprite("cloud2.png")
	self:AddSprite("cloud3.png")
	self:AddSprite("cloud4.png")
	self:AddSprite("cloud5.png")
	self:AddSprite("cloud6.png")
	self:AddSprite("water1.png")
	self:AddSprite("water2.png")
	self:AddSprite("door1.png")
	self:AddSprite("door2.png")
	self:AddSprite("door3.png")
end

function SpriteList:AddSpriteToID(id, imageLocation)
	table.insert(self.spriteDict, id, love.graphics.newImage("img/" .. imageLocation))
end

function SpriteList:AddSprite(imageLocation)
	table.insert(self.spriteDict, self:GetAmountOfBlocks()+1, love.graphics.newImage("img/" .. imageLocation))
end

function SpriteList:GetSpriteFromID(id)
	return self.spriteDict[id]
end


function SpriteList:ContainsID(id)
	if self.spriteDict[id] ~= nil then
		return true
	end
		return false
end