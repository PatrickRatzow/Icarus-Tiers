local function createFont(name, size)
  surface.CreateFont(name, {
    font = "Roboto",
    size = size or 16
  })
end

createFont("Icarus.tiers.admin.title", 20)
createFont("Icarus.tiers.admin.progress", 16)

local PANEL = {}

function PANEL:Init()
  self.leftright = Icarus.libs.icons["leftright.png"]
  self.topbottom = Icarus.libs.icons["topbottom.png"]

  self.theme = Icarus.libs.getActiveTheme()
  self.font = "Icarus.button"

  self.buttons = {}
  self.jobButtons = {}
  self.panels = {}

  self.sidebar = vgui.Create("Icarus.panel", self)
  self.sidebar:Dock(LEFT)
  self.sidebar.Paint = function(pnl, w, h)
    surface.SetDrawColor(self.theme.featured)
    surface.DrawRect(0, 0, self.sidebarWidth - 4, h)

    if (type(self.leftright) == "IMaterial") then
      surface.SetDrawColor(Color(0, 0, 0, 125))
      surface.SetMaterial(self.leftright)

      if (!self.backgroundExpanded) then
        surface.DrawTexturedRect(w - 4, 0, 4, h)
      else
        surface.DrawTexturedRect(w - 4, 56, 4, h - 56)

        surface.SetDrawColor(self.theme.primary)
        surface.DrawRect(w - 4, 0, 4, 56)

        if (type(self.topbottom) == "IMaterial") then
          surface.SetDrawColor(Color(0, 0, 0, 125))
          surface.SetMaterial(self.topbottom)
          surface.DrawTexturedRect(w - 4, 56, 4, 4)
        end
      end
    end
  end

  self.sidebar.buttons = vgui.Create("Icarus.panel", self.sidebar)
  self.sidebar.buttons.scrollpanel = vgui.Create("DScrollPanel", self.sidebar.buttons)

  self.sidebar.jobs = vgui.Create("Icarus.panel", self.sidebar)
  self.sidebar.jobs.Paint = function(pnl, w, h)
    local btn = self.buttons[self.activePlayer]
    if btn then
      local col = btn.background

      surface.SetDrawColor(col)
      surface.DrawRect(0, 0, w, h)
    end
  end
  self.sidebar.jobs.scrollpanel = vgui.Create("DScrollPanel", self.sidebar.jobs)

  self.sidebarWidth = self:CalculateSidebarWidth()
  self.sidebar:SetWide(self.sidebarWidth)

  for i, ply in pairs(player.GetAll()) do


    self:AddPlayer(ply)
  end

  self.background = vgui.Create("Icarus.panel", self)
  self.background:SetWide(0)
  self.background.Paint = function(pnl, w, h)
    surface.SetDrawColor(self.theme.primary)
    surface.DrawRect(0, 0, w, 56)

    if (type(self.topbottom) == "IMaterial") then
      surface.SetDrawColor(Color(0, 0, 0, 125))
      surface.SetMaterial(self.topbottom)
      surface.DrawTexturedRect(0, 56, w, 4)
    end
  end

  self.background.title = vgui.Create("Icarus.label", self.background)
  self.background.title:SetText("Citizen")
  self.background.title:SetFont("Icarus.tiers.admin.title")
  self.background.title:SetTextColor(self.theme.text.hover)
  self.background.title:SizeToContents()

  self.background.progress = vgui.Create("Icarus.label", self.background)
  self.background.progress:SetText("Tier 2/5")
  self.background.progress:SetFont("Icarus.tiers.admin.progress")
  self.background.progress:SetTextColor(self.theme.text.normal)
  self.background.progress:SizeToContents()

  self.background.setTier = vgui.Create("Icarus.button", self.background)
  self.background.setTier:SetText("Set Tier Level")
  self.background.setTier.Paint = function(pnl, w, h)
    surface.SetDrawColor(pnl.background)
    surface.DrawRect(0, 0, w, h)

    pnl:SetTextColor(pnl.text)
  end
  self.background.setTier.DoClick = function(pnl)
    local ply = self.buttons[self.activePlayer].ply
    local job = self.activeJob

    local currentTier = Icarus.tiers.player:getTier(ply, job).level or 1
    local maxTiers = Icarus.tiers.player:getMaxTier(job) or 1

    Icarus.tiers.stringRequest("Tiers", "Set Tier Level (" .. currentTier .. "/" .. maxTiers .. ")", currentTier, function(text)
      local number = tonumber(text)
      number = math.Clamp(number, 1, maxTiers)

      net.Start("Icarus.tiers.admin.setTier")
      net.WriteEntity(ply)
      net.WriteUInt(job, 16)
      net.WriteUInt(number, 32)
      net.SendToServer()

      Icarus.tiers.player:setTier(ply, job, number, 0)

      self:PopulateBackground()
    end, true)
  end

  self.background.setProgress = vgui.Create("Icarus.button", self.background)
  self.background.setProgress:SetText("Set Progress XP")
  self.background.setProgress.Paint = function(pnl, w, h)
    surface.SetDrawColor(pnl.background)
    surface.DrawRect(0, 0, w, h)

    pnl:SetTextColor(pnl.text)
  end
  self.background.setProgress.DoClick = function(pnl)
    local ply = self.buttons[self.activePlayer].ply
    local job = self.activeJob

    local tierTbl = Icarus.tiers.player:getTier(ply, job)
    local currentProgress = tierTbl.progress or 0
    local progressRequired = Icarus.tiers.config.tiers[job][tierTbl.level or 1].progressRequired or 1

    Icarus.tiers.stringRequest("Progress", "Set Progress XP (" .. currentProgress .. "/" .. progressRequired .. ")", currentProgress, function(text)
      local number = tonumber(text)
      number = math.Clamp(number, 0, progressRequired)

      net.Start("Icarus.tiers.admin.setProgress")
      net.WriteEntity(ply)
      net.WriteUInt(job, 16)
      net.WriteUInt(number, 32)
      net.SendToServer()

      Icarus.tiers.player:setTier(ply, job, tierTbl.level or 1, number)
    end, true)
  end





end

function PANEL:AddPlayer(ply)
  local i = table.Count(self.buttons) + 1

  self.buttons[i] = vgui.Create("Icarus.button", self.sidebar.buttons.scrollpanel)
  self.buttons[i]:Dock(TOP)
  self.buttons[i]:SetText("")
  self.buttons[i].ply = ply
  self.buttons[i].text = ply:Nick()
  self.buttons[i].font = self.font
  self.buttons[i].background = self.theme.featured
  self.buttons[i].textColor = self.theme.text.normal
  self.buttons[i].Paint = function(pnl, w, h)
    surface.SetDrawColor(pnl.background)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(pnl.text, pnl.font, 10 + 24 + 5, h / 2, pnl.textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end
  self.buttons[i].OnCursorEntered = function(pnl)
    Icarus.libs.ui.misc.lerpPanelColor(pnl, "background", self.theme.primary)
    Icarus.libs.ui.misc.lerpPanelColor(pnl, "textColor", self.theme.text.noticeable)
  end
  self.buttons[i].OnCursorExited = function(pnl)
    if (self.activePlayer != i) then
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "background", self.theme.featured)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "textColor", self.theme.text.normal)
    end
  end
  self.buttons[i].DoClick = function(pnl)
    self:SetActivePlayer(i)
  end

  self.buttons[i].avatar = vgui.Create("Icarus.tiers.avatar", self.buttons[i])
  self.buttons[i].avatar:Dock(LEFT)
  self.buttons[i].avatar:DockMargin(10, 10, 10, 10)
  self.buttons[i].avatar:SetVertices(360)
  self.buttons[i].avatar:SetPlayer(ply, 32)
end

function PANEL:ExpandSidebar(index)
  Icarus.libs.ui.misc.sizeTo(self.sidebar, 0.2, self:CalculateSidebarWidth() * 2, self.sidebar:GetTall())
end

function PANEL:AddJobs()
  local tbl = table.Copy(Icarus.tiers.config.tiers)

  local nameTbl = {}
  for i, v in pairs(tbl) do
    if (!RPExtraTeams[i]) then continue end
    if (!RPExtraTeams[i].name) then continue end

    nameTbl[i] = RPExtraTeams[i].name
  end

  table.sort(nameTbl, function(a, b)
    return (a or "") < (b or "")
  end)

  local firstTab = true
  for i, v in pairs(nameTbl) do
    if (!Icarus.tiers.config.tiers[i]) then continue end

    self:AddJob(i, v)

    firstTab = false
  end
end

function PANEL:AddJob(index, name)
  local tbl = RPExtraTeams[index]

  self.jobButtons[index] = vgui.Create("Icarus.button", self.sidebar.jobs.scrollpanel)
  self.jobButtons[index]:Dock(TOP)
  self.jobButtons[index]:SetText("")
  self.jobButtons[index].text = name
  self.jobButtons[index].font = self.font
  self.jobButtons[index].textColor = self.theme.text.normal
  self.jobButtons[index].Paint = function(pnl, w, h)
    draw.SimpleText(pnl.text, pnl.font, 10 + 24 + 5, h / 2, pnl.textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end
  self.jobButtons[index].OnCursorEntered = function(pnl)
    Icarus.libs.ui.misc.lerpPanelColor(pnl, "textColor", self.theme.text.noticeable)
  end
  self.jobButtons[index].OnCursorExited = function(pnl)
    if (self.activeJob != index) then
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "textColor", self.theme.text.normal)
    end
  end
  self.jobButtons[index].DoClick = function(pnl)
    self:SetActiveJob(index)
  end

  self.jobButtons[index].icon = vgui.Create("DPanel", self.jobButtons[index])
  self.jobButtons[index].icon:Dock(LEFT)
  self.jobButtons[index].icon:DockMargin(10, 10, 10, 10)
  self.jobButtons[index].icon.Paint = function(pnl, w, h)
    surface.SetDrawColor(tbl.color)
    draw.NoTexture()
    Icarus.tiers.DrawCircle(w / 2, h / 2, h / 2, 64)
  end
end

function PANEL:SetActiveJob(index)
  if (self.activeJob == index) then return end

  local btn = self.jobButtons[self.activeJob]

  if btn then
    Icarus.libs.ui.misc.lerpPanelColor(btn, "textColor", self.theme.text.normal)
  end

  self.activeJob = index

  local newBtn = self.jobButtons[self.activeJob]

  if newBtn then
    Icarus.libs.ui.misc.lerpPanelColor(newBtn, "textColor", self.theme.text.noticeable)
  end

  if (!self.backgroundExpanded) then
    self.backgroundExpanded = true

    Icarus.libs.ui.misc.sizeTo(self.background, 0.2, self:GetWide() - self.sidebar:GetWide(), self:GetTall())
  end

  self:PopulateBackground()
end

function PANEL:PopulateBackground()
  local ply = self.buttons[self.activePlayer].ply
  local job = RPExtraTeams[self.activeJob]

  local currentTier = Icarus.tiers.player:getTier(ply, self.activeJob).level or 1
  local maxTiers = Icarus.tiers.player:getMaxTier(self.activeJob) or 1

  self.background.title:SetText(job.name)
  self.background.title:SizeToContents()

  self.background.progress:SetText("Tier " .. currentTier .. "/" .. maxTiers)
  self.background.progress:SizeToContents()
end

function PANEL:SetActivePlayer(index)
  if (self.activePlayer == index) then return end

  local btn = self.buttons[self.activePlayer]

  if btn then
    Icarus.libs.ui.misc.lerpPanelColor(btn, "background", self.theme.featured)
    Icarus.libs.ui.misc.lerpPanelColor(btn, "textColor", self.theme.text.normal)
  end

  self.activePlayer = index

  local newBtn = self.buttons[self.activePlayer]

  if newBtn then
    Icarus.libs.ui.misc.lerpPanelColor(newBtn, "background", self.theme.primary)
    Icarus.libs.ui.misc.lerpPanelColor(newBtn, "textColor", self.theme.text.noticeable)
  end

  if (!self.isExpanded) then
    self.isExpanded = true

    self:ExpandSidebar(index)

    self:AddJobs()
  end
end

function PANEL:CalculateSidebarWidth()
  return 160
end

PANEL.buttonsCheck = {
  "setTier", "setProgress"
}

function PANEL:PerformLayout(w, h)
  self.sidebar.buttons:SetTall(self.sidebar:GetTall())
  self.sidebar.buttons:SetWide(self.sidebarWidth - 4)
  self.sidebar.buttons.scrollpanel:SetSize(self.sidebar.buttons:GetSize())

  self.sidebar.jobs:SetPos(self.sidebar.buttons:GetWide())
  self.sidebar.jobs:SetTall(self.sidebar:GetTall())
  self.sidebar.jobs:SetWide(w - self.sidebar.buttons:GetWide() - 481)
  self.sidebar.jobs.scrollpanel:SetSize(self.sidebar.jobs:GetSize())

  self.background:SetTall(h)
  self.background:SetPos(self.sidebar:GetWide())
  self.background.title:SetPos(10, 10)
  self.background.progress:SetPos(10, 10 + draw.GetFontHeight("Icarus.tiers.admin.title"))

  surface.SetFont(self.background.setTier:GetFont())

  local widest = 0
  local tallest = 0

  for i, v in pairs(self.buttonsCheck) do
    local btn = self.background[v]

    local tw, th = surface.GetTextSize(btn:GetText())
    tw = tw + 30

    if (tw > widest) then
      widest = tw
    end

    tallest = th + 15
  end

  self.background.setTier:SetPos(10, self.background.progress.y + draw.GetFontHeight(self.background.progress:GetFont()) + 24)
  surface.SetFont(self.background.setTier:GetFont())
  local tw, th = surface.GetTextSize(self.background.setTier:GetText())
  self.background.setTier:SetSize(widest, tallest)

  self.background.setProgress:SetPos(10, self.background.setTier.y + self.background.setTier:GetTall() + 5)
  local tw, th = surface.GetTextSize(self.background.setProgress:GetText())
  self.background.setProgress:SetSize(widest, tallest)





  for i, v in pairs(self.buttons) do
    v:SetTall(42)
    v.avatar:SetWide(24)
  end
  for i, v in pairs(self.jobButtons) do
    v:SetTall(42)
    v.icon:SetWide(24)
  end
end

vgui.Register("Icarus.tiers.admin", PANEL, "Panel")
