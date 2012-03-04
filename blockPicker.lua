BlockPicker = Class()

function BlockPicker:init(editorTop, size, width, height, spriteList)
	self.blockSize = size
	self.currentBlockID = 1
	self.amountOfBlocks = spriteList:GetAmountOfBlocks()
	self.tileButtons = {}
	self.editorTop = editorTop
	self.currentPage = 0
	self.width = width
	self.height = height
	self.leftArrowButton = Button("leftArrowButton.png", 20, self.editorTop + 10)
	self.rightArrowButton = Button("rightArrowButton.png", 70 + (self.width*(self.blockSize+3)), self.editorTop + 10)
	self:CreateButtons(self.currentPage, spriteList)
end

function BlockPicker:CreateButtons(page, spriteList)
	j = 1
	while j <= self:GetPageTotal() and spriteList:ContainsID(j + self:GetPageStart(self.currentPage)) do
		line = math.floor((j-1)/self.width)
		column = (j-1)%self.width
		table.insert(self.tileButtons, Button(spriteList:GetSpriteFromID(j + self:GetPageStart(self.currentPage)), 60 + column*(self.blockSize+3), self.editorTop + 10 + line*(self.blockSize+3), self.blockSize))
		j = j + 1
	end
end

function BlockPicker:RemoveButtons()
	self.tileButtons = {}
end

function BlockPicker:GetAmountOfPages()
	return math.ceil(self.amountOfBlocks / (self.width * self.height))
end

function BlockPicker:GetPageStart(page)
	return self.width * self.height * page
end

function BlockPicker:GetPageTotal()
	return self.width * self.height
end

function BlockPicker:GetBlockID()
	return self.currentBlockID + self:GetPageStart(self.currentPage)
end

function BlockPicker:DrawTileButtons()
	for i, v in ipairs(self.tileButtons) do
		v:Draw()
		if i == self.currentBlockID then
			love.graphics.rectangle("line", v.pos.x, v.pos.y, self.blockSize, self.blockSize)
		end
	end
end

function BlockPicker:Draw(x, y)
	self.leftArrowButton:Draw()
	self.rightArrowButton:Draw()
	self:DrawTileButtons()
end

function BlockPicker:DrawCursor(x, y, spriteList)
	love.graphics.draw(spriteList:GetSpriteFromID(self:GetBlockID()), x, y, 0, self.blockSize/spriteList:GetSpriteFromID(self:GetBlockID()):getWidth())
end


function BlockPicker:MousePressedEvent(world, x, y, button)
	if self.leftArrowButton:CheckIfPressed(x, y) and self.currentPage > 0 then
		self.currentPage = self.currentPage - 1
		self:RemoveButtons()
		self:CreateButtons(self.currentPage, world:GetSpriteList())
	elseif self.rightArrowButton:CheckIfPressed(x, y) and self.currentPage < self:GetAmountOfPages()-1 then
		self.currentPage = self.currentPage + 1
		self.currentBlockID = 1
		self:RemoveButtons()
		self:CreateButtons(self.currentPage, world:GetSpriteList())
	end

	for i, v in ipairs(self.tileButtons) do
		if (v:CheckIfPressed(x, y)) then
			self.currentBlockID = i
		end
	end	
end

function BlockPicker:MouseScrollCheck(world, button)
	if button == "wu" and self.currentBlockID < self:GetPageTotal() then
		if world.spriteList:ContainsID(self.currentBlockID + 1 + self:GetPageStart(self.currentPage)) then
			self.currentBlockID = self.currentBlockID + 1
		end
	elseif button == "wd" and self.currentBlockID > 1 then
		self.currentBlockID = self.currentBlockID - 1
	end
end