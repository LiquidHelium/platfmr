SpikeEntity = Class(EntityBase)

function SpikeEntity:Update(world, player)

	if self:IsPlayerTouchingTrigger(player:GetRect()) then
		self.active = true
	end

	if (self.active) then
		self.pos.y = self.pos.y + 4
	end

end