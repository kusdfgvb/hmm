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

local Window = library:AddWindow("Cybernetics 1", {
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
	kill_everyone = false,
	selected_player = nil,
	spectating = nil
}

local joinEvent = nil
local leaveEvent = nil


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

local antiknock = nil
local antiidle = nil
MainTab:AddSwitch("Anti Knock", function(b)
	if b then
		antiknock = game:GetService("RunService").Stepped:Connect(function()
			local char = game.Players.LocalPlayer.Character
			if char then
				local HRP = char:FindFirstChild("HumanoidRootPart")

				if HRP then
					local punchVelocity = HRP:FindFirstChild("punchVelocity")

					if punchVelocity then
						punchVelocity.Velocity = Vector3.new(0, 0, 0)
						punchVelocity:Destroy()
						HRP.Velocity = Vector3.new(0, 0, 0)
					end
				end
			end
		end)
	else
		antiknock:Disconnect()
		antiknock = nil
	end
end)

MainTab:AddSwitch("Anti Afk", function(b)
	if b then
		antiidle = game.Players.LocalPlayer.Idled:Connect(function()
			local VU = game:GetService("VirtualUser")

			VU:CaptureController()
			VU:ClickButton1(Vector2.new())
		end)
	else
		antiidle:Disconnect()
		antiidle = nil
	end
end)


local function getPlayerUsernames()
	local t = {}
	for _, v in pairs(game:GetService("Players"):GetPlayers()) do
		if v ~= game.Players.LocalPlayer then
			table.insert(t, v.Name)
		end
	end

	return t
end

local PlayerDropdown = KillTab:AddDropdown("Select Player", function(obj)
	flags.selected_player = game:GetService("Players"):FindFirstChild(obj)
end):Refresh(getPlayerUsernames())

KillTab:AddButton("Spectate", function()
	if flags.selected_player then
		flags.spectating = flags.selected_player
		local char = flags.selected_player.Character
		game:GetService("Workspace").CurrentCamera.CameraSubject = char
	end
end)

KillTab:AddButton("Stop Spectating", function()
	game:GetService("Workspace").CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
end)

KillTab:AddButton("Wl Player", function()
	if not flags.selected_player then return end
	local found = table.find(flags.wl, flags.selected_player.Name)
	if not found then table.insert(flags.wl, flags.selected_player.Name) end
end)

KillTab:AddButton("Remove Wl", function()
	if not flags.selected_player then return end
	table.remove(flags.wl, flags.selected_player.Name)
end)

KillTab:AddButton("Kill Player", function()
	if not flags.selected_player then return end
	local isWl = table.find(flags.wl, flags.selected_player.Name)
	if isWl then return end
	local found = table.find(flags.kl, flags.selected_player.Name)
	if not found then table.insert(flags.kl, flags.selected_player.Name) end
end)

KillTab:AddButton("Stop Killing Player", function()
	if not flags.selected_player then return end
	table.remove(flags.kl, flags.selected_player.Name)
end)

KillTab:AddSwitch("Kill everyone", function(b)
	flags.kill_everyone = b
end)

local function kill_everyone()

	local muscle_event = game.Players.LocalPlayer:FindFirstChild("muscleEvent")
	local self_char = game.Players.LocalPlayer.Character
	if not self_char then return end

	local left_hand = self_char.LeftHand
	local right_hand = self_char.RightHand

	for _, v in pairs(game:GetService("Players"):GetPlayers()) do
		if v ~= game.Players.LocalPlayer and v.Name ~= "Forgiveness19" and v.Name ~= "Wraith1286" then
			if not table.find(flags.wl, v.Name) then
				local player_char = v.Character
				if player_char and player_char:FindFirstChild("Humanoid") and player_char.Humanoid.Health > 0 then
					local head = player_char:FindFirstChild("Head")
					if head then
						local punchTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")
						if punchTool then punchTool.Parent = game.Players.LocalPlayer.Character end
						head.Anchored = true
						muscle_event:FireServer(unpack({ [1] = "punch", [2] = "leftHand"}))
						muscle_event:FireServer(unpack({ [1] = "punch", [2] = "rightHand"}))
						muscle_event:FireServer(unpack({ [1] = "punch", [2] = "leftHand"}))
						muscle_event:FireServer(unpack({ [1] = "punch", [2] = "rightHand"}))
						head.Anchored = false
						head.CFrame = CFrame.new(Vector3.new(9999, 9999, 9999))
					end
				end
			end
		end
	end


end

local function kill_players(t)
	if #t < 1 then return end

	local muscle_event = game.Players.LocalPlayer:FindFirstChild("muscleEvent")
	local self_char = game.Players.LocalPlayer.Character
	if not self_char then return end

	local left_hand = self_char.LeftHand
	local right_hand = self_char.RightHand

	for _, v in ipairs(t) do
		if t ~= game.Players.LocalPlayer.Name and t ~= "Forgiveness19" and t ~= "Wraith1286" then

			local player = game:GetService("Players"):FindFirstChild(v)

			if player and player.Character then
				local player_char = player.Character
				local head = player_char:FindFirstChild("Head")
				if head then
					local punchTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")
					if punchTool then punchTool.Parent = game.Players.LocalPlayer.Character end
					head.Anchored = true
					muscle_event:FireServer(unpack({ [1] = "punch", [2] = "leftHand"}))
					muscle_event:FireServer(unpack({ [1] = "punch", [2] = "rightHand"}))
					muscle_event:FireServer(unpack({ [1] = "punch", [2] = "leftHand"}))
					muscle_event:FireServer(unpack({ [1] = "punch", [2] = "rightHand"}))
					head.Anchored = false
					head.CFrame = CFrame.new(Vector3.new(9999, 9999, 9999))
				end
			end
		end
	end
end


MainTab:Show()
library:FormatWindows()

local heartbeat = nil

local startTime = tick()

heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
	if not game:GetService("CoreGui"):FindFirstChild("imgui") then
		if heartbeat then
			heartbeat:Disconnect()
			heartbeat = nil
		end
		return
	end

	if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then
		if flags.spectating then
			game:GetService("Workspace").CurrentCamera.CameraSubject = flags.spectating
		else
			game:GetService("Workspace").CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
		end
		if flags.fast_punch then
			local punchTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")

			if not punchTool then
				punchTool = game.Players.LocalPlayer.Character:FindFirstChild("Punch")
			end

			if punchTool then punchTool.attackTime.Value = 0 end
		end

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
			local lefthand = game.Players.LocalPlayer.Character.LeftHand

			rock.Size = Vector3.new(0.1, 0.1, 0.1)
			rock.CanCollide = false

			local gui = rock:FindFirstChild("rockGui")
			local particle = rock:FindFirstChild("hoopParticle")

			if gui then gui:Destroy() end
			if particle then particle.Enabled = false end

			local punchTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")

			rock.CFrame = lefthand.CFrame

			if not punchTool then
				punchTool = game.Players.LocalPlayer.Character:FindFirstChild("Punch")
			else
				punchTool.Parent = game.Players.LocalPlayer.Character
			end

			if punchTool then punchTool:Activate() end

		else
			local rock = workspace.machinesFolder:FindFirstChild("Muscle King Mountain").Rock
			if rock then rock.CFrame = CFrame.new(Vector3.new(9999, 9999, 9999)) end
		end

		if tick() - startTime >= 0.1 then
			startTime = tick()

			if flags.kill_everyone then
				kill_everyone()
			end

			kill_players(flags.kl)
		end
	end
end)

