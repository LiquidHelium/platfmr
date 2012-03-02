require("class")
require("vector")
require("functions")
require("rect")
require("sprite")
require("world")
require("worldeditor")
require("button")
require("player")
require("gameplaymanager")
require("spritelist")
require("blockpicker")

function love.load()
   love.graphics.setBackgroundColor(55, 55, 55)
   world = World(79, 45, 16)
   world:LoadFromFile("lvl.txt")
   gameplayManager = GameplayManager(world)
   worldEditor = WorldEditor(world)
   gameState = "play"
end

function love.update(dt)
   if gameState == "play" then
      gameplayManager:Update(world)
   elseif gameState == "edit" then
      worldEditor:Update(world)
   end
end

function love.draw()
   
   if gameState == "play" then
      gameplayManager:Draw(world)
   elseif gameState == "edit" then
      worldEditor:Draw(world)
   end
end

function love.mousepressed(x, y, button)
   if gameState == "play" then
      gameplayManager:MousePressedEvent(world, x, y, button)
   elseif gameState == "edit" then
      worldEditor:MousePressedEvent(world, x, y, button)
   end
end

function love.mousereleased(x, y, button)
   if gameState == "play" then
      gameplayManager:MouseReleasedEvent(world, x, y, button)
   elseif gameState == "edit" then
      worldEditor:MouseReleasedEvent(world, x, y, button)
   end
end