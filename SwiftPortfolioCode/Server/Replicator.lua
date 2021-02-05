local module = {}
local Replicating = script:WaitForChild("Player")
local Replicator = workspace.Replicator
local Players = game:GetService("Players")
local FolderToPutReplicatorsIn = workspace.Replicator

function module.AssignReplicator(Player, ID) -- a replicator is my way of transferring data from client to server quickly, instead of having the rate limits that remote events have, ive basically created my own remote event here.
	local ReplicatingItem = Replicating:Clone()
	if ID then --if replicator is assigned to server then make sure its set to nil which means players can never own the part.
		ReplicatingItem.Name = ID -- so the client can find the part easily.
		ReplicatingItem.Parent = FolderToPutReplicatorsIn
		ReplicatingItem:SetNetworkOwner(Player) -- here is the key part that allows them to control where the part sits.
	else
		ReplicatingItem.Name = Player -- so the client can find the part easily.
		ReplicatingItem.Parent = FolderToPutReplicatorsIn
		ReplicatingItem:SetNetworkOwner(nil) -- here is the key part that allows them to control where the part sits.
	end

	--one may ask why not just do the physics directly from the client to the server by assigning the paddle to the client? Well the reason I'm not doing that is because it can be exploited this way all it can do is move within limits through a very controlled interpreter.
end

local RunService = game:GetService("RunService")

function module.Startup(Core)
	local Modules = Core.Modules
	local ControlPaddle = Modules.ControlPaddle.MovePaddle
	Players.PlayerAdded:Connect(function(Player) -- when new player joins assign them a replicator.
		module.AssignReplicator(Player, "Player1")
		local Death = Instance.new("BoolValue")
		Death.Name = "Death"
		Death.Value = false
		Death.Parent = Player
		Modules.AssignPlayerToPaddle.AssignPaddle(Player, "Player1")
	end)

	RunService.Heartbeat:Connect(function()
		for I, Replicate in pairs(Replicator:GetChildren()) do -- loops through all replicators grabbing data
			local Data = Replicate.CFrame.Position -- grab data
			local Position = math.round(Data.X)/100 -- calculate position based on data.
			ControlPaddle(Replicate.Name, Position) -- control paddle based on data. (naturally this replicator works like a tween function which also helps against exploiters teleporting the paddle to the ball location)
		end
	end)
end

return module
