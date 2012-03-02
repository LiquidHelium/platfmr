LevelList = Class()

function LevelList:init()
	self.LevelDict = {}
	self:LoadLevels()
end

function LevelList:GetAmountOfLevels()
	return table.getn(self.LevelDict)
end

function LevelList:LoadLevels()
	self:AddLevel("lvl.txt")
	self:AddLevel("lvl2.txt")
end

function LevelList:AddLevelToID(id, levelLocation)
	table.insert(self.LevelDict, id, "lvl/" .. levelLocation)
end

function LevelList:AddLevel(levelLocation)
	table.insert(self.LevelDict, self:GetAmountOfLevels()+1, "lvl/" .. levelLocation)
end

function LevelList:GetLevelLocationFromID(id)
	return self.LevelDict[id]
end


function LevelList:ContainsID(id)
	if self.LevelDict[id] ~= nil then
		return true
	end
		return false
end