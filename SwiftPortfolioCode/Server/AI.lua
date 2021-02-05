local module = {}

local GameObj = workspace.Game
local Replication = workspace.Replicator
local AIRunning = false

local Map = GameObj:WaitForChild("Map")
local Backboard = Map.Backboard

local Modifier

--[[ basic AI, things i could improve:

- create prediction algorithm to predict where the ball will be after any wall bounces.
- improve its realism by limiting it further.

]]
function module.StartAI(Ball, Easyness) -- grabs the targeted ball and the easy-ness it needs.
	spawn(function()
		if Modifier then -- checks if theres replicator
			AIRunning = true -- prepare the upvalue for loop starting.
			local RandomFailure = 0 -- creates artificial failure in the algorithm.
			spawn(function() -- opens new thread to control randomizing of failure.
				while AIRunning do
					RandomFailure = math.random(-Easyness*100, Easyness*100)/100 -- based on easyness offset value based on percentage.
					wait(math.random(1, 100)/100) -- wait a random amount of time for next failure.
				end
			end)
			while AIRunning do -- while the upvalue AI running is actually running, run the loop, this way it stops if it doesnt need to AI.
				local PreviousValue = Modifier.Replicate.Position --grabs location on replicator
				local CalculatedValue = Vector3.new((Ball.Position.Z/(Backboard.Size.Z/2))*100+RandomFailure, 1000, 0) -- calculates what location the paddle should be.
				Modifier.Replicate.Position = PreviousValue:Lerp(CalculatedValue, Easyness/10) -- generate randomized failure on how slowly it can reach the target.
				wait() -- 30 times a second is smooth enough..
			end
		end
	end)
end

function module.StopAI()
	AIRunning = false
	-- just set the upvalue to false to stop all loops.
end

function module.Startup(Core)
	local Modules = Core.Modules
	local Replicator = Modules.Replicator

	Replicator.AssignReplicator("Player2") -- grab a replicator for the AI so it runs through the same input line as a player to generate more realism.

	Modifier = Replication:FindFirstChild("Player2") -- actually grab the modifier.

end

return module
