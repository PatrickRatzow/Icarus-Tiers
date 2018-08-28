local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("Salary")
EVENT:SetDescription("Gain XP when getting your paycheck")
EVENT:SetProgressMessage("getting a paycheck")
EVENT:SetReward(2)

EVENT:AddHook("playerGetSalary", function(ply)
  EVENT:OnComplete(ply)
end)

EVENT:Register()
