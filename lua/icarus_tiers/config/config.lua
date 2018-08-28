local config = Icarus.tiers.helper

-- Overwrite HUD and Scoreboard functions?
config:SetOverwriteFunctions(true)
-- Enable HUD?
config:SetHUDEnabled(true)
-- Set position
-- Positions:
-- topleft
-- topcenter
-- topright
-- bottomleft
-- bottomcenter
-- bottomright
config:SetHUDPosition("topcenter")
-- Set X margin
config:SetHUDMarginX(0)
-- Set Y margin
config:SetHUDMarginY(10)
-- Width of the HUD in pixels
-- This can simply be a number like:
-- config:SetHUDWidth(600)
-- Or it can be a function like the default example (scales to different resolutions)
config:SetHUDWidth(function(ply)
  return ScrW() * 0.3125
end)
-- Should the HUD show "XP"
config:SetHUDShowXP(true)
-- Is third party addons (other addons) allowed to interact with this script?
config:SetThirdPartyOverwrite(true)
-- Lua function to determine who is an admin and who is not an admin
config:SetAdminCheck(function(ply)
  -- Table to determine which usergroups are considered admin.
  -- Example:
  -- ["usergroup_name"] = true,
  local tbl = {
    ["superadmin"] = true,
  }

  return tbl[ply:GetUserGroup()]
end)