local EVENT = Icarus.tiers:GetEventTemplate()
EVENT:SetEnabled(true)
EVENT:SetName("Time")
EVENT:SetDescription("Gain XP every minute")
EVENT:SetProgressMessage("playing")
EVENT:SetReward(1)
EVENT:SetConfig({
  timeDelay = 60,
  restrictedJobs = {
    ["Mayor"] = true
  }
})

if SERVER then
  EVENT:AddHook("Initialize", function(ply)
    local config = EVENT:GetConfig()

    timer.Create("Icarus.tiers.events" .. EVENT:GetName(), config.timeDelay, 0, function()
      for i, ply in pairs(player.GetAll()) do
        if (!IsValid(ply)) then continue end

        local teamName = team.GetName(ply:Team())
        if config.restrictedJobs[teamName] then continue end

        EVENT:OnComplete(ply)
      end
    end)
  end)
end

EVENT:Register()
