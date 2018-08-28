local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("Crafting")
EVENT:SetDescription("Gain XP for crafting an item")
EVENT:SetProgressMessage("crafting something")
EVENT:SetReward(5)

EVENT:AddHook("Icarus.craft.finishedCrafting", function(ply)
  EVENT:OnComplete(ply)
end)

EVENT:Register()
