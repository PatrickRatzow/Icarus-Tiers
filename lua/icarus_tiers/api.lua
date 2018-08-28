Icarus.tiers.api = {}

function Icarus.tiers.api:getJobName(ply, teamId)
  local tbl = Icarus.tiers.config.tiers

  if (!tbl[teamId]) then
    return false
  end

  local tierTbl = self:getTier(ply, teamId)

  if (!tbl[teamId][tierTbl.level]) then
    return false
  end

  local str = tbl[teamId][tierTbl.level].name

  if Icarus.tiers.config.showTierLevel then str = str .. " (tier " .. tierTbl.level .. ")"
  end

  return str
end

function Icarus.tiers.api:getTier(ply, teamId)
  return Icarus.tiers.player:getTier(ply, teamId)
end

function Icarus.tiers.api:getWeapons(ply, teamId)
  local tbl = Icarus.tiers.config.tiers

  if (!tbl[teamId]) then
    return false
  end

  local tierTbl = self:getTier(ply, teamId)

  if (!tbl[teamId][tierTbl.level]) then
    return false
  end

  return tbl[teamId][tierTbl.level].weapons
end

function Icarus.tiers.api:getModels(ply, teamId)
  local tbl = Icarus.tiers.config.tiers

  if (!tbl[teamId]) then
    return false
  end

  local tierTbl = self:getTier(ply, teamId)

  if (!tbl[teamId][tierTbl.level]) then
    return false
  end

  return tbl[teamId][tierTbl.level].models
end

function Icarus.tiers.api:getProgress(ply, teamId)
  local tbl = Icarus.tiers.config.tiers

  if (!tbl[teamId]) then
    return false
  end

  local tierTbl = self:getTier(ply, teamId)

  if (!tbl[teamId][tierTbl.level]) then
    return false
  end

  return Icarus.tiers.player:getProgress(ply, teamId)
end

function Icarus.tiers.api:isTier(ply, teamId, level)
  local tier = self:getTier(ply, teamId)

  if (!tier) then return false end

  return tier.level >= level
end

function Icarus.tiers.api:getMaxProgress(ply, teamId)
  local tbl = Icarus.tiers.config.tiers

  if (!tbl[teamId]) then
    return false
  end

  local tierTbl = self:getTier(ply, teamId)

  if (!tbl[teamId][tierTbl.level]) then
    return false
  end

  return Icarus.tiers.player:getMaxProgress(ply, teamId)
end
