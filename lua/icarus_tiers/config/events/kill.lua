local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("Kill")
EVENT:SetDescription("Kill someone")
EVENT:SetProgressMessage("killing someone")
EVENT:SetReward(5)

EVENT:SetRequirements(function(victim, inflicator, attacker)
  return victim != attacker and IsValid(attacker) and type(attacker) == "Player"
end)

EVENT:AddHook("PlayerDeath", function(victim, inflicator, attacker)
  EVENT:OnComplete(attacker)
end)

EVENT:Register()
