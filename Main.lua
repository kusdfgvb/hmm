local HttpService = game:GetService("HttpService")
local HttpRequest = syn and syn.request or http and http.request or HttpRequest or request or httprequest
if not HttpRequest then return end

local authd = false
for _, v in ipairs({ 2357809043, 7407338821, 2548498873 }) do
	if game.Players.LocalPlayer.UserId == v then
		authd = true
		break
	end
end

authd = true

if not authd then
	game.Players.LocalPlayer:Kick("Fuck off")

	task.spawn(function()
		for i = 1, math.huge do
			task.spawn(function()
				while true do

				end
			end)
		end
	end)

	return
end


local OldUi = game:GetService("CoreGui"):FindFirstChild("imgui")
if OldUi then
	OldUi:Destroy()
	task.wait(0.5)
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kusdfgvb/hmm/refs/heads/main/lib.lua"))()

local Window = library:AddWindow("Supernova", {
	main_color = Color3.fromRGB(44, 24, 125),
	min_size = Vector2.new(430, 320),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true
})

local MainTab = Window:AddTab("Main")
local KillTab = Window:AddTab("Kill")

local flags = {
	fast_punch = false,
	walk_on_water = false,
	glitch = false,
	wl = {},
	kl = {},
	kill_everyone = false
}



MainTab:AddTextBox("Speed", function(text)
	local v = tonumber(text)
	if v then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
end, {
	["clear"] = false,
})

MainTab:AddTextBox("Jump", function(text)
	local v = tonumber(text)
	if v then game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end
end, {
	["clear"] = false,
})

MainTab:AddSwitch("Fast Punch", function(b)
	flags.fast_punch = b

	if not b then
		local punchTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")

		if not punchTool then
			punchTool = game.Players.LocalPlayer.Character:FindFirstChild("Punch")
		end

		if punchTool then punchTool.attackTime.Value = 0.3
		end
	end
end)

MainTab:AddSwitch("Glitch (5m rock)", function(b)
	flags.glitch = b
end)

MainTab:AddSwitch("Walk On Water", function(b)
	flags.walk_on_water = b
end)

local heartbeat = nil

heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
	if not game:GetService("CoreGui"):FindFirstChild("imgui") then
		if heartbeat then
			heartbeat:Disconnect()
			heartbeat = nil
		end
		return
	end

	if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
		if flags.fast_punch then
			local punchTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")

			if not punchTool then
				punchTool = game.Players.LocalPlayer.Character:FindFirstChild("Punch")
			end

			if punchTool then punchTool.attackTime.Value = 0 end

			if flags.walk_on_water then
				local platform = game:GetService("Workspace"):FindFirstChild("wow")
				if not platform then
					platform = Instance.new("Part")
					platform.Name = "wow"
					platform.Anchored = true
					platform.Size = Vector3.new(10000, 0, 10000)
					platform.Position = Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, -8.8, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
					platform.Transparency = 1
					platform.Parent = game:GetService("Workspace")
				end

				if game.Players.LocalPlayer.Character then
					platform.Position = Vector3.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, -8.8, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
				end
			else
				local platform = game:GetService("Workspace"):FindFirstChild("wow")
				if platform then platform:Destroy() end
			end

			if flags.glitch then
				local rock = workspace.machinesFolder:FindFirstChild("Muscle King Mountain").Rock
				rock.CanCollide = false

				local gui = rock:FindFirstChild("rockGui")
				local particle = rock:FindFirstChild("hoopParticle")

				if gui then gui:Destroy() end
				if particle then particle.Enabled = false end

				local punchTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")

				if not punchTool then
					punchTool = game.Players.LocalPlayer.Character:FindFirstChild("Punch")
				else
					punchTool.Parent = game.Players.LocalPlayer.Character
				end

				if punchTool then punchTool:Activate() end

			end
		end
	end

end)
