EntityBase = Class()

function EntityBase:init(sprite, x, y, tileSize, entityTypeID, triggerPointList)
	self.entityType = entityTypeID
	self.tileSize = tileSize
	self.pos = Vector(x * tileSize, y * tileSize)
	self.sprite = love.graphics.newImage("img/" .. sprite)
	self.startSprite = self.sprite
	self.startTilePos = Vector(x, y)
	if triggerPointList == nil then
		self.TriggerPointsList = {}
	else
		self.TriggerPointsList = triggerPointList
	end
	self.actice = false
end


function EntityBase:IsPlayerTouchingTrigger(rect)

	rightBound = math.floor(rect:GetRight()/self.tileSize)
	bottomBound = math.floor(rect:GetBottom()/self.tileSize)

	for leftBound = math.floor(rect:GetLeft()/self.tileSize), rightBound do
		for topBound = math.floor(rect:GetTop()/self.tileSize), bottomBound do
			for k, v in ipairs(self.TriggerPointsList) do
				if v.x == leftBound and v.y == topBound then
					return true
				end
			end
		end
	end
	return false
end

function EntityBase:GetRect()
	return Rect(self.pos.x, self.pos.y, self.sprite:getWidth(), self.sprite:getHeight())
end

function EntityBase:Update(world, player)
	return
end

function EntityBase:Draw()
	love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
end

function EntityBase:DrawForEditor()
	love.graphics.draw(self.startSprite, self.startTilePos.x * self.tileSize, self.startTilePos.y * self.tileSize)
end