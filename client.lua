local zoomed = false
local zoomFOV = 30.0 -- Zoom level (Field of View DO NOT TOUCH)
local normalFOV = 50.0 -- Default FOV (I would suggest to only edit if you have default views set default value is 70)
local zoomSpeed = 5.0 -- Speed of FOV transition (This one is okay to touch but DO NOT DO TOO MUCH LOL)
local camera = nil

CreateThread(function()
    while true do
        Wait(0)
        local targetFOV

        if IsControlPressed(0, 20) then -- This is Z key (control ID 20)
            if not zoomed then
                zoomed = true

                -- This creates and activates a new camera
                if not camera then
                    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                end
                SetCamCoord(camera, GetGameplayCamCoord())
                SetCamRot(camera, GetGameplayCamRot(2), 2)
                SetCamActive(camera, true)
                RenderScriptCams(true, false, 0, true, true)
            end
            targetFOV = zoomFOV -- Sets target FOV to zoom level
        else
            if zoomed then
                zoomed = false -- Mark zoom as inactive
            end
            targetFOV = normalFOV -- Sets target FOV to normal level
        end

        -- This keeps the zoom state smooth when active
        if camera then
            local currentFOV = GetCamFov(camera)
            local newFOV = currentFOV + (targetFOV - currentFOV) / zoomSpeed
            SetCamFov(camera, newFOV)

            -- This will restore the camera back to normal for a smooth zoom out
            if not zoomed and math.abs(newFOV - normalFOV) < 0.1 then
                RenderScriptCams(false, false, 0, true, true)
                DestroyCam(camera, false)
                camera = nil
            end
        end
    end
end)
