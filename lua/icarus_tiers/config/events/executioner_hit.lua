local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("Hitman")
EVENT:SetDescription("Gain XP for completing a hit")
EVENT:SetProgressMessage("completing a hit")
EVENT:SetReward(10)

EVENT:AddHook("Executioner.OnHitCompleted", function(data, victim, ply)
  EVENT:OnComplete(ply)
end)

EVENT:Register()
