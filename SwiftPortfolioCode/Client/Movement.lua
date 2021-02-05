local module = {}
local Main
local UIS = game:GetService("UserInputService")
local ScreenCentre = workspace.Camera.ViewportSize/2
function module.MouseMoved(Vector2Mouse)
	Main.Modules.MouseIcon.MoveToPos(Vector2.new(ScreenCentre.X-(ScreenCentre.X/1.5), Vector2Mouse.Y))
	Main.Modules.Replicator.ReplicateValue("UpDown", (
		(Vector2Mouse.Y-ScreenCentre.Y)/ScreenCentre.Y)*100
	)
end

function module.Startup(Core)
	Main = Core
	UIS.MouseIconEnabled = false -- disables stock mouse icon and replaces it with my custom one.
	UIS.InputChanged:Connect(function(InputObj) -- fires when anything changes.
		if InputObj.UserInputType == Enum.UserInputType.MouseMovement then -- filters so i only use mouse movement.
			module.MouseMoved(UIS:GetMouseLocation()) -- grabs location and fires main mouse movement event.
		end
	end)
end

return module
