Block = Class(Sprite)

function Block:init(sprite, x, y, tileSize)
	Sprite.init(self, sprite, x, y)
	self.scaleX = tileSize / self.sprite:GetWidth()
	self.scaleY = tileSize / self.sprite:GetHeight()
end

function Block:Draw()
	love.graphics.draw(self.sprite, self.pos.x, self.pos.y, 0, self.scaleX, self.scaleY)
end