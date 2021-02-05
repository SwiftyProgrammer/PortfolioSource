local module = {}
local GameObj = workspace:WaitForChild("Game")
local Players = GameObj:waitForChild("Players")
local Map = GameObj:waitForChild("Map")
local Width = (Map.Backboard.Size.Z/2)-(Players["Player1"].Paddle.Size.Z/2) -- create a maximum and minimum bound for the paddles.

local PaddlePositions = {
	["Player1"] = Vector3.new(-20.5, 0, 0),
	["Player2"] = Vector3.new(20.5, 0, 0),
}
--default positions for paddles.

local Vector3New = Vector3.new
local MathClamp = math.clamp -- efficiency upvalue caching...
function module.MovePaddle(PaddleID, Value)
	Players[PaddleID].Paddle.Position = PaddlePositions[PaddleID]+Vector3New(0, 0, MathClamp(Value, -1, 1)*Width) -- takes stock value and adds a Z offset onto it based on the input value and multiplies it by the maximum bounds.
end

function module.Startup(Core)
end

return module
