World = Class()

function World:init(width, height, blockSize)
	self.width = width
	self.height = height
	self.blockSize = blockSize
	self.spriteList = SpriteList()
	self.level = ""
   	backgroundSprite = love.graphics.newImage("img/" .. "background.png")

	self.solidBlockMap = {}
	self.illusionBlockMap = {}
	for i=0, width do
    	self.solidBlockMap[i] = {}
    	self.illusionBlockMap[i] = {}
    	for z=0, height do
        	self.solidBlockMap[i][z] = 0
        	self.illusionBlockMap[i][z] = 0
	    end
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

function World:LoadFromFile(fileLocation)
	self.level = fileLocation 
	file = io.open("lvl.txt", "r")
	fileData = file:read("*all")
	file:close()
	blockType = "none"

	y = 0
	for i, line in pairs(split(fileData, "\n")) do
		x = 0
		if (string.find(line, "solid") ~= nil) then blockType = "solid"; y = -1; end
		if (string.find(line, "illusion") ~= nil) then blockType = "illusion"; y = -1; end

		for i, char in pairs(split(line, " ")) do
			if (char ~= "0") then
				if (blockType == "solid") then
					self:SetSolidBlockID(x, y, tonumber(char))
				elseif (blockType == "illusion") then
					self:SetIllusionBlockID(x, y, tonumber(char))
				end
			end
			x = x + 1
		end
		y = y + 1
	end
end

function World:Reload()
	self:LoadFromFile(self.level)
end

function World:SaveToFile(fileLocation)
	file = io.open("lvl.txt", "w")
	file:write("[solid] \n")
	for y = 0, self.height do
		lineString = ""
		for x = 0, self.width do
			lineString = lineString .. self:GetSolidBlockID(x, y) .. " "
		end
		file:write(lineString .. "\n")
	end
	file:write("[illusion] \n")
	for y = 0, self.height do
		lineString = ""
		for x = 0, self.width do
			lineString = lineString .. self:GetIllusionBlockID(x, y) .. " "
		end
		file:write(lineString .. "\n")
	end
	file:close()
end

function World:Draw(onlyDraw)
	if onlyDraw == nil or onlyDraw == "Background" then
   		love.graphics.draw(backgroundSprite, 0, 0)
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