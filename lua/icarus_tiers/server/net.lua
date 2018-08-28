util.AddNetworkString("Icarus.tiers.requestSelfData")
util.AddNetworkString("Icarus.tiers.playerData")
util.AddNetworkString("Icarus.tiers.networkTierStatus")
util.AddNetworkString("Icarus.tiers.databaseMigration")
util.AddNetworkString("Icarus.tiers.menu")
util.AddNetworkString("Icarus.tiers.networkTierBans")

util.AddNetworkString("Icarus.tiers.admin.setTier")
util.AddNetworkString("Icarus.tiers.admin.setProgress")

net.Receive("Icarus.tiers.requestSelfData", function(len, ply)
  if ply.tiersHasClaimedSelfData then return end

  ply.Icarus = ply.Icarus or {}
  ply.Icarus.tiers = ply.Icarus.tiers or {}

  Icarus.tiers.database:getPlayer(ply, function(result)
    for i, v in pairs(result) do
      ply.Icarus.tiers[tonumber(v.teamId)] = {
        level = tonumber(v.tier),
        progress = tonumber(v.progress)
      }
    end

    net.Start("Icarus.tiers.playerData")
    net.WriteEntity(ply)
    net.WriteTable(result)
    net.Broadcast()

    ply.tiersHasClaimedSelfData = true
  end)
end)

net.Receive("Icarus.tiers.databaseMigration", function(len, ply)
  if (!Icarus.libs.isConfigAdmin(ply)) then return end

  Icarus.tiers.database:migrateToV2()
end)


net.Receive("Icarus.tiers.admin.setTier", function(len, ply)
  if (!Icarus.tiers.IsAdmin(ply)) then return end

  local target = net.ReadEntity(ply)
  local teamId = net.ReadUInt(16)
  local tier = net.ReadUInt(32)

  Icarus.tiers.player:setTier(target, teamId, tier, 0)
  Icarus.tiers.player:network(target)
end)

net.Receive("Icarus.tiers.admin.setProgress", function(len, ply)
  if (!Icarus.tiers.IsAdmin(ply)) then return end

  local target = net.ReadEntity(ply)
  local teamId = net.ReadUInt(16)
  local progress = net.ReadUInt(32)

  local level = Icarus.tiers.player:getTier(ply, teamId).level or 1

  Icarus.tiers.player:setTier(target, teamId, level, progress)
  Icarus.tiers.player:network(target)
end)
