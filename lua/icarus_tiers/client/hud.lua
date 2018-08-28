local function DrawHUD()
  local isEnabled = Icarus.tiers.config.hud.enabled

  if (!isEnabled) then return end

  local ply = LocalPlayer()
  local job = {
    id = ply:Team(),
    name = Icarus.tiers.api:getJobName(ply, ply:Team())
  }

  if (!job.name) then return end

  local tbl = Icarus.tiers.api:getTier(ply, job.id)
  local level = tbl.level or 1
  local progress = tbl.progress or 0

  local maxTier = Icarus.tiers.player:getMaxTier(job.id)
  local maxProgress = Icarus.tiers.api:getMaxProgress(ply, job.id) or 0

  progress = math.Clamp(progress, 0, maxProgress)

  local scrW, scrH = ScrW(), ScrH()
  local width = Icarus.tiers.config.hud.width
  if (type(width) == "function") then
    width = width()
  end
  local height = 30

  local position = Icarus.tiers:GetHUDPosition():lower()

  local x = 0
  local y = 0

  local xMargin = Icarus.tiers:GetHUDMarginX()
  local yMargin = Icarus.tiers:GetHUDMarginY()

  local top = position:find("bottom")
  if (position == "topleft") then
    x = xMargin
    y = yMargin
  elseif (position == "topcenter") then
    x = scrW / 2 - width / 2 - xMargin
    y = yMargin
  elseif (position == "topright") then
    x = scrW - width - xMargin
    y = yMargin
  elseif (position == "bottomleft") then
    x = xMargin
    y = scrH - height - yMargin
  elseif (position == "bottomcenter") then
    x = scrW / 2 - width / 2 - xMargin
    y = scrH - height - yMargin
  elseif (position == "bottomright") then
    x = scrW - width - xMargin
    y = scrH - height - yMargin
  end

  local backgroundCol = Color(41, 41, 41, 200)
  local progressCol = Color(39, 174, 96)

  surface.SetDrawColor(backgroundCol)
  surface.DrawRect(x, y, width, height)

  local progressFraction = progress / maxProgress
  local progressWidth = width - 10
  progressWidth = math.Clamp(progressWidth * progressFraction, 0, progressWidth)

  local left = position:find("left")
  local right = position:find("right")
  local center = position:find("center")

  surface.SetDrawColor(progressCol)
  if (!right) then
    surface.DrawRect(x + 5, y + 5, progressWidth, height - 10)
  else
    surface.DrawRect(x + width - 5 - progressWidth, y + 5, progressWidth, height - 10)
  end
  local progressStr = tostring(progress) .. "/" .. tostring(maxProgress)

  if Icarus.tiers.config.hud.showXP then progressStr = progressStr .. " XP"
  end

  local progressAlign = TEXT_ALIGN_CENTER
  local progressX = x + width / 2
  local progressY = y + height / 2

  if right then
    progressAlign = TEXT_ALIGN_RIGHT
    progressX = x + width - 5 - 5
  elseif left then
    progressAlign = TEXT_ALIGN_LEFT
    progressX = x + 5 + 5
  end

  draw.SimpleText(progressStr, "Icarus.title", progressX, progressY, Color(255, 255, 255), progressAlign, TEXT_ALIGN_CENTER)

  local xPos = 0
  local yPos = 0
  surface.SetFont("Icarus.title")
  local tw, th = surface.GetTextSize(job.name)

  if top then
    yPos = y - height + th / 2 + 3
  else
    yPos = y + height + th / 2 - 7
  end

  local textXPos = xPos + 10
  if top then
    textYPos = yPos + (th / 2) + 3
  else
    textYPos = yPos + (th / 2)
  end

  if (level == maxTier) then
    if left then
      xPos = x
    elseif center then
      xPos = x + width / 2 - (tw + 20) / 2
    elseif right then
      xPos = x + width - (tw + 20)
    end

    surface.SetDrawColor(backgroundCol)
    surface.DrawRect(xPos, yPos, tw + 20, th + 5)

    if center then
      textXPos = xPos + tw / 2 + 10
    elseif right then
      textXPos = x + width - 10
    end

    draw.SimpleText(job.name, "Icarus.title", textXPos, textYPos, Color(255, 255, 255), progressAlign, TEXT_ALIGN_CENTER)
  else
    local start = x
    local startName = job.name
    local startTw, startTh = surface.GetTextSize(startName)

    surface.SetDrawColor(backgroundCol)
    surface.DrawRect(start, yPos, startTw + 20, startTh + 5)

    draw.SimpleText(startName, "Icarus.title", start + 10, textYPos, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    local nextTierLevel = level + 1
    local nextTier = Icarus.tiers.config.tiers[job.id][nextTierLevel]
    local nextName = "Next: " .. nextTier.name
    local nextTw, nextTh = surface.GetTextSize(nextName)
    local next = x + width - nextTw - 20

    surface.DrawRect(next, yPos, nextTw + 20, startTh + 5)

    draw.SimpleText(nextName, "Icarus.title", next + 10, textYPos, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end
end

hook.Add("HUDPaint", "Icarus.tiers.HUDPaint", function()
  DrawHUD()
end)
