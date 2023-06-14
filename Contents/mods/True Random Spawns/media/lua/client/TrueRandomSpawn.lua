building_table = {};
cellList = {};


--do intialization check
--do list filter based on options -function
--pick random value based on length of array
--pull cell coordinate from array
--set cell coordinate as x * 300 and y * 300
--randomly generate a value between 1 to 300 for x and y
--add values to x and y
--teleport character
--check if on water
--remove zombies within 8 tiles



local function intializeTrueRandomSpawnSettings()
    local player = getPlayer();
    local pillowmod = player:getModData();
    --pillowmod.validSpawn = false; 
    pillowmod.optionInBuilding = false;
    pillowmod.optionNearCiv = false;
    pillowmod.optionNearRoad = false;
    pillowmod.optionWildCamp = false;
    pillowmod.optionWildDeep = false;
    pillowmod.optionAnywhere = false;

    pillowmod.optionSelection = SandboxVars.TRS.optionSelection;
    print("true random spawns sandbox option selection :" ,pillowmod.optionSelection);

    if  SandboxVars.TRS.optionSelection == 1 then
        pillowmod.optionInBuilding = true;
    elseif SandboxVars.TRS.optionSelection == 2 then
        pillowmod.optionNearCiv = true;
    elseif SandboxVars.TRS.optionSelection == 3 then
        pillowmod.optionNearRoad = true;
    elseif SandboxVars.TRS.optionSelection == 4 then 
        pillowmod.optionWildCamp = true;
    elseif SandboxVars.TRS.optionSelection == 5 then
        pillowmod.optionWildDeep = true;
    else
        pillowmod.optionAnywhere = true;
    end 

    print("===============true random spawns debug options===============")
    print("optionInBuilding = ",  pillowmod.optionInBuilding);
    print("optionNearCiv = ", pillowmod.optionNearCiv);
    print("optionNearRoad = ", pillowmod.optionNearRoad);
    print("optionWildCamp = ", pillowmod.optionWildCamp);
    print("optionWildDeep = ", pillowmod.optionWildDeep);
    print("optionAnywhere = ", pillowmod.optionAnywhere);

    pillowmod.settingsApplied = true;

end 

local function filterCellPickList(filterTable)
    local player = getPlayer();
    local pillowmod = player:getModData();
    local i = 1;

    while i <= #filterTable do
        --handles in building or near civ, building loop is later
        --nearciv = 1, 0 no 
        if (pillowmod.optionInBuilding == true  or pillowmod.optionNearCiv == true ) 
            and filterTable[i].nearCiv ~= 1 then
            --print("removing record from pick list " .. filterTable[i].xcell .. ",".. filterTable[i].ycell );
            print("removing:")
            print("cell xy:" .. pillowmod.cellList[i].xcell .. "," .. pillowmod.cellList[i].ycell);
            print("nearRoad:" .. pillowmod.cellList[i].nearRoad .. " ,  nearCiv:" .. pillowmod.cellList[i].nearCiv .. ", civDist:".. pillowmod.cellList[i].civDist);
            table.remove(filterTable, i);
        --handles near road 
        elseif pillowmod.optionNearRoad == true and filterTable[i].nearRoad == 0 then
            --print("removing record from pick list " .. filterTable[i].xcell .. ",".. filterTable[i].ycell );
            print("removing:")
            print("cell xy:" .. pillowmod.cellList[i].xcell .. "," .. pillowmod.cellList[i].ycell);
            print("nearRoad:" .. pillowmod.cellList[i].nearRoad .. " ,  nearCiv:" .. pillowmod.cellList[i].nearCiv .. ", civDist:".. pillowmod.cellList[i].civDist);
            table.remove(filterTable, i);
        --handles near camp
        elseif pillowmod.optionWildCamp == true 
            and (filterTable[i].poi ~= "Cabin" or filterTable[i].poi ~= "Camp")  then 
            --print("removing record from pick list " .. filterTable[i].xcell .. ",".. filterTable[i].ycell );
            print("removing:")
            print("cell xy:" .. pillowmod.cellList[i].xcell .. "," .. pillowmod.cellList[i].ycell);
            print("nearRoad:" .. pillowmod.cellList[i].nearRoad .. " ,  nearCiv:" .. pillowmod.cellList[i].nearCiv .. ", civDist:".. pillowmod.cellList[i].civDist);
            table.remove(filterTable, i);   
        --handles deep woods
        elseif pillowmod.optionWildDeep == true and filterTable[i].nearRoad == 1 and filterTable[i].civDist <= 3
            then
            --print("removing record from pick list " .. filterTable[i].xcell .. ",".. filterTable[i].ycell );
            print("removing:")
            print("cell xy:" .. pillowmod.cellList[i].xcell .. "," .. pillowmod.cellList[i].ycell);
            print("nearRoad:" .. pillowmod.cellList[i].nearRoad .. " ,  nearCiv:" .. pillowmod.cellList[i].nearCiv .. ", civDist:".. pillowmod.cellList[i].civDist);         
            table.remove(filterTable, i);               
        else
            i = i + 1;
        end
    end
    return filterTable; 
end 

local function calcTableSize(table)
    local count = 0;
    for _ in pairs(table) do
        count = count + 1;
    end
    return count;
end 

local function initializeCellPickList()
    local player = getPlayer();
    local pillowmod = player:getModData();

    pillowmod.cellList = cellPickList();
    --cellList = cellPickList();
    print("init cell list size:");
    print(calcTableSize(pillowmod.cellList));

    pillowmod.cellList = filterCellPickList(pillowmod.cellList);
    print("post filter cell list size:");

    print(calcTableSize(pillowmod.cellList));
    pillowmod.cellListInitialized = true;
    print("cellListInitialized", pillowmod.cellListInitialized);
end 

local function displayCellPick()
    local player = getPlayer();
    local pillowmod = player:getModData();

    local i = pillowmod.cellPickIndex
    print("----------------CELL PICK DISPLAY----------------");
    print("cell xy:" .. pillowmod.cellList[i].xcell .. "," .. pillowmod.cellList[i].ycell);
    print("nearRoad:" .. pillowmod.cellList[i].nearRoad .. " ,  nearCiv:" .. pillowmod.cellList[i].nearCiv .. ", civDist:".. pillowmod.cellList[i].civDist);
    print("----------------CELL PICK DISPLAY----------------");
end 


local function FloorDrawCheck()
    local player = getPlayer();
    local pillowmod = player:getModData();
    if pillowmod.floorDrawn == nil or pillowmod.floorDrawn == false then
        pillowmod.floorDrawn = true;
    end
end 

local function ResetFloorDrawCheck()
    local player = getPlayer();
    local pillowmod = player:getModData();
    print("floor drawn reset value");
    pillowmod.floorDrawn = false;
end


local function teleportPlayer()

    local player = getSpecificPlayer(0);
    local pillowmod = player:getModData();


    pillowmod.spawnCount = pillowmod.spawnCount + 1;
    print("current spawn attempt count:" , pillowmod.spawnCount );
    print("teleporting player to : " .. pillowmod.targetXvalue .. "," .. pillowmod.targetYvalue);
    player:setX(pillowmod.targetXvalue);
    player:setY(pillowmod.targetYvalue);
    player:setZ(0);
    player:setLx(pillowmod.targetXvalue);
    player:setLy(pillowmod.targetYvalue);
    player:setLz(0);
    pillowmod.pendingTP = false;    
    ResetFloorDrawCheck();
    Events.OnTick.Remove(teleportPlayer);


end

local function isWater(square)
    if square:getFloor() == nil then 
        return false;
    else 
        return square:getFloor():getWaterAmount() == 9999;
    end 
end 

local function probabilityCheck(percentageTrue)
    local random = ZombRand(1,1000);
    return random <= percentageTrue * 10;
end

local function coinFlip()
    return ZombRand(1) == 0;
end

local function giveRarePillow()
    if probabilityCheck(1) then getPlayer():getInventory():AddItem("Base.Pillow")
    else end 
end 

local function isCharacterOutside(character)
    local currentSquare = character:getCurrentSquare();
    if currentSquare ~= nil then 
        return currentSquare:isOutside();
    else 
        return true
    end 
end

local function hasRoomDef(square)
    if square:getRoom() == nil 
        or square:getRoom():getRoomDef():getName() ~= "empty"  
        or square:getRoom():getRoomDef():getName() ~= "traincar" then
        return true;
    else 
        return false;
    end 
end 

--as squares are loaded, add the associated buildings to a table
local function addBuildingList(_square)
    local sq = _square;
    if sq then 
        if sq:isOutside() == false then
            local building = sq:getBuilding();
            building_table[building] = building;
        end
    end   
end --end add building function

--as squares are unloaded, remove the associated buildings from the table.
local function removeBuildingList(_square)
    local sq = _square;
    if sq then 
            if sq:isOutside() == false then 
                building_table[sq:getBuilding()] = nil;
            end
    end   
end --end remove building function

local function isBuildingListEmpty()
    count = 0;
    for i, v in pairs(building_table) do 
        return false;
    end
    return true;
end

-- calculate the closeset building in the list
local function calcClosestBuilding(_square) --isAllExplored()
    local sourcesq = _square ;
    local closest = nil;
    local closestDist = 1000000;

    if isBuildingListEmpty() == true then 
        closest = sourcesq;
    else 
        for id, b in pairs(building_table) do
            local sq = b:getRandomRoom():getRandomFreeSquare();
            if sq ~= nil then 
                local dist = IsoUtils.DistanceTo(sourcesq:getX(), sourcesq:getY(), sq:getX() , sq:getY())
                if dist < closestDist then
                    closest = sq;
                    closestDist = dist;
                end
            end
        end 
    end 
    return closest
end 

local function distanceCheck(sourceCharacter, targetCharacter)
    local sourcesq = sourceCharacter:getCurrentSquare();
    local targetsq = targetCharacter:getCurrentSquare();
    return IsoUtils.DistanceTo(sourcesq:getX(), sourcesq:getY(), targetsq:getX() , targetsq:getY())
end 


local function getSquareInRandomBuilding()
    local buildingTableLength = calcTableSize(building_table);
    buildingPickIndex = ZombRand(1,buildingTableLength);
    local sq = building_table[buildingPickIndex]:getRandomRoom():getRandomFreeSquare();
    return sq
end 


local function getSquareInClosestBuilding(character)
    local sourcesq = character:getCurrentSquare();
    return calcClosestBuilding(sourcesq);
end

local function removeNearbyZombies()
    local player = getPlayer();
    local zombies = getCell():getObjectList()
    if zombies == nil
        then return
    else 
    end


    for i=zombies:size(),1,-1 do
        local zombie = zombies:get(i-1)
        if instanceof(zombie, "IsoZombie") and distanceCheck(player,zombie) <= 16 then
            print("removing nearby zombie");
            zombie:removeFromWorld()
            zombie:removeFromSquare()
        end
    end
    Events.OnPlayerUpdate.Remove(removeNearbyZombies);
end


local function processTicks()

    local player = getPlayer();
    local pillowmod = player:getModData();
     if pillowmod.tick == nil or pillowmod.tick >= 10 then 
        pillowmod.tick = 1;
    elseif pillowmod.tick <= 10 then 
        pillowmod.tick = pillowmod.tick + 1;
    end
    --print("tick", pillowmod.tick);

end 

local function startTicks()
    print("starting tick function");
    Events.OnTick.Add(processTicks);
end 

local function stopTicks()
    print("stopping tick function");
    Events.OnTick.Remove(processTicks);

end 



local function pickSpawnTarget()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local cellListLength = calcTableSize(pillowmod.cellList);

    pillowmod.cellPickIndex = ZombRand(1,cellListLength);

    local xvalue = pillowmod.cellList[pillowmod.cellPickIndex].xcell;
    local yvalue = pillowmod.cellList[pillowmod.cellPickIndex].ycell;

    displayCellPick();

    pillowmod.targetXvalue = xvalue * 300 + ZombRand(0,300) + 0.5;
    pillowmod.targetYvalue = yvalue * 300 + ZombRand(0,300) + 0.5;
    print("picked Spawn Target complete");
end

local function validateSpawn()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local playersq = player:getCurrentSquare();

    if pillowmod.playerInitialized == false then
        print("player not initialized");
         return
    elseif pillowmod.validSpawn == true then
        print("spawn is valid");
        --Events.OnPlayerUpdate.Add(validSpawnCleanup);
    elseif pillowmod.spawnCount >= 3 then
        print("spawn count greater than 3, reset with new choice");
        pillowmod.spawnCount = 0;
        pickSpawnTarget();
    elseif pillowmod.pendingTP == true then
        return
    --handles when a player is standing on water
    elseif playersq ~= nil and isWater(playersq) then
        print("exception found:player on water, trying to put player on valid spot");
        pillowmod.targetXvalue = pillowmod.targetXvalue -2 ;
        pillowmod.targetYvalue = pillowmod.targetYvalue +10 ;
    --handles when a player spawns in a bad room in a building
    --2023-06-13 remove in building check pillowmod.optionInBuilding == false and           
    elseif isCharacterOutside(player) == false then
        --2023-06-13 move from elseif into this part of control to avoid errors
        --a player will only need this check if they are inside
        if hasRoomDef(playersq) == false then
            print("exception found:player in bad roomdef , trying to put player on valid spot");
            pillowmod.targetXvalue = pillowmod.targetXvalue-2 ;
            pillowmod.targetYvalue = pillowmod.targetXvalue+10 ;
        else end 
    --handles spawn in building option but building table is not loaded This might put players in a bad room, so loop back to be caught in previous statement
    elseif pillowmod.optionInBuilding == true and isCharacterOutside(player) and isBuildingListEmpty()  then 
        print("player is outside and has spawn in building option");
        print("building table was empty, moving player slightly");

        if  pillowmod.spawnCount % 2 == 0 then
            pillowmod.targetXvalue = pillowmod.targetXvalue- (pillowmod.spawnCount * 5) ;
            pillowmod.targetYvalue = pillowmod.targetYvalue+ (pillowmod.spawnCount * 5) ;
        else
            pillowmod.targetXvalue = pillowmod.targetXvalue+ (pillowmod.spawnCount * 5) ;
            pillowmod.targetYvalue = pillowmod.targetYvalue- (pillowmod.spawnCount * 5) ;
        end 
    --handles spawn in building option and the building table is populated . This might put players in a bad room, so loop back to be caught in previous statement
    elseif pillowmod.optionInBuilding == true and isCharacterOutside(player) and isBuildingListEmpty() == false  then
        print("player is outside and has spawn in building option");
        print("there is a building nearby");
        --local targetsq = getSquareInClosestBuilding(player);
        local targetsq = getSquareInRandomBuilding();
        print("building target x:" .. targetsq:getX() .. ",y:" .. targetsq:getY() );
        pillowmod.targetXvalue = targetsq:getX();
        pillowmod.targetYvalue = targetsq:getY();
    else end

    if pillowmod.optionInBuilding == false and playersq ~= nil and isWater(playersq) == false then
        pillowmod.validSpawn = true;
    elseif pillowmod.optionInBuilding == false and isCharacterOutside(player) == false then
        if hasRoomDef(playersq) == true then
            pillowmod.validSpawn = true;
        else end 
    elseif pillowmod.optionInBuilding == true and isCharacterOutside(player) == false then
        pillowmod.validSpawn = true;
    else end 

    if pillowmod.targetXvalue ~= nil and pillowmod.targetYvalue ~= nil then
        pillowmod.pendingTP = true;
        Events.OnTick.Add(teleportPlayer);
    else return 
    end

end

local function adjustOutdoorSpawnTarget()
    local player = getPlayer();
    local pillowmod = player:getModData();

    --use mod function to sweep larger adjust values
    if  pillowmod.spawnCount % 2 == 0 then
        pillowmod.adjustValue = -1 * pillowmod.spawnCount;
    else
        pillowmod.adjustValue = 1 * pillowmod.spawnCount;
    end 

    pillowmod.targetXvalue = pillowmod.targetXvalue - 10 * pillowmod.adjustValue;
    pillowmod.targetYvalue = pillowmod.targetYvalue + 10 * pillowmod.adjustValue;    
    print("outdoor target x:" .. pillowmod.targetXvalue .. ",y:" .. pillowmod.targetYvalue );
    Events.OnPlayerUpdate.Remove(adjustOutdoorSpawnTarget);
end

local function adjustIndoorSpawnTarget()
    local player = getPlayer();
    local pillowmod = player:getModData();
    if isBuildingListEmpty() == true then 
        pickSpawnTarget();
        print("TRS event processor : adjust spawn target : building list empty, picking new target");
    else
        print("TRS event processor : adjust spawn target : pick random square in building");
        local targetsq = getSquareInClosestBuilding(player);
        print("building target x:" .. targetsq:getX() .. ",y:" .. targetsq:getY() );
        pillowmod.targetXvalue = targetsq:getX();
        pillowmod.targetYvalue = targetsq:getY();
    end 
    Events.OnPlayerUpdate.Remove(adjustIndoorSpawnTarget);

end

local function adjustSpawnTarget()
    local player = getPlayer();
    local pillowmod = player:getModData();
    --processing logic
    --1. handle first spawn
    --2. handle retargeting
    --3. handle in building target
    --4. handle anywhere target

    --handle first spawn
    if pillowmod.spawnCount == 0 then
        pickSpawnTarget();
    elseif pillowmod.spawnCount >= 5 then
        pillowmod.spawnCount = 1;
        pickSpawnTarget();
    elseif pillowmod.optionInBuilding == true then
        Events.OnPlayerUpdate.Add(adjustIndoorSpawnTarget);
        print("TRS event processor : adjust spawn target : adjust indoor target");
    elseif pillowmod.optionInBuilding == false then
        print("TRS event processor : adjust spawn target : adjust outdoor target");
        Events.OnPlayerUpdate.Add(adjustOutdoorSpawnTarget);
    else end

    pillowmod.pendingTP = true;
    Events.OnPlayerUpdate.Remove(adjustSpawnTarget);
end 



local function checkValidSpawn()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local playersq = player:getCurrentSquare();
    print("TRS event processor : start check valid spawn function");
    print("TRS Debug: playersq:", playersq)
    print("TRS Debug: optionInBuilding:", pillowmod.optionInBuilding )
    print("TRS Debug: isCharacterOutside:", isCharacterOutside(player))


    if playersq == nil then
        pillowmod.validSpawn = false;
        print("TRS event processor: check valid spawn : player is nil");
    --optionInBuilding false, outside, water check
    elseif pillowmod.optionInBuilding == false and isWater(playersq) == false then
        pillowmod.validSpawn = true;
        print("TRS event processor: check valid spawn : player is outside and not on water");
    --optionInBuilding falsee, inside, valid room check
    elseif pillowmod.optionInBuilding == false and isCharacterOutside(player) == false then
        if hasRoomDef(playersq) == true then
            pillowmod.validSpawn = true;
        print("TRS event processor: check valid spawn : player is inside with valid room defintion");
        else end 
    elseif pillowmod.optionInBuilding == true and isCharacterOutside(player) == false then 
        if hasRoomDef(playersq) == true then
            pillowmod.validSpawn = true;
        print("TRS event processor: check valid spawn : spawn option in building player is inside with valid room defintion");
        else end 
    else
        print("TRS event processor: check valid spawn : player has not passed any other check, default to validspawn false");
        pillowmod.validSpawn = false;
    end 

    Events.OnPlayerUpdate.Remove(checkValidSpawn);

end

local function validSpawnCleanup()
        print("process valid spawn cleanup functions");
        local player = getPlayer();
        local pillowmod = player:getModData();
        --Events.OnTick.Remove(processTicks);
        --Events.OnTick.Remove(trueRandomSpawnsEventProcessor);
        Events.OnTick.Remove(teleportPlayer);
        Events.OnPlayerUpdate.Remove(validateSpawn);        
        Events.OnPlayerUpdate.Remove(adjustSpawnTarget);
        Events.OnPlayerUpdate.Remove(adjustOutdoorSpawnTarget);
        Events.LoadGridsquare.Remove(addBuildingList);
        Events.ReuseGridsquare.Remove(removeBuildingList);
        Events.OnPostFloorLayerDraw.Remove(FloorDrawCheck);
        pillowmod.pendingTP = false; 
        pillowmod.finalizedSpawn = false;
        Events.OnPlayerUpdate.Remove(validSpawnCleanup)
end 

local function trueRandomSpawnsEventProcessor()
    --first spawn requires tp , force first spawn with init validspawn false
    --validate spot
    --if valid stop
    local player = getPlayer();
    local pillowmod = player:getModData();
    local playersq = player:getCurrentSquare();

    if pillowmod.validSpawn == true then
        print("TRS event processor :  spawn is valid");
        Events.OnPlayerUpdate.Add(removeNearbyZombies);
        Events.OnTick.Remove(processTicks);
        Events.OnTick.Remove(trueRandomSpawnsEventProcessor);
        Events.OnPlayerUpdate.Remove(validSpawnCleanup);
    elseif pillowmod.tick  > 0 and pillowmod.tick == 3 then
        print("TRS event processor : check valid spawn");
        Events.OnPlayerUpdate.Add(checkValidSpawn);
    elseif pillowmod.validSpawn == false and pillowmod.floorDrawn == true and pillowmod.tick == 5 then
        print("TRS event processor : adjust spawn");
        Events.OnPlayerUpdate.Add(adjustSpawnTarget);
    elseif pillowmod.pendingTP == true and pillowmod.floorDrawn == true and pillowmod.tick == 9  then
        print("TRS event processor : add teleport");
        Events.OnTick.Add(teleportPlayer);
    else
    end 

end



local function initializeTrueRandomSpawn()
    local player = getPlayer();
    local pillowmod = player:getModData();
    print("initializing true random spawns mod");
    pillowmod.settingsApplied = false;
    pillowmod.cellListInitialized = false;

    print("initalizing mod settings");
    intializeTrueRandomSpawnSettings();
    initializeCellPickList();
    --pickSpawnTarget();
    --start tick processing, and event processing

    startTicks();
    Events.OnPostFloorLayerDraw.Add(FloorDrawCheck);
    Events.OnTick.Add(trueRandomSpawnsEventProcessor);



end

local function intializeTrueRandomSpawnPlayerSettings()
    local player = getPlayer();
    local pillowmod = player:getModData();
    if pillowmod.finalizedSpawn == true then
        validSpawnCleanup(); 
    elseif pillowmod.playerInitialized == nil then
        pillowmod.spawnCount = 0;
        pillowmod.tick = 0;       
        pillowmod.validSpawn = false; 
        pillowmod.playerInitialized = true;
        pillowmod.pendingTP = false;
        pillowmod.finalizedSpawn = false;
    else end

end 



local function debugSpawn(key)
    if key == Keyboard.KEY_F9  then
        print("debug select new spawn");
        local player = getPlayer();
        local pillowmod = player:getModData();
        pillowmod.validSpawn = false; 
        pillowmod.spawnCount = 10;
        startTicks();
        Events.LoadGridsquare.Add(addBuildingList);
        Events.ReuseGridsquare.Add(removeBuildingList);
        Events.OnTick.Add(trueRandomSpawnsEventProcessor);
    elseif key == Keyboard.KEY_DELETE then
        print("debug remove zombies");
        Events.OnPlayerUpdate.Add(removeNearbyZombies);
    else end
end

local function testOnPostFloorLayerDraw()

    print("TRS testOnPostFloorLayerDraw");
end 





--Events

--Events.OnPostFloorLayerDraw.Add(countFloorLayerDraw);

Events.LoadGridsquare.Add(addBuildingList);
Events.ReuseGridsquare.Add(removeBuildingList);

Events.OnGameStart.Add(initializeTrueRandomSpawn); --required to reinitialize when starting a new game.
Events.OnCreatePlayer.Add(intializeTrueRandomSpawnPlayerSettings); 

--debug
Events.OnKeyPressed.Add(debugSpawn);