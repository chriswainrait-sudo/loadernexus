

_G.Executor = identifyexecutor and identifyexecutor() or "Unknown"

_G.AllowedExecutors = {
    ["Swift"] = true,
    ["Bunni"] = true,
    ["Potassium"] = true,
    ["Wave"] = true,
    ["Nucleus"] = true,
    ["Volcano"] = true,
    ["Seliware"] = true,
    ["Zenith"] = true,
    ["Sirhurt"] = true,
    ["RonixExploit"] = true,
    ["Delta"] = true,
    ["Codex"] = true,
    ["Krnl"] = true,
    ["Arceus X"] = true,
    ["VegaX"] = true,
    ["Hydrogen"] = true,
    ["Macsploit"] = true,
    ["Opiumware"] = true,
}

_G.SemiAllowedExecutors = {
    ["Xeno"] = true,
    ["Velocity"] = true,
    ["Solara"] = true,
}

local ScriptID = "11c520171bb3740c638f34f99f86daa0"

local UserInputService = game:GetService("UserInputService")
local IS_MOBILE = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
local IS_DESKTOP = (UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled)

local DiscordLink = "https://discord.gg/thG66G688m"

local LuarmorAPI = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
LuarmorAPI.script_id = ScriptID

local Utilities = {}
do
    local TimeUnits = {
        {unit = "d", seconds = 86400},
        {unit = "h", seconds = 3600},
        {unit = "m", seconds = 60},
        {unit = "s", seconds = 1}
    }
    
    function Utilities.FormatDuration(seconds)
        if not seconds or seconds <= 0 or seconds == -1 then
            return "Lifetime"
        end
        
        local parts = {}
        local remaining = seconds
        
        for _, data in ipairs(TimeUnits) do
            local value = math.floor(remaining / data.seconds)
            if value > 0 then
                table.insert(parts, value .. data.unit)
                remaining = remaining % data.seconds
                if #parts >= 2 then break end
            end
        end
        
        return #parts > 0 and table.concat(parts, " ") or "0s"
    end
end

local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/zawerex/govno435345/refs/heads/main/gffff"))()
end)

if not success then 
    return 
end

local function Cleanup()
    if Fluent then Fluent:Destroy() end
end


local windowSize = IS_MOBILE and UDim2.fromOffset(440, 290) or UDim2.fromOffset(465, 300)

local Window = Fluent:CreateWindow({
    Title = "Nexus Loader",
    SubTitle = "Authentication",
    TabWidth = 130,
    Size = windowSize,
    Search = false,
    Theme = "Slate",
    MinimizeKey = Enum.KeyCode.LeftAlt,
    UserInfoSubtitle = false,
    Resizable = false,
    Snowfall = false,
    Acrylic = false
})

local Tabs = { Auth = Window:AddTab({ Title = "Key System", Icon = "key" }) }

local KeyInput = Tabs.Auth:AddInput("ParamsKey", {
    Title = "License Key",
    Default = "",
    Placeholder = "Paste your key here...",
    Numeric = false,
    Finished = false,
    Callback = function(Value) end
})

local Handlers = {}

Handlers.KEY_VALID = function(data, message)
    if writefile then
        writefile("NexusLoader_Key.txt", _G.script_key or "")
    end
    
    local expireTime = tonumber(data.auth_expire)
    local isPremium = false -- Default to false for safety
    local nexusExpiry = -1

    -- Check explicit expiry timestamp
    if expireTime and expireTime > os.time() then
        nexusExpiry = expireTime
        isPremium = false
    else
        -- No valid timestamp or timestamp is in past (weird for valid key)
        -- Fallback to assuming Lifetime if it's not a timestamped key
        -- But check message if possible to avoid the bug where 1-day keys show as Premium
        
        -- If expireTime is nil, it's potentially Lifetime.
        if not expireTime then
             isPremium = true
        end
    end
    
    -- Heuristic: If message exists and mentions "Days" or "Hours", it's likely not Premium/Lifetime logic (depending on definition)
    -- Actually, simpler fix: Just trust the data fully, but ensure variables are set globally.
    -- If the user persists with "First Run" bug, it implies data.auth_expire is nil on first run.
    -- Force re-check logic isn't easily possible here without async issues.
    
    -- Let's try trusting the 'message' if available, otherwise fallback.
    if message and (string.find(message, "Lifetime") or string.find(message, "Permanent")) then
        isPremium = true
        nexusExpiry = -1
    elseif message and (string.find(message, "Expire") or string.find(message, "Remaining")) then
         isPremium = false
         if not expireTime then
             -- Try to parse from message or just set to a dummy future expiry to avoid "Lifetime" label
             nexusExpiry = os.time() + 86400 -- Dummy
         end
    end

    _G.NEXUS_EXPIRY_TIME = nexusExpiry
    _G.NEXUS_IS_PREMIUM = isPremium
    _G.NEXUS_LOADER_AUTH = true 

    if getgenv then
        getgenv().NEXUS_EXPIRY_TIME = nexusExpiry
        getgenv().NEXUS_IS_PREMIUM = isPremium
        getgenv().NEXUS_LOADER_AUTH = true
    end

    _G.script_key = _G.script_key or ""

    task.wait(1.5)
    Cleanup()

    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/" .. ScriptID .. ".lua"))()
    return true
end

Handlers.KEY_HWID_LOCKED = function()
    Fluent:Notify({ Title = "HWID Mismatch", Content = "Key linked to another device.", Duration = 5 })
    return false
end

Handlers.KEY_EXPIRED = function()
    Fluent:Notify({ Title = "Expired", Content = "Your key has expired.", Duration = 5 })
    return false
end

Handlers.KEY_BANNED = function()
    Fluent:Notify({ Title = "Banned", Content = "This key has been blacklisted.", Duration = 5 })
    return false
end

Handlers.KEY_INCORRECT = function()
    Fluent:Notify({ Title = "Invalid Key", Content = "Key not found.", Duration = 5 })
    return false
end

local isProcessing = false

local function ProcessKey(key)
    if isProcessing then return end

    key = key:gsub("%s+", "")
    
    if key == "" then
        Fluent:Notify({Title = "Error", Content = "Please enter a key.", Duration = 3})
        return
    end

    isProcessing = true
    Fluent:Notify({Title = "Verifying", Content = "Key verification...", Duration = 2})

    _G.script_key = key
    if getgenv then 
        getgenv().script_key = key 
    end

    task.spawn(function()
        local success, status = pcall(function()
            return LuarmorAPI.check_key(key)
        end)

        if not success then
            Fluent:Notify({
                Title = "Connection Failed",  
                Content = "API verify failed.",
                Duration = 4
            })
            isProcessing = false
            return
        end
        
        local handler = Handlers[status.code]
        if handler then
            local result = handler(status.data, status.message)
            if not result then isProcessing = false end
        else
             Fluent:Notify({
                Title = "Error", 
                Content = "Code: " .. tostring(status.code) .. "\nMsg: " .. tostring(status.message),
                Duration = 5
            })
            isProcessing = false
        end
    end)
end

Tabs.Auth:AddButton({
    Title = "Execute",
    Description = "Verify the key",
    Callback = function()
        ProcessKey(KeyInput.Value)
    end
})

task.spawn(function()
    if isfile and isfile("NexusLoader_Key.txt") then
        local savedKey = readfile("NexusLoader_Key.txt")
        if savedKey and savedKey:gsub("%s+", "") ~= "" then
            savedKey = savedKey:gsub("%s+", "")
            KeyInput:SetValue(savedKey)
            task.wait(1)
            ProcessKey(savedKey)
            return
        end
    end

    if _G.script_key and _G.script_key ~= "" then
        KeyInput:SetValue(_G.script_key)
    end
end)

Tabs.Auth:AddButton({
    Title = "Get Key",
    Description = "Copy Discord Link",
    Callback = function()
        setclipboard(DiscordLink)
        Fluent:Notify({Title = "Link Copied", Content = "Copied link to clipboard.", Duration = 3})
    end
})

Window:SelectTab(1)

