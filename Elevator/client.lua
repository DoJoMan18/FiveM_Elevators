--[[

    Elevators for FiveM
    By DoJoMan18 (DoJoMan18.com).

    You can change the keys here, if you change them you have to also change them in the notifications on line 78. For more information see: (https://docs.fivem.net/docs/game-references/controls/)

--]]

key_floor_up = 188 -- ARROW UP
key_floor_down = 187 -- ARROW DOWN

--[[

The numbers in the elevators array (line 29) should always count up. Do not leave a gap like this:

    [1] = {
        (coords here)
    },
    [4] = {
        (coords here)
    },
    [10] = {
        (coords here)
    },

]]--

elevators = {
    [1] = { -- 398 F.I.B.
        -- Floor 1
        {136.19, -761.00, 45.75, "Lobby"},
        -- Floor 2
        {136.19, -761.00, 234.15, "Floor 47"},
        -- Floor 3
        {136.19, -761.00, 242.15, "Floor 49"}
    },
    [2] = { -- 1002 Army Base
        {-2361.00, 3249.20, 31.80},{-2361.00, 3249.20, 91.80},{-2361.00, 3249.20, 31.80}
    },
    [3] = { -- 140 Morgue
        {246.43, -1372.55, 24.54},{248.68, -1369.94, 29.65},{246.43, -1372.55, 24.54}
    },
    [4] = { -- 963 Humane Labs and Research
        {3540.75, 3676.64, 21.00},{3540.75, 3676.64, 28.12},{3540.75, 3676.64, 21.00}
    },
}

Citizen.CreateThread(function()
    -- turn positions into vectors for faster calculations
    for i = 1, #elevators do
        for k,floor in ipairs(elevators[i]) do
            elevators[i][k] = {vector3(floor[1], floor[2], floor[3]), floor[4]}
        end
    end
    while true do
        Citizen.Wait(5)
        local player = PlayerPedId()
        local PlayerLocation = GetEntityCoords(player)

        for i = 1, #elevators do
            for k,floor in ipairs(elevators[i]) do
                -- New floor
                local Level = floor[1]
                local distance = #(PlayerLocation - Level)
                if distance < 2.0 then
                    -- Get the total amount of floors
                    local numFloors = #elevators[i]

                    -- Check if there are floors above and below our current floor
                    local floorUp = nil
                    if k < numFloors then
                        floorUp = elevators[i][k + 1]
                    end
                    local floorDown = nil
                    if k > 1 then
                        floorDown = elevators[i][k - 1]
                    end

                    -- Text to show
                    -- Show current floor
                    local message = "Elevator (" .. (floor[2] or "Floor " .. k) .. ")"
                    if floorUp then
                        -- Show prompt to go up
                        message = message .. "~n~" .. "~INPUT_FRONTEND_UP~ " .. (floorUp[2] or "Floor " .. k + 1)
                    end
                    if floorDown then
                        -- Show prompt to go down
                        message = message .. "~n~" .. "~INPUT_FRONTEND_DOWN~ " .. (floorDown[2] or "Floor " .. k - 1)
                    end

                    -- Sent information how to use
                    MessageUpLeftCorner(message)

                    if floorUp ~= nil then
                        if IsControlJustReleased(1, key_floor_up) then
                            Citizen.Wait(1500)
                            -- Lets freeze the user so he can't get away..
                            FreezeEntityPosition(player, true)
                            Citizen.Wait(500)
                            -- Play some sounds the make the elevator extra cool! :D
                            PlaySoundFrontend(-1, "CLOSED", "MP_PROPERTIES_ELEVATOR_DOORS", 1);
                            Citizen.Wait(4500)
                            PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
                            Citizen.Wait(500)
                            PlaySoundFrontend(-1, "OPENED", "MP_PROPERTIES_ELEVATOR_DOORS", 1);

                            -- Is elevator a vehicle elevator?
                            if IsPedInAnyVehicle(player, true) then
                                -- Lets teleport the user / vehicle and unfreeze the user.
                                SetEntityCoords(GetVehiclePedIsUsing(player), floorUp[1])
                                FreezeEntityPosition(player, false)
                            else
                                -- Lets teleport the user / vehicle and unfreeze the user.
                                SetEntityCoords(player, floorUp[1])
                                FreezeEntityPosition(player, false)
                            end
                        end
                    end

                    if floorDown ~= nil then
                        if IsControlJustReleased(1, key_floor_down) then
                            Citizen.Wait(1500)
                            -- Lets freeze the user so he can't get away..
                            FreezeEntityPosition(player, true)
                            Citizen.Wait(500)
                            -- Play some sounds the make the elevator extra cool! :D
                            PlaySoundFrontend(-1, "CLOSED", "MP_PROPERTIES_ELEVATOR_DOORS", 1);
                            Citizen.Wait(4500)
                            PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0)
                            Citizen.Wait(500)
                            PlaySoundFrontend(-1, "OPENED", "MP_PROPERTIES_ELEVATOR_DOORS", 1);

                            -- Is elevator a vehicle elevator?
                            if IsPedInAnyVehicle(player, true) then
                                -- Lets teleport the user / vehicle and unfreeze the user.
                                SetEntityCoords(GetVehiclePedIsUsing(player), floorDown[1])
                                FreezeEntityPosition(player, false)
                            else
                                -- Lets teleport the user / vehicle and unfreeze the user.
                                SetEntityCoords(player, floorDown[1])
                                FreezeEntityPosition(player, false)
                            end
                        end
                    end
                    -- Get to here but you haven't been teleported? You are not close to an elevator ingame.
                end
            end
            -- New building
        end
    end
end)

-- Message in left up corner.
function MessageUpLeftCorner(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


-- Message above radar.
function MessageAboveRadar(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end
