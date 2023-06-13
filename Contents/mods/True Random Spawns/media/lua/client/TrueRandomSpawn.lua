building_table = {};
cellList = {};

--TRUE RANDOM SPAWNS alpha v1
--STREAM RELEASE 2023-06-13
--DEBUG FUNCTIONS STILL ENABLED using f9 key to respawn.

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

    pillowmod.validSpawn = false; 
    pillowmod.optionInBuilding = false;
    pillowmod.optionNearCiv = false;
    pillowmod.optionNearRoad = false;
    pillowmod.optionWildCamp = false;
    pillowmod.optionNearRoad = false;
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
    print("optionNearRoad = ", pillowmod.optionWildDeep);
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
    if square:getRoom():getRoomDef():getName() ~= "empty" or square:getRoom() == nil then
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
    local buildingPickIndex = ZombRand(1,buildingTableLength);
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
    end
    for i=zombies:size(),1,-1 do
        local zombie = zombies:get(i-1)
        if instanceof(zombie, "IsoZombie") and distanceCheck(player,zombie) <= 32 then
            print("removing nearby zombie");
            zombie:removeFromWorld()
            zombie:removeFromSquare()
        end
    end
end



--this function can cause lag , once the player is given a valid spawn, remove it as a lua event
local function checkValidSpot()

    print("checking player spot validity");


    local player = getPlayer();
    local pillowmod = player:getModData();
    local playersq = player:getCurrentSquare();
    print("pillowmod.optionInBuilding:" , pillowmod.optionInBuilding);
    print("is player outside:" , isCharacterOutside(player));


    --2023-06-13 remove the checks for spawn attempted
    if pillowmod.validSpawn == true then
        Events.OnPlayerUpdate.Remove(checkValidSpot);
        removeNearbyZombies();
        print("valid spawn:" , pillowmod.validSpawn);
        print("removing checkValidSpot from OnPlayerUpdate");
        return
    --2023-06-13 add this check for too many spawn attempts, reset and pick a new spawn
    elseif pillowmod.spawnCount >= 10 then
        pillowmod.spawnCount = 0;
        local cellListLength = calcTableSize(pillowmod.cellList);
        pillowmod.cellPickIndex = ZombRand(1,cellListLength);
        local xvalue = pillowmod.cellList[pillowmod.cellPickIndex].xcell;
        local yvalue = pillowmod.cellList[pillowmod.cellPickIndex].ycell;
        --print("xcell pick:".. xvalue .. " ycell pick:" .. yvalue);
        displayCellPick();
        --xvalue = xvalue * 300 + ZombRand(0,300) + 0.5;
        --yvalue = yvalue * 300 + ZombRand(0,300) + 0.5;
        pillowmod.targetXvalue = xvalue * 300 + ZombRand(0,300) + 0.5;
        pillowmod.targetYvalue = yvalue * 300 + ZombRand(0,300) + 0.5;

    else  
   
        --handles when a player is standing on water
        --2023-06-13 remove inbuildingoption check pillowmod.optionInBuilding == false and
        if playersq ~= nil and isWater(playersq) 
        then
            print("exception found:player on water, trying to put player on valid spot");
            pillowmod.targetXvalue = playersq:getX()-2 ;
            pillowmod.targetYvalue = playersq:getY()+10 ;


        --handles when a player spawns in a bad room in a building
        --2023-06-13 remove in building check pillowmod.optionInBuilding == false and           
        elseif isCharacterOutside(player) == false
        then
            --2023-06-13 move from elseif into this part of control to avoid errors
            --a player will only need this check if they are inside
            if hasRoomDef(playersq) == false then
                print("exception found:player in bad roomdef , trying to put player on valid spot");
                pillowmod.targetXvalue = playersq:getX()-2 ;
                pillowmod.targetYvalue = playersq:getY()+10 ;
            else end 

        --handles spawn in building option but building table is not loaded This might put players in a bad room, so loop back to be caught in previous statement
        elseif pillowmod.optionInBuilding == true and isCharacterOutside(player) and isBuildingListEmpty()  then 
            print("player is outside and has spawn in building option");
            print("building table was empty, moving player slightly");

            if  pillowmod.spawnCount % 2 == 0 then
                pillowmod.targetXvalue = playersq:getX()- (pillowmod.spawnCount * 2) ;
                pillowmod.targetYvalue = playersq:getY()+ (pillowmod.spawnCount * 2) ;
            else
                pillowmod.targetXvalue = playersq:getX()+ (pillowmod.spawnCount * 2) ;
                pillowmod.targetYvalue = playersq:getY()- (pillowmod.spawnCount * 2) ;
            end 

        --handles spawn in building option and the building table is populated . This might put players in a bad room, so loop back to be caught in previous statement
        elseif pillowmod.optionInBuilding == true and isCharacterOutside(player) and isBuildingListEmpty() == false  then
            print("player is outside and has spawn in building option");
            print("there is a building nearby");
            local targetsq = getSquareInClosestBuilding(player);
            print("building target x:" .. targetsq:getX() .. ",y:" .. targetsq:getY() );
            pillowmod.targetXvalue = targetsq:getX();
            pillowmod.targetYvalue = targetsq:getY();
        else
            --2023-06-13 this else statement is not triggering correctly
            --change to add validspawn = false to all else statements and make a function below to 
            --recheck all of the conditions
            --print("player position is valid after adjustments");
            --pillowmod.validSpawn = true;
        end 
    end

    if pillowmod.optionInBuilding == false and playersq ~= nil and isWater(playersq) == false then
        pillowmod.validSpawn = true;
    elseif pillowmod.optionInBuilding == false and isCharacterOutside(player) == false then
        if hasRoomDef(playersq) == false then
            pillowmod.validSpawn = true;
        else end 
    elseif pillowmod.optionInBuilding == true and isCharacterOutside(player) == false then
        pillowmod.validSpawn = true;
    else end 

    if pillowmod.targetXvalue ~= nil and pillowmod.targetYvalue ~= nil then
        Events.OnTick.Add(teleportPlayer);
    else return 
    end


end 

--function only used for setting the first spawn attempt, and utilized in debugging
local function pickSpawn()


local player = getPlayer();
local pillowmod = player:getModData();
local playersq = player:getCurrentSquare();

--turn off local cell list, use pre-sorted one
--cellList = cellPickList();
--cellList = filterCellPickList(cellList);

local cellListLength = calcTableSize(pillowmod.cellList);

pillowmod.cellPickIndex = ZombRand(1,cellListLength);

local xvalue = pillowmod.cellList[pillowmod.cellPickIndex].xcell;
local yvalue = pillowmod.cellList[pillowmod.cellPickIndex].ycell;
--print("xcell pick:".. xvalue .. " ycell pick:" .. yvalue);
displayCellPick();

--xvalue = xvalue * 300 + ZombRand(0,300) + 0.5;
--yvalue = yvalue * 300 + ZombRand(0,300) + 0.5;
pillowmod.targetXvalue = xvalue * 300 + ZombRand(0,300) + 0.5;
pillowmod.targetYvalue = yvalue * 300 + ZombRand(0,300) + 0.5;

Events.OnTick.Add(teleportPlayer);


removeNearbyZombies();

giveRarePillow();

end 



local function initializeTrueRandomSpawn()
    --print('using spawn region '..tostring(spawnRegion.name));
    local player = getPlayer();
    local pillowmod = player:getModData();
    pillowmod.validSpawn = false;
    pillowmod.spawnCount = 0;
    print("spawncount:" .. pillowmod.spawnCount);
    print("settingsApplied = ", pillowmod.settingsApplied);
    print("cellListInitialized = ", pillowmod.cellListInitialized);
    print("spawnAttempted = ", pillowmod.spawnAttempted);

    print("initializing true random spawns mod");
    if pillowmod.settingsApplied == nil or pillowmod.settingsApplied == false then
        print("initalizing mod settings");
        intializeTrueRandomSpawnSettings();
    elseif pillowmod.cellListInitialized == nil or pillowmod.cellListInitialized == false then 
        print("initalizing cell pick list");
        initializeCellPickList(); 
    elseif pillowmod.spawnAttempted == nil or pillowmod.spawnAttempted == false then
        print("attempting first spawn");
        pickSpawn();
        pillowmod.spawnAttempted = true;
    else 
        Events.OnCreatePlayer.Remove(initializeTrueRandomSpawn);
    end 
end


local function debugSpawn(key)
    if key == Keyboard.KEY_F9  then
        local player = getPlayer();
        local pillowmod = player:getModData();
        pillowmod.validSpawn = false;
        pillowmod.spawnCount = 11;
        building_table = {}; --reset building table
        print("spawncount:" .. pillowmod.spawnCount);
        print("debug spawn");
        Events.OnPlayerUpdate.Add(checkValidSpot);  
        --pickSpawn();
    elseif key == Keyboard.KEY_DELETE then
        print("debug remove zombies");
        removeNearbyZombies();
    else end
end

--events

--change to onTick 2023-06-13
--Events.OnPlayerUpdate.Add(checkValidSpot);
Events.OnPlayerUpdate.Add(checkValidSpot);



Events.OnCreatePlayer.Add(initializeTrueRandomSpawn); --required to reinitialize when starting a new game.
--Events.OnCreatePlayer.Add(intializeTrueRandomSpawnSettings);
--Events.OnCreatePlayer.Add(initializeCellPickList);
--Events.OnCreatePlayer.Add(pickSpawn);

--change control flow to use this funcction below instead of the 3 above.
--Events.OnCreatePlayer.Add(initializeTrueRandomSpawn);
--change to on player update
--2023-06-13 change to on tick
--Events.OnPlayerUpdate.Add(initializeTrueRandomSpawn);
Events.OnCreatePlayer.Add(initializeTrueRandomSpawn);

--gridsquare functions that were modified from original fear the rain.
Events.LoadGridsquare.Add(addBuildingList);
Events.ReuseGridsquare.Add(removeBuildingList);

--debug
Events.OnKeyPressed.Add(debugSpawn);
