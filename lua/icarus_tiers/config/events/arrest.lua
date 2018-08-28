local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("Arrest")
EVENT:SetDescription("Gain XP for arresting someone")
EVENT:SetProgressMessage("arresting someone")
EVENT:SetReward(3)

EVENT:SetRequirements(function(crim, time, actor)
  return actor:isCP() and !crim:isCP()
end)

EVENT:AddHook("playerArrested", function(crim, time, actor)
  EVENT:OnComplete(ply)
end)

EVENT:Register()
