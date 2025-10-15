local Players = game:GetService('Players')
local player = Players.LocalPlayer
local playerGui = player:WaitForChild('PlayerGui')

-- Main GUI creation
local gui = Instance.new('ScreenGui')
gui.Name = 'ModularGUI'
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- Color scheme
local colors = {
    background = Color3.fromRGB(30, 30, 40),
    header = Color3.fromRGB(40, 40, 50),
    text = Color3.fromRGB(255, 255, 255),
    subtext = Color3.fromRGB(200, 200, 200),
    button = Color3.fromRGB(70, 70, 80),
    buttonHover = Color3.fromRGB(90, 90, 100),
    toggleOff = Color3.fromRGB(60, 60, 70),
    toggleOn = Color3.fromRGB(0, 170, 127),
    input = Color3.fromRGB(50, 50, 60),
}

-- Main container
local mainFrame = Instance.new('Frame')
mainFrame.Name = 'MainFrame'
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 300, 0, 0) -- Height will auto-adjust
mainFrame.Parent = gui

-- Round corners
local corner = Instance.new('UICorner')
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Shadow effect
local shadow = Instance.new('ImageLabel')
shadow.Name = 'Shadow'
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.BorderSizePixel = 0
shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Image = 'rbxassetid://1316045217'
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame
shadow.ZIndex = -1

-- Title bar
local titleBar = Instance.new('Frame')
titleBar.Name = 'TitleBar'
titleBar.BackgroundColor3 = colors.header
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Parent = mainFrame

local titleCorner = Instance.new('UICorner')
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local title = Instance.new('TextLabel')
title.Name = 'Title'
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 10, 0, 0)
title.Size = UDim2.new(1, -40, 1, 0)
title.Font = Enum.Font.GothamSemibold
title.Text = 'BasicIsBetter! SUBSCRIBE!'
title.TextColor3 = colors.text
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close button
local closeButton = Instance.new('TextButton')
closeButton.Name = 'CloseButton'
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(1, -10, 0.5, 0)
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = 'X'
closeButton.TextColor3 = colors.text
closeButton.TextSize = 14
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Content frame
local contentFrame = Instance.new('Frame')
contentFrame.Name = 'ContentFrame'
contentFrame.BackgroundTransparency = 1
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Parent = mainFrame

-- Auto-layout variables
local currentYPosition = 0
local elementPadding = 5
local sectionPadding = 15

-- Player name input (automatically added)
local playerInputFrame = Instance.new('Frame')
playerInputFrame.Name = 'PlayerInputFrame'
playerInputFrame.BackgroundTransparency = 1
playerInputFrame.Position = UDim2.new(0, 0, 0, currentYPosition)
playerInputFrame.Size = UDim2.new(1, 0, 0, 60)
playerInputFrame.Parent = contentFrame

local playerLabel = Instance.new('TextLabel')
playerLabel.Name = 'PlayerLabel'
playerLabel.BackgroundTransparency = 1
playerLabel.Position = UDim2.new(0, 0, 0, 0)
playerLabel.Size = UDim2.new(1, 0, 0, 20)
playerLabel.Font = Enum.Font.Gotham
playerLabel.Text = 'Player Name:'
playerLabel.TextColor3 = colors.subtext
playerLabel.TextSize = 12
playerLabel.TextXAlignment = Enum.TextXAlignment.Left
playerLabel.Parent = playerInputFrame

local playerInput = Instance.new('TextBox')
playerInput.Name = 'PlayerInput'
playerInput.BackgroundColor3 = colors.input
playerInput.BorderSizePixel = 0
playerInput.Position = UDim2.new(0, 0, 0, 25)
playerInput.Size = UDim2.new(1, 0, 0, 30)
playerInput.Font = Enum.Font.Gotham
playerInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
playerInput.PlaceholderText = 'Enter player name (case sensitive)'
playerInput.Text = ''
playerInput.TextColor3 = colors.text
playerInput.TextSize = 14
playerInput.TextXAlignment = Enum.TextXAlignment.Left
playerInput.Parent = playerInputFrame

local inputCorner = Instance.new('UICorner')
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = playerInput

local inputPadding = Instance.new('UIPadding')
inputPadding.PaddingLeft = UDim.new(0, 8)
inputPadding.Parent = playerInput

currentYPosition = currentYPosition + 60 + sectionPadding

-- Function to update main frame size
local function UpdateFrameSize()
    local totalHeight = 40 + currentYPosition + 10 -- Title bar + content + bottom padding
    mainFrame.Size = UDim2.new(0, 300, 0, totalHeight)
end

--[[
    ELEMENT CREATION FUNCTIONS
]]

-- Create a new section label
function CreateSection(titleText)
    local sectionFrame = Instance.new('Frame')
    sectionFrame.Name = titleText .. 'Section'
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Position = UDim2.new(0, 0, 0, currentYPosition)
    sectionFrame.Size = UDim2.new(1, 0, 0, 20)
    sectionFrame.Parent = contentFrame

    local label = Instance.new('TextLabel')
    label.Name = 'Label'
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = titleText
    label.TextColor3 = colors.subtext
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sectionFrame

    currentYPosition = currentYPosition + 20 + elementPadding
    UpdateFrameSize()

    return sectionFrame
end

-- Create a new button
function CreateButton(buttonName, callback)
    local button = Instance.new('TextButton')
    button.Name = buttonName
    button.BackgroundColor3 = colors.button
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, 0, 0, currentYPosition)
    button.Size = UDim2.new(1, 0, 0, 35)
    button.Font = Enum.Font.GothamSemibold
    button.Text = buttonName
    button.TextColor3 = colors.text
    button.TextSize = 14
    button.Parent = contentFrame

    -- Add corner rounding
    local buttonCorner = Instance.new('UICorner')
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button

    -- Hover effects
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = colors.buttonHover
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = colors.button
    end)

    -- Click handler
    button.MouseButton1Click:Connect(function()
        callback(playerInput.Text) -- Pass the player input to the callback
    end)

    currentYPosition = currentYPosition + 35 + elementPadding
    UpdateFrameSize()

    return button
end

-- Create a new toggle
function CreateToggle(toggleName, defaultState, callback)
    local toggleFrame = Instance.new('Frame')
    toggleFrame.Name = toggleName .. 'Toggle'
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Position = UDim2.new(0, 0, 0, currentYPosition)
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.Parent = contentFrame

    local label = Instance.new('TextLabel')
    label.Name = 'Label'
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = toggleName
    label.TextColor3 = colors.text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleButton = Instance.new('TextButton')
    toggleButton.Name = 'ToggleButton'
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = defaultState and colors.toggleOn
        or colors.toggleOff
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(1, 0, 0.5, 0)
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.Text = defaultState and 'ON' or 'OFF'
    toggleButton.TextColor3 = colors.text
    toggleButton.TextSize = 12
    toggleButton.Parent = toggleFrame

    local toggleCorner = Instance.new('UICorner')
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton

    toggleButton.MouseButton1Click:Connect(function()
        local newState = not (toggleButton.Text == 'ON')
        toggleButton.Text = newState and 'ON' or 'OFF'
        toggleButton.BackgroundColor3 = newState and colors.toggleOn
            or colors.toggleOff
        callback(newState, playerInput.Text) -- Pass state and player input to callback
    end)

    currentYPosition = currentYPosition + 30 + elementPadding
    UpdateFrameSize()

    return toggleFrame
end

-- Create a label
function CreateLabel(labelText)
    local label = Instance.new('TextLabel')
    label.Name = labelText .. 'Label'
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, currentYPosition)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Gotham
    label.Text = labelText
    label.TextColor3 = colors.text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = contentFrame

    currentYPosition = currentYPosition + 20 + elementPadding
    UpdateFrameSize()

    return label
end

function CreateDropdown(name, options, callback)
    local dropdownHeight = 30
    local optionHeight = 30
    local expandedHeight = dropdownHeight + (optionHeight * #options)

    -- Store original Y position before any dropdown expansion
    local originalYPosition = currentYPosition

    -- Create main container frame
    local dropdownContainer = Instance.new('Frame')
    dropdownContainer.Name = name .. 'DropdownContainer'
    dropdownContainer.BackgroundTransparency = 1
    dropdownContainer.Position = UDim2.new(0, 0, 0, originalYPosition)
    dropdownContainer.Size = UDim2.new(1, 0, 0, dropdownHeight)
    dropdownContainer.ClipsDescendants = true
    dropdownContainer.Parent = contentFrame

    -- Create the selected option button
    local selectedButton = Instance.new('TextButton')
    selectedButton.Name = 'SelectedButton'
    selectedButton.BackgroundColor3 = colors.input
    selectedButton.Size = UDim2.new(1, 0, 0, dropdownHeight)
    selectedButton.Font = Enum.Font.Gotham
    selectedButton.Text = 'Select ' .. name
    selectedButton.TextColor3 = colors.text
    selectedButton.TextSize = 14
    selectedButton.TextXAlignment = Enum.TextXAlignment.Left
    selectedButton.ZIndex = 2
    selectedButton.Parent = dropdownContainer

    local selectedCorner = Instance.new('UICorner')
    selectedCorner.CornerRadius = UDim.new(0, 4)
    selectedCorner.Parent = selectedButton

    local selectedPadding = Instance.new('UIPadding')
    selectedPadding.PaddingLeft = UDim.new(0, 8)
    selectedPadding.Parent = selectedButton

    -- Create dropdown frame that will contain all options
    local dropdownFrame = Instance.new('Frame')
    dropdownFrame.Name = 'DropdownFrame'
    dropdownFrame.BackgroundColor3 = colors.background
    dropdownFrame.BackgroundTransparency = 0
    dropdownFrame.Position = UDim2.new(0, 0, 0, dropdownHeight)
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Visible = false
    dropdownFrame.ZIndex = 10
    dropdownFrame.Parent = dropdownContainer

    local dropdownFrameCorner = Instance.new('UICorner')
    dropdownFrameCorner.CornerRadius = UDim.new(0, 4)
    dropdownFrameCorner.Parent = dropdownFrame

    -- Create options
    for i, option in ipairs(options) do
        local optionButton = Instance.new('TextButton')
        optionButton.Name = option
        optionButton.BackgroundColor3 = colors.input
        optionButton.BorderSizePixel = 0
        optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * optionHeight)
        optionButton.Size = UDim2.new(1, 0, 0, optionHeight)
        optionButton.Font = Enum.Font.Gotham
        optionButton.Text = option
        optionButton.TextColor3 = colors.text
        optionButton.TextSize = 14
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.ZIndex = 11
        optionButton.Parent = dropdownFrame

        local corner = Instance.new('UICorner')
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = optionButton

        local padding = Instance.new('UIPadding')
        padding.PaddingLeft = UDim.new(0, 8)
        padding.Parent = optionButton

        optionButton.MouseButton1Click:Connect(function()
            selectedButton.Text = option
            dropdownFrame.Visible = false
            dropdownContainer.Size = UDim2.new(1, 0, 0, dropdownHeight)
            callback(option, playerInput.Text)
        end)
    end

    -- Toggle dropdown visibility
    local isExpanded = false
    selectedButton.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded

        if isExpanded then
            -- Show all options
            dropdownFrame.Visible = true
            dropdownFrame.Size = UDim2.new(1, 0, 0, optionHeight * #options)
            dropdownContainer.Size = UDim2.new(1, 0, 0, expandedHeight)

            -- Bring to front
            dropdownContainer.ZIndex = 10
            selectedButton.ZIndex = 11
            dropdownFrame.ZIndex = 10
        else
            -- Collapse the dropdown
            dropdownFrame.Visible = false
            dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
            dropdownContainer.Size = UDim2.new(1, 0, 0, dropdownHeight)

            -- Reset ZIndex
            dropdownContainer.ZIndex = 1
            selectedButton.ZIndex = 2
            dropdownFrame.ZIndex = 1
        end
    end)

    -- Close dropdown when clicking elsewhere
    local inputConnection
    inputConnection = game
        :GetService('UserInputService').InputBegan
        :Connect(function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseButton1
                and isExpanded
            then
                local mousePos = input.Position
                local absolutePos = dropdownContainer.AbsolutePosition
                local absoluteSize = dropdownContainer.AbsoluteSize

                -- Check if click was outside the dropdown
                if
                    not (
                        mousePos.X >= absolutePos.X
                        and mousePos.X <= absolutePos.X + absoluteSize.X
                        and mousePos.Y >= absolutePos.Y
                        and mousePos.Y <= absolutePos.Y + absoluteSize.Y
                    )
                then
                    isExpanded = false
                    dropdownFrame.Visible = false
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
                    dropdownContainer.Size = UDim2.new(1, 0, 0, dropdownHeight)

                    -- Reset ZIndex
                    dropdownContainer.ZIndex = 1
                    selectedButton.ZIndex = 2
                    dropdownFrame.ZIndex = 1
                end
            end
        end)

    -- Clean up the connection when the dropdown is destroyed
    dropdownContainer.Destroying:Connect(function()
        if inputConnection then
            inputConnection:Disconnect()
        end
    end)

    currentYPosition = currentYPosition + dropdownHeight + elementPadding
    UpdateFrameSize()

    return dropdownContainer
end

-- Draggable window functionality
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if
        input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
    then
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
    if
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    then
        dragInput = input
    end
end)

game:GetService('UserInputService').InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Example usage:
CreateSection('Random Shit')
CreateButton('Damage player', function(playerName)
    local targetName = string.sub(playerName or '', 1, 20)
    game.ReplicatedStorage.Events.ClickAttack:FireServer(
        game.Players[targetName].Character,
        1,
        false
    )
    print(
        game.Players[targetName].Character:FindFirstChild('Humanoid').Health
            .. ' Remaining HP'
    )
end)

CreateButton('Damage near', function(playerName)
    for i, v in pairs(game.Players:GetPlayers()) do
        if
            v.Name ~= game.Players.LocalPlayer.Name
            and v.Character
            and v.Character.Humanoid
            and v.Character.Humanoid.Health > 0
            and v.Character.HumanoidRootPart
        then
            print('hitting ' .. v.Name)
            game.ReplicatedStorage.Events.ClickAttack:FireServer(
                v.Character,
                1,
                false
            )
        end
    end
end)

CreateButton('Heal Bug Hit', function()
    game.ReplicatedStorage.Events.VigorWaspEvent:FireServer(
        workspace.Effects.Vigorwasps.Vigorwasp
    )
end)
CreateSection('Toggle Features')

local killauraLoop -- store outside so it persists across toggles
local killauraActive = false

CreateToggle('Killaura', false, function(state, playerName)
    killauraActive = state
    local player = game.Players.LocalPlayer
    local attackEvent = game.ReplicatedStorage.Events.ClickAttack
    local range = 30
    local cooldown = 0.2

    local function isValidTarget(target)
        return target ~= player
            and target.Character
            and target.Character:FindFirstChild('Humanoid')
            and target.Character.Humanoid.Health > 0
            and target.Character:FindFirstChild('HumanoidRootPart')
            and (
                    target.Character.HumanoidRootPart.Position
                    - player.Character.HumanoidRootPart.Position
                ).Magnitude
                < range
    end

    if killauraActive then
        if killauraLoop then
            killauraLoop:Disconnect()
        end

        killauraLoop = game
            :GetService('RunService').Heartbeat
            :Connect(function()
                if not killauraActive then
                    return
                end
                if
                    not player.Character
                    or not player.Character:FindFirstChild('HumanoidRootPart')
                then
                    return
                end

                for _, target in ipairs(game.Players:GetPlayers()) do
                    if isValidTarget(target) then
                        print('Attacking ' .. target.Name)
                        attackEvent:FireServer(target.Character, 1, false)
                        task.wait(cooldown)
                    end
                end
            end)
    else
        -- Disable killaura
        if killauraLoop then
            killauraLoop:Disconnect()
            killauraLoop = nil
        end
    end
end)
CreateSection('Abilities')

CreateDropdown(
    'Ability Select',
    { 'Attack1', 'Attack2', 'Attack3', 'Attack4', 'Attack5' },
    function(selected, playerName)
        print(
            'Selected ability:',
            selected,
            'on player:',
            game.Players.LocalPlayer.Name
        )
        firesignal(
            game.ReplicatedStorage.Events.ReduceCooldown.OnClientEvent,
            selected,
            444
        )
    end
)

CreateSection('Information')
CreateLabel('Status: Ready')
CreateLabel('Players Online: ' .. #Players:GetPlayers())
