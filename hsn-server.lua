ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("hsn-fishing:givemoneyplayer")
AddEventHandler("hsn-fishing:givemoneyplayer",function()
    local pl = ESX.GetPlayerFromId(source)
    local amount = math.random(Hsn.Cash.a,Hsn.Cash.b)
    local item = pl.getInventoryItem("fish").count
    local para = amount * item
    if item == 0 then
        return
    else
        pl.removeInventoryItem("fish",item)
        pl.addMoney(para) 
    end
end)

RegisterServerEvent("hsn-fishing:givefishtoplayer")
AddEventHandler("hsn-fishing:givefishtoplayer",function()
    local pl = ESX.GetPlayerFromId(source)
    if Hsn.RandomFish then
        amount = math.random(Hsn.RandomFishAmount.a,Hsn.RandomFishAmount.b)
    else
        amount = 1
    end
    pl.addInventoryItem("fish",amount)
end)
ESX.RegisterUsableItem("olta",function(source)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    TriggerClientEvent("hsn-fishing:startfishing",src)
end)

