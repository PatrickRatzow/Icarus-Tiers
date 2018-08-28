function Icarus.tiers.GetConfig(key)
  return Icarus.tiers.config[key]
end

function Icarus.tiers.SetConfig(key, value)
  Icarus.tiers.config[key] = value
end

function Icarus.tiers.IsAdmin(ply)
  return Icarus.tiers.config.adminCheck(ply)
end

local HELPER = {}

function HELPER:SetOverwriteFunctions(bool)
  Icarus.tiers.config.overwriteFunctions = bool
end

function HELPER:SetHUDEnabled(bool)
  Icarus.tiers.config.hud.enabled = bool
end

function HELPER:SetHUDWidth(width)
  Icarus.tiers.config.hud.width = width
end

function HELPER:SetHUDShowXP(bool)
  Icarus.tiers.config.hud.showXP = bool
end

function HELPER:SetThirdPartyOverwrite(bool)
  Icarus.tiers.config.thirdpartyOverwrite = bool
end

function HELPER:SetAdminCheck(func)
  Icarus.tiers.config.adminCheck = func
end

function HELPER:SetHUDPosition(str)
  Icarus.tiers.config.hud.pos = str
end

function HELPER:SetHUDMarginX(margin)
  Icarus.tiers.config.hud.xMargin = margin
end

function HELPER:SetHUDMarginY(margin)
  Icarus.tiers.config.hud.yMargin = margin
end

function Icarus.tiers:GetHUDPosition()
  return Icarus.tiers.config.hud.pos or ""
end

function Icarus.tiers:GetHUDMarginX()
  return Icarus.tiers.config.hud.xMargin
end

function Icarus.tiers:GetHUDMarginY()
  return Icarus.tiers.config.hud.yMargin
end

Icarus.tiers.helper = HELPER
