WorldEditor = Class()

function WorldEditor:init(world)
	self.width = world.width
	self.height = world.height
	self.blockSize = world.blockSize
   self.brushMode = "None"
   self.blockType = "Solid"
   self.EditorTop = 720
   self.blockPicker = BlockPicker(self.EditorTop, self.blockSize, 20, 2, world:GetSpriteList())
   self.PlayButton = Button("playButton.png", 1235, self.EditorTop + 15)

   self.SolidButton = Button("solidButton.png", 1180, self.EditorTop+ 5)
   self.IllusionButton = Button("illusionButton.png", 1140, self.EditorTop + 5)
   self.BackgroundButton = Button("bgButton.png", 1100, self.EditorTop + 5)
end

function WorldEditor:Draw(world)
   self:DrawWorld(world)
   self:DrawCursorSelect()
   self:DrawBottomBar()
   self:DrawBottomBarBlockMode()
end

function WorldEditor:DrawWorld(world)
   love.graphics.setColor(255, 255, 255, 255)
   world:Draw("Background")
   if self.blockType == "Solid" then
      world:Draw("Solid")
      love.graphics.setColor(255, 255, 255, 100)
      world:Draw("Illusion")
   elseif self.blockType == "Illusion" then
      world:Draw("Illusion")
      love.graphics.setColor(255, 255, 255, 100)
      world:Draw("Solid")
   end
   love.graphics.setColor(255, 255, 255, 255)
end

function WorldEditor:DrawCursorSelect()
   if (love.mouse.getY() < self.EditorTop) then
      love.graphics.setColor(255, 255, 255, 100)
      love.graphics.rectangle("line", math.floor(love.mouse.getX()/self.blockSize)*self.blockSize, math.floor(love.mouse.getY()/self.blockSize)*self.blockSize, self.blockSize, self.blockSize)
   end
end

function WorldEditor:DrawBottomBar()
   love.graphics.setColor(0, 0, 0, 255)
   love.graphics.rectangle("fill", 0, self.EditorTop, 1280, 60)
   love.graphics.setColor(255, 255, 255, 255)

   self.PlayButton:Draw()
   self.BackgroundButton:Draw()

   self.SolidButton:Draw()
   if self.blockType == "Solid" then
      love.graphics.setColor(0, 0, 255, 100)
      love.graphics.rectangle("fill", self.SolidButton.pos.x-1, self.SolidButton.pos.y-1, 32, 52)
      love.graphics.setColor(255, 255, 255, 255)
   end

   self.IllusionButton:Draw()
   if self.blockType == "Illusion" then
      love.graphics.setColor(0, 0, 255, 100)
      love.graphics.rectangle("fill", self.IllusionButton.pos.x-1, self.IllusionButton.pos.y-1, 32, 52)
      love.graphics.setColor(255, 255, 255, 255)
   end

end

function WorldEditor:DrawBottomBarBlockMode()
   self.blockPicker:Draw()
end

function WorldEditor:Update(world)
   x = math.floor(love.mouse.getX()/self.blockSize)
   y = math.floor(love.mouse.getY()/self.blockSize)
   if (love.mouse.getY() < self.EditorTop) then
      if self.blockType == "Solid" then
            if (self.brushMode == "Place") then
               world:SetSolidBlockID(x, y, self.blockPicker:GetBlockID())
            elseif (self.brushMode == "Remove") then
               world:SetSolidBlockID(x, y, 0)
            end
      elseif self.blockType == "Illusion" then
         if (self.brushMode == "Place") then
            world:SetIllusionBlockID(x, y, self.blockPicker:GetBlockID())
         elseif (self.brushMode == "Remove") then
            world:SetIllusionBlockID(x, y, 0)
         end
      end
   end
end

function WorldEditor:MousePressedEvent(world, x, y, button)
   if (y < self.EditorTop) then
      x = math.floor(x/self.blockSize)
      y = math.floor(y/self.blockSize)

      if self.blockType == "Solid" then
         if (world:GetSolidBlockID(x, y) ~= 0) then
            self.brushMode = "Remove"
         else
            self.brushMode = "Place"
         end
      elseif self.blockType == "Illusion" then
         if (world:GetIllusionBlockID(x, y) ~= 0) then
            self.brushMode = "Remove"
         else
            self.brushMode = "Place"
         end
      end
   end
end

function WorldEditor:MouseReleasedEvent(world, x, y, button)
   self.brushMode = "None"

   if (y > self.EditorTop) then
      self.blockPicker:MousePressedEvent(world, x, y, button)

      if self.BackgroundButton:CheckIfPressed(x, y) then
         world:ChangeBG()
      elseif self.PlayButton:CheckIfPressed(x, y) then
         world:SaveToFile(world:GetLevelLocation())
         world:Reload()
         gameState = "play"
      elseif self.SolidButton:CheckIfPressed(x, y) then
         self.blockType = "Solid" 
      elseif self.IllusionButton:CheckIfPressed(x, y) then
         self.blockType = "Illusion" 
      end
   end
end