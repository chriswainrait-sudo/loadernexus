
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiService = game:GetService("GuiService")

local endDate = os.time({year=2026, month=4, day=10, hour=0, min=0, sec=0})

local function getTimeRemaining()
    local now = os.time()
    local remaining = endDate - now
    
    if remaining <= 0 then
        return "0d 0h 0m 0s", true
    end
    
    local days = math.floor(remaining / 86400)
    remaining = remaining % 86400
    local hours = math.floor(remaining / 3600)
    remaining = remaining % 3600
    local minutes = math.floor(remaining / 60)
    local seconds = remaining % 60
    
    return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, seconds), false
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpdateCountdownGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.6
overlay.BorderSizePixel = 0
overlay.Parent = screenGui


local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 220)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true


local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

local shadow = Instance.new("UIShadow")
shadow.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleLabel.BackgroundTransparency = 0.2
titleLabel.Text = "SCRIPT UPDATE"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
titleLabel.TextScaled = false
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextWrapped = true
titleLabel.BorderSizePixel = 0

local titleCorners = Instance.new("UICorner")
titleCorners.CornerRadius = UDim.new(0, 12)
titleCorners.Parent = titleLabel

titleLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Position = UDim2.new(0, 0, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Script is under maintenance"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 18
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

local waitLabel = Instance.new("TextLabel")
waitLabel.Name = "WaitLabel"
waitLabel.Size = UDim2.new(1, 0, 0, 30)
waitLabel.Position = UDim2.new(0, 0, 0, 100)
waitLabel.BackgroundTransparency = 1
waitLabel.Text = "Please wait..."
waitLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
waitLabel.TextSize = 16
waitLabel.Font = Enum.Font.Gotham
waitLabel.TextWrapped = true
waitLabel.Parent = mainFrame

local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "Timer"
timerLabel.Size = UDim2.new(1, 0, 0, 60)
timerLabel.Position = UDim2.new(0, 0, 0, 140)
timerLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
timerLabel.BackgroundTransparency = 0.3
timerLabel.Text = "3d 00h 00m 00s"
timerLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
timerLabel.TextSize = 28
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextWrapped = true

local timerCorners = Instance.new("UICorner")
timerCorners.CornerRadius = UDim.new(0, 8)
timerCorners.Parent = timerLabel

timerLabel.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BackgroundTransparency = 0.8
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0

local closeCorners = Instance.new("UICorner")
closeCorners.CornerRadius = UDim.new(1, 0)
closeCorners.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

closeButton.Parent = mainFrame

mainFrame.Parent = screenGui

screenGui.Parent = player:WaitForChild("PlayerGui")

local function updateTimer()
    while screenGui and screenGui.Parent do
        local timeStr, isExpired = getTimeRemaining()
        
        if isExpired then
            timerLabel.Text = "0d 00h 00m 00s"
            statusLabel.Text = "✅ UPDATE READY ✅"
            waitLabel.Text = "Script is now available! Re-inject to use."
            waitLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            break
        else
            timerLabel.Text = timeStr
        end
        
        wait(1)
    end
end

spawn(updateTimer)

mainFrame.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

game:GetService("TweenService"):Create(
    mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {BackgroundTransparency = 0.1, Size = UDim2.new(0, 400, 0, 220), Position = UDim2.new(0.5, -200, 0.5, -110)}
):Play()
