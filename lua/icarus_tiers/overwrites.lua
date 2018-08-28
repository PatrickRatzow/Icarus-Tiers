function Icarus.tiers.overwriteFunctions()
  local plyMeta = FindMetaTable("Player")
  local old_getDarkRPVar = plyMeta.getDarkRPVar

  plyMeta.getDarkRPVar = function(ply, str)
    local oldJob = old_getDarkRPVar(ply, str)

    if (str != "job") then
      return oldJob
    end

    local jobName = Icarus.tiers.api:getJobName(ply, ply:Team())

    if (!jobName) then
      return oldJob
    end

    return jobName
  end
end

if CLIENT then
  hook.Add("DarkRPFinishedLoading", "Icarus.tiers.overwriteFunctions", function()
    timer.Simple(3, function()
      if Icarus.tiers.config.overwriteFunctions then
        Icarus.tiers.overwriteFunctions()
      end
    end)
  end)
end
