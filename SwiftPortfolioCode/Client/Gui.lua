local module = {}
local Main
local UIS = game:GetService("UserInputService")
local ScreenCentre = workspace.Camera.ViewportSize/2
local RS = game:GetService("ReplicatedStorage")
local Points = RS:WaitForChild("CurrentPoints")

function module.Startup(Core)
	Main = Core
	local PointMenu = Core.Script.Parent:WaitForChild("Points")

	for I, Item in pairs(Points:GetChildren()) do -- loop through the parts when starting up
		Item.Changed:Connect(function() -- apply a changed event to the value so it can assign it to the gui.
			PointMenu[Item.Name].Text = Item.Value --assign value to UI.
		end)
	end
end

return module
