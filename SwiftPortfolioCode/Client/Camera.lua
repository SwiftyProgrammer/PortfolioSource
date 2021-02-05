local module = {}

local Camera = workspace.Camera
local CameraCF = workspace.CameraMain.CFrame

local MaxYaw, MaxPitch, MaxRoll, MaxOffsetX, MaxOffsetY, MaxOffsetZ = math.rad(0.1), math.rad(0.1), math.rad(20), 2, 2, 0 -- lua var stacking LOL, as a sidenote this is just creating preset vars incase i dont wanna stick in any values when activating the camera shake.

local RunService = game:GetService("RunService")
local CurrentShake = 0

local mathNoise = math.noise -- localizing the values which have to index a table (in this case the math api) is better for performance, and since im running this many times a second its important that this is done.
local mathSeed = 1.6
local mathClamp = math.clamp
local Clock = os.clock
local CFrameAngles = CFrame.Angles
local SpeedReduction = 0.01
local SpeedModifier = 1
local Vector3New = Vector3.new

local function Noise(Seed, Time)
	return mathClamp(mathNoise(Seed, Time)*2, -1, 1) -- this is just for making sure a noise value is always -1 or 1 and anything inbetween. normal perlin noise works at 0.5, (which is why im multiplying it)
end


--[[

local Parameters = {
			["MaxYaw"] = math.rad(0.5),
			["MaxPitch"] = math.rad(0.5),
			["MaxRoll"] = math.rad(10),
			["MaxOffsetX"] = 1,
			["MaxOffsetY"] = 1,
			["MaxOffsetZ"] = 1,
		}
		CameraShake(0.2, 100, 10, Parameters)

]]

function module.Shake(Amount, Time, Speed, Parameters)
	SpeedReduction = 1/(Time*60) -- configuring speed values, In this case i like to stick in a time function so it will correctly adjust how it affects the effect based on time. Instead of it being an immediate damping effect it can be a minor one.
	CurrentShake += Amount -- just adds it to the total shake so you can stack shaking.
	SpeedModifier = Speed -- just sets speed as the new time line modifier.
	if Parameters then
		MaxYaw, MaxPitch, MaxRoll, MaxOffsetX, MaxOffsetY, MaxOffsetZ = Parameters.MaxYaw, Parameters.MaxPitch, Parameters.MaxRoll, Parameters.MaxOffsetX, Parameters.MaxOffsetY, Parameters.MaxOffsetZ -- more var stacking...
	end
end

function module.Startup(Core)
	local function RenderedSteppedFunc()
		if CurrentShake <= 0 then
			return
		end
		local Time = Clock()*SpeedModifier -- Perlin noise has a timeline, in this case im using the actual time of the lua script instance as a timeline, and then multiplying it by a speed factor to increase how fast it shakes or how slowly. So i can create slow motion effects or super agressive fast effects.

		local ActualShake = mathClamp(CurrentShake^2, 0, 1) -- forcing the shake value to be between 0 and 1 and making it a exponent for a better effect.

		local CameraNewX = MaxYaw * ActualShake * Noise(mathSeed, Time) -- running time as a timeline on the 2D perlin noise system.
		local CameraNewY = MaxPitch * ActualShake * Noise(mathSeed+1, Time) -- i add 1 to the seed just to make sure all the axis are doing their own thing.
		local CameraNewZ = MaxRoll * ActualShake * Noise(mathSeed+2, Time)

		local OffsetX = MaxOffsetX * ActualShake * Noise(mathSeed+3, Time)
		local OffsetY = MaxOffsetY * ActualShake * Noise(mathSeed+4, Time)
		local OffsetZ = MaxOffsetZ * ActualShake * Noise(mathSeed+5, Time)

		local OffsetVector = Vector3New(OffsetX, OffsetY, OffsetZ) -- creates a vector to offset the camera with.

		local NewCameraCF = (CameraCF*CFrameAngles(CameraNewX, CameraNewY, CameraNewZ))+OffsetVector -- this is where i actually execute it to the camera, I'm only writing the value to the camera once to save speed.

		Camera.CFrame = NewCameraCF
		CurrentShake = mathClamp(CurrentShake - SpeedReduction, 0, 1) -- here i'm reducing the value, as this runs 60 times a second its important it only takes small increments from the total shake value. Making a realistic damping effect.
	end

	while Camera.CFrame ~= CameraCF do -- runs loop to ensure camera moves to correct position, then runs the rest of the script when its done.
		Camera.CameraType = Enum.CameraType.Scriptable  -- forcing camera to not move without deliberate actions said by a script.
		Camera.CFrame = CameraCF -- sets camera to actual designed position.
		wait(0.1) -- 10 times a second is good enough to not affect starting performance speeds.
	end
	RunService:BindToRenderStep("CameraShake", 300, RenderedSteppedFunc) -- i decided to stick it at this order because when i designed this module i wanted it to also work with other games. that i have planned, some games may rely on the standard roblox camera system and this means it adjusts the camera after the camera has been controlled by the player meaning theres no stuttering.

end










return module
