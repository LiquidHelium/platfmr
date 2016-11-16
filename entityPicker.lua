EntityPicker = Class()

function EntityPicker:init(editorTop, size, width, height, entityList)
	self.blockSize = size
	self.currentBlockID = 1
	self.amountOfBlocks = entityList:AmountOfEntitys()
	self.tileButtons = {}
	self.editorTop = editorTop
	self.currentPage = 0
	self.width = width
	self.height = height
	self.leftArrowButton = Button("leftArrowButton.png", 20, self.editorTop + 10)
	self.rightArrowButton = Button("rightArrowButton.png", 70 + (self.width*(self.blockSize+3)), self.editorTop + 10)
	self:CreateButtons(self.currentPage, entityList)
end

function EntityPicker:CreateButtons(page, entityList)
	j = 1
	while j <= self:GetPageTotal() and entityList:ContainsID(j + self:GetPageStart(self.currentPage)) do
		line = math.floor((j-1)/self.width)
		column = (j-1)%self.width
		table.insert(self.tileButtons, Button(entityList:GetEntityPeviewImage(j + self:GetPageStart(self.currentPage)), 60 + column*(self.blockSize+3), self.editorTop + 10 + line*(self.blockSize+3), self.blockSize))
		j = j + 1
	end
end

function EntityPicker:RemoveButtons()
	self.tileButtons = {}
end

function EntityPicker:GetAmountOfPages()
	return math.ceil(self.amountOfBlocks / (self.width * self.height))
end

function EntityPicker:GetPageStart(page)
	return self.width * self.height * page
end

function EntityPicker:GetPageTotal()
	return self.width * self.height
end

function EntityPicker:GetBlockID()
	return self.currentBlockID + self:GetPageStart(self.currentPage)
end

function EntityPicker:DrawTileButtons()
	for i, v in ipairs(self.tileButtons) do
		v:Draw()
		if i == self.currentBlockID then
			love.graphics.rectangle("line", v.pos.x, v.pos.y, self.blockSize, self.blockSize)
		end
	end
end

function EntityPicker:Draw(x, y)
	self.leftArrowButton:Draw()
	self.rightArrowButton:Draw()
	self:DrawTileButtons()
end

function EntityPicker:DrawCursor(x, y, entityList)
	love.graphics.draw(entityList:GetEntityPeviewImage(self:GetBlockID()), x, y, 0, self.blockSize/entityList:GetEntityPeviewImage(self:GetBlockID()):getWidth())
end


function EntityPicker:MousePressedEvent(world, x, y, button)
	if self.leftArrowButton:CheckIfPressed(x, y) and self.currentPage > 0 then
		self.currentPage = self.currentPage - 1
		self:RemoveButtons()
		self:CreateButtons(self.currentPage, world:GetEntityList())
	elseif self.rightArrowButton:CheckIfPressed(x, y) and self.currentPage < self:GetAmountOfPages()-1 then
		self.currentPage = self.currentPage + 1
		self.currentBlockID = 1
		self:RemoveButtons()
		self:CreateButtons(self.currentPage, world:GetEntityList())
	end

	for i, v in ipairs(self.tileButtons) do
		if (v:CheckIfPressed(x, y)) then
			self.currentBlockID = i
		end
	end	
end

function EntityPicker:MouseScrollCheck(world, button)
	if button == "wu" and self.currentBlockID < self:GetPageTotal() then
		if world.entityList:ContainsID(self.currentBlockID + 1 + self:GetPageStart(self.currentPage)) then
			self.currentBlockID = self.currentBlockID + 1
		end
	elseif button == "wd" and self.currentBlockID > 1 then
		self.currentBlockID = self.currentBlockID - 1
	end
end