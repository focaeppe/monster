-- ==========================================
-- GUI TOGGLE CONTROLS
-- ==========================================

-- Create open/close button
local openButton = Instance.new('TextButton')
openButton.Name = 'OpenButton'
openButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
openButton.BorderSizePixel = 0
openButton.Size = UDim2.new(0, IS_MOBILE and 80 : 60, 0, IS_MOBILE and 80 : 60)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.Font = Enum.Font.GothamBold
openButton.Text = 'MENU'
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = IS_MOBILE and 16 : 14
openButton.ZIndex = 100
openButton.Parent = playerGui

-- Round corners for button
local openButtonCorner = Instance.new('UICorner')
openButtonCorner.CornerRadius = UDim.new(1, 0) -- Perfect circle
openButtonCorner.Parent = openButton

-- Add shadow to button
local openButtonShadow = Instance.new('ImageLabel')
openButtonShadow.Name = 'Shadow'
openButtonShadow.AnchorPoint = Vector2.new(0.5, 0.5)
openButtonShadow.BackgroundTransparency = 1
openButtonShadow.BorderSizePixel = 0
openButtonShadow.Position = UDim2.new(0.5, 0, 0.5, 4)
openButtonShadow.Size = UDim2.new(1, 10, 1, 10)
openButtonShadow.Image = 'rbxassetid://1316045217'
openButtonShadow.ImageColor3 = Color3.new(0, 0, 0)
openButtonShadow.ImageTransparency = 0.8
openButtonShadow.ScaleType = Enum.ScaleType.Slice
openButtonShadow.SliceCenter = Rect.new(10, 10, 118, 118)
openButtonShadow.Parent = openButton
openButtonShadow.ZIndex = 99

-- Add touch feedback
createTouchFeedback(openButton)

-- Toggle GUI function
local function toggleGUI()
    gui.Enabled = not gui.Enabled
    if gui.Enabled then
        openButton.Text = "MENU"
        openButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    else
        openButton.Text = "MENU"
        openButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    end
end

-- Button click
openButton.MouseButton1Click:Connect(toggleGUI)

-- Keyboard shortcut for PC (Right Control key)
if not IS_MOBILE then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.RightControl then
            toggleGUI()
        end
    end)
end

-- Chat command
game.Players.LocalPlayer.Chatted:Connect(function(message)
    if string.lower(message) == "/gui" or string.lower(message) == "/menu" then
        toggleGUI()
    end
end)

print("GUI Loaded! Use the green button to open/close")
print("Chat '/gui' or press RightControl (PC) to toggle")
