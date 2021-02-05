local Animate = {}
local TweenService = game:GetService("TweenService")

function Animate.Tween(object, propertyToChange, timeItTakes, Fade, FadeIn)
	if Fade == nil then
		Fade = Enum.EasingStyle.Sine
	end
	if FadeIn == nil then
		FadeIn = Enum.EasingDirection.Out
	end
	local tweenInfo = TweenInfo.new(timeItTakes, Fade, FadeIn)
	local tween1 = TweenService:Create(object, tweenInfo, propertyToChange)
	tween1:Play()
end

-- a utility i took from my main utility library.

return Animate
