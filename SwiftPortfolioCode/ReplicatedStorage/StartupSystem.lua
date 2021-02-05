local RS = game:GetService("ReplicatedStorage")
local SwiftsUtil = RS:WaitForChild("Swifts Util")

local function LoadModuleAndNameIt(Module, Table)

	local Environment = require(Module) -- Actually require it. But stick it in a variable for future use.
	Table[Module.Name] = Environment -- Inserting it into the dictionary with its script name as its key.

	return Table
end

local function StartupHandler(Folder, Script)
	local AllModules = Folder --Grab module folder.
	local ScriptMain = {
		["Script"] = Script,
		["Modules"] = {},
		["Utils"] = {}
	} --Create a core table holding all the functions and any other useful info.

	for Index, Module in pairs(AllModules:GetChildren()) do -- run through the folder initilizating them.
		ScriptMain["Modules"] = LoadModuleAndNameIt(Module, ScriptMain["Modules"]) --load module and assign it to dictionary
	end

	for Index, Module in pairs(SwiftsUtil:GetChildren()) do -- run through the folder initilizating them.
		ScriptMain["Utils"] = LoadModuleAndNameIt(Module, ScriptMain["Utils"]) --load module and assign it to dictionary
	end

	for EnvironmentName, Environment in pairs(ScriptMain["Modules"]) do -- run through the folder initilizating them.
		Environment.Startup(ScriptMain) -- this allows me to access all the other modules from all the other scripts in a nice and neat package. Along with additional data which is useful with referencing.
	end
	return ScriptMain
end




return StartupHandler
