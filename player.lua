Player = Class(Sprite)

function Player:init(sprite, x, y)
	Sprite.init(self, sprite, x, y)
	self.gravity = 0.4
	self.jumpSpeed = -0.3
	self.initialJumpSpeed = -5
	self.velocity = 0
	self.speed = 4
	self.terminalVelocity = 5
	self.jumpCharges = 2
	self.previousJumpState = false
end

function Player:Update(world)
	if love.keyboard.isDown("right") then
		self.pos.x = self.pos.x + self.speed
		if world:IsTouchingSolid(self:GetRect()) then
			while world:IsTouchingSolid(self:GetRect()) do
				self.pos.x = self.pos.x - 1
			end
		end
	end

	if love.keyboard.isDown("left") then
		self.pos.x = self.pos.x - self.speed
		if world:IsTouchingSolid(self:GetRect()) then
			while world:IsTouchingSolid(self:GetRect()) do
				self.pos.x = self.pos.x + 1
			end
		end
	end

	if love.keyboard.isDown("up") then
		if self.jumpCharges > 0 and self.previousJumpState == false then
			self.jumpCharges = self.jumpCharges - 1
			self.velocity = self.initialJumpSpeed
		else
			if self.velocity < 0 then
				self.velocity = self.velocity + self.jumpSpeed
			end
		end
		self.previousJumpState = true
	else
		self.previousJumpState = false
	end

	if self.jumpCharges == 2 and self.velocity ~= 0 then
		self.jumpCharges = 1
	end

	self.velocity = self.velocity + self.gravity
	--self.pos.y = self.pos.y + self.velocity
	if self.velocity > 0 then
		tempVelocity = self.velocity
		while tempVelocity > 0 and not world:IsTouchingSolid(self:GetRect()) do
			self.pos.y = self.pos.y + 1
			tempVelocity = tempVelocity - 1
		end
	else
		self.pos.y = self.pos.y + self.velocity
	end

	if world:IsTouchingSolid(self:GetRect()) then
		self.jumpCharges = 2
		self.pos.y = self.pos.y - 1
	end

	if self.velocity > self.terminalVelocity then
		self.velocity = self.terminalVelocity
	end

	if self.velocity < 0 then
		while world:IsTouchingSolid(self:GetRect()) do
			self.pos.y = self.pos.y + 1
			self.velocity = 0
		end
	end

	--if self.velocity > 0 then
	--	while world:IsTouchingSolid(self:GetRect()) do
	--		self.pos.y = self.pos.y - 1
	--		self.velocity = 0
	--		self.jumpCharges = 2
	--	end
	--end
end

function Player:Draw()
	Sprite.Draw(self)
	--leftBound = math.floor(self:GetRect():GetLeft()/16)*16
	--rightBound = math.ceil(self:GetRect():GetRight()/16)*16
	--bottomBound = math.ceil(self:GetRect():GetBottom()/16)*16
	--topBound = math.floor(self:GetRect():GetTop()/16)*16
    --love.graphics.setColor(0, 0, 255, 100)
   	--love.graphics.rectangle("fill", leftBound, topBound, rightBound - leftBound, bottomBound - topBound)
end