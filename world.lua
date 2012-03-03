World = Class()

function World:init(width, height, blockSize)
	self.width = width
	self.height = height
	self.blockSize = blockSize
	self.spriteList = SpriteList()
	self.bgList = BGList()
	self.level = ""
   	self.backgroundID = 1

	levelList = LevelList()
	self.currentLevel = 1

	self:Clear()
end

function World:GetLevelLocation()
	return levelList:GetLevelLocationFromID(self.currentLevel)
end

function World:IsNextLevel()
	return levelList:ContainsID(self.currentLevel + 1)
end

function World:IsPrevLevel()
	return levelList:ContainsID(self.currentLevel - 1)
end

function World:LoadNextLevel()
	self.currentLevel = self.currentLevel + 1
    self:LoadFromFile(levelList:GetLevelLocationFromID(self.currentLevel))
end

function World:LoadPrevLevel()
	self.currentLevel = self.currentLevel - 1
    self:LoadFromFile(levelList:GetLevelLocationFromID(self.currentLevel))
end

function World:GetBGList()
	return self.bgList
end

function World:ChangeBG()
	if self.bgList:ContainsID(self.backgroundID + 1) then
		self.backgroundID = self.backgroundID + 1
	else
   		self.backgroundID = 1
	end
end

function World:GetSpriteList()
	return self.spriteList
end

function World:GetSolidBlockID(x, y)
	return self.solidBlockMap[x][y]
end

function World:SetSolidBlockID(x, y, id)
	self.solidBlockMap[x][y] = id
end

function World:GetIllusionBlockID(x, y)
	return self.illusionBlockMap[x][y]
end

function World:SetIllusionBlockID(x, y, id)
	self.illusionBlockMap[x][y] = id
end

function World:IsTouchingSolid(rect)
	rightBound = math.floor(rect:GetRight()/self.blockSize)
	bottomBound = math.floor(rect:GetBottom()/self.blockSize)

	if (rightBound > self.width or rect:GetLeft() < 0 or rect:GetBottom()/self.blockSize > self.height) then
		return true
	end

	for leftBound = math.floor(rect:GetLeft()/self.blockSize), rightBound do
		for topBound = math.floor(rect:GetTop()/self.blockSize), bottomBound do
			if self:GetSolidBlockID(leftBound, topBound) ~= 0 then
				return true
			end
		end
	end
	return false
end

function World:Clear()
	self.solidBlockMap = {}
	self.illusionBlockMap = {}
	for i=0, self.width do
    	self.solidBlockMap[i] = {}
    	self.illusionBlockMap[i] = {}
    	for z=0, self.height do
        	self.solidBlockMap[i][z] = 0
        	self.illusionBlockMap[i][z] = 0
	    end
	end
end

function World:LoadFromFile(fileLocation)

	file = love.filesystem.newFile(fileLocation)
	file:open('r')
	fileData = file:read()
	file:close()

	if (fileData ~= nil and string.len(fileData) > 10) then
		decodedTable = json.decode(fileData)

		self.backgroundID = decodedTable['Level']['Background']

		for x=0, self.width do
    		for y=0, self.height do
    			if (decodedTable['Level']['SolidBlockMap'][tostring(x)][y] ~= nil) then
    				self.solidBlockMap[x][y] = decodedTable['Level']['SolidBlockMap'][tostring(x)][y]
    			end
    			if (decodedTable['Level']['IllusionBlockMap'][tostring(x)][y] ~= nil) then
    				self.illusionBlockMap[x][y] = decodedTable['Level']['IllusionBlockMap'][tostring(x)][y]
    			end
    		end
    	end
	else
		self:Clear()
	end
end

function World:Reload()
	self:LoadFromFile(self:GetLevelLocation(self.level))
end

function World:SaveToFile(fileLocation)

	tempSolidBlockMap = {}
	tempIllusionBlockMap = {}

	for i=0, self.width do
		tempSolidBlockMap[i] = {}
		tempIllusionBlockMap[i] = {}
	end

	for x=0, self.width do
    	for y=1, self.height do
    		table.insert(tempSolidBlockMap[x], self.solidBlockMap[x][y])
    		table.insert(tempIllusionBlockMap[x], self.illusionBlockMap[x][y])
    	end
    end


	jsonTable = {}
	jsonTable['Level'] = {}
	jsonTable['Level']['Background'] = self.backgroundID
	jsonTable['Level']['SolidBlockMap'] = tempSolidBlockMap
	jsonTable['Level']['IllusionBlockMap'] = tempIllusionBlockMap
	encodedTable = json.encode(jsonTable)

	file = love.filesystem.newFile(fileLocation)
	file:open('w')
	file:write(encodedTable)
	file:close()
end

function World:Draw(onlyDraw)
	if onlyDraw == nil or onlyDraw == "Background" then
   		love.graphics.draw(self.bgList:GetBackgroundFromID(self.backgroundID), 0, 0)
   	end
   	if onlyDraw ~= "Background" then
		for x = 0, self.width do
			for y = 0, self.height do
				if onlyDraw == nil or onlyDraw == "Solid" then
					if self:GetSolidBlockID(x, y) ~= 0 then
						love.graphics.draw(self.spriteList:GetSpriteFromID(self:GetSolidBlockID(x, y)), x * self.blockSize, y * self.blockSize, 0, (self.blockSize / self.spriteList:GetSpriteFromID(self:GetSolidBlockID(x, y)):getWidth()))
					end
				end
				if onlyDraw == nil or onlyDraw == "Illusion" then
					if self:GetIllusionBlockID(x, y) ~= 0 then
						love.graphics.draw(self.spriteList:GetSpriteFromID(self:GetIllusionBlockID(x, y)), x * self.blockSize, y * self.blockSize, 0, (self.blockSize / self.spriteList:GetSpriteFromID(self:GetIllusionBlockID(x, y)):getWidth()))
					end
				end
			end
		end
	end
end