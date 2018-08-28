hook.Add("HUDPaint", "Icarus.tiers.NetHUD", function()
  timer.Simple(3, function()
    net.Start("Icarus.tiers.requestSelfData")
    net.SendToServer()
  end)

  hook.Remove("HUDPaint", "Icarus.tiers.NetHUD")
end)

net.Receive("Icarus.tiers.playerData", function(len)
  local ply = net.ReadEntity()
  local tbl = net.ReadTable()

  ply.Icarus = ply.Icarus or {}
  if (!istable(ply.Icarus)) then ply.Icarus = {}end
  ply.Icarus.tiers = {}

  for i, v in pairs(tbl) do
    ply.Icarus.tiers[tonumber(v.teamId)] = {
      level = tonumber(v.tier) or tonumber(tbl.level) or 1,
      progress = tonumber(v.progress) or 0
    }
  end
end)

net.Receive("Icarus.tiers.networkTierStatus", function(len)
  local ply = net.ReadEntity()
  local teamId = net.ReadUInt(16)
  local tbl = net.ReadTable()


  if (teamId == 0) then return end

  ply.Icarus = ply.Icarus or {}
  if (!istable(ply.Icarus)) then ply.Icarus = {}end
  ply.Icarus.tiers = ply.Icarus.tiers or {}

  ply.Icarus.tiers[tonumber(teamId)] = {
    progress = tonumber(tbl.progress) or 0,
    level = tonumber(tbl.tier) or tonumber(tbl.level) or 1
  }
end)

net.Receive("Icarus.tiers.menu", function(len)
  LocalPlayer():ConCommand("icarus_tiers")
end)

net.Receive("Icarus.tiers.networkTierBans", function(len)
  local ply = LocalPlayer()
  local teamId = net.ReadUInt(16)
  local tiers = net.ReadTable()

  Icarus.tiers.player:banTiers(ply, teamId, tiers)
end)
