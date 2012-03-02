Rect = Class()

function Rect:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width - 1
	self.height = height - 1
end

function Rect:GetTop()
	return self.y
end

function Rect:GetLeft()
	return self.x
end

function Rect:GetRight()
	return self.x + self.width
end

function Rect:GetBottom()
	return self.y + self.height
end

function Rect:GetWidth()
	return self.width
end

function Rect:GetHeight()
	return self.height
end

function Rect:IsColliding(otherRect)
	return self:GetLeft() < otherRect:GetRight() and self:GetRight() > otherRect:GetLeft() and self:GetTop() < otherRect:GetBottom() and self:GetBottom() > otherRect:GetTop()
end

function Rect:Contains(x, y)
	return self:GetLeft() < x and self:GetRight() > x and self:GetTop() < y and self:GetBottom() > y
end