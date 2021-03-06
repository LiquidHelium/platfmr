WorldEditor = Class()

function WorldEditor:init(world)
	self.width = world.width
	self.height = world.height
	self.blockSize = world.blockSize
   self.brushMode = "None"
   self.blockType = "Solid"
   self.EditorTop = 720
   self.blockPicker = BlockPicker(self.EditorTop, self.blockSize, 20, 2, world:GetSpriteList())
   self.entityPicker = EntityPicker(self.EditorTop, self.blockSize, 20, 2, world:GetEntityList())
   self.PlayButton = Button("playButton.png", 1235, self.EditorTop + 15)

   self.selectedEntity = nil

   self.SolidButton = Button("solidButton.png", 1180, self.EditorTop+ 5)
   self.IllusionButton = Button("illusionButton.png", 1140, self.EditorTop + 5)
   self.BackgroundButton = Button("bgButton.png", 1100, self.EditorTop + 5)
   self.PlayerStartButton = Button("playerStartButton.png", 1060, self.EditorTop + 5)
   self.EntityButton = Button("entityButton.png", 1020, self.EditorTop + 5)
   self.TriggerButton = Button("triggerButton.png", 980, self.EditorTop + 5)
end

function WorldEditor:Draw(world)
   self:DrawWorld(world)
   self:DrawCursorSelect(world)
   self:DrawBottomBar()
   if (self.blockType == "Solid" or self.blockType == "Illusion") then
      self:DrawBottomBarBlockMode()
   elseif (self.blockType == "Entity") then
      self:DrawBottomBarEntityMode()
   end
end

function WorldEditor:DrawWorld(world)
   love.graphics.setColor(255, 255, 255, 255)
   world:Draw("Background")
   if self.blockType == "Solid" then
      world:Draw("Solid")
      love.graphics.setColor(255, 255, 255, 100)
      world:Draw("Illusion")
      world:Draw("Entity")
   elseif self.blockType == "Illusion" then
      world:Draw("Illusion")
      love.graphics.setColor(255, 255, 255, 100)
      world:Draw("Solid")
      world:Draw("Entity")
   elseif self.blockType == "PlayerStart" then
      world:Draw("Illusion")
      world:Draw("Solid")
      world:Draw("PlayerStart")
      world:Draw("Entity")
   elseif self.blockType == "Entity" then
      world:Draw("Entity")
      love.graphics.setColor(255, 255, 255, 100)
      world:Draw("Solid")
      world:Draw("Illusion")
   elseif self.blockType == "Trigger" then
      if self.selectedEntity == nil then
         world:Draw("Entity")
         love.graphics.setColor(255, 255, 255, 100)
      else
         world.entityContainer[self.selectedEntity]:DrawForEditor()
         love.graphics.setColor(0, 255, 0, 100)
         for k, v in ipairs(world.entityContainer[self.selectedEntity].TriggerPointsList) do
            love.graphics.rectangle("fill", v.x*self.blockSize, v.y*self.blockSize, self.blockSize, self.blockSize)
         end
         love.graphics.setColor(255, 255, 255, 100)
         world:Draw("Entity")
      end
      world:Draw("Solid")
      world:Draw("Illusion")
   end
   love.graphics.setColor(255, 255, 255, 255)
end

function WorldEditor:DrawCursorSelect(world)
   if love.mouse.getY() < self.EditorTop then

      if self.blockType == "Solid" or self.blockType == "Illusion" then
         love.graphics.setColor(255, 255, 255, 50)
         self.blockPicker:DrawCursor(math.floor(love.mouse.getX()/self.blockSize)*self.blockSize, math.floor(love.mouse.getY()/self.blockSize)*self.blockSize, world.spriteList)
      end
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

   self.PlayerStartButton:Draw()
   if self.blockType == "PlayerStart" then
      love.graphics.setColor(0, 0, 255, 100)
      love.graphics.rectangle("fill", self.PlayerStartButton.pos.x-1, self.PlayerStartButton.pos.y-1, 32, 52)
      love.graphics.setColor(255, 255, 255, 255)
   end

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

   self.EntityButton:Draw()
   if self.blockType == "Entity" then
      love.graphics.setColor(0, 0, 255, 100)
      love.graphics.rectangle("fill", self.EntityButton.pos.x-1, self.EntityButton.pos.y-1, 32, 52)
      love.graphics.setColor(255, 255, 255, 255)
   end

   self.TriggerButton:Draw()
   if self.blockType == "Trigger" then
      love.graphics.setColor(0, 0, 255, 100)
      love.graphics.rectangle("fill", self.TriggerButton.pos.x-1, self.TriggerButton.pos.y-1, 32, 52)
      love.graphics.setColor(255, 255, 255, 255)
   end

end

function WorldEditor:DrawBottomBarBlockMode()
   self.blockPicker:Draw()
end

function WorldEditor:DrawBottomBarEntityMode()
   self.entityPicker:Draw()
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

      if button == "l" then
         if self.blockType == "PlayerStart" then
            world.playerStartPos.x, world.playerStartPos.y = x, y
         elseif self.blockType == "Entity" then
            world:AddEntity(self.entityPicker:GetBlockID(), x, y)
         elseif self.blockType == "Trigger" then
            for k, entityObject in ipairs(world.entityContainer) do
               if entityObject.startTilePos.x == x and entityObject.startTilePos.y == y then 
                  self.selectedEntity = k
                  return
               end
            end
            if self.selectedEntity ~= nil then
               for k, v in ipairs(world.entityContainer[self.selectedEntity].TriggerPointsList) do
                  if v.x == x and v.y == y then
                     table.remove(world.entityContainer[self.selectedEntity].TriggerPointsList, k)
                     return
                  end
               end
               table.insert(world.entityContainer[self.selectedEntity].TriggerPointsList, Vector(x, y))
            end
         elseif self.blockType == "Solid" then
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
end

function WorldEditor:MouseReleasedEvent(world, gameplayManager, x, y, button)
   self.brushMode = "None"

   if button == "l" then
      if (y > self.EditorTop) then
         if self.blockType == "Solid" or self.blockType == "Illusion" then
            self.blockPicker:MousePressedEvent(world, x, y, button)
         end 
         if self.BackgroundButton:CheckIfPressed(x, y) then
            world:ChangeBG()
         elseif self.PlayButton:CheckIfPressed(x, y) then
            world:SaveToFile(world:GetLevelLocation())
            world:Reload()
            gameplayManager:Reload(world)
            gameState = "play"
         elseif self.SolidButton:CheckIfPressed(x, y) then
            self.blockType = "Solid" 
         elseif self.IllusionButton:CheckIfPressed(x, y) then
            self.blockType = "Illusion" 
         elseif self.PlayerStartButton:CheckIfPressed(x, y) then
            self.blockType = "PlayerStart" 
         elseif self.EntityButton:CheckIfPressed(x, y) then
            self.blockType = "Entity" 
         elseif self.TriggerButton:CheckIfPressed(x, y) then
            self.selectedEntity = nil
            self.blockType = "Trigger" 
         end
      end
   else
      self.blockPicker:MouseScrollCheck(world, button)
   end
end