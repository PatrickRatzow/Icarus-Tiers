concommand.Add("icarus_tiers_database_migration", function()
  Icarus.tiers.database:migrateToV2()
end)

local function findTeamId(name)
  local teamId

  for i, v in pairs(RPExtraTeams) do
    if (v.name:lower() != name:lower()) then continue end

    teamId = i

    break
  end

  return teamId
end


concommand.Add("icarus_tiers_set_tier", function(caller, cmd, args)
  local sid64 = tostring(args[1])
  local team = findTeamId(tostring(args[2]))
  local tier = tonumber(args[3])

  Icarus.tiers.database:saveTeam(sid64, team, tier, 0)

  local ply = player.GetBySteamID64(sid64)

  if ply then
    Icarus.tiers.player:setTier(ply, team, tier, 0)
    Icarus.tiers.player:network(ply)
  end
end)

local str = "!tiers"
hook.Add("PlayerSay", "Icarus.tiers.PlayerSay", function(ply, text)
  if (text:sub(1, str:len()) == str) then
    net.Start("Icarus.tiers.menu")
    net.Send(ply)
  end
end)
