----------------------------------
        --------------
        -- ELEMENTDATA --
        --------------
        -- ("job:veh"); --
        -- ("aru:level") --
        -- ("show:fuvarlevel) --
        -- ("ped:aru") -- 
----------------------------------

-----------------------------------------------------------------------------
                        -- Változók, stb --
-----------------------------------------------------------------------------

local npcclick = false
local panelclick = false
local showPanel = false
local camera = false
local currentTask
local currentPed
local maincolor = "#2980b9"
local w,h = guiGetScreenSize();
local w2,h2 = guiGetScreenSize();
local w5, h5 = guiGetScreenSize();
local w6, h6 = guiGetScreenSize();
local sx,sy = guiGetScreenSize();
local w,h = 350,125
local w2,h2 = 300,350
local mainfont = dxCreateFont("files/mainfont.ttf",14)
local mainfont2 = dxCreateFont("files/mainfont.ttf",18)
local mainfont3 = dxCreateFont("files/mainfont.ttf",13)
local render1 = {0,0,0,0}
local pedtext = {}
local move = {}
local x,y = sx/2-w/2,sy/2-h/2
local time = 5000

syntax = {
    ["info"] = "#2980b9[SiegeMta - Árufeltöltő]:#ffffff ";
    ["success"] = "#27ae60[SiegeMta - Árufeltöltő]:#ffffff ";
	["error"] = "#c0392b[SiegeMta - Árufeltöltő]:#ffffff ";
	["warning"] = "#f39c12[SiegeMta - Árufeltöltő]:#ffffff ";
}

for i, player in pairs(getElementsByType("player")) do 
setElementData(localPlayer,"job:veh",false);
setElementData(localPlayer,"aru:level",false)
setElementData(localPlayer,"show:fuvarlevel",false)
setElementData(localPlayer,"veh:door",false)
setElementData(localPlayer,"box:hand",false)
setElementData(localPlayer,"ped:camera",false)
setElementData(localPlayer,"box:car",nil)
end


function getPedText()
    local text = {}
        text = {
           "Szevasz Koma! Úgy hallom, most munkanélküli vagy. Nálunk van munka bőven, szeretnél segíteni? * (nyomj egy ENTER-t vagy BACKSPACE-t)",
        }
    return text
end

local felvevo = createMarker(4.9706406593323, 2005.0994873047, 17.640625,"checkpoint",2,100,100,0)
local munkaado = createPed(200,8.2045497894287, 2010.8972167969, 17.640625)
setElementData(munkaado,"ped:aru",true)
setElementFrozen(munkaado,true)

-----------------------------------------------------------------------------
                                    -- RENDER --
-----------------------------------------------------------------------------

function renderCarPanel()
    local veh = getElementData(localPlayer,"job:veh",true)
    if veh then
        local pX, pY, pZ = getVehicleComponentPosition(veh,"bump_rear_dummy","world");
        local px,py,pz = getElementPosition(localPlayer);
        if getDistanceBetweenPoints3D(pX, pY, pZ, px, py, pz) <= 2 then
            ------------
            local doortext = "Hátsó ajtó "..maincolor.."nyitásához #ffffffnyomd meg az\n "..maincolor.."E #ffffffgombot!"
            if getElementData(localPlayer,"veh:door") then
                doortext = "Hátsó ajtó "..maincolor.."zárásához #ffffffnyomdnyomd meg az\n "..maincolor.."E #ffffffgombot!"
            end
            -------------
            local doboztext = "Doboz kivétel: "..maincolor.."R #ffffffbetű"
            if getElementData(localPlayer, "box:hand") then
                doboztext = "Doboz berakás: "..maincolor.."R #ffffffbetű"
            end
            dxDrawRectangle(sx/2-w/2,sy/2-h/2+400,w,80,tocolor(0, 0, 0,200))
            dxDrawText(doortext,sx/2-w/2,sy/2-h/2+415,sx/2-w/2+w,h,tocolor(255,255,255,255), 1, mainfont3, "center", "top", false, false, true, true);
            --------------
            dxDrawRectangle(sx/2-w/2,sy/2-h/2+340,w,25,tocolor(0, 0, 0,200))
            dxDrawText(doboztext,sx/2-w/2,sy/2-h/2+340,sx/2-w/2+w,h,tocolor(255,255,255,255), 1, mainfont, "center", "top", false, false, true, true);
        end
    end
end
addEventHandler("onClientRender",root,renderCarPanel)

function renderPedpanel()
    if render1[1] < 100 then
        render1[1] = render1[1] +1
    end
    
    dxDrawRectangle(0,0,sx,render1[1],tocolor(0,0,0))
    dxDrawRectangle(0,sy-render1[1],sx,render1[1],tocolor(0,0,0))
    
    if render1[1] == 100 then
        local length = dxGetTextWidth(pedtext[currentText], 1.3, "default-bold", false)
        if render1[currentText+1] < length + 40 then
            render1[currentText+1] = render1[currentText+1] +3
        end
        dxDrawText(pedtext[currentText],30,sy-100,render1[currentText+1],sy,tocolor(255,255,255,255),1.3,"default-bold","left","center",true)
    end    
end

function renderFuvarlevel()
    if getElementData(localPlayer,"aru:level") == true then
        local leveltext = "Fuvarlevél megjelenítése!"
        if getElementData(localPlayer,"show:fuvarlevel") then
            leveltext = "Fuvarlevél elrejtése!"
        end
        dxDrawRectangle(sx/2-w/2,sy/2-h/2+370,w,25,tocolor(192, 57, 43,150))
        dxDrawText(leveltext,sx/2-w/2,sy/2-h/2+370,sx/2-w/2+w,h,tocolor(255,255,255,255), 1, mainfont, "center", "top", false, false, true, true);
    end
end

function renderFuvarlevelKep()
    if getElementData(localPlayer,"show:fuvarlevel") == true then
        if isCursorShowing() then 
            local cursorX, cursorY = getCursorPosition();
            local cursorX, cursorY = cursorX * sx, cursorY * sy;
            if move[1] then 
                x = cursorX + move[2];
                y = cursorY + move[3];
            end
        else 
            if move[1] then 
                move = {};
            end
        end
        dxDrawImage(x+30,y-10,w2,h2,"files/fuvarlevel.png",0, 0, 0, tocolor(255, 255, 255, 255), true)
        for k,v in pairs(lista) do
            local player = "Levente"
            dxDrawText(v[1],x+60,y+35+(k*35.5),x+w,h,tocolor(255,255,255,255), 1, mainfont, "left", "top", false, false, true, true);
            dxDrawText(v[2],x+200,y+35+(k*35.5),x+w,h,tocolor(255,255,255,255), 1, mainfont, "center", "top", false, false, true, true);
            dxDrawText(player,x+70,y+290,x+w,h,tocolor(255,255,255,255), 1, mainfont, "left", "top", false, false, true, true);
            dxDrawText("Dim",x+150,y+290,x+w,h,tocolor(255,255,255,255), 1, mainfont, "center", "top", false, false, true, true);  
        end
    end
end

function renderStartPanel()  
    dxDrawRectangle(sx/2-w/2,sy/2-h/2,w,h,tocolor(0,0,0,150))
    if isInSlot(sx/2-w/2+10,sy/2-h/2+64,w/3,h/2.5) then
        dxDrawRectangle(sx/2-w/2+10,sy/2-h/2+64,w/3,h/2.5,tocolor(46, 204, 113,220))
    else
        dxDrawRectangle(sx/2-w/2+10,sy/2-h/2+64,w/3,h/2.5,tocolor(46, 204, 113,150))
    end
    if isInSlot(sx/2-w/2+223,sy/2-h/2+64,w/3,h/2.5) then
        dxDrawRectangle(sx/2-w/2+223,sy/2-h/2+64,w/3,h/2.5,tocolor(192, 57, 43,220))
    else
        dxDrawRectangle(sx/2-w/2+223,sy/2-h/2+64,w/3,h/2.5,tocolor(192, 57, 43,150))
    end
    local veh = getPedOccupiedVehicle(localPlayer)
    local text = "Szeretnél lehívni egy munkajárművet?"
    if getElementData(localPlayer,"job:veh") then
        text = "Leszeretnéd adni a munkajárművedet?"
    end
    dxDrawText(text,sx/2-w/2,sy/2-h/2+13,sx/2-w/2+w,h,tocolor(255,255,255,255), 1, mainfont, "center", "top", false, false, true, true);
    dxDrawText("Igen",sx/2-w/2+47.5,sy/2-h/2+72.5,sx/2-w/2+w,h,tocolor(255,255,255,255), 1, mainfont2, "left", "top", false, false, true, true);
    dxDrawText("Nem",sx/2-w/2+217,sy/2-h/2+72.5,sx/2-w/2+w,h,tocolor(255,255,255,255), 1, mainfont2, "center", "top", false, false, true, true);
end

-----------------------------------------------------------------------------
                                    -- CLICK --
-----------------------------------------------------------------------------


function click( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if getElementData(localPlayer,"show:fuvarlevel") == true then 
        if button == "left" then 
            if state == "down" then 
                if isInSlot(x,y, 350,125) then   
                    move = {};
                    move[1] = true;
                    move[2] = x-cursorX;
                    move[3] = y-cursorY;
                end
            elseif state == "up" then 
                move = {};
            end
        end
    end
    if button == "left" and state == "down" then
        if ( clickedElement ) then
            if (clickedElement) and getElementData(clickedElement,"ped:aru") then
                if (npcclick == false) then
                    local x, y, z = getElementPosition(localPlayer)
                    if getDistanceBetweenPoints3D(x, y, z, worldX, worldY, worldZ)<=2 then
                        if getElementData(localPlayer,"job:veh") == false then
                            outputChatBox(syntax["warning"].."Előbb vegyél fel egy munka járművet, után kérj egy fuvarlevelet!",255,255,255,true)
                        else
                            if getElementData(localPlayer,"ped:camera") == false then
                                local ex,ey,ez = unpack{getElementPosition(clickedElement)}
                                local x1,y1,z1,x2,y2,z2 = getCameraMatrix()
                                local x3,y3,z3 = 8.2481517791748, 2013.4368896484, 18.340625762939
                                exports['eh_core']:smoothMoveCamera(x1,y1,z1,x2,y2,z2,x3,y3,z3,ex,ey,ez+0.5, time)
                                currentTask = "pedpanel"
                                currentPed = clickedElement
                                currentText = 1
                                pedtext = getPedText()
                                setElementAlpha(localPlayer,0)
                                setElementFrozen(localPlayer, true)
                                toggleAllControls(false)
                                showChat(false)
                                npcclick = true
                                addEventHandler("onClientRender",root,renderPedpanel)
                                setTimer(
                                    function()
                                        setElementData(localPlayer,"ped:camera",true)
                                end, 8600, 1)
                            end
                        end
                    end
                end
            end
            if isInSlot(sx/2-w/2,sy/2-h/2+370,w,25) then
                if getElementData(localPlayer,"aru:level") == true then
                    if getElementData(localPlayer,"show:fuvarlevel") == false then
                        setElementData(localPlayer,"show:fuvarlevel",true)
                        addEventHandler("onClientRender",root,renderFuvarlevelKep)
                    else
                        setElementData(localPlayer,"show:fuvarlevel",false)
                        removeEventHandler("onClientRender",root,renderFuvarlevelKep)
                    end
                end
            end
            if (panelclick == true) then
                if isInSlot(sx/2-w/2+223,sy/2-h/2+64,w/3,h/2.5) then
                    removeEventHandler("onClientRender",root,renderStartPanel)
                    panelclick = false
                end
            end
            if (panelclick == true) then
                if isInSlot(sx/2-w/2+10,sy/2-h/2+64,w/3,h/2.5) then
                    if getElementData(localPlayer,"job:veh") == false then
                        removeEventHandler("onClientRender",root,renderStartPanel)
                        panelclick = false
                        triggerServerEvent("jarmuadas",localPlayer,localPlayer)
                        outputChatBox(syntax["info"].."Lekértél egy munkajárművet, most menj oda "..maincolor.."Dimhez #ffffffés kérj fuvarlevelet!",255,255,255,true)
                    else
                        triggerServerEvent("jarmuelvetel",localPlayer,localPlayer)
                        outputChatBox(syntax["info"].."Leadtad a munkajárművet!",255,255,255,true)
                        removeEventHandler("onClientRender",root,renderStartPanel)
                        setElementData(localPlayer,"aru:level",false)
                        setElementData(localPlayer,"show:fuvarlevel",false)
                        setElementData(localPlayer,"box:car",nil)
                        setElementData(localPlayer,"box:id",false)
                        panelclick = false
                        npcclick = false
                    end
                end
            end
            if getElementData(clickedElement,"box:id") then
                triggerServerEvent("dobozfelvesz",localPlayer,localPlayer)
                triggerServerEvent("doboztorles",localPlayer,localPlayer,clickedElement)
            end
        end
    end
end
addEventHandler("onClientClick",root,click)

-----------------------------------------------------------------------------
                                    -- KEY --
-----------------------------------------------------------------------------


function press(key,state)
    if key == "enter" and state then
        if currentTask == "pedpanel" then
            if currentText == 1 then
                if (camera == false) then
                    if getElementData(localPlayer,"ped:camera") == true then
                        waitData["start"] = getTickCount()
                        waitData["end"] = getTickCount()+5200
                        addEventHandler("onClientRender",root,renderWait)
                        fadeCamera ( false, 1.0, 0, 0, 0 )
                        setTimer ( fadeCameraDelayed, 5100, 1)
                        camera = true
                        setTimer(function()
                            removeEventHandler("onClientRender",root,renderWait)
                            removeFunctions();
                            addEventHandler("onClientRender",root,renderFuvarlevel)
                            setElementData(localPlayer,"aru:level",true)
                            setElementData(localPlayer,"show:fuvarlevel",false)
                            triggerServerEvent("dobozadas",localPlayer,localPlayer)
                            work1();
                            outputChatBox(syntax["info"].."Menj be a raktárba és "..maincolor.."keresd meg #ffffffa dobozokat, majd "..maincolor.."pakold be #ffffffa munkajárműved be!",255,255,255,true)
                        end, 5200, 1)
                    end
                end
            end
        end
    elseif key == "backspace" and state then
        if currentTask == "pedpanel" then
            removeFunctions();
        end
    elseif key == "e" and state then
        if getElementData(localPlayer,"job:veh",true) then
            local veh = getElementData(localPlayer,"job:veh",true)
            local pX, pY, pZ = getVehicleComponentPosition(veh,"bump_rear_dummy","world")
            local px,py,pz = getElementPosition(localPlayer)
            if getDistanceBetweenPoints3D(pX, pY, pZ, px, py, pz) <= 2 then
                addEventHandler("onClientRender",root,renderCarPanel)
                moveDoor();
            else
                removeEventHandler("onClientRender",root,renderCarPanel)
            end
        end
    elseif key == "r" and state then
        if getElementData(localPlayer,"job:veh",true) then
            local veh = getElementData(localPlayer,"job:veh",true)
            local pX, pY, pZ = getVehicleComponentPosition(veh,"bump_rear_dummy","world")
            local px,py,pz = getElementPosition(localPlayer)
            if getDistanceBetweenPoints3D(pX, pY, pZ, px, py, pz) <= 2 then
                if getElementData(localPlayer,"veh:door") == true then
                    if getElementData(localPlayer,"box:hand",true) then
                        triggerServerEvent("doboztorles >> kocsi",localPlayer,localPlayer)
                        setElementData(localPlayer, "box:hand", false)
                        setElementData(localPlayer,"box:car",(getElementData(localPlayer,"box:car")or 0 )+ 1)
                        outputChatBox("Betettél egy dobozt a kocsiba. Dobozok száma: " ..maincolor..getElementData(localPlayer,"box:car").."/6",255,255,255, true);
                    end
                    --[[if getElementData(localPlayer,"box:car") == true then
                        triggerServerEvent("doboztorles >> kocsi",localPlayer,localPlayer)
                        outputChatBox("Kivettél egy dobozt a kocsiba. Dobozok száma: " ..maincolor..getElementData(localPlayer,"box:car").."/6",255,255,255, true);
                    else
                        outputChatBox(syntax["error"].."Nincs a kocsiban semmi amit "..maincolor.."ki #fffffftudnál venni!",255,255,255,true)
                    end]]
                else
                    outputChatBox(syntax["error"].."Az ajtó zárva van ezáltal nem tudsz belepakolni, "..maincolor.."nyisd fel #ffffffaz ajtót!",255,255,255,true)
                end
            end
        end
    end
end
addEventHandler("onClientKey", root, press)

-----------------------------------------------------------------------------
                                    -- EGYÉB --
-----------------------------------------------------------------------------

function work1()
    for k,v in pairs(shopobjpos) do
        local shops = createObject(1891,v[1],v[2],v[3]-1.2,0,0,0)
        local col = createColCuboid(2,2,2,2,2,3)
        attachElementToElement(col,shops)
    end
end

function moveDoor()
    local veh = getElementData(localPlayer,"job:veh",true)
    if veh then
        if getElementData(localPlayer,"veh:door") == false then
            local x,y,z = getVehicleComponentPosition(veh,"boot_dummy","root")
            local rx,ry,rz = getVehicleComponentPosition(veh,"boot_dummy","root")
            setVehicleComponentRotation(veh,"boot_dummy",rx+90.5,ry+5,rz,"root")
            setVehicleComponentPosition(veh,"boot_dummy",x,y+0.52,z+1.03,"root")
            setElementData(localPlayer,"veh:door",true)
        else
            local x2,y2,z2 = getVehicleComponentPosition(veh,"boot_dummy","root")
            local rx2,ry2,rz2 = getVehicleComponentPosition(veh,"boot_dummy","root")
            setVehicleComponentRotation(veh,"boot_dummy",rx2-0.5,ry2+4.4,rz2-2,"root") -- dőlés befelé kifelé, jobbra balra, keresztbe 
            setVehicleComponentPosition(veh,"boot_dummy",x2,y2-0.52,z2-1.03,"root")
            setElementData(localPlayer,"veh:door",false)
        end
    end
end

addEventHandler("onClientPedDamage",root,function()
    if getElementData(source,"ped:aru") then 
        cancelEvent();
    end
end);
addEventHandler("onClientPlayerStealthKill", localPlayer, function(target)
    if getElementData(target,"ped:aru") then 
        cancelEvent();
    end
end)

function MarkerHit ( hitPlayer, matchingDimension )
    if hitPlayer == localPlayer then
        if source == felvevo then
            panelclick = true
            addEventHandler("onClientRender",root,renderStartPanel)
        end
    end
end
addEventHandler ( "onClientMarkerHit", getRootElement(), MarkerHit )

function MarkerLeave ( leavingPlayer, matchingDimension )
    if source == felvevo then
        panelclick = false
        removeEventHandler("onClientRender",root,renderStartPanel)
    end
end
addEventHandler ( "onClientMarkerLeave", getRootElement(), MarkerLeave )

local cursorState = isCursorShowing()
cursorX, cursorY = 0,0
if cursorState then
    local cursorX, cursorY = getCursorPosition()
    cursorX, cursorY = cursorX * sx, cursorY * sy
end

addEventHandler("onClientCursorMove", root, 
    function(_, _, x, y)
        cursorX, cursorY = x, y
    end
)

function isInBox(dX, dY, dSZ, dM, eX, eY)
    local eX, eY = exports['eh_core']:getCursorPosition()
    if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
        return true
    else
        return false
    end
end

function isInSlot(xS,yS,wS,hS)
    if isCursorShowing() then
        if isInBox(xS,yS,wS,hS, cursorX, cursorY) then
            return true
        else
            return false
        end
    end 
end

function fadeCameraDelayed()
    if (isElement(localPlayer)) then
          fadeCamera(true, 0.5)
    end
end

waitData = {
	["start"] = 0,
	["end"] = 0,
	["pos"] = false,
}
local w5, h5 = 260,28.5
local w6, h6 = 253,22.5
function renderWait()
	local now = getTickCount()
	local elapsedTime = now - waitData["start"]
	local duration = waitData["end"] - waitData["start"]
	local progress = elapsedTime / duration
	local width = interpolateBetween(0, 0, 0, w6, 0, 0, progress, "Linear")
	dxDrawRectangle(sx/2-w5/2,sy/2-h5/2,w5,h5, tocolor(20, 20, 20, 255))
    dxDrawRectangle(sx/2-w6/2,sy/2-h6/2,width,h6, tocolor(41, 128, 185,255))
    dxDrawText("Fuvarlevél nyomtatása...",sx/2-w/2,sy/2-h/2+50,sx/2-w/2+w,h,tocolor(255,255,255,255), 1, mainfont, "center", "top", false, false, true, true);
end

function removeFunctions()
    if getElementData(localPlayer,"ped:camera") == true then
        currentTask = nil
        render1 = {0,0,0,0}
        currentPed = nil
        setElementAlpha(localPlayer, 255)
        removeEventHandler("onClientRender",root,renderPedpanel)
        setElementFrozen(localPlayer, false)
        toggleAllControls(true)
        setCameraTarget(localPlayer, localPlayer)
        showChat(true)
        setElementData(localPlayer,"ped:camera",false)
        camera = false
        npcclick = false
    end
end