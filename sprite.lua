Sprite = Class()

function Sprite:init(sprite, x, y)
	self.pos = Vector(x, y)
	self.sprite = love.graphics.newImage("img/" .. sprite)
end

function Sprite:GetX()
	return self.pos.x
end

function Sprite:GetY()
	return self.pos.y
end

function Sprite:GetRect()
	return Rect(self.pos.x, self.pos.y, self.sprite:getWidth(), self.sprite:getHeight())
end

function Sprite:MoveBy(x, y)
	self.pos.x = self.pos.x + x
	self.pos.y = self.pos.y + y
end

function Sprite:MoveTo(x, y)
	self.pos.x = x
	self.pos.y = y
end

function Sprite:Draw()
	love.graphics.draw(self.sprite, self.pos.x, self.pos.y)
end

