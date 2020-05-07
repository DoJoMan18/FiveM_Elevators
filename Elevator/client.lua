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
        {136.19, -761.00, 45.75}, 
        -- Floor 2
        {136.19, -761.00, 234.15}, 
        -- Floor 3
        {136.19, -761.00, 242.15}
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

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(5)
        local player = GetPlayerPed(-1)
        local PlayerLocation = GetEntityCoords(player)

        for i = 1, #elevators do
            for k,floor in ipairs(elevators[i]) do
                -- New floor
                Level = {
                    x=floor[1],
                    y=floor[2],
                    z=floor[3], 
                }

                if GetDistanceBetweenCoords(PlayerLocation.x, PlayerLocation.y, PlayerLocation.z, Level.x, Level.y, Level.z, true) < 2.0 then
                    -- Sent information how to use
                    MessageUpLeftCorner("Use: ~INPUT_FRONTEND_UP~ of ~INPUT_FRONTEND_DOWN~")
                    LevelUp = k + 1
                    LevelDown = k - 1

                    for k,floor in ipairs(elevators[i]) do
                        if k == LevelUp then
                            floorUp = {
                                x=floor[1],
                                y=floor[2],
                                z=floor[3], 
                            }
                        end
                        if k == LevelDown then
                            floorDown = {
                                x=floor[1],
                                y=floor[2],
                                z=floor[3], 
                            }
                        end
                    end

                    if floorUp ~= nil then
                        if IsControlJustReleased(1, key_floor_up) then
                            Citizen.Wait(1500)
                            -- Lets freeze the user so he can't get away..
                            FreezeEntityPosition(GetPlayerPed(-1), true)
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
                                SetEntityCoords(GetVehiclePedIsUsing(player), floorUp.x, floorUp.y, floorUp.z)
                                FreezeEntityPosition(GetPlayerPed(-1), false)
                            else
                                -- Lets teleport the user / vehicle and unfreeze the user.
                                SetEntityCoords(player, floorUp.x, floorUp.y, floorUp.z)
                                FreezeEntityPosition(GetPlayerPed(-1), false)
                            end
                        end
                    end

                    if floorDown ~= nil then
                        if IsControlJustReleased(1, key_floor_down) then
                            Citizen.Wait(1500)
                            -- Lets freeze the user so he can't get away..
                            FreezeEntityPosition(GetPlayerPed(-1), true)
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
                                SetEntityCoords(GetVehiclePedIsUsing(player), floorDown.x, floorDown.y, floorDown.z)
                                FreezeEntityPosition(GetPlayerPed(-1), false)
                            else
                                -- Lets teleport the user / vehicle and unfreeze the user.
                                SetEntityCoords(player, floorDown.x, floorDown.y, floorDown.z)
                                FreezeEntityPosition(GetPlayerPed(-1), false)
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
