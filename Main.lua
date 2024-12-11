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

local ui = game:GetService("CoreGui"):FindFirstChild("imgui")

local MainTab = Window:AddTab("Main")
local KillTab = Window:AddTab("Kill")

local walk_on_water = nil
local anti_knock = nil
local anti_idle = nil
local fast_punch = nil
local glitch = nil

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

MainTab:AddSwitch("Walk On Water", function(b)
	if b then
		walk_on_water = game:GetService("RunService").Stepped:Connect(function()
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
		end)
	else
		walk_on_water:Disconnect()
		walk_on_water = nil
		local platform = game:GetService("Workspace"):FindFirstChild("wow")
		if platform then
			platform:Destroy()
		end
	end
end)

MainTab:AddSwitch("Anti Knockback", function(b)
	if b then
		anti_knock = game:GetService("RunService").Stepped:Connect(function()
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
		if anti_knock then
			anti_knock:Disconnect()
			anti_knock = nil
		end
	end
end)

MainTab:AddSwitch("Anti Idle", function(b)
	if b then
		anti_idle = game.Players.LocalPlayer.Idled:Connect(function()
			local VU = game:GetService("VirtualUser")

			VU:CaptureController()
			VU:ClickButton1(Vector2.new())
		end)
	else
		if anti_idle then
			anti_idle:Disconnect()
			anti_idle = nil
		end
	end
end)

MainTab:AddSwitch("Fast Punch", function(b)
	if b then
		fast_punch = game:GetService("RunService").Heartbeat:Connect(function()
			if not ui then
				fast_punch:Disconnect()
				return
			end
			local punchTool = game.Players.LocalPlayer.Backpack.Punch
			if not punchTool then punchTool = game.Players.LocalPlayer.Character.Punch end

			if punchTool then
				punchTool.attackTime = 0
			end
		end)
	else
		if fast_punch then
			fast_punch:Disconnect()
			fast_punch = nil

			local punchTool = game.Players.LocalPlayer.Backpack.Punch
			if not punchTool then punchTool = game.Players.LocalPlayer.Character.Punch end

			if punchTool then
				punchTool.attackTime = 0.3
			end
		end
	end
end)

MainTab:AddSwitch("Glitch Rock (5m)", function(b)
	if b then
		glitch = game:GetService("RunService").Stepped:Connect(function()
			local rock = workspace.machinesFolder:FindFirstChild("Muscle King Mountain").Rock
			
			local gui = rock:FindFirstChild("rockGui")
			local emitter = rock:FindFirstChild("rockEmitter")

			if gui then gui:Destroy() end
			if emitter then emitter:Destroy() end

			rock.Size = Vector3.new(0.1, 0.1, 0.1)
			rock.CanCollide = false

			local punchTool = game.Players.LocalPlayer.Backpack.Punch
			if not punchTool then punchTool = game.Players.LocalPlayer.Character.Punch end

			

			local leftHand = game.Players.LocalPlayer.Character.LeftHand
			if rock then
				rock.CFrame = leftHand.CFrame
			end

			if punchTool then
				punchTool:Activate()
			end
		end)
	else
		if glitch then
			glitch:Disconnect()
			glitch = nil
		end
	end
end)
