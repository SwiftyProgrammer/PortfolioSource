local RS = game:GetService("ReplicatedStorage") -- grab Replicated storage
local StartupSystem = require(RS:waitForChild("StartupSystem")) -- load the startup system
local AllFolders = script:WaitForChild("Handlers") --Grab module folder

local ScriptMain = StartupSystem(AllFolders, script) -- this function will startup and run all scripts returning the package it sends to all scripts.
