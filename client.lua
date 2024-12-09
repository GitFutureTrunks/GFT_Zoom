local zoomed = false
local zoomFOV = 30.0
local normalFOV = 50.0
local zoomSpeed = 2.0
local camera = nil

function interpolateFOV(currentFOV, targetFOV, speed)
    return currentFOV + (targetFOV - currentFOV) / speed
end

RegisterKeyMapping("holdZoom", "Hold to Zoom", "keyboard", "Z")

CreateThread(function()
    while true do
        Wait(0)
        local isZoomKeyHeld = IsControlPressed(0, 20) -- Z key (Control ID 20)
        local targetFOV

        if isZoomKeyHeld then
            if not zoomed then
                zoomed = true
                if not camera then
                    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                    SetCamActive(camera, true)
                    RenderScriptCams(true, false, 0, true, true)
                end
                SetCamCoord(camera, GetGameplayCamCoord())
                SetCamRot(camera, GetGameplayCamRot(2), 2)
            end
            targetFOV = zoomFOV
        else
            if zoomed then
                zoomed = false
            end
            targetFOV = normalFOV
        end

        if camera then
            local currentFOV = GetCamFov(camera)
            local newFOV = interpolateFOV(currentFOV, targetFOV, zoomSpeed)
            SetCamFov(camera, newFOV)
            local gameplayCamCoords = GetGameplayCamCoord()
            local gameplayCamRot = GetGameplayCamRot(2)
            SetCamCoord(camera, gameplayCamCoords)
            SetCamRot(camera, gameplayCamRot, 2)

            if not zoomed and math.abs(newFOV - normalFOV) < 1.0 then
                RenderScriptCams(false, false, 0, true, true)
                DestroyCam(camera, false)
                camera = nil
            end
        end
    end
end)
