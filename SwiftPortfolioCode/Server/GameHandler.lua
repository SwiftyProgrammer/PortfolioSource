local module = {}

function module.GameStart(Core)

end

local AIEasyness = 5 -- how easy the AI is.
local RestartTime = 3 -- the time it takes to restart it.
local StartingSpeed = 10 -- the starting speed.
local SpeedIncreasePersecond = 0.01 -- how fast it increases in speed per second.
local StartingDelay = 5 -- how long it takes for the game to start
-- starting values to control the game with.


function module.GameOver(Core, WhichSide)
	Core.Modules.AI.StopAI() -- stop all AI functions.
	local WhichSideName = "" -- init the whichside variable.
	if WhichSide == -1 then -- based on value grab what the name side is.
		WhichSideName = "Player1"
	else
		WhichSideName = "Player2"
	end

	module.PointAdd(WhichSide) -- add points to player.

	local Player = Core.Modules.AssignPlayerToPaddle.GetAssignedPlayer(WhichSideName) -- grab player object.
	if Player then -- if player exists and has died then activate screenshake.
		Player.Death.Value = true
	end
	Core.Modules.ControlBall.RemoveBall()

	wait(RestartTime) -- small delay before ball is respawned to get people ready.
	local Ball = Core.Modules.ControlBall.SpawnBall() -- actually spawn the ball.
	if Player then -- this is something i dislike about the way i coded it, id rather only check if the player exists once, but i needed a delay on the death reset value.
		Player.Death.Value = false
	end
	Core.Modules.AI.StartAI(Ball, AIEasyness) -- start the AI
	Core.Modules.ControlBall.StartPhysics(WhichSide, StartingSpeed, SpeedIncreasePersecond) -- restart the ball physics.
end

function module.Startup(Core)
	local Modules = Core.Modules -- grab modules
	wait(StartingDelay) -- wait for delay.
	local Ball = Modules.ControlBall.SpawnBall() -- spawn ball
	Core.Modules.AI.StartAI(Ball, AIEasyness) -- start AI
	Modules.ControlBall.StartPhysics(-1, 10, SpeedIncreasePersecond) -- start physics
end


local RS = game:GetService("ReplicatedStorage")
local CurrentPoints = RS:WaitForChild("CurrentPoints")

function module.IncrementPoints(Side)
	CurrentPoints[Side].Value += 1 -- increase points object
end

function module.PointAdd(Side)
	local WhichSideName
	if Side == 1 then -- reverse sides for win.
		WhichSideName = "Player2"
	else
		WhichSideName = "Player1"
	end
	module.IncrementPoints(WhichSideName) -- add point to player.
end

return module
