-- Add a new tier
Icarus.tiers.config:addTier(TEAM_CITIZEN, {
  -- The name of the tier (for tier 1 use the same name as otherwise)
  name = "Citizen",
  -- Level must be specified
  level = 1,
  -- How much progress is required to progress from this?
  progressRequired = 300,
})

Icarus.tiers.config:addTier(TEAM_CITIZEN, {
  -- Same as above
  name = "Trusted Citizen",
  level = 2,
  progressRequired = 800,
  -- A weapons table, they spawn with this weapon.
  weapons = {
    weapon_fiveseven52 = true
  },
  -- A bonus salary applied to players with this tier.
  salary = 80,
})

Icarus.tiers.config:addTier(TEAM_CITIZEN, {
  name = "Advanced Citizen",
  level = 3,
  progressRequired = 1500,
  weapons = {
    weapon_fiveseven52 = true
  },
  salary = 120,
  -- Their total amount of health
  health = 150,
  -- Their total amount of armor
  armor = 50,
  -- What usergroups (ranks) can become this?
  userGroups = {
    superadmin = true
  },
  -- Which model?
  model = {
    "models/player/mossman.mdl",
    "models/player/Barney.mdl"
  }
})

Icarus.tiers.config:addTier(TEAM_GUN, {
  name = "Gun Dealer",
  level = 1,
  progressRequired = 200
})

Icarus.tiers.config:addTier(TEAM_MAYOR, {
  name = "Mayor",
  level = 1,
  progressRequired = 200
})

Icarus.tiers.config:addTier(TEAM_MAYOR, {
  name = "Respected Mayor",
  level = 2,
  progressRequired = 500
})