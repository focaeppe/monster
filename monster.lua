--[[  MOBILE-COMPATIBLE GUI (phone/tablet/pc)
     - Scrolling layout
     - Touch-first inputs (Activated)
     - Large tap targets + auto-scaling text
     - Safe area aware
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local CAS = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "ModularGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- Color scheme
local colors = {
	background   = Color3.fromRGB(30, 30, 40),
	header       = Color3.fromRGB(40, 40, 50),
	text         = Color3.fromRGB(255, 255, 255),
	subtext      = Color3.fromRGB(200, 200, 200),
	button       = Color3.fromRGB(70, 70, 80),
	buttonHover  = Color3.fromRGB(90, 90, 100), -- used as "pressed" on mobile
	toggleOff    = Color3.fromRGB(60, 60, 70),
	toggleOn     = Color3.fromRGB(0, 170, 127),
	input        = Color3.fromRGB(50, 50, 60),
	shadow       = Color3.new(0, 0, 0),
}

-- device safe area padding helper
local function getSafePadding()
	-- emulate safe area: top bar + notches
	local topLeftInset, bottomRightInset = GuiService:GetGuiInset() -- Vector2
	-- add small side padding on tall phones
	return {
		Top = topLeftInset.Y,
		Left = math.max(8, topLeftInset.X),
		Right = math.max(8, bottomRightInset.X),
		Bottom = math.max(8, bottomRightInset.Y)
	}
end

-- responsive width helper (card max ~360px on phone, 420 on tablet/pc)
local function getTargetWidth()
	local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	local isPortrait = vp.Y > vp.X
	local maxWidth = isPortrait and 360 or 420
	-- keep some margins
	local margin = 24
	return math.min(maxWidth, vp.X - margin * 2)
end

-- Main container (floating card)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.fromScale(0.5, 0.5)
mainFrame.Size = UDim2.new(0, getTargetWidth(), 0, 420)
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.BorderSizePixel = 0
shadow.Position = UDim2.new(0.5, 0, 0.5, 6)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = colors.shadow
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame
shadow.ZIndex = -1

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.BackgroundColor3 = colors.header
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 12, 0, 0)
title.Size = UDim2.new(1, -60, 1, 0)
title.Font = Enum.Font.GothamSemibold
title.Text = "BasicIsBetter! SUBSCRIBE!"
title.TextColor3 = colors.text
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = titleBar

-- Close
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(1, -10, 0.5, 0)
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "✕"
closeButton.TextColor3 = colors.text
closeButton.TextSize = 18
closeButton.AutoButtonColor = false
closeButton.Parent = titleBar
closeButton.Activated:Connect(function()
	gui:Destroy()
end)

-- Content area (scrolling)
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 0, 0, titleBar.Size.Y.Offset)
content.Size = UDim2.new(1, 0, 1, -titleBar.Size.Y.Offset)
content.ScrollBarThickness = 6
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.ClipsDescendants = true
content.Parent = mainFrame

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 12 + getSafePadding().Top)
pad.PaddingBottom = UDim.new(0, 12 + getSafePadding().Bottom)
pad.PaddingLeft = UDim.new(0, 12 + getSafePadding().Left)
pad.PaddingRight = UDim.new(0, 12 + getSafePadding().Right)
pad.Parent = content

local list = Instance.new("UIListLayout")
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 8)
list.Parent = content

-- shared builders
local function mkTextLabel(text, size, color)
	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.Font = Enum.Font.Gotham
	lbl.Text = text
	lbl.TextColor3 = color or colors.text
	lbl.TextSize = size or 14
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextWrapped = false
	return lbl
end

local function mkButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 44) -- large tap target
	btn.BackgroundColor3 = colors.button
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Text = text
	btn.TextColor3 = colors.text
	btn.TextSize = 16
	btn.Font = Enum.Font.GothamSemibold
	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 6)

	-- press feedback (works on touch/mouse/gamepad)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
		or input.KeyCode == Enum.KeyCode.ButtonA then
			btn.BackgroundColor3 = colors.buttonHover
		end
	end)
	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
		or input.KeyCode == Enum.KeyCode.ButtonA then
			btn.BackgroundColor3 = colors.button
		end
	end)
	return btn
end

local function mkFieldBox(placeholder)
	local tb = Instance.new("TextBox")
	tb.Size = UDim2.new(1, 0, 0, 40)
	tb.BackgroundColor3 = colors.input
	tb.BorderSizePixel = 0
	tb.Font = Enum.Font.Gotham
	tb.PlaceholderColor3 = Color3.fromRGB(160, 160, 160)
	tb.PlaceholderText = placeholder or ""
	tb.Text = ""
	tb.TextColor3 = colors.text
	tb.TextSize = 16
	tb.TextXAlignment = Enum.TextXAlignment.Left
	local c = Instance.new("UICorner", tb) c.CornerRadius = UDim.new(0, 6)
	local p = Instance.new("UIPadding", tb) p.PaddingLeft = UDim.new(0, 10)
	return tb
end

-- Section
local function CreateSection(titleText)
	local holder = Instance.new("Frame")
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.new(1, 0, 0, 22)
	holder.LayoutOrder = #content:GetChildren()

	local label = mkTextLabel(titleText, 12, colors.subtext)
	label.Parent = holder
	holder.Parent = content
	return holder
end

-- Label
local function CreateLabel(text)
	local lbl = mkTextLabel(text, 14, colors.text)
	lbl.Size = UDim2.new(1, 0, 0, 22)
	lbl.Parent = content
	return lbl
end

-- Button
local function CreateButton(buttonName, callback)
	local btn = mkButton(buttonName)
	btn.Parent = content
	btn.Activated:Connect(function()
		callback(playerInput.Text)
	end)
	return btn
end

-- Toggle
local function CreateToggle(toggleName, defaultState, callback)
	local row = Instance.new("Frame")
	row.BackgroundTransparency = 1
	row.Size = UDim2.new(1, 0, 0, 40)
	row.Parent = content

	local lbl = mkTextLabel(toggleName, 14, colors.text)
	lbl.Size = UDim2.new(0.7, 0, 1, 0)
	lbl.Parent = row

	local btn = Instance.new("TextButton")
	btn.AnchorPoint = Vector2.new(1, 0.5)
	btn.Position = UDim2.new(1, 0, 0.5, 0)
	btn.Size = UDim2.new(0, 70, 0, 30)
	btn.AutoButtonColor = false
	btn.BackgroundColor3 = defaultState and colors.toggleOn or colors.toggleOff
	btn.BorderSizePixel = 0
	btn.Text = defaultState and "ON" or "OFF"
	btn.TextColor3 = colors.text
	btn.TextSize = 14
	btn.Font = Enum.Font.Gotham
	btn.Parent = row
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)

	btn.Activated:Connect(function()
		local newState = btn.Text ~= "ON"
		btn.Text = newState and "ON" or "OFF"
		btn.BackgroundColor3 = newState and colors.toggleOn or colors.toggleOff
		callback(newState, playerInput.Text)
	end)

	return row
end

-- Dropdown (tap-friendly)
local function CreateDropdown(name, options, callback)
	local container = Instance.new("Frame")
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(1, 0, 0, 40)
	container.Parent = content

	local selected = mkButton("Select " .. name)
	selected.Size = UDim2.new(1, 0, 1, 0)
	selected.Parent = container

	local drop = Instance.new("Frame")
	drop.BackgroundColor3 = colors.background
	drop.Visible = false
	drop.Size = UDim2.new(1, 0, 0, 0)
	drop.ClipsDescendants = true
	drop.Parent = content
	Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)

	local innerList = Instance.new("UIListLayout")
	innerList.SortOrder = Enum.SortOrder.LayoutOrder
	innerList.Parent = drop

	local function setExpanded(expand)
		if expand then
			drop.Visible = true
			drop.Size = UDim2.new(1, 0, 0, #options * 40)
			-- trap back button to close
			CAS:BindAction("CloseDropdown", function(_, state)
				if state == Enum.UserInputState.Begin then
					setExpanded(false)
				}
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB)
		else
			drop.Visible = false
			drop.Size = UDim2.new(1, 0, 0, 0)
			CAS:UnbindAction("CloseDropdown")
		end
	end

	selected.Activated:Connect(function()
		setExpanded(not drop.Visible)
	end)

	-- options
	for _, opt in ipairs(options) do
		local optBtn = mkButton(opt)
		optBtn.Size = UDim2.new(1, 0, 0, 40)
		optBtn.Parent = drop
		optBtn.Activated:Connect(function()
			selected.Text = opt
			setExpanded(false)
			callback(opt, playerInput.Text)
		end)
	end

	-- close on outside tap
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp or not drop.Visible then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			local pos = input.Position
			local inSel = selected.AbsolutePosition
			local selSize = selected.AbsoluteSize
			local inDrop = drop.AbsolutePosition
			local dropSize = drop.AbsoluteSize
			local insideSelected = pos.X >= inSel.X and pos.X <= inSel.X + selSize.X and pos.Y >= inSel.Y and pos.Y <= inSel.Y + selSize.Y
			local insideDrop = pos.X >= inDrop.X and pos.X <= inDrop.X + dropSize.X and pos.Y >= inDrop.Y and pos.Y <= inDrop.Y + dropSize.Y
			if not insideSelected and not insideDrop then
				setExpanded(false)
			end
		end
	end)

	return container
end

-- Draggable (mouse + touch)
do
	local dragging = false
	local dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			mainFrame.Position.X.Scale, startPos.X.Offset + delta.X,
			mainFrame.Position.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end

	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			RunService.Heartbeat:Wait()
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
end

-- Responsive resize on orientation/viewport change
local function resizeCard()
	mainFrame.Size = UDim2.new(0, getTargetWidth(), 0, math.clamp(mainFrame.AbsoluteSize.Y, 360, 520))
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	task.delay(0.1, resizeCard)
end)
UserInputService:GetPropertyChangedSignal("WindowSize"):Connect(resizeCard)

-- ====== CONTENT ======

-- Player name input
do
	local group = Instance.new("Frame")
	group.BackgroundTransparency = 1
	group.Size = UDim2.new(1, 0, 0, 62)
	group.Parent = content

	local playerLabel = mkTextLabel("Player Name:", 12, colors.subtext)
	playerLabel.Size = UDim2.new(1, 0, 0, 18)
	playerLabel.Parent = group

	playerInput = mkFieldBox("Enter player name (case sensitive)")
	playerInput.Position = UDim2.new(0, 0, 0, 22)
	playerInput.Parent = group
end

-- Sections & Buttons
CreateSection("Random Shit")

CreateButton("Damage player", function(playerName)
	local targetName = string.sub(playerName or "", 1, 20)
	local target = game.Players:FindFirstChild(targetName)
	if target and target.Character then
		game.ReplicatedStorage.Events.ClickAttack:FireServer(target.Character, 1, false)
		local hum = target.Character:FindFirstChild("Humanoid")
		if hum then
			print(hum.Health .. " Remaining HP")
		end
	else
		warn("Player not found: " .. tostring(targetName))
	end
end)

CreateButton("Damage near", function()
	for _, v in ipairs(game.Players:GetPlayers()) do
		if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid")
			and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
			print("hitting " .. v.Name)
			game.ReplicatedStorage.Events.ClickAttack:FireServer(v.Character, 1, false)
			RunService.Heartbeat:Wait()
		end
	end
end)

CreateButton("Heal Bug Hit", function()
	local wasp = workspace:FindFirstChild("Effects")
		and workspace.Effects:FindFirstChild("Vigorwasps")
		and workspace.Effects.Vigorwasps:FindFirstChild("Vigorwasp")
	if wasp then
		game.ReplicatedStorage.Events.VigorWaspEvent:FireServer(wasp)
	else
		warn("Vigorwasp not found")
	end
end)

CreateSection("Toggle Features")

local killauraLoop
local killauraActive = false

CreateToggle("Killaura", false, function(state)
	killauraActive = state
	local attackEvent = game.ReplicatedStorage.Events.ClickAttack
	local range = 30
	local cooldown = 0.2

	local function isValidTarget(target)
		return target ~= player
			and target.Character
			and target.Character:FindFirstChild("Humanoid")
			and target.Character.Humanoid.Health > 0
			and target.Character:FindFirstChild("HumanoidRootPart")
			and (target.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude < range
	end

	if killauraActive then
		if killauraLoop then killauraLoop:Disconnect() end
		killauraLoop = RunService.Heartbeat:Connect(function()
			if not killauraActive then return end
			if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
			for _, t in ipairs(game.Players:GetPlayers()) do
				if isValidTarget(t) then
					attackEvent:FireServer(t.Character, 1, false)
					task.wait(cooldown)
				end
			end
		end)
	else
		if killauraLoop then killauraLoop:Disconnect() killauraLoop = nil end
	end
end)

CreateSection("Abilities")

CreateDropdown("Ability Select", { "Attack1", "Attack2", "Attack3", "Attack4", "Attack5" }, function(selected)
	print("Selected ability:", selected, "on player:", player.Name)
	local ev = game.ReplicatedStorage.Events:FindFirstChild("ReduceCooldown")
	if ev and ev:FindFirstChild("OnClientEvent") then
		-- firesignal is exploit-only in some environments; call the event if your environment supports it.
		pcall(function()
			firesignal(ev.OnClientEvent, selected, 444)
		end)
	else
		warn("ReduceCooldown.OnClientEvent not found")
	end
end)

CreateSection("Information")
CreateLabel("Status: Ready")
CreateLabel("Players Online: " .. #Players:GetPlayers())
