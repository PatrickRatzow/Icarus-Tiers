local function createFont(name, size)
  surface.CreateFont(name, {
    font = "Roboto",
    size = size or 16
  })
end

createFont("Icarus.tiers.info.title", 24)
createFont("Icarus.tiers.info.name", 20)
createFont("Icarus.tiers.info.desc", 16)
createFont("Icarus.tiers.info.reward", 15)

local PANEL = {}

function PANEL:Init()
  self.theme = Icarus.libs.getActiveTheme()

  self.title = vgui.Create("Icarus.label", self)
  self.title:Dock(TOP)
  self.title:DockMargin(10, 10, 10, 10)
  self.title:SetText("Events")
  self.title:SetTextColor(self.theme.text.noticeable)
  self.title:SetFont("Icarus.tiers.info.title")

  self.scroll = vgui.Create("Icarus.scrollpanel", self)
  self.scroll:Dock(FILL)
  self.scroll.tbl = {}

  local tbl = table.Copy(Icarus.tiers.events)
  table.sort(tbl, function(a, b)
    return a.m_name > b.m_name end)

  for i, v in SortedPairs(tbl) do
    if (!v:GetEnabled()) then continue end

    self.scroll.tbl[i] = vgui.Create("DPanel", self.scroll)
    local panel = self.scroll.tbl[i]
    panel:Dock(TOP)
    panel:DockMargin(10, 0, 10, 5)
    panel:SetTall(60)
    panel.backgroundColor = self.theme.featured
    panel.Paint = function(pnl, w, h)
      surface.SetDrawColor(pnl.backgroundColor)
      surface.DrawRect(0, 0, w, h)
    end
    panel.OnCursorEntered = function(pnl)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "backgroundColor", self.theme.primary)
    end
    panel.OnCursorExited = function(pnl)
      Icarus.libs.ui.misc.lerpPanelColor(pnl, "backgroundColor", self.theme.featured)
    end

    if v:GetIcon() then
      panel.icon = vgui.Create("DImage", panel)
      panel.icon:Dock(LEFT)
      panel.icon:DockMargin(8, 8, 8, 8)
      panel.icon:SetImage("wyvernf4/archive.png")
    end

    panel.name = vgui.Create("Icarus.label", panel)
    panel.name:SetText(v:GetName())
    panel.name:SetFont("Icarus.tiers.info.name")
    panel.name:SetTextColor(self.theme.text.hover)

    panel.desc = vgui.Create("Icarus.label", panel)
    panel.desc:SetText(v:GetDescription())
    panel.desc:SetFont("Icarus.tiers.info.desc")
    panel.desc:SizeToContents()

    panel.reward = vgui.Create("Icarus.label", panel)
    panel.reward:SetText(v:GetReward() .. " XP")
    panel.reward:SetFont("Icarus.tiers.info.reward")
    panel.reward:SizeToContents()
    panel.reward:SetContentAlignment(6)
    panel.reward:SetTextColor(self.theme.featured.hover)
  end
end

function PANEL:PerformLayout(w, h)
  for i, v in pairs(self.scroll.tbl) do
    local offset = v.icon and v.icon:GetWide() or 8

    v.name:SetPos(offset + 8, 12)
    v.desc:SetPos(offset + 8 + 1, 12 + 20)

    surface.SetFont(v.reward:GetFont())
    local tw, th = surface.GetTextSize(v.reward:GetText())
    v.reward:SetPos(v:GetWide() - tw - 24)
    v.reward:CenterVertical()
  end
end

vgui.Register("Icarus.tiers.info", PANEL, "Panel")
