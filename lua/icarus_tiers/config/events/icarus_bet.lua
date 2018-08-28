local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("Dice")
EVENT:SetDescription("Gain XP for winning a dice game")
EVENT:SetProgressMessage("winning the dice roll")
EVENT:SetReward(5)
EVENT:SetConfig({
  minWinChance = 25,
  minBet = 5
})

EVENT:SetRequirements(function(ply, won, betAmount, payout, rollNumber, direction)
  local config = EVENT:GetConfig()
  local text

  if (direction == ICARUS_DICE_DIRECTION_OVER) then
    text = 100 - rollNumber
  else
    text = math.abs(rollNumber - 100)
  end

  if (text < config.minWinChance) then return end
  if (betAmount < config.minBet) then return end

  return true
end)

EVENT:AddHook("Icarus.craft.bet", function(ply)
  EVENT:OnComplete(ply)
end)

EVENT:Register()
