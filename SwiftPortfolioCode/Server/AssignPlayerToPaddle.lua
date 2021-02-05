local module = {}
local GameObj = workspace:WaitForChild("Game")
local Players = GameObj:waitForChild("Players")
local Map = GameObj:waitForChild("Map")

local Values = {}

function module.AssignPaddle(Player, PaddleID)
	Values[PaddleID] = Player -- assign the paddle to a dictionary for future lookup.
end

function module.GetAssignedPlayer(PaddleID)
	return Values[PaddleID] -- grab the paddle player.
end


function module.Startup(Core)

end

return module
