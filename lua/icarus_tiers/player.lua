Icarus.tiers.player = {}

function Icarus.tiers.player:setupTables(ply)
  ply.Icarus = ply.Icarus or {}
  ply.Icarus.tiers = ply.Icarus.tiers or {}
  ply.Icarus.bannedTiers = ply.Icarus.bannedTiers or {}
end

function Icarus.tiers.player:getMaxTier(teamId)
  return math.max(#Icarus.tiers.config.tiers[teamId], 1)
end

function Icarus.tiers.player:getTier(ply, teamId)
  self:setupTier(ply, teamId)

  return ply.Icarus.tiers[teamId] or {
    level = 1,
    progress = 0
  }
end

function Icarus.tiers.player:getProgress(ply, teamId)
  if (!ply.Icarus.tiers[teamId]) then
    return 0
  end

  return ply.Icarus.tiers[teamId].progress or 0
end

function Icarus.tiers.player:getMaxProgress(ply, teamId)
  if (!ply.Icarus.tiers[teamId]) then
    return 0
  end

  local level = ply.Icarus.tiers[teamId].level

  if (!Icarus.tiers.config.tiers[teamId][level]) then
    return 0
  end

  return Icarus.tiers.config.tiers[teamId][level].progressRequired
end

function Icarus.tiers.player:addProgress(ply, teamId, amt)

  if (!ply.tiersHasClaimedSelfData) then return end

  self:setupTables(ply)
  self:setupTier(ply, teamId)

  if (!ply.Icarus.tiers[teamId]) then return end

  ply.Icarus.tiers[teamId].progress = ply.Icarus.tiers[teamId].progress + amt

  local progress = self:getProgress(ply, teamId)

  local tierTbl = Icarus.tiers.config.tiers[teamId][1]

  if (progress >= tierTbl.progressRequired) then
    self:addTier(ply, teamId)
  end

  local tbl = self:getTier(ply, teamId)

  Icarus.tiers.database:saveTeam(ply, teamId, tbl.level, tbl.progress)
end

function Icarus.tiers.player:setupTier(ply, teamId)
  self:setupTables(ply)

  local tierTbl = Icarus.tiers.config.tiers[teamId]

  if tierTbl then
    if (!ply.Icarus.tiers[teamId]) then
      ply.Icarus.tiers[teamId] = {
        level = 1,
        progress = 0
      }
    end
  end
end

function Icarus.tiers.player:setTier(ply, teamId, level, progress)
  self:setupTables(ply)
  self:setupTier(ply, teamId)

  ply.Icarus.tiers[teamId] = {
    level = level,
    progress = progress
  }
end

function Icarus.tiers.player:addTier(ply, teamId, increase)
  if increase == nil then increase = 1
  end
  self:setupTables(ply)

  local exists = ply.Icarus.tiers[teamId]
  local maxTier = self:getMaxTier(teamId)

  if (!exists) then
    ply.Icarus.tiers[teamId] = {
      level = 1,
      progress = 0
    }

    return
  end

  if (ply.Icarus.tiers[teamId].level >= maxTier and increase > 0) then return end

  ply.Icarus.tiers[teamId].progress = ply.Icarus.tiers[teamId].progress - Icarus.tiers.config.tiers[teamId][self:getTier(ply, teamId).level].progressRequired
  ply.Icarus.tiers[teamId].level = ply.Icarus.tiers[teamId].level + 1
end

function Icarus.tiers.player:tiersExists(ply)
  self:setupTier(ply, ply:Team())

  return ply.Icarus.tiers[ply:Team()]
end

function Icarus.tiers.player:banTiers(ply, teamId, tiers)
  self:setupTables(ply)

  if (!istable(tiers)) then
    tiers = {
      tiers}
  end

  ply.Icarus.bannedTiers[teamId] = unpack(tiers)
end

function Icarus.tiers.player:getBannedTiers(ply, teamId)
  return ply.Icarus.bannedTiers[teamId] or {}
end

if SERVER then
  function Icarus.tiers.player:network(ply)
    local teamId = ply:Team()
    self:setupTier(ply, teamId)

    if (!ply.Icarus.tiers[teamId]) then return end

    local tbl = self:getTier(ply, teamId)

    net.Start("Icarus.tiers.networkTierStatus")
    net.WriteEntity(ply)
    net.WriteUInt(teamId, 16)
    net.WriteTable(tbl)
    net.Broadcast()
  end

  function Icarus.tiers.player:networkTiers(ply, teamId)
    local tiers = Icarus.tiers.player:getBannedTiers(ply, teamId)

    net.Start("Icarus.tiers.networkTierBans")
    net.WriteUInt(teamId, 16)
    net.WriteTable(tiers)
    net.Send(ply)
  end
end

hook.Add("OnPlayerChangedTeam", "Icarus.tiers.player.OnPlayerChangedTeam", function(ply, prevJob, newJob)
  Icarus.tiers.player:setupTables(ply)
  Icarus.tiers.player:setupTier(ply, newJob)
end)
