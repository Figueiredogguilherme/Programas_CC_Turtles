-- Tunneler code for Create Astral modpack
    -- Code adapated from 'ComputerCraft DFS Mining' from '0XSHAWN' in pastebin



-- 🗺️ Variable declaration
-- =================================

-- Block type used to fill the holes after mining
local FILL_BLOCKS = {
  ["minecraft:cobblestone"]=true,
  ["minecraft:granite"]=true,
  ["minecraft:diorite"]=true,
  ["minecraft:andesite"]=true,
  ["minecraft:cobbled_deepslate"]=true,
["minecraft:tuff"]=true,
  ["minecraft:dirt"]=true,
  ["ad_astra:moon_cobblestone"]=true,
  ["ad_astra:mars_cobblestone"]=true,
  ["ad_astra:venus_cobblestone"]=true,
  ["ad_astra:mercury_cobblestone"]=true,
  ["ad_astra:glacio_cobblestone"]=true,
}

-- Table containing the whitelist of ores to mine
local ORES_WHITELIST = {
  ["minecraft:copper_ore"]=true,
  ["minecraft:deepslate_copper_ore"]=true,
  ["minecraft:gold_ore"]=true,
  ["minecraft:deepslate_gold_ore"]=true,
  ["minecraft:iron_ore"]=true,
  ["minecraft:deepslate_iron_ore"]=true,
  ["minecraft:coal_ore"]=true,
  ["minecraft:deepslate_coal_ore"]=true,
  ["minecraft:redstone_ore"]=true,
  ["minecraft:deepslate_redstone_ore"]=true,
  ["minecraft:emerald_ore"]=true,
  ["minecraft:deepslate_emerald_ore"]=true,
  ["minecraft:diamond_ore"]=true,
  ["minecraft:deepslate_diamond_ore"]=true,
  ["minecraft:lapis_ore"]=true,
  ["minecraft:deepslate_lapis_ore"]=true,
  ["minecraft:nether_gold_ore"]=true,
  ["minecraft:nether_quartz_ore"]=true,
  ["minecraft:ancient_debris"]=true,
  ["ad_astra:moon_iron_ore"]=true,
  ["ad_astra:moon_ice_shard_ore"]=true,
  ["ad_astra:deepslate_ice_shard_ore"]=true,
  ["ad_astra:moon_cheese_ore"]=true,
  ["ad_astra:moon_desh_ore"]=true,
  ["ad_astra:deepslate_desh_ore"]=true,
  ["ad_astra:mars_iron_ore"]=true,
  ["ad_astra:mars_diamond_ore"]=true,
  ["ad_astra:mars_ostrum_ore"]=true,
  ["ad_astra:deepslate_ostrum_ore"]=true,
  ["ad_astra:mars_ice_shard_ore"]=true,
  ["ad_astra:venus_coal_ore"]=true,
  ["ad_astra:venus_gold_ore"]=true,
  ["ad_astra:venus_diamond_ore"]=true,
  ["ad_astra:venus_calorite_ore"]=true,
  ["ad_astra:deepslate_calorite_ore"]=true,
  ["ad_astra:mercury_iron_ore"]=true,
  ["ad_astra:glacio_ice_shard_ore"]=true,
  ["ad_astra:glacio_coal_ore"]=true,
  ["ad_astra:glacio_copper_ore"]=true,
  ["ad_astra:glacio_iron_ore"]=true,
  ["ad_astra:glacio_lapis_ore"]=true,
  ["create:zinc_ore"]=true,
  ["create:deepslate_zinc_ore"]=true,
  ["techreborn:bauxite_ore"]=true,
  ["techreborn:deepslate_bauxite_ore"]=true,
  ["techreborn:ruby_ore"]=true,
  ["techreborn:deepslate_ruby_ore"]=true,
  ["techreborn:sapphire_ore"]=true,
  ["techreborn:deepslate_sapphire_ore"]=true,
  ["techreborn:tin_ore"]=true,
  ["techreborn:deepslate_tin_ore"]=true,
  ["techreborn:cinnabar_ore"]=true,
  ["techreborn:galena_ore"]=true,
  ["techreborn:deepslate_galena_ore"]=true,
  ["techreborn:iridium_ore"]=true,
  ["techreborn:pyrite_ore"]=true,
  ["techreborn:lead_ore"]=true,
  ["techreborn:peridot_ore"]=true,
  ["techreborn:deepslate_peridot_ore"]=true,
  ["techreborn:sheldonite_ore"]=true,
  ["techreborn:deepslate_sheldonite_ore"]=true,
  ["techreborn:silver_ore"]=true,
  ["techreborn:deepslate_silver_ore"]=true,
  ["techreborn:tungsten_ore"]=true,
  ["techreborn:deepslate_tungsten_ore"]=true,
  ["techreborn:sodalite_ore"]=true,
  ["techreborn:deepslate_sodalite_ore"]=true,
  ["techreborn:sphalerite_ore"]=true
}

-- Enum containing directions (Front, Back, Left, Right, Up, Down).
local Dir = {
  Front = 0,
  Back = 1,
  Left = 2,
  Right = 3,
  Up = 4,
  Down = 5
}

-- Declares the coal slot
local COAL_SLOT = 16

-- Declares the redstone position of the transmitter
local REDSTONE_TRANSMITTER = 'Back'

-- Declares if the turtle is the right one or the left one
local TURTLE_SIDE = 'Left'

-- Declares the amount of chunks to mine
local CHUNKS_TO_MINE = 4

--  Number of times the turtle moves forward and checks for ore veins (zero because it will be defined later)
local ITER = 0

-- Set redstone output to zero
redstone.setAnalogOutput(REDSTONE_TRANSMITTER,0)


-- ⚙️ Functions
-- =================================

-- Creates a table with depth and direction
local function vector(depth, dir)
return {depth=depth, dir=dir}
end

-- Aligns the turtle and adds information to the track table
local function alignDir(dir, depth, track)
if (dir == Dir.Left) then
  turtle.turnLeft()
  table.insert(track, vector(depth, Dir.Left))
elseif (dir == Dir.Right) then
  turtle.turnRight()
  table.insert(track, vector(depth, Dir.Right))
elseif (dir == Dir.Back) then
  turtle.turnRight()
  turtle.turnRight()
  table.insert(track, vector(depth, Dir.Right))
  table.insert(track, vector(depth, Dir.Right))
end
end

-- Undoes alignment based on the track table for the specified depth
local function undoAlignDir(depth, track)
while (#track > 0 and track[#track].depth == depth) do
  local vec = table.remove(track)
  if (vec.dir == Dir.Left) then
    turtle.turnRight()
  elseif (vec.dir == Dir.Right) then
    turtle.turnLeft()
  end
end
end

-- Checks if the block is an ore based on the whitelist and reports rare ores
local function isMine(hasBlock, blockInfo)
return hasBlock and ORES_WHITELIST[blockInfo.name]
end

-- Checks if the block in the given direction is mineable
local function inspectDirIsMine(dir)
local hasBlock, blockInfo
if (dir == Dir.Up) then
  hasBlock, blockInfo = turtle.inspectUp()
elseif (dir == Dir.Down) then
  hasBlock, blockInfo = turtle.inspectDown()
else
  hasBlock, blockInfo = turtle.inspect()
end

return isMine(hasBlock, blockInfo)
end

-- Mines the block in the given direction, updates the turtle position, and adds information to the track table
local function excavateDir(dir, depth, track)
if (dir == Dir.Up) then
  turtle.digUp()
  turtle.up()
  table.insert(track, vector(depth, Dir.Up))
elseif (dir == Dir.Down) then
  turtle.digDown()
  turtle.down()
  table.insert(track, vector(depth, Dir.Down))
else
  local counter = 0
  repeat
    turtle.dig()
    counter = counter + 1
  until turtle.forward()
  table.insert(track, vector(depth, Dir.Front))
end
end

-- Selects the fill block from the turtle inventory
local function selectFillBlock()
for i = 1, 16 do
  local info = turtle.getItemDetail(i)
  if (info ~= null) then
    for key, _ in pairs(FILL_BLOCKS) do
      if (key == info.name) then
        turtle.select(i)
        return
      end
    end
  else
    select(i)
    return
  end
end
end

-- Moves the turtle back to the original position, filling the holes
local function backtrack(currentDepth, targetDepth, moveTrack, turnTrack)
while (currentDepth ~= targetDepth) do
  while (#moveTrack > 0 and moveTrack[#moveTrack].depth == currentDepth - 1) do
    local vec = table.remove(moveTrack)
    if (vec.dir == Dir.Front) then
      turtle.back()
      selectFillBlock()
      turtle.place()
    elseif (vec.dir == Dir.Up) then
      turtle.down()
      selectFillBlock()
      turtle.placeUp()
    elseif (vec.dir == Dir.Down) then
      turtle.up()
      selectFillBlock()
      turtle.placeDown()
    end
  end
  undoAlignDir(currentDepth - 1, turnTrack)
  currentDepth = currentDepth - 1
end
end

-- Starts the depth-first search for ore veins in the given direction
local function dfs(initDir)
local stack = {}
local turnTrack = {}
local moveTrack = {}
local depth = 0
table.insert(stack, vector(depth, initDir))

while (#stack > 0) do
  local vec = table.remove(stack)
  backtrack(depth, vec.depth, moveTrack, turnTrack)
  depth = vec.depth

  alignDir(vec.dir, depth, turnTrack)

  if (inspectDirIsMine(vec.dir)) then
    excavateDir(vec.dir, depth, moveTrack)
    depth = depth + 1

    if isMine(turtle.inspect()) then
      table.insert(stack, vector(depth, Dir.Front))
    end

    if isMine(turtle.inspectUp()) then
      table.insert(stack, vector(depth, Dir.Up))
    end
    if isMine(turtle.inspectDown()) then
      table.insert(stack, vector(depth, Dir.Down))
    end
    turtle.turnRight()
    if isMine(turtle.inspect()) then
      table.insert(stack, vector(depth, Dir.Right))
    end
    turtle.turnRight()
    if isMine(turtle.inspect()) then
      table.insert(stack, vector(depth, Dir.Back))
    end
    turtle.turnRight()
    if isMine(turtle.inspect()) then
      table.insert(stack, vector(depth, Dir.Left))
    end
    turtle.turnRight()
  else
    undoAlignDir(depth, turnTrack)
  end
end

backtrack(depth, 0, moveTrack, turnTrack)
end

-- Triggers the depth-first search if an ore block is found in the given direction
local function triggerDfs(dir)
if inspectDirIsMine(dir) then
  dfs(dir)
end
end

-- Checks for ore blocks around the turtle in all directions
local function inspectAround()
turtle.turnRight()
triggerDfs(Dir.Front)

turtle.turnLeft()
triggerDfs(Dir.Up)

turtle.turnLeft()
triggerDfs(Dir.Front)

turtle.down()
triggerDfs(Dir.Front)

turtle.turnRight()
triggerDfs(Dir.Down)

turtle.turnRight()
triggerDfs(Dir.Front)

turtle.turnLeft()
turtle.up()
end

-- Refuel when bellow 50 fuel
local function refuel()
fuel_level = turtle.getFuelLevel()
if (fuel_level < 200) then
  turtle.select(COAL_SLOT)
  while (fuel_level < 600) do
    fuel_level = turtle.getFuelLevel()
    turtle.refuel()
  end
end
end

-- Digs one block ahead and breaks the block, and digs downwards
local function advance()
repeat
  turtle.dig()
until turtle.forward()
turtle.digDown()
refuel()
end

-- Checks if it is in the initial poisition
local function isItTheInitialPosition()
hasBlockUp, blockInfoUp = turtle.inspectUp()
hasBlockDown, blockInfoDown = turtle.inspectDown()
if (blockInfo == 'reinfchest:gold_chest') and (blockInfoDown == 'minecraft:chest') then
  INITIAL_POSITION = True
else
  INITIAL_POSITION = False
end
return INITIAL_POSITION
end

-- Checks coal amount in turtle inventory
local function checkCoalAmount()
turtle.select(COAL_SLOT)
coal_amount = turtle.getItemCount()
if (coal_amount < 64) then
  coal_amount_to_get = 64
  return coal_amount_to_get
else
  coal_amount_to_get = 0
  return coal_amount_to_get
end
end

-- Grabs coal from chest bellow
local function suckCoalFromChest(coal_amount_to_get)
turtle.select(COAL_SLOT)
turtle.suckDown(coal_amount_to_get)
end

-- Deposit the item in the chest above
local function depositsItems()
for i = 1, 16 do
  turtle.select(i)
  item = turtle.getItemDetail()
  if (item == null) then
  else
    if (item.name ~= 'minecraft:coal') then
      didItWork = turtle.dropUp()
      if (didItWork == False) then
        repeat
          print("Error, not able to deposit in chest (maybe it is full)!")
          didItWork = turtle.dropUp()
        until (didItWork == True)
      end
    else
      didItWork = turtle.dropDown()
      if (didItWork == False) then
          didItWork = turtle.dropUp()
          if (didItWork == False) then
            repeat
              print("Error, not able to deposit in chest (maybe it is full)!")
              didItWork = turtle.dropUp()
            until (didItWork == True)
          end
      end
    end
  end
end
end

-- Defines ITER value based on the turtle position
local function defineITER()
if (TURTLE_SIDE == 'Left') then
  ITER = (CHUNKS_TO_MINE * 16) - 5
else
  ITER = (CHUNKS_TO_MINE * 16) - 1
end
end




-- ⭐ Main function
-- =================================

INITIAL_POSITION = isItTheInitialPosition()
if (INITIAL_POSITION == True) then

-- Get coal amount in the coal slot, if it less than a stack, it grabs more
coal_amount_to_get = checkCoalAmount()
while (coal_amount_to_get ~= 0) do
  coal_amount_to_get = checkCoalAmount()
  suckCoalFromChest(coal_amount_to_get)
  refuel()
end

-- Define ITER amount
defineITER()

-- Does the movement to get out of the Create machine and start mining
if (TURTLE_SIDE == 'Left') then
  turtle.turnLeft()
  turtle.forward()
else
  turtle.turnRight()
  hasBlock = turtle.inspect()
  if (hasBlock == True) then
    turtle.dig()
    turtle.forward()
  end
  turtle.forward()
turtle.forward()
end

-- Starts the mining
for i = 1, ITER do
  advance()
  inspectAround()
  selectFillBlock()
  turtle.placeDown()
end

-- Ends the mining and return to the starting point before starting mining
turtle.turnRight()
turtle.turnRight()
for i = 1, ITER do
  turtle.forward()
end

-- Returns to the initial position inside the create machine
if (TURTLE_SIDE == 'Left') then
  turtle.forward()
  turtle.turnLeft()
else
  turtle.forward()
  turtle.forward()
  turtle.turnRight()
end

-- Deposit items
depositsItems()

-- Sends a redstone signal to the back of the turtle to trigger the create machine movement
redstone.setAnalogOutput(REDSTONE_TRANSMITTER,15)

-- End of program

else
end 