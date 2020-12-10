addEvent("dobozadas",true);
addEventHandler("dobozadas",root,function(player)
    for k,v in pairs(boxobjpos) do
        local createbox = createObject(2969,v[1],v[2],v[3]-0.85,0,0,90)
        setElementData(createbox,"box:id",true)
    end
end)

addEvent("shopadas",true);
addEventHandler("shopadas",root,function(player)
    for k,v in pairs(shopobjpos) do
        local shops = createObject(1891,v[1],v[2],v[3]-1.2,0,0,0)
        local col = createColCuboid(2,2,2,2,2,3)
        attachElementToElement(col,shops)
    end
end);

addEvent("jarmuadas",true);
addEventHandler("jarmuadas",root,function(player)
    local x,y,z = getElementPosition(player);
    local rx,ry,rz = getElementRotation(player);
    local jarmu = createVehicle(456,x,y,z,rx,ry,rz);
    setVehicleVariant(jarmu,0,0)
    setVehicleEngineState(jarmu,true);
    setElementData(player,"job:veh",jarmu);
    warpPedIntoVehicle(player,jarmu);
    loadjarmu(jarmu);

end);

addEvent("jarmuelvetel",true);
addEventHandler("jarmuelvetel",root,function(player)
    local jarmu = getElementData(player,"job:veh",true)
    if jarmu then 
        destroyElement(jarmu);
        setElementData(player,"job:veh",false);
        setElementData(player,"aru:level",false);
        setElementData(player,"show:fuvarlevel",false)
    end
end);

function loadjarmu(jarmu)
    if not isElement(jarmu) then return end;
    setElementAlpha(jarmu,100);
    setVehicleDamageProof(jarmu,true)
    setTimer(function()
        setElementAlpha(jarmu,150);
            setTimer(function()
                setElementAlpha(jarmu,255);
                setVehicleDamageProof(jarmu,false);
            end,1000,1);
    end,1000,1);
end

addEvent("dobozfelvesz", true)
addEventHandler("dobozfelvesz", root, function(player)
    triggerEvent("carry->anim", player, player)
    local boxtohand = createObject(2969, 0, 0, 0, 0, 0, 0)
    setElementData(player, "box:hand", boxtohand)
    exports.bone_attach:attachElementToBone(boxtohand, player, 12,0.18,0.12,0,-90,0,-15)
end)

addEvent("doboztorles", true)
addEventHandler("doboztorles", root, function(player, box)
    local doboz = getElementData(box,"box:id",true)
    if doboz then
        destroyElement(box)
    end
end)

addEvent("carry->anim", true)
addEventHandler("carry->anim", root, function(player)
    setPedAnimation(player,"CARRY", "crry_prtial", 1, true, true, false)
    toggleControl(player,"fire",false)
    toggleControl(player,"jump",false)
    toggleControl(player,"sprint",false)
end)

function quit()
    local player = source
    local jarmu = getElementData(player,"job:veh",true)
    if jarmu then 
        destroyElement(jarmu);
        setElementData(player,"job:veh",false);
        setElementData(player,"aru:level",false);
    end
end
addEventHandler("onPlayerQuit",root,quit)

addEvent("doboztorles >> kocsi", true)
addEventHandler("doboztorles >> kocsi", root, function(player)
    if getElementData(player,"box:hand",true) then
        local doboz = getElementData(player,"box:hand",boxtohand)
        if doboz then
            destroyElement(doboz)
            toggleControl(player,"fire",true)
            toggleControl(player,"jump",true)
            toggleControl(player,"sprint",true)
        end
    end
end)

addEvent("dobozadas >> kocsi", true)
addEventHandler("dobozadas >> kocsi", root, function(player)
    if getElementData(player,"box:car") == true then
        triggerEvent("carry->anim", player, player)
        local boxtohand = createObject(2969, 0, 0, 0, 0, 0, 0)
        setElementData(player, "box:hand", boxtohand)
        exports.bone_attach:attachElementToBone(boxtohand, player, 12,0.18,0.12,0,-90,0,-15)
        setElementData(localPlayer,"box:car",(getElementData(player,"box:car")or 0 )- 1)
    end
end)
