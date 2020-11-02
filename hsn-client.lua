ESX = nil 
Citizen.CreateThread(function()
	while ESX == nil do
        ESX = exports["es_extended"]:getSharedObject()
        PlayerData = ESX.GetPlayerData()
	  Citizen.Wait(0)
	end
  end)
local startfishing = false

RegisterNetEvent("hsn-fishing:startfishing")
AddEventHandler("hsn-fishing:startfishing",function()
    local playerPed = PlayerPedId()
    local plped = GetEntityCoords(PlayerPedId())
    for k,v in pairs(Hsn.Zones) do
        if GetDistanceBetweenCoords(plped,v.x,v.y,v.z,false) < 1.5 then
            startfishing = true
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_FISHING", 0, true)
        end
    end  
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plped = PlayerPedId()
        if startfishing then
            if IsEntityDead(plped) then
                TriggerEvent("hsn-fishing:stopfishing")
            end
            if IsControlPressed(1, 73) then
                TriggerEvent("hsn-fishing:stopfishing")
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		local wait = math.random(Hsn.Fishtime.a , Hsn.Fishtime.b)
		Wait(wait)
			if startfishing then
				local skill = exports["reload-skillbar"]:taskBar(2000,math.random(5,15))
				if skill ~= 100 then
					TriggerEvent("notification","Başarısız oldun")
				else
					TriggerServerEvent("hsn-fishing:givefishtoplayer")
				end
			end			
	end
end)

RegisterNetEvent("hsn-fishing:stopfishing")
AddEventHandler("hsn-fishing:stopfishing",function()
    ClearPedTasks(PlayerPedId())
    startfishing = false
    TriggerEvent("notification","İşlem iptal edildi",2)
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        local playerped = PlayerPedId()
        local entity = GetEntityCoords(playerped)
        for k,v in pairs(Hsn.SellFishCoords) do
            if GetDistanceBetweenCoords(entity,v.x,v.y,v.z) <= 3.0 then
                wait = 3
                DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, false, false, false, false)
                DrawText3Ds(v.x,v.y,v.z+0.19,"[E] - Balık Sat")
                   if IsControlPressed(1,38) then
                    OpenFishingMenu()
                   end
            end
        end
        Citizen.Wait(wait)
    end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	ClearDrawOrigin()
end

OpenFishingMenu = function()
    TriggerServerEvent("hsn-fishing:givemoneyplayer")
end

Citizen.CreateThread(function()
    for k,v in pairs(Hsn.SellFishCoords) do
    local blip = AddBlipForCoord(v.x, v.y, v.z)

	SetBlipSprite (blip, 356)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, 17)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Balık Satış Noktası")
    EndTextCommandSetBlipName(blip)
    end
end)



