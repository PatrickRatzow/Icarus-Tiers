function Icarus.tiers.DrawCircle(x, y, radius, seg)
  local cir = {}

  table.insert(cir, {
    x = x, y = y, u = 0.5, v = 0.5})
  for i = 0, seg do
    local a = math.rad((i / seg) * -360)
    table.insert(cir, {
      x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
  end

  local a = math.rad(0)
  table.insert(cir, {
    x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})

  surface.DrawPoly(cir)
end

local PANEL = {}

function PANEL:Init()
  self.topbottom = Icarus.libs.icons["topbottom.png"]
  self.bottomtop = Icarus.libs.icons["bottomtop.png"]

  self.theme = Icarus.libs.getActiveTheme()

  self.background:DockPadding(1, 0, 0, 1)
  self.background:DockMargin(0, 0, 0, 0)
  self.background.Paint = function(pnl, w, h)
    surface.SetDrawColor(self.theme.secondary)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(self.theme.accent)
    surface.DrawLine(0, 0, 0, h)
    surface.DrawLine(1, h - 1, w, h - 1)
    surface.DrawLine(w - 1, h - 1, w - 1, 0)

    if (type(self.bottomtop) == "IMaterial") then
      surface.SetDrawColor(Color(0, 0, 0, 35))
      surface.SetMaterial(self.bottomtop)
      surface.DrawTexturedRect(1, 28 + 1, w - 2, 5)
      surface.DrawTexturedRect(1, 0 + 1, w - 2, 5)
    end

    if (type(self.topbottom) == "IMaterial") then
      surface.SetDrawColor(Color(0, 0, 0, 125))
      surface.SetMaterial(self.topbottom)
      surface.DrawTexturedRect(1, h - 7, w - 2, 5)
    end
  end

  if self.theme.menuVertical then
    self.scrollpanel = vgui.Create("Icarus.navbar.scrollpanel", self.background)
    self.scrollpanel.vertical = true

    self.navbar = vgui.Create("Icarus.navbar", self.scrollpanel)
  else
    self.navbar = vgui.Create("Icarus.navbar.horizontal", self.background)
    self.navbar.Paint = function(pnl, w, h)
      surface.SetDrawColor(self.theme.primary)
      surface.DrawRect(0, 0, w, h)
    end
  end

  self.content = vgui.Create("DPanel", self.background)
  self.content.Paint = function(pnl, w, h)end

  self.box = vgui.Create("DPanel", self.content)
  self.box:Dock(FILL)
  self.box:DockMargin(0, 0, 0, 0)
  self.box.Paint = function(pnl, w, h)end

  self.navbar:SetBody(self.box)
  self.navbar:AddCategory("Jobs", "Icarus.tiers.jobs")
  self.navbar:AddCategory("Events", "Icarus.tiers.info")
  if Icarus.tiers.IsAdmin(LocalPlayer()) then
    self.navbar:AddCategory("Admin", "Icarus.tiers.admin")
  end
  self.navbar:ForceActiveCategory("Jobs", true)
end

function PANEL:PerformLayout(w, h)
  self.top:SetTall(26)

  self.closeButton:SetWide(self.top:GetTall())

  if self.theme.menuVertical then
    self.scrollpanel:SetPos(1, 0)
    self.scrollpanel:SetSize(120, self.background:GetTall() - 1)

    self.navbar:SetPos(0, 5)
    self.navbar:SetSize(self.scrollpanel:GetWide(), self.scrollpanel:GetTall() - 25)

    self.content:SetPos(self.navbar:GetWide() + 5, 5)
    self.content:SetSize(self.background:GetWide() - self.navbar:GetWide(), self.background:GetTall() - 10)
  else
    self.navbar:SetPos(1, 0)
    self.navbar:SetSize(self.background:GetWide() - 2, 28)

    self.content:SetPos(1, 28 + 5)
    self.content:SetSize(self.background:GetWide() - 2, self.background:GetTall() - 10 - 30)
  end
end
vgui.Register("Icarus.tiers.frame", PANEL, "Icarus.frame")

local function menu()
  local w = math.Clamp(ScrW(), 640, 808)
  local h = math.Clamp(ScrH(), 480, 608)

  local frame = vgui.Create("Icarus.tiers.frame")
  frame:SetSize(w, h)
  frame:SetTitle("Icarus Tiers")
  frame:Center()
  frame:MakePopup()
end

concommand.Add("icarus_tiers", menu)
