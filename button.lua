Button = Class()

function Button:init(sprite, x, y, size)
	self.pos = Vector(x, y)
	if type(sprite) == "string" then
		self.sprite = love.graphics.newImage("img/" .. sprite)
	else
		self.sprite = sprite
	end
	if type(size) == "number" then
		self.size = size
	end
end

function Button:GetRect()
	if type(self.size) == "number" then
		return Rect(self.pos.x, self.pos.y, self.size, self.size)
	else
		return Rect(self.pos.x, self.pos.y, self.sprite:getWidth(), self.sprite:getHeight())
	end
end

function Button:CheckIfPressed(x, y)
	if self:GetRect():Contains(x, y) then
		return true
	end
	return false
end

function Button:Draw()
	if self.size ~= nil then
		love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0, self.size/self.sprite:getWidth())
	else
		love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
	end
end

