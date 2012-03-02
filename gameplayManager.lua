GameplayManager = Class()

function GameplayManager:init(world)
	self.width = world.width
	self.height = world.height
	self.blockSize = world.blockSize
	self.EditorTop = 720
	self.EditButton = Button("editButton.png", 1235, 735)

	player = Player("player.png", 50, 50)
end

function GameplayManager:Update(world)
	player:Update(world)
end

function GameplayManager:Reload()
	player = Player("player.png", 50, 50)
end

function GameplayManager:Draw(world)
	self:DrawWorld(world)
    self:DrawObjects()
    self:DrawBottomBar()
    self:DrawBottomBarPlayMode()
end

function GameplayManager:DrawWorld(world)
   world:Draw()
end

function GameplayManager:DrawObjects()
   player:Draw()
end

function GameplayManager:DrawBottomBar()
   love.graphics.setColor(0, 0, 0, 255)
   love.graphics.rectangle("fill", 0, self.EditorTop, 1280, 60)
   love.graphics.setColor(255, 255, 255, 255)
end

function GameplayManager:DrawBottomBarPlayMode()
	self.EditButton:Draw()
   	love.graphics.print("FPS: " .. love.timer.getFPS(), 10, self.EditorTop + 10)
end


function GameplayManager:MousePressedEvent(world, x, y, button)
end

function GameplayManager:MouseReleasedEvent(world, x, y, button)
	if self.EditButton:CheckIfPressed(x, y) then
      	world:Reload()
      	self:Reload()
		gameState = "edit"
	end
end