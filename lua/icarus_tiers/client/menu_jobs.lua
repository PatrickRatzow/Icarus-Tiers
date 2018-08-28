local function createFont(name, size)
  surface.CreateFont(name, {
    font = "Roboto",
    size = size or 16
  })
end

createFont("Icarus.tiers.jobs.title", 17)
createFont("Icarus.tiers.jobs.name", 18)
createFont("Icarus.tiers.jobs.progress", 14)

local PANEL = {}

function PANEL:Init()
  self.leftright = Icarus.libs.icons["leftright.png"]

  self.theme = Icarus.libs.getActiveTheme()
  self.font = "Icarus.button"

  self.buttons = {}
  self.panels = {}

  self.activeTab = 0

  self.sidebar = vgui.Create("Icarus.panel", self)
  self.sidebar:Dock(LEFT)
  self.sidebar:DockPadding(0, 0, 4, 0)
  self.sidebar.Paint = function(pnl, w, h)
    surface.SetDrawColor(self.theme.featured)
    surface.DrawRect(0, 0, w - 4, h)

    if (type(self.leftright) == "IMaterial") then
      surface.SetDrawColor(Color(0, 0, 0, 125))
      surface.SetMaterial(self.leftright)
      surface.DrawTexturedRect(w - 4, 0, 4, h)
    end
  end

  self.sidebar.scrollpanel = vgui.Create("Icarus.scrollpanel", self.sidebar)
  self.sidebar.scrollpanel:Dock(FILL)

  local tierTbl = table.Copy(Icarus.tiers.config.tiers)

  local nameTbl = {}
  for i, v in pairs(tierTbl) do
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

    self:CreateTab(i, v, firstTab)

    firstTab = false
  end

  local frame = self:GetParent():GetParent():GetParent():GetParent()
  local frameWidth = math.max(808, 600 + self:CalculateSidebarWidth())

  timer.Simple(0, function()
    frame:SetWide(frameWidth)
    frame:Center()
  end)
end

function PANEL:CreateTab(index, name, visible)
  local tbl = RPExtraTeams[index]

  self.buttons[index] = vgui.Create("Icarus.button", self.sidebar.scrollpanel)
  self.buttons[index]:Dock(TOP)
  self.buttons[index]:SetText("")
  self.buttons[index].text = name
  self.buttons[index].font = self.font
  self.buttons[index].background = self.theme.featured
  self.buttons[index].textColor = self.theme.text.normal
  self.buttons[index].Paint = function(pnl, w, h)
    surface.SetDrawColor(pnl.background)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(pnl.text, pnl.font, 10 + 24 + 5, h / 2, pnl.textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end
  self.buttons[index].OnCursorEntered = function(pnl)
    Icarus.libs.ui.misc.lerpPanelColor(pnl, "background", self.theme.primary)
    Icarus.libs.ui.misc.lerpPanelColor(pnl, "textColor", self.theme.text.noticeable)
  end
  self.buttons[index].OnCursorExited = function(pnl)
    if (self.activeTab != index) then
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "background", self.theme.featured)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "textColor", self.theme.text.normal)
    end
  end
  self.buttons[index].DoClick = function(pnl)
    self:SetActiveTab(index)
  end

  if visible then
    self.activeTab = index

    self.buttons[index].background = self.theme.primary
    self.buttons[index].textColor = self.theme.text.noticeable
  end

  self.buttons[index].icon = vgui.Create("DPanel", self.buttons[index])
  self.buttons[index].icon:Dock(LEFT)
  self.buttons[index].icon:DockMargin(10, 10, 10, 10)
  self.buttons[index].icon.Paint = function(pnl, w, h)
    surface.SetDrawColor(tbl.color)
    draw.NoTexture()
    Icarus.tiers.DrawCircle(w / 2, h / 2, h / 2, 64)
  end

  self.panels[index] = vgui.Create("Icarus.panel", self)
  self.panels[index]:Dock(FILL)
  self.panels[index]:DockPadding(10, 10, 10, 10)
  self.panels[index]:SetVisible(visible)
  self.panels[index].tiers = {}

  for i, v in pairs(Icarus.tiers.config.tiers[index]) do
    self.panels[index].tiers[i] = vgui.Create("Panel", self.panels[index])
    local panel = self.panels[index].tiers[i]
    panel:Dock(TOP)
    panel:DockMargin(0, 0, 0, 10)
    panel:SetTall(80)

    panel.text = vgui.Create("Icarus.label", panel)
    panel.text:Dock(TOP)
    panel.text:SetText("Tier " .. i)
    panel.text:SetFont("Icarus.tiers.jobs.title")
    panel.text:SetTextColor(self.theme.text.noticeable)

    panel.box = vgui.Create("DPanel", panel)
    panel.box:Dock(FILL)
    panel.box:DockMargin(0, 5, 0, 0)
    panel.box.background = self.theme.featured
    panel.box.nameColor = self.theme.text.hover
    panel.box.progressColor = self.theme.text.normal
    panel.box.Paint = function(pnl, w, h)
      surface.SetDrawColor(pnl.background)
      surface.DrawRect(0, 0, w, h)

      draw.SimpleText(v.name, "Icarus.tiers.jobs.name", panel.model:GetWide() + 8, h / 2 - 8 - 8, pnl.nameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
      draw.SimpleText(v.progressRequired .. " XP required", "Icarus.tiers.jobs.progress", panel.model:GetWide() + 8, h / 2 + 2, pnl.progressColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    panel.box.OnCursorEntered = function(pnl)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "background", self.theme.primary)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "nameColor", self.theme.text.noticeable)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "progressColor", self.theme.text.hover)
    end
    panel.box.OnCursorExited = function(pnl)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "background", self.theme.featured)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "nameColor", self.theme.text.hover)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "progressColor", self.theme.text.normal)
    end

    local model = RPExtraTeams[index].model

    if istable(model) then
      model = model[1]
    end

    if v.models then
      if istable(v.models) then
        model = v.models[1]
      else
        model = v.models
      end
    end

    panel.model = vgui.Create("DModelPanel", panel.box)
    panel.model:Dock(LEFT)
    panel.model:DockMargin(0, 5, 0, 5)
    panel.model:SetModel(model)
    panel.model:SetCamPos(Vector(20, 0, 65))
    panel.model:SetLookAt(Vector(0, 0, 62))
    panel.model:SetMouseInputEnabled(false)
    panel.model.LayoutEntity = function() end
  end
end

function PANEL:SetActiveTab(i)
  if (self.activeTab == i) then return end

  local btn = self.buttons[self.activeTab]

  if btn then
    Icarus.libs.ui.misc.lerpPanelColor(btn, "background", self.theme.featured)
    Icarus.libs.ui.misc.lerpPanelColor(btn, "textColor", self.theme.text.normal)

    local pnl = self.panels[self.activeTab]

    if pnl then
      pnl:SetVisible(false)
    end
  end

  self.activeTab = i

  local newBtn = self.buttons[self.activeTab]

  if newBtn then
    Icarus.libs.ui.misc.lerpPanelColor(newBtn, "background", self.theme.primary)
    Icarus.libs.ui.misc.lerpPanelColor(newBtn, "textColor", self.theme.text.noticeable)

    local newPnl = self.panels[self.activeTab]

    if newPnl then
      newPnl:SetVisible(true)
    end
  end
end

function PANEL:GetActiveTab()
  return self.activeTab
end

function PANEL:CalculateSidebarWidth()
  local w = 0

  surface.SetFont(self.font)

  for i, v in pairs(self.buttons) do
    local name = v.text

    local tW = surface.GetTextSize(name)
    tW = tW + 10
    tW = tW + 10
    tW = tW + 24
    tW = tW + 9


    if (#self.buttons > 13) then tW = tW + 16
    end

    if (tW > w) then
      w = tW
    end
  end

  return w
end

function PANEL:PerformLayout(w, h)
  local sidebarWidth = math.max(160, self:CalculateSidebarWidth())
  self.sidebar:SetWide(sidebarWidth)

  for i, v in pairs(self.buttons) do
    v:SetTall(42)
    v.icon:SetWide(24)
  end
end

vgui.Register("Icarus.tiers.jobs", PANEL, "Panel")
