RunService.RenderStepped:Connect(function()
    if not Features.SilentAim then
        TargetPos = nil
        TargetPart = nil
        return
    end
    local hrp, part = GetNearestTarget(Features.SilentAimTarget, Features.SilentAimMode, Features.SilentAimDistance)
    if hrp and part then
        TargetPart = part
        local pos = part.Position
        local pred = Features.SilentAimPrediction or 0
        if pred > 0 then
            local vel = part.AssemblyLinearVelocity or hrp.AssemblyLinearVelocity
            if vel then
                -- scale prediction with ping for better accuracy
                local ping = (player:GetNetworkPing() or 0) * 0.5
                pos = pos + (vel * (pred + ping))
            end
        end
        TargetPos = pos
    else
        TargetPos = nil
        TargetPart = nil
    end
end)
