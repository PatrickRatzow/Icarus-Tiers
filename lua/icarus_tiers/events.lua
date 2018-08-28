local TEMPLATE = {}
TEMPLATE.requirements = function()
  return true
end
TEMPLATE.config = {}

AccessorFunc(TEMPLATE, "m_name", "Name", FORCE_STRING)
AccessorFunc(TEMPLATE, "m_enabled", "Enabled", FORCE_BOOL)
AccessorFunc(TEMPLATE, "m_desc", "Description", FORCE_STRING)
AccessorFunc(TEMPLATE, "m_progressMessage", "ProgressMessage", FORCE_STRING)
AccessorFunc(TEMPLATE, "m_icon", "Icon")

function TEMPLATE:SetReward(reward)
  self.reward = reward
end

function TEMPLATE:GetReward(...)
  if (type(self.reward) == "function") then
    return self.reward(...)
  end

  return self.reward
end

function TEMPLATE:AddHook(name, func)
  hook.Add(name, "Icarus.tiers.events." .. self:GetName(), function(...)
    if (self:GetEnabled() and self:GetRequirements(...)) then
      func(...)
    end
  end)
end

function TEMPLATE:SetupPlayer(ply)
  Icarus.tiers.player:setupTables(ply)
  Icarus.tiers.player:setupTier(ply, ply:Team())
end

function TEMPLATE:Network(ply)
  Icarus.tiers.player:network(ply)
end

function TEMPLATE:SetRequirements(func)
  self.requirements = func
end

function TEMPLATE:GetRequirements(...)
  return self.requirements(...)
end

function TEMPLATE:SetConfig(tbl)
  self.config = tbl
end

function TEMPLATE:GetConfig()
  return self.config
end

function TEMPLATE:IsMaxLevel(ply)
  if (!Icarus.tiers.player:tiersExists(ply)) then return true end

  local team = ply:Team()
  local level = Icarus.tiers.api:getTier(ply, team).level or 1
  local maxLevel = Icarus.tiers.player:getMaxTier(team) or 1

  return tonumber(level) > tonumber(maxLevel)
end

function TEMPLATE:OnComplete(ply, ...)
  self:SetupPlayer(ply)

  if self:IsMaxLevel(ply) then return end

  Icarus.tiers.player:addProgress(ply, ply:Team(), self:GetReward(...))

  self:Message(ply, ...)
  self:Network(ply)
end

function TEMPLATE:Message(ply, ...)
  DarkRP.notify(ply, 0, 4, "You got " .. self:GetReward(...) .. " tier progress for " .. self:GetProgressMessage())
end

function TEMPLATE:Register()
  Icarus.tiers.events[self:GetName()] = self
end

function Icarus.tiers:GetEventTemplate()
  return table.Copy(TEMPLATE)
end
