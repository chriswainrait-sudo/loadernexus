--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local Players = game:GetService("Players");
local player = Players.LocalPlayer;
local endDate = os.time({year=2026,month=4,day=10,hour=0,min=0,sec=0});
local function getTimeRemaining()
	local now = os.time();
	local remaining = endDate - now;
	if (remaining <= 0) then
		return "0d 00h 00m 00s", true;
	end
	local days = math.floor(remaining / 86400);
	remaining = remaining % 86400;
	local hours = math.floor(remaining / 3600);
	remaining = remaining % 3600;
	local minutes = math.floor(remaining / 60);
	local seconds = remaining % 60;
	return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, seconds), false;
end
local screenGui = Instance.new("ScreenGui");
screenGui.Name = "UpdateGUI";
screenGui.ResetOnSpawn = false;
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
screenGui.Parent = player:WaitForChild("PlayerGui");
local mainFrame = Instance.new("Frame");
mainFrame.Size = UDim2.new(0, 300, 0, 180);
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90);
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
mainFrame.BackgroundTransparency = 0;
mainFrame.BorderSizePixel = 1;
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100);
mainFrame.Parent = screenGui;
local title = Instance.new("TextLabel");
title.Size = UDim2.new(1, 0, 0, 40);
title.Position = UDim2.new(0, 0, 0, 0);
title.BackgroundTransparency = 1;
title.Text = "SCRIPT UPDATE";
title.TextColor3 = Color3.fromRGB(255, 255, 255);
title.TextSize = 18;
title.Font = Enum.Font.GothamBold;
title.TextXAlignment = Enum.TextXAlignment.Left;
title.PaddingLeft = UDim.new(0, 10);
title.Parent = mainFrame;
local closeButton = Instance.new("TextButton");
closeButton.Size = UDim2.new(0, 30, 0, 30);
closeButton.Position = UDim2.new(1, -35, 0, 5);
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
closeButton.BackgroundTransparency = 0;
closeButton.Text = "✕";
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255);
closeButton.TextSize = 18;
closeButton.Font = Enum.Font.GothamBold;
closeButton.BorderSizePixel = 1;
closeButton.BorderColor3 = Color3.fromRGB(100, 100, 100);
closeButton.Parent = mainFrame;
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy();
end);
local statusText = Instance.new("TextLabel");
statusText.Size = UDim2.new(1, 0, 0, 30);
statusText.Position = UDim2.new(0, 0, 0, 50);
statusText.BackgroundTransparency = 1;
statusText.Text = "Script is under maintenance";
statusText.TextColor3 = Color3.fromRGB(255, 100, 100);
statusText.TextSize = 14;
statusText.Font = Enum.Font.Gotham;
statusText.TextXAlignment = Enum.TextXAlignment.Center;
statusText.Parent = mainFrame;
local waitText = Instance.new("TextLabel");
waitText.Size = UDim2.new(1, 0, 0, 25);
waitText.Position = UDim2.new(0, 0, 0, 80);
waitText.BackgroundTransparency = 1;
waitText.Text = "Please wait...";
waitText.TextColor3 = Color3.fromRGB(180, 180, 180);
waitText.TextSize = 13;
waitText.Font = Enum.Font.Gotham;
waitText.TextXAlignment = Enum.TextXAlignment.Center;
waitText.Parent = mainFrame;
local timerText = Instance.new("TextLabel");
timerText.Size = UDim2.new(1, 0, 0, 40);
timerText.Position = UDim2.new(0, 0, 0, 115);
timerText.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
timerText.BackgroundTransparency = 0;
timerText.Text = "3d 00h 00m 00s";
timerText.TextColor3 = Color3.fromRGB(255, 255, 255);
timerText.TextSize = 20;
timerText.Font = Enum.Font.GothamBold;
timerText.TextXAlignment = Enum.TextXAlignment.Center;
timerText.BorderSizePixel = 1;
timerText.BorderColor3 = Color3.fromRGB(80, 80, 80);
timerText.Parent = mainFrame;
local function updateTimer()
	while screenGui and screenGui.Parent do
		local timeStr, expired = getTimeRemaining();
		if expired then
			timerText.Text = "0d 00h 00m 00s";
			statusText.Text = "Update ready!";
			waitText.Text = "Re-inject to use";
			waitText.TextColor3 = Color3.fromRGB(100, 255, 100);
			break;
		else
			timerText.Text = timeStr;
		end
		wait(1);
	end
end
spawn(updateTimer);
