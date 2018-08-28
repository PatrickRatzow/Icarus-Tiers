Icarus.tiers.database = {}

local conn = IMySQLite

function Icarus.tiers.database:setup()
  conn.query([[
    CREATE TABLE IF NOT EXISTS icarus_tiers_player_2 (
      sid64 BIGINT(21) NOT NULL,
      teamId INT NOT NULL,
      tier INT NOT NULL,
      progress INT NOT NULL
    )
  ]])

  conn.query([[
    CREATE TABLE IF NOT EXISTS icarus_tiers_bans (
      sid64 BIGINT(21) NOT NULL,
      teamId INT NOT NULL,
      tier INT NOT NULL
    )
  ]])
end

timer.Create("Icarus.tiers.database.init", 0.1, 0, function()
  if (Icarus and Icarus.databaseLoaded) then
    timer.Remove("Icarus.tiers.database.init")

    Icarus.tiers.database:setup()
  end
end)

local function findSteamID64(input)
  if (type(input) == "string" and input) then
    return input
  elseif (type(input) == "Player") then
    return input:SteamID64()
  end
end

function Icarus.tiers.database:banPlayerFromTier(ply, teamId, tiers, expires, callback)
  if callback == nil then callback = function() end
  end
  local sid64 = findSteamID64(ply)

  if (!sid64) then
    callback(false)

    return
  end

  local tbl = tiers
  if (!istable(tiers)) then
    tbl = {
      tiers}
  end


  ply = player.GetBySteamID64(sid64)
  if ply then
    Icarus.tiers.player:setupTable(ply)
    Icaurs.tiers.player:setupTier(ply, teamId)

    local demoteToTier = math.max(1, tbl[1] - 1)

    Icarus.tiers.player:setTier(ply, teamId, demoteToTier, 0)
    Icarus.tiers.player:network(ply)

    Icarus.tiers.player:banTiers(ply, teamId, tiers)
    Icarus.tiers.player:networkTiers(ply, teamId)
  end

  for i, v in pairs(tbl) do
    local sql = Icarus.libs.string([[
      SELECT * FROM icarus_tiers_ban
      WHERE sid64 = :sid64
        AND teamId = :teamId
        AND tier = :tier
    ]])
    sql:escape(":sid64", sid64)
    sql:escape(":teamId", teamId)
    sql:escape(":tier", tier)

    conn.query(sql, function(result)
      local sql

      if (type(result) == "table" and #result > 0) then
        sql = Icarus.libs.string([[
          UPDATE icarus_tiers_ban
          SET expires = :expires
          WHERE sid64 = :sid64
            AND teamId = :teamId
            AND tier = :tier
        ]])
      else
        sql = Icarus.libs.string([[
          INSERT INTO icarus_tiers_ban (sid64, teamId, tier, expires)
          VALUES (:sid64, :teamId, :tier, :expires)
        ]])
      end

      sql:escape(":sid64", sid64)
      sql:escape(":teamId", teamId)
      sql:escape(":tier", tier)
      sql:escape(":expires", expires)

      conn.query(sql, callback)
    end)
  end
end

function Icarus.tiers.database:saveTeam(ply, teamId, tier, progress, callback)
  if callback == nil then callback = function() end
  end
  local sid64 = findSteamID64(ply)

  if (!sid64) then
    callback(false)

    return
  end

  local sql = Icarus.libs.string([[
    SELECT * FROM icarus_tiers_player_2
    WHERE sid64 = :sid64
      AND teamId = :teamId
  ]])
  sql:escape(":sid64", sid64)
  sql:escape(":teamId", teamId)

  conn.query(sql, function(result)
    local sql

    if (type(result) == "table" and #result > 0) then
      sql = Icarus.libs.string([[
        UPDATE icarus_tiers_player_2
        SET progress = :progress,
            tier = :tier
        WHERE sid64 = :sid64
          AND teamId = :teamId
      ]])
    else
      sql = Icarus.libs.string([[
        INSERT INTO icarus_tiers_player_2 (sid64, teamId, tier, progress)
        VALUES (:sid64, :teamId, :tier, :progress)
      ]])
    end

    sql:escape(":sid64", sid64)
    sql:escape(":teamId", teamId)
    sql:escape(":tier", tier)
    sql:escape(":progress", progress)

    conn.query(sql, callback)
  end)
end

function Icarus.tiers.database:getPlayer(ply, callback)
  if callback == nil then callback = function() end
  end
  local sid64 = findSteamID64(ply)

  local sql = Icarus.libs.string([[
    SELECT * FROM icarus_tiers_player_2
    WHERE sid64 = :sid64
  ]])
  sql:escape(":sid64", sid64)

  conn.query(sql, function(result)
    callback(result or {})
  end)
end

function Icarus.tiers.database:migrateToV2()
  local startTime = SysTime()

  local sql = Icarus.libs.string([[
    SELECT * FROM icarus_tiers_player
  ]])

  conn.query(sql, function(result)
    if (type(result) == "table" and #result > 0) then
      print("Starting database migration!")

      local tbl = {}

      for i, v in pairs(result) do
        tbl[v.sid64] = util.JSONToTable(v.json)
      end
      for sid64, v in pairs(tbl) do
        for i, v in pairs(v) do
          self:saveTeam(sid64, i, v.level, v.progress)
        end
      end

      local endTime = SysTime() - startTime

      print("Database migration took " .. endTime .. " seconds")

      conn.query("DROP TABLE icarus_tiers_player")
    end
  end)
end
