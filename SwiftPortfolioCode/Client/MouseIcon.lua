local module = {}
local CoreScript
local Cursor
local TweenSystem
function module.MoveToPos(Vector2Mouse)
	if Cursor == nil then
		return
	end
	Cursor.Position = Cursor.Position:Lerp(UDim2.new(0, Vector2Mouse.X, 0, Vector2Mouse.Y), 0.5)
end

local Running = false

function module.Startup(Core)
	CoreScript = Core.Script
	Cursor = CoreScript.Parent.MouseCursor
	Running = true
	TweenSystem = Core.Utils.TweenSystem.Tween
	spawn(function() -- opens it on a new thread not to disturb the main chain. (i'm using spawn cause i dont care if it has delay.)
		while Running do -- this loop creates a mini animation to the mouse cursor creating a sort of trailing effect. Then deletes itself.
			local Item = Cursor:Clone() -- clones main object fortunately this also transfers location data so all i gotta do is set its parent.
			Item.Parent = Cursor.Parent -- set to cursor parent.
			spawn(function()
				wait(0.05)
				TweenSystem(Item, {ImageTransparency = 1}, 0.2, Enum.EasingStyle.Quart) -- animation to fade out, using my module.
				wait(0.2)
				Item:Destroy()
			end)
			wait(0) -- 30 times a second should be good and smooth
		end
	end)
end

function module.StopCursor()
	Running = false
end

return module
