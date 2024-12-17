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


--read from sandbox settings
local function intializeTrueRandomSpawnSettings()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local worldModData = getGameTime():getModData()
    --pillowmod.validSpawn = false; 
    worldModData.optionInBuilding = false;
    worldModData.optionNearCiv = false;
    worldModData.optionNearRoad = false;
    worldModData.optionWildCamp = false;
    worldModData.optionWildDeep = false;
    worldModData.optionAnywhere = false;

    pillowmod.optionSelection = SandboxVars.TRS.optionSelection;
    print("true random spawns sandbox option selection :" ,pillowmod.optionSelection);

    if  SandboxVars.TRS.optionSelection == 1 then
        worldModData.optionInBuilding = true;
    elseif SandboxVars.TRS.optionSelection == 2 then
        worldModData.optionNearCiv = true;
    elseif SandboxVars.TRS.optionSelection == 3 then
        worldModData.optionNearRoad = true;
    elseif SandboxVars.TRS.optionSelection == 4 then 
        worldModData.optionWildCamp = true;
    elseif SandboxVars.TRS.optionSelection == 5 then
        worldModData.optionWildDeep = true;
    else
        worldModData.optionAnywhere = true;
    end 

    print("===============true random spawns debug options===============")
    print("optionInBuilding = ",  worldModData.optionInBuilding);
    print("optionNearCiv = ", worldModData.optionNearCiv);
    print("optionNearRoad = ", worldModData.optionNearRoad);
    print("optionWildCamp = ", worldModData.optionWildCamp);
    print("optionWildDeep = ", worldModData.optionWildDeep);
    print("optionAnywhere = ", worldModData.optionAnywhere);

    worldModData.settingsApplied = true;

end 

--filters spawn cell selection table based on settings
local function filterCellPickList(filterTable)
    --local player = getPlayer();
    --local pillowmod = player:getModData();
    local worldModData = getGameTime():getModData()
    local i = 1;

    while i <= #filterTable do
        --handles in building or near civ, building loop is later
        --nearciv = 1, 0 no 
        if (worldModData.optionInBuilding == true  or worldModData.optionNearCiv == true ) 
            and filterTable[i].nearCiv ~= 1 then
            --print("removing record from pick list " .. filterTable[i].xcell .. ",".. filterTable[i].ycell );
            print("removing:")
            print("cell xy:" .. worldModData.cellList[i].xcell .. "," .. worldModData.cellList[i].ycell);
            print("nearRoad:" .. worldModData.cellList[i].nearRoad .. " ,  nearCiv:" .. worldModData.cellList[i].nearCiv .. ", civDist:".. worldModData.cellList[i].civDist);
            print("poi:" .. worldModData.cellList[i].poi);
            table.remove(filterTable, i);
        --handles near road 
        elseif worldModData.optionNearRoad == true and filterTable[i].nearRoad == 0 then
            --print("removing record from pick list " .. filterTable[i].xcell .. ",".. filterTable[i].ycell );
            print("removing:")
            print("cell xy:" .. worldModData.cellList[i].xcell .. "," .. worldModData.cellList[i].ycell);
            print("nearRoad:" .. worldModData.cellList[i].nearRoad .. " ,  nearCiv:" .. worldModData.cellList[i].nearCiv .. ", civDist:".. worldModData.cellList[i].civDist);
            print("poi:" .. worldModData.cellList[i].poi);
            table.remove(filterTable, i);
        --handles near camp
        elseif worldModData.optionWildCamp == true 
            and (filterTable[i].poi ~= "Cabin" and filterTable[i].poi ~= "Camp")  then 
            --print("removing record from pick list " .. filterTable[i].xcell .. ",".. filterTable[i].ycell );
            print("removing:")
            print("cell xy:" .. worldModData.cellList[i].xcell .. "," .. worldModData.cellList[i].ycell);
            print("nearRoad:" .. worldModData.cellList[i].nearRoad .. " ,  nearCiv:" .. worldModData.cellList[i].nearCiv .. ", civDist:".. worldModData.cellList[i].civDist);
            print("poi:" .. worldModData.cellList[i].poi);
            table.remove(filterTable, i);   
        --handles deep woods
        elseif worldModData.optionWildDeep == true and filterTable[i].nearRoad == 1 and filterTable[i].civDist <= 3
            then
            --print("removing record from pick list " .. filterTable[i].xcell .. ",".. filterTable[i].ycell );
            print("removing:")
            print("cell xy:" .. worldModData.cellList[i].xcell .. "," .. worldModData.cellList[i].ycell);
            print("nearRoad:" .. worldModData.cellList[i].nearRoad .. " ,  nearCiv:" .. worldModData.cellList[i].nearCiv .. ", civDist:".. worldModData.cellList[i].civDist);         
            print("poi:" .. worldModData.cellList[i].poi);
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

--sets up and calls filter cell pick list for further use
local function initializeCellPickList()
    --local player = getPlayer();
    --local pillowmod = player:getModData();
    local worldModData = getGameTime():getModData()

    worldModData.cellList = cellPickList();
    --cellList = cellPickList();
    print("init cell list size:");
    print(calcTableSize(worldModData.cellList));

    worldModData.cellList = filterCellPickList(worldModData.cellList);
    print("post filter cell list size:");

    print(calcTableSize(worldModData.cellList));
    worldModData.cellListInitialized = true;
    print("cellListInitialized", worldModData.cellListInitialized);
end 


local function displayCellPick()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local worldModData = getGameTime():getModData()

    local i = pillowmod.cellPickIndex
    print("----------------CELL PICK DISPLAY----------------");
    print("cell xy:" .. worldModData.cellList[i].xcell .. "," .. worldModData.cellList[i].ycell);
    print("nearRoad:" .. worldModData.cellList[i].nearRoad .. " ,  nearCiv:" .. worldModData.cellList[i].nearCiv .. ", civDist:".. worldModData.cellList[i].civDist);
    print("----------------CELL PICK DISPLAY----------------");
end 

--Floor draw check function gets called when the floor is drawn meaning the map is current 
--enough for the game to determine the player's current square
local function FloorDrawCheck()
    local player = getPlayer();
    local pillowmod = player:getModData();
    if pillowmod.floorDrawn == nil or pillowmod.floorDrawn == false then
        pillowmod.floorDrawn = true;
    end
end 

--reset the floor draw chance, used after teleporting
local function ResetFloorDrawCheck()
    local player = getPlayer();
    local pillowmod = player:getModData();
    print("floor drawn reset value");
    pillowmod.floorDrawn = false;
end


local function teleportPlayer()

    local player = getPlayer();
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

function removeNearbyZombies()
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


function processTicks()

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


--picks a spawn point based on the filtered cell pick list
function pickSpawnTarget()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local worldModData = getGameTime():getModData()
    local cellListLength = calcTableSize(worldModData.cellList);

    pillowmod.cellPickIndex = ZombRand(1,cellListLength);

    local xvalue = worldModData.cellList[pillowmod.cellPickIndex].xcell;
    local yvalue = worldModData.cellList[pillowmod.cellPickIndex].ycell;

    displayCellPick();

    pillowmod.targetXvalue = xvalue * 300 + ZombRand(0,300) + 0.5;
    pillowmod.targetYvalue = yvalue * 300 + ZombRand(0,300) + 0.5;
    print("picked Spawn Target complete");
end

--OLD validate spawn function, deprecated.
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

--adjust outdoor spawn, called when it is on water or in a bad room
--function sweeps back and forth
function adjustOutdoorSpawnTarget()
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

--adjust indoor spawn, checking if there are buildings nearby or not
--they are are not just pick a new spawn target
function adjustIndoorSpawnTarget()
    local player = getPlayer();
    local pillowmod = player:getModData();
    if isBuildingListEmpty() == true then 
        pickSpawnTarget();
        print("TRS event processor : adjust spawn target : building list empty, picking new target");
    else
        print("TRS event processor : adjust spawn target : pick random square in building");
        local targetsq = getSquareInClosestBuilding(player);
        --2023-06-22 add to avoid error spam with this
        if targetsq ~= nil then
            print("building target x:" .. targetsq:getX() .. ",y:" .. targetsq:getY() );
            pillowmod.targetXvalue = targetsq:getX();
            pillowmod.targetYvalue = targetsq:getY();
        else end
    end 
    Events.OnPlayerUpdate.Remove(adjustIndoorSpawnTarget);

end

--handles adjustments to spawn location
function adjustSpawnTarget()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local worldModData = getGameTime():getModData()
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
    elseif worldModData.optionInBuilding == true then
        Events.OnPlayerUpdate.Add(adjustIndoorSpawnTarget);
        print("TRS event processor : adjust spawn target : adjust indoor target");
    elseif worldModData.optionInBuilding == false then
        print("TRS event processor : adjust spawn target : adjust outdoor target");
        Events.OnPlayerUpdate.Add(adjustOutdoorSpawnTarget);
    else end

    pillowmod.pendingTP = true;
    Events.OnPlayerUpdate.Remove(adjustSpawnTarget);
end 


--valid spawn check function, this is the current one. 
--toggles valid spawn in various cases
--LOGIC
--1. player square is not loaded, invalid spawn (mostly to avoid spamming errors)
--2. player does not care about spawning in a building, but spawns on water, inalid spawn
--3. player does not care about spawning in a building, but has, check for valid room defintion
--3.a current ones found in testing "empty" and "traincar" are problematic
--4. player wants to spawn in a building, and is in on. Check for valid room based on 3a.
--5. anything else is considered invalid
function checkValidSpawn()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local playersq = player:getCurrentSquare();
    local worldModData = getGameTime():getModData()
    print("TRS event processor : start check valid spawn function");
    print("TRS Debug: playersq:", playersq)
    print("TRS Debug: optionInBuilding:", worldModData.optionInBuilding )
    print("TRS Debug: isCharacterOutside:", isCharacterOutside(player))


    if playersq == nil then
        pillowmod.validSpawn = false;
        print("TRS event processor: check valid spawn : player is nil");
    --optionInBuilding false, outside, water check
    elseif worldModData.optionInBuilding == false and isWater(playersq) == false then
        pillowmod.validSpawn = true;
        print("TRS event processor: check valid spawn : player is outside and not on water");
    --optionInBuilding falsee, inside, valid room check
    elseif worldModData.optionInBuilding == false and isCharacterOutside(player) == false then
        if hasRoomDef(playersq) == true then
            pillowmod.validSpawn = true;
        print("TRS event processor: check valid spawn : player is inside with valid room defintion");
        else end 
    elseif worldModData.optionInBuilding == true and isCharacterOutside(player) == false then 
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

--cleans up all of the helper functions running to reduce lag
function validSpawnCleanup()
        print("process valid spawn cleanup functions");
        local player = getPlayer();
        local pillowmod = player:getModData();
        --Events.OnTick.Remove(processTicks);
        --Events.OnTick.Remove(trueRandomSpawnsEventProcessor);
        Events.OnTick.Remove(teleportPlayer);
        Events.OnPlayerUpdate.Remove(validateSpawn); 
        Events.OnPlayerUpdate.Remove(checkValidSpawn);       
        Events.OnPlayerUpdate.Remove(adjustSpawnTarget);
        Events.OnPlayerUpdate.Remove(adjustOutdoorSpawnTarget);
        Events.LoadGridsquare.Remove(addBuildingList);
        Events.ReuseGridsquare.Remove(removeBuildingList);
        Events.OnPostFloorLayerDraw.Remove(FloorDrawCheck);
        pillowmod.pendingTP = false; 
        pillowmod.finalizedSpawn = true;
        Events.OnPlayerUpdate.Remove(validSpawnCleanup)
end 

--event processor, relies on tick function running
--processing order 
--1. check for a valid spawn being true, if so, start clean up 
--2. call for check valid spawn
--3. call for adjusting an invalid spawn
--4. call for teleport function to adjusted spawn point
function trueRandomSpawnsEventProcessor()
    --first spawn requires tp , force first spawn with init validspawn false
    --validate spot
    --if valid stop
    local player = getPlayer();
    local pillowmod = player:getModData();
    local playersq = player:getCurrentSquare();

    if pillowmod.validSpawn == true then
        print("TRS event processor :  spawn is valid");
        Events.OnPlayerUpdate.Add(removeNearbyZombies);
        Events.OnTick.Remove(trueRandomSpawnsEventProcessor);
        stopTicks(); --Events.OnTick.Remove(processTicks);
        player:setInvisible(false);
        player:setZombiesDontAttack(false);
        --06-14-2023 this logic seems incorrect but works. Maybe need to add the function instead of remove
        Events.OnPlayerUpdate.Add(validSpawnCleanup);
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


--initiate the mod itself, sets up the actual settings which feed into the filtering functions
function initializeTrueRandomSpawn()
    local player = getPlayer();
    local pillowmod = player:getModData();
    local worldModData = getGameTime():getModData();
    print("TRS event : initializing true random spawns mod");
    worldModData.settingsApplied = false;
    worldModData.cellListInitialized = false;

    print("TRS event : initalizing true random spawns  mod settings");
    intializeTrueRandomSpawnSettings();
    if  pillowmod.finalizedSpawn == nil then
    elseif   pillowmod.finalizedSpawn == true then return else end
    initializeCellPickList();
    --pickSpawnTarget();
    --start tick processing, and event processing

    startTicks();
    Events.OnPostFloorLayerDraw.Add(FloorDrawCheck);
    Events.OnTick.Add(trueRandomSpawnsEventProcessor);

    Events.LoadGridsquare.Add(addBuildingList);
    Events.ReuseGridsquare.Add(removeBuildingList);

end
 
function restartProcessing()
    print("TRS Event : restart processing.");
    startTicks();
    intializeTrueRandomSpawnSettings();
    initializeCellPickList();
    Events.OnPostFloorLayerDraw.Add(FloorDrawCheck);
    Events.OnTick.Add(trueRandomSpawnsEventProcessor);    
    Events.LoadGridsquare.Add(addBuildingList);
    Events.ReuseGridsquare.Add(removeBuildingList);
end

function intializeTrueRandomSpawnPlayerSettings()
    print("TRS Event : initalize player settings")
    local player = getPlayer();
    local pillowmod = player:getModData();
    if pillowmod.playerInitialized == true then
        return
    elseif 
        pillowmod.playerInitialized == nil  then
        print("TRS Event : new game player setting initialization")
        pillowmod.spawnCount = 0;
        pillowmod.tick = 0;       
        pillowmod.validSpawn = false; 
        pillowmod.playerInitialized = true;
        pillowmod.pendingTP = false;
        pillowmod.finalizedSpawn = false;
        pillowmod.playerDied = false;
        player:setInvisible(true);
        player:setZombiesDontAttack(true);
    elseif  pillowmod.playerInitialized == false then
        print("TRS Event : player initalized = false, game player setting initialization")
        pillowmod.spawnCount = 0;
        pillowmod.tick = 0;       
        pillowmod.validSpawn = false; 
        pillowmod.playerInitialized = true;
        pillowmod.pendingTP = false;
        pillowmod.finalizedSpawn = false;
        pillowmod.playerDied = false;  
        player:setInvisible(true);
        player:setZombiesDontAttack(true);    
        restartProcessing();  
    end

end 

 
function resetTrueRandomSpawnsPlayerSettings()
    print("TRS event : reset player settings");
    local player = getPlayer();
    local pillowmod = player:getModData();
    pillowmod.playerInitialized = false;
end



function debugSpawn(key)
    if key == Keyboard.KEY_F9  then
        print("debug select new spawn");
        local player = getPlayer();
        local pillowmod = player:getModData();
        pillowmod.validSpawn = false;
        pillowmod.finalizedSpawn = false; 
        pillowmod.spawnCount = 0;
        startTicks();
        Events.OnPostFloorLayerDraw.Add(FloorDrawCheck);
        Events.OnTick.Add(trueRandomSpawnsEventProcessor);
        Events.LoadGridsquare.Add(addBuildingList);
        Events.ReuseGridsquare.Add(removeBuildingList);
    elseif key == Keyboard.KEY_DELETE then
        print("debug remove zombies");
        Events.OnPlayerUpdate.Add(removeNearbyZombies);
    else end
end


--Events

--Events.OnPostFloorLayerDraw.Add(countFloorLayerDraw);

--2023-06-22 remove gridsquare functions from here and turn them on during initilization
--Events.LoadGridsquare.Add(addBuildingList);
--Events.ReuseGridsquare.Add(removeBuildingList);

Events.OnGameTimeLoaded.Add(initializeTrueRandomSpawn); --required to reinitialize when starting a new game.

--Initializing settings on create player seems to be the best way
Events.OnCreatePlayer.Add(intializeTrueRandomSpawnPlayerSettings);
Events.OnNewGame.Add(intializeTrueRandomSpawnPlayerSettings);

Events.OnPlayerDeath.Add(resetTrueRandomSpawnsPlayerSettings);


--debug
Events.OnKeyPressed.Add(debugSpawn);