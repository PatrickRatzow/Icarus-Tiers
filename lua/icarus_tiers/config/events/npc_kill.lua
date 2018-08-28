local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("NPC Kill")
EVENT:SetDescription("Kill an NPC")
EVENT:SetProgressMessage("killing an NPC")
EVENT:SetConfig({
  defaultXP = 3,
  npcs = {
    ["npc_zombie"] = 5,
    ["npc_crow"] = 10
  }
})
EVENT:SetReward(function(npc)
  if (!npc) then return EVENT.config.defaultXP end

  local npcClass = npc:GetClass()

  if EVENT.config.npcs[npcClass] then
    return EVENT.config.npcs[npcClass]
  else
    return EVENT.config.defaultXP
  end
end)

EVENT:SetRequirements(function(npc, attacker, inflictor)
  return IsValid(attacker) and type(attacker) == "Player"
end)

EVENT:AddHook("OnNPCKilled", function(npc, attacker, inflictor)
  EVENT:OnComplete(attacker, npc)
end)

EVENT:Register()
