local module = {}
local CurrentBall
local Core
local GameObj = workspace.Game
--grabs game on workspace
local BallObj = script:WaitForChild("Ball") -- waits for ball
local BallSpeed = 5/60 -- sets standard ball speed

local Players = GameObj:WaitForChild("Players") -- get player objects on game workspace

local Player1 = Players["Player1"] -- grab death and paddle inside for player 1
local Player2 = Players["Player2"] -- grab death and paddle inside for player 2

local Paddle1 = Player1.Paddle
local Paddle2 = Player2.Paddle

local Death1 = Player1.Death
local Death2 = Player2.Death

local Heartbeat = game:GetService("RunService").Heartbeat -- grab heartbeat event for fast looping.
local Players = game:GetService("Players")

function module.SpawnBall() -- creates a ball and sets its position to the centre of the field.
	local Ball = BallObj:Clone()
	CurrentBall = Ball
	Ball.Position = Vector3.new(0,0,0)
	Ball.Parent = GameObj
	return Ball
end

function module.RemoveBall() -- removes the ball and clears the variable so it can be garbage collected.
	CurrentBall:Destroy()
	CurrentBall = nil
end

local CFrameNew = CFrame.new
local Vector3New = Vector3.new -- speed caching so that it takes less time to find the variable.

function module.IncreaseSpeed(Increment)
	BallSpeed += (Increment/60) -- sets the increment so that for the programmer its per second. since the code runs 60 times a second, this should make it smooth.
end

local Paddles = {Paddle1, Paddle2}
local DeathBarriers = {Death1, Death2}

local function TargetType(Target)
	for I, Paddle in pairs(Paddles) do
		if Paddle == Target.Instance then
			local Offset = Target.Instance.CFrame:PointToObjectSpace(Target.Position).Z/5 -- localizes it to the paddle and then divides it so it will be adjusted.
			return Offset
		end
	end
	for I, Death in pairs(DeathBarriers) do
		if Death == Target.Instance then
			local Multiplier = 1 -- checks which side it hits
			if I == 1 then
				Multiplier = -1 -- reverses the multiplier if its the other player.
			end
			Core.Modules.GameHandler.GameOver(Core, Multiplier) -- Fires the game over event function.
			return
		end
	end
	return true
end

local function CalculateTrajectory(Position, Normal, IncreaseSpeed) -- physics handler for ball running a basic reflection algorithm with raycasting.

	local ActualNormal = Normal*BallSpeed --takes the normal and times it by ball speed to raycast in that direction and expected location for ball in next frame.
	local Target = workspace:Raycast(Position, ActualNormal) -- raycast in that direction.
	local EndPosition = Position -- set endpos to position incase something fails it at-least stops the ball from moving.

	if Target then
		EndPosition = Target.Position -- set it at the hit target.

		local TargetNormal = Target.Normal -- grabs the surface normal it hit.
		Normal = (Normal - (2*Normal:Dot(TargetNormal)*TargetNormal)) -- compares it to the current normal and reflects it.

		local Result = TargetType(Target) -- checks if what it hit was something special such as a paddle or one of the death barriers.
		if Result == true then -- if no actual results then ignore

		elseif Result then -- if it hit a paddle then offset the normal rotation so that the paddles can direct the location
			Normal += Vector3New(0, 0, Result) -- offsets the rotation.
		else
			return -- if it hit a death barrier then end physics simulation.
		end
	else
		EndPosition = EndPosition + ActualNormal -- sets ball position infront of its current one for next frame.
	end
	CurrentBall.CFrame = CFrame.new(EndPosition) -- sets the ball position.
	Heartbeat:wait() -- so it runs at 60/s so its sorta smooth.
	module.IncreaseSpeed(IncreaseSpeed) -- increase the speed of the ball to make it entertaining.
	CalculateTrajectory(EndPosition, Normal, IncreaseSpeed) -- and recursive loop on it.
	return
end

function module.StartPhysics(XDirection, StartingSpeed, IncreaseSpeed) -- just a thing to start the ball and its direction...
	BallSpeed = StartingSpeed/60 --adjusts the ball speed to the expected starting speed.
	local Normal = CFrame.lookAt(Vector3.new(0, 0, 0), Vector3New(XDirection, 0, 0)).LookVector --decides which paddle it will go towards when starting.
	CalculateTrajectory(Vector3New(), Normal, IncreaseSpeed) --fires the recursive event to let it go.
end


function module.Startup(CoreData)
	Core = CoreData -- set the upvalue core to the data.
end

return module
