local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("Lottery")
EVENT:SetDescription("Gain XP for winning the lottery")
EVENT:SetProgressMessage("winning the lottery")
EVENT:SetReward(2)

EVENT:AddHook("lotteryEnded", function(participants, winner, amount)
  EVENT:OnComplete(winner)
end)

EVENT:Register()
