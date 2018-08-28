local scrW = ScrW
local scrH = ScrH

surface.CreateFont("Icarus.tiers.stringRequest.question", {
  font = "Roboto",
  size = 16
})

local blurMat = Material("pp/blurscreen")
local blur = function(pnl, x, y, w, h)
  local X, Y = pnl:LocalToScreen(0, 0)

  surface.SetDrawColor(255, 255, 255)
  surface.SetMaterial(blurMat)

  for i = 1, 2 do
    blurMat:SetFloat("$blur", i * 1.5)
    blurMat:Recompute()

    render.UpdateScreenEffectTexture()

    render.SetScissorRect(x, y, x + w, y + h, true)
    surface.DrawTexturedRect(X * -1, Y * -1, ScrW(), ScrH())
    render.SetScissorRect(0, 0, 0, 0, false)
  end

  surface.SetDrawColor(0, 0, 0)
  surface.DrawOutlinedRect(x, y, w, h)
end

function Icarus.tiers.stringRequest(title, question, default, enter, numeric)
  local theme = Icarus.libs.getActiveTheme()

  local bg = vgui.Create("EditablePanel")
  bg:SetSize(scrW(), scrH())
  bg:Center()
  bg:MakePopup()
  bg.startTime = SysTime()
  bg.Paint = function(pnl, w, h)
    blur(pnl, 0, 0, w, h)
  end

  local frame = vgui.Create("DPanel", bg)
  frame:SetSize(350, 130)
  frame:SetPos(bg:GetWide() / 2 - frame:GetWide() / 2, bg:GetTall() / 2 - frame:GetTall() / 2)
  frame.Paint = function(pnl, w, h)
    local x, y = pnl:LocalToScreen(0, 0)

    BSHADOWS.BeginShadow()
    surface.SetDrawColor(0, 0, 0, 205)
    surface.DrawRect(x, y, w, h)
    BSHADOWS.EndShadow(1, 2, 3, 360, nil, nil, true)

    surface.SetDrawColor(theme.secondary)
    surface.DrawRect(0, 0, w, h)
  end

  local top = vgui.Create("DPanel", frame)
  top:Dock(TOP)
  top:SetTall(24)
  top.Paint = function(pnl, w, h)
    surface.SetDrawColor(theme.primary)
    surface.DrawRect(0, 0, w, h)

    draw.SimpleText(title, "Icarus.title", 5, h / 2, Color(212, 212, 212), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end

  local closeButton = vgui.Create("DButton", top)
  closeButton:Dock(RIGHT)
  closeButton:SetTall(top:GetTall())
  closeButton:SetText("")
  closeButton.DoClick = function(pnl)
    bg:Remove()
  end
  closeButton.textColor = Color(107, 107, 107)
  closeButton.Paint = function(pnl, w, h)
    draw.NoTexture()
    surface.SetDrawColor(pnl.textColor)
    surface.DrawTexturedRectRotated(w / 2, h / 2, 11, 2, 45)
    surface.DrawTexturedRectRotated(w / 2, h / 2, 11, 2, 135)
  end
  closeButton.OnCursorEntered = function(pnl)
    pnl.textColor = Color(213, 213, 213)
  end
  closeButton.OnCursorExited = function(pnl)
    pnl.textColor = Color(107, 107, 107)
  end
  closeButton:SetWide(top:GetTall())

  local questionLbl = vgui.Create("DLabel", frame)
  questionLbl:SetText(question)
  questionLbl:SetFont("Icarus.tiers.stringRequest.question")
  questionLbl:SetPos(0, 24 + 10)
  questionLbl:SetWide(frame:GetWide())
  questionLbl:SetContentAlignment(5)
  questionLbl:SizeToContentsY()
  questionLbl:SetTextColor(Color(148, 148, 148))

  local textEntry = vgui.Create("Icarus.textentry", frame)
  textEntry:SetText(default)
  textEntry:SetPos(frame:GetWide() / 6, 24 + 10 + questionLbl:GetTall() + 10)
  textEntry:SetWide(frame:GetWide() - ((frame:GetWide() / 6) * 2))
  textEntry:SetNumeric(numeric)

  local confirm = vgui.Create("Icarus.button", frame)
  confirm:SetText("Confirm")
  confirm:SizeToContentsX(30)
  confirm.DoClick = function(pnl)
    enter(textEntry:GetText())

    bg:Remove()
  end
  confirm:SetPos(frame:GetWide() / 2 - confirm:GetWide() / 2, 24 + 10 + questionLbl:GetTall() + 10 + textEntry:GetTall() + 10)
end
