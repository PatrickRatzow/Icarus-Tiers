Icarus = Icarus or {}
Icarus.tiers = Icarus.tiers or {}
Icarus.tiers.events = {}
Icarus.tiers.config = Icarus.tiers.config or {}
Icarus.tiers.config.tiers = Icarus.tiers.config.tiers or {}
Icarus.tiers.config.tiersConfig = Icarus.tiers.config.tiersConfig or {}
Icarus.tiers.config.groups = Icarus.tiers.config.groups or {}
Icarus.tiers.config.hud = Icarus.tiers.config.hud or {}

Icarus.tiers.groups = {}

function Icarus.tiers.config:addTier(teamId, options)
  if (!teamId) then return end

  if (!self.tiers[teamId]) then
    self.tiers[teamId] = {}
  end

  assert(options ~= nil, "cannot destructure nil value")
  local level, progressRequired, name, weapons, health, armor, model, onSpawn, onDeath, onLoadout, customCheck, customCheckFailMsg, userGroups, salary = options.level, options.progressRequired, options.name, options.weapons, options.health, options.armor, options.model, options.onSpawn, options.onDeath, options.onLoadout, options.customCheck, options.customCheckFailMsg, options.userGroups, options.salary

  self.tiers[teamId][level] = {
    name = name,
    progressRequired = progressRequired,
    weapons = weapons
  }

  local tbl = self.tiers[teamId][level]

  tbl.onSpawn = onSpawn
  tbl.onDeath = onDeath
  tbl.onLoadout = onLoadout
  tbl.health = health
  tbl.armor = armor
  tbl.models = model
  tbl.userGroups = userGroups
  tbl.salary = salary
end

local dirPrefix = "icarus_tiers"

local shared = file.Find(tostring(dirPrefix) .. "/*.lua", "LUA")
local server = file.Find(tostring(dirPrefix) .. "/server/*.lua", "LUA")
local client = file.Find(tostring(dirPrefix) .. "/client/*.lua", "LUA")
local config = file.Find(tostring(dirPrefix) .. "/config/*.lua", "LUA")
local events = file.Find(tostring(dirPrefix) .. "/config/events/*.lua", "LUA")

if SERVER then
  local server = file.Find(tostring(dirPrefix) .. "/server/*.lua", "LUA")

  for i, v in pairs(shared) do
    AddCSLuaFile(tostring(dirPrefix) .. "/" .. tostring(v))
    include(tostring(dirPrefix) .. "/" .. tostring(v))
  end

  for i, v in pairs(server) do
    include(tostring(dirPrefix) .. "/server/" .. tostring(v))
  end

  for i, v in pairs(client) do
    AddCSLuaFile(tostring(dirPrefix) .. "/client/" .. tostring(v))
  end

  for i, v in pairs(config) do
    AddCSLuaFile(tostring(dirPrefix) .. "/config/" .. tostring(v))
    include(tostring(dirPrefix) .. "/config/" .. tostring(v))
  end

  for i, v in pairs(events) do
    AddCSLuaFile(tostring(dirPrefix) .. "/config/events/" .. tostring(v))
    include(tostring(dirPrefix) .. "/config/events/" .. tostring(v))
  end
end

if CLIENT then
  for i, v in pairs(shared) do
    include(tostring(dirPrefix) .. "/" .. tostring(v))
  end

  for i, v in pairs(client) do
    include(tostring(dirPrefix) .. "/client/" .. tostring(v))
  end

  for i, v in pairs(config) do
    include(tostring(dirPrefix) .. "/config/" .. tostring(v))
  end

  for i, v in pairs(events) do
    include(tostring(dirPrefix) .. "/config/events/" .. tostring(v))
  end
end

hook.Add("DarkRPFinishedLoading", "Icarus.tiers.FinishedLoading", function()
  timer.Simple(3, function()
    CompileFile("icarus_tiers/config/groups.lua")()
    CompileFile("icarus_tiers/config/jobs.lua")()
  end)
end)
