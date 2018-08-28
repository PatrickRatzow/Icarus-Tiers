hook.Add("PlayerSpawn", "Icarus.tiers.hooks.PlayerSpawn", function(ply)
  Icarus.tiers.player:setupTables(ply)

  local job = ply:Team()
  local tbl = Icarus.tiers.config.tiers[job]

  if (tbl and ply.Icarus.tiers[job]) then
    local tierTbl = Icarus.tiers.player:getTier(ply, job)
    tbl = tbl[tierTbl.level]

    if tbl.onSpawn then
      tbl.onSpawn(ply)
    end

    if tbl.models then
      if istable(tbl.models) then
        local rnd = table.Random(tbl.models)

        ply:SetModel(rnd)
      else
        ply:SetModel(tbl.models)
      end
    end
  end
end)

hook.Add("PlayerDeath", "Icarus.tiers.hooks.PlayerDeaeth", function(victim, inflictor, attacker)
  Icarus.tiers.player:setupTables(victim)

  local job = victim:Team()
  local tbl = Icarus.tiers.config.tiers[job]

  if (tbl and victim.Icarus.tiers[job]) then
    local tierTbl = Icarus.tiers.player:getTier(victim, job)
    tbl = tbl[tierTbl.level]

    if tbl.onDeath then
      tbl.onDeath(victim, inflictor, attacker)
    end
  end
end)

hook.Add("PlayerLoadout", "Icarus.tiers.hooks.PlayerLoadout", function(ply)
  local job = ply:Team()
  local tbl = Icarus.tiers.config.tiers[job]

  if (tbl and ply.Icarus.tiers[job]) then
    local tierTbl = Icarus.tiers.player:getTier(ply, job)
    tbl = tbl[tierTbl.level]

    if tbl.weapons then for i, v in pairs(tbl.weapons) do
        ply:Give(i)
      end
    end

    if tbl.onLoadout then
      tbl.onLoadout(ply)
    end

    if tbl.health then
      ply:SetHealth(tbl.health)
    end

    if tbl.armor then
      ply:SetArmor(tbl.armor)
    end
  end
end)

hook.Add("PlayerSetModel", "Icarus.tiers.hooks.PlayerSetModel", function(ply)
  local job = ply:Team()
  local tbl = Icarus.tiers.config.tiers[job]

  if (tbl and ply.Icarus.tiers[job]) then
    local tierTbl = Icarus.tiers.player:getTier(ply, job)
    tbl = tbl[tierTbl.level]

    if tbl.models then
      local mdl = tbl.models
      if istable(tbl.models) then
        mdl = table.Random(tbl.models)
      end

      timer.Simple(1, function()
        if (!IsValid(ply)) then return end

        ply:SetModel(mdl)
      end)
    end
  end
end)

hook.Add("PlayerInitialSpawn", "Icarus.tiers.hooks.PlayerInitialSpawn", function(ply)
  local job = ply:Team()

  Icarus.tiers.player:setupTables(ply)
  Icarus.tiers.player:setupTier(ply, job)
  Icarus.tiers.player:network(ply)
end)

hook.Add("playerGetSalary", "Icarus.tiers.hooks.playerGetSalary", function(ply, amount)
  local job = ply:Team()
  local tbl = Icarus.tiers.config.tiers[job]

  if (tbl and ply.Icarus.tiers[job]) then
    local tierTbl = Icarus.tiers.player:getTier(ply, job)
    tbl = tbl[tierTbl.level]

    if tbl.salary then
      ply:addMoney(tbl.salary)

      DarkRP.notify(ply, 0, 4, "Your job tier gave you a salary bonus of " .. DarkRP.formatMoney(tbl.salary) .. "!")
    end
  end
end)
