if (not game:IsLoaded()) then
    game.Loaded:Wait()
end

--// Services
local ps = game:GetService("Players")
local ls = game:GetService("Lighting")
local rs = game:GetService("RunService")
local ts = game:GetService("Teams")
local uiss = game:GetService("UserInputService")

--// Local Variables
local c = workspace.CurrentCamera
local lp = ps.LocalPlayer
local lp_char = lp.Character
local PlaceId = game.PlaceId
local Mouse = lp:GetMouse()
local Mouse_vector = Vector2.new(Mouse.X, Mouse.Y)

--// Settings

--[[ 
    Fonts:
    UI	0
    System	1
    Plex	2
    Monospace	3

    Roundings:
    Rounding 0 - 5
    Rounding 1 - 5.1
    Rounding 2 - 5.15
    Rounding 3 - 5.155
]]--

local DefaultSettings = {
    ESP = {
        NamesEnabled = false,
        TracerEnabled = false,
        HealthEnabled = false,
        BoxEnabled = false,

        Color = Color3.fromRGB(255, 255, 255),
        Size = 13,
        Font = 2,
        Thickness = 1,
        Transparency = 1,
    },
    VERSION = 0.1
}
local espSettings = DefaultSettings.ESP
local hubVersion = DefaultSettings.VERSION

local repo = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'Ozki Skidded ' .. hubVersion,
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Main'), 
    Other = Window:AddTab('Other'),

    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Tabs
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('xddd')
local MainGroupBoxSettings = Tabs.Main:AddLeftGroupbox('Ben HOHOHO')
local OtherGroupBox = Tabs.Other:AddLeftGroupbox('fuk!')


-- Main Toggles
MainGroupBoxSettings:AddLabel('Color'):AddColorPicker('ColorPicker', {
    Default = espSettings.Color, -- Bright green
    Title = 'Some color', -- Optional. Allows you to have a custom color picker title (when you open it)
})

MainGroupBoxSettings:AddSlider('Font', {
    Text = 'Font',
    Default = espSettings.Font,
    Min = 1,
    Max = 3,
    Rounding = 0,
    Compact = true,
})

MainGroupBoxSettings:AddSlider('Size', {
    Text = 'Size',
    Default = espSettings.Size,
    Min = 0,
    Max = 40,
    Rounding = 0,
    Compact = true,
})

MainGroupBoxSettings:AddSlider('Thickness', {
    Text = 'Thickness',
    Default = 1,
    Min = 0,
    Max = 3,
    Rounding = 1,
    Compact = true,
})
--Main

LeftGroupBox:AddToggle('TeamCheck', {
    Text = 'Team Check - Not working rn',
    Default = false, -- Default value (true / false)
})

LeftGroupBox:AddToggle('NameESP', {
    Text = 'Name',
    Default = espSettings.NamesEnabled, -- Default value (true / false)
})

LeftGroupBox:AddToggle('Tracer', {
    Text = 'Tracer',
    Default = espSettings.TracerEnabled, -- Default value (true / false)
})

LeftGroupBox:AddToggle('HealthESP', {
    Text = 'Health',
    Default = espSettings.HealthEnabled, -- Default value (true / false)
})

LeftGroupBox:AddToggle('BoxESP', {
    Text = 'Box - Bugged',
    Default = espSettings.BoxEnabled, -- Default value (true / false)
})

-- Other Toggles
OtherGroupBox:AddToggle('Fly', {
    Text = 'Fly - Risky',
    Default = false, -- Default value (true / false)
})
OtherGroupBox:AddSlider('FlySlider', {
    Text = 'Fly',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = true,
})

OtherGroupBox:AddToggle('SlowFall', {
    Text = 'SlowFalling',
    Default = false, -- Default value (true / false)
})

OtherGroupBox:AddToggle('Speed', {
    Text = 'Speed',
    Default = false, -- Default value (true / false)
})
OtherGroupBox:AddSlider('SpeedSlider', {
    Text = 'Speed',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = true,
})


OtherGroupBox:AddToggle('FullBright', {
    Text = 'Full Bright - Rejoin to fix',
    Default = false, -- Default value (true / false)
})

--// Main
local function getdistancefc(part)
    return (part.Position - c.CFrame.Position).Magnitude
end

local function esp(p,cr)
    local h = cr:WaitForChild("Humanoid")
    local hrp = cr:WaitForChild("HumanoidRootPart")
    local head = cr:WaitForChild("Head")

    local HeadOff = Vector3.new(0, 0.5, 0)
    local LegOff = Vector3.new(0,0.1,0)

    local root_pos, RootVis = c:WorldToViewportPoint(hrp.Position)
    local Head_pos = c:WorldToViewportPoint(head.Position + HeadOff)
    local leg_pos = c:WorldToViewportPoint(hrp.Position - LegOff)

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true 
    text.Font = espSettings.Font
    text.Color = espSettings.Color
    text.Size = espSettings.Size

    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = espSettings.Color
    line.Thickness = espSettings.Thickness
    line.Transparency = espSettings.Transparency

    local healthtext = Drawing.new("Text")
    healthtext.Visible = false
    healthtext.Center = true
    healthtext.Outline = true 
    healthtext.Font = espSettings.Font
    healthtext.Color = espSettings.Color
    healthtext.Size = espSettings.Size

    local boxOutline = Drawing.new("Square")
    boxOutline.Visible = false
    boxOutline.Color = espSettings.Color
    boxOutline.Thickness = espSettings.Thickness
    boxOutline.Transparency = espSettings.Transparency
    boxOutline.Filled = false

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = espSettings.Color
    box.Thickness = espSettings.Thickness
    box.Transparency = espSettings.Transparency
    box.Filled = false

    local c1
    local c2
    local c3

    local function dc()
        text.Visible = false
        line.Visible = false
        healthtext.Visible = false
        box.Visible = false
        boxOutline.Visible = false
        
        if c1 then
            c1:Disconnect()
            c1 = nil 
        end
        if c2 then
            c2:Disconnect()
            c2 = nil 
        end
        if c3 then
            c3:Disconnect()
            c3 = nil 
        end
    end

    -- functions
    c2 = cr.AncestryChanged:Connect(function(_,parent)
        if not parent then
            dc()
        end
    end)

    c3 = h.HealthChanged:Connect(function(v)
        if (v<=0) or (h:GetState() == Enum.HumanoidStateType.Dead) then
            dc()
        end
    end)

    -- Main Functions
    c1 = rs.RenderStepped:Connect(function(delta)
        local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(hrp.Position)

        -- ESP ETC.
        if hrp_onscreen then
            if Toggles.TeamCheck.Value == true then
                print("STOP")
                
            end

            -- NameESP
            if Toggles.NameESP.Value == true then
                text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
                text.Font = Options.Font.Value
                text.Size = Options.Size.Value
                text.Color = Options.ColorPicker.Value
                text.Text = p.Name .. " (" .. tostring(math.floor(getdistancefc(hrp))) .. ")"
                text.Visible = true
            else
                text.Visible = false
            end

            -- Tracer
            if Toggles.Tracer.Value == true then
                line.Color = Options.ColorPicker.Value
                line.From = Vector2.new(c.ViewportSize.X / 2, c.ViewportSize.Y / 2)
                line.To = Vector2.new(hrp_pos.X, hrp_pos.Y)
                line.Thickness = Options.Thickness.Value
                line.Visible = true
            else
                line.Visible = false
            end

            -- HealthESP
            if Toggles.HealthESP.Value == true then
                healthtext.Position = Vector2.new(hrp_pos.X, hrp_pos.Y + 15)
                healthtext.Font = Options.Font.Value
                healthtext.Size = Options.Size.Value
                healthtext.Text = tostring(h.Health .. "/" .. h.MaxHealth)
                healthtext.Color = Options.ColorPicker.Value
                healthtext.Visible = true
            else
                healthtext.Visible = false
            end

            -- BoxESP
            if Toggles.BoxESP.Value == true then
                boxOutline.Size = Vector2.new(1000 / hrp_pos.Z, Head_pos.Y - leg_pos.Y)
                boxOutline.Position = Vector2.new(hrp_pos.X - boxOutline.Size.X / 2, hrp_pos.Y - boxOutline.Size.Y / 2)
                boxOutline.Visible = true

                box.Size = Vector2.new(1000 / hrp_pos.Z, Head_pos.Y - leg_pos.Y)
                box.Position = Vector2.new(hrp_pos.X - box.Size.X / 2, hrp_pos.Y - box.Size.Y / 2)
                box.Visible = true
            else
                box.Visible = false
                boxOutline.Visible = false
            end

        else
            line.Visible = false
            text.Visible = false
            healthtext.Visible = false
            box.Visible = false
            boxOutline.Visible = false
        end

        -- OTHER
        -- Fly
        if Toggles.Fly.Value == true then
            lp_char.HumanoidRootPart.Velocity = Vector3.zero

            local is_key_down = uiss:IsKeyDown(Enum.KeyCode.W)

            if (is_key_down) then
                lp_char.HumanoidRootPart.CFrame += Vector3.new(lp_char.Humanoid.MoveDirection.X * Options.FlySlider.Value * delta, c.CFrame.LookVector.Y * (Options.FlySlider.Value / 2) * delta, lp_char.Humanoid.MoveDirection.Z * Options.FlySlider.Value * delta)
            end
        end

        -- SlowFall
        if Toggles.SlowFall.Value == true then
            lp_char.HumanoidRootPart.Velocity = Vector3.zero
        end

        -- Speed
        if Toggles.Speed.Value == true then
            lp_char.HumanoidRootPart.Velocity *= Vector3.new(0,1,0)

            local is_key_down = uiss:IsKeyDown(Enum.KeyCode.W)

            if (is_key_down) then
                lp_char.HumanoidRootPart.CFrame += Vector3.new(lp_char.Humanoid.MoveDirection.X * Options.SpeedSlider.Value * delta, 0, lp_char.Humanoid.MoveDirection.Z * Options.SpeedSlider.Value * delta)
            end
        end

        -- FullBright
        if Toggles.FullBright.Value == true then
            ls.ClockTime = 12
        end
    end)
end


--// DO NOT CHANGE
local function p_added(p)
    if p.Character then
        esp(p,p.Character)
    end
    p.CharacterAdded:Connect(function(cr)
        esp(p,cr)
    end)
end

for i,p in next, ps:GetPlayers() do 
    if p ~= lp then
        p_added(p)
    end
end

ps.PlayerAdded:Connect(p_added)

--// UI Things
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' }) 
MenuGroup:AddButton('Unload', function() Library:Unload() end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetFolder('OzkiSkidded')
SaveManager:SetFolder('OzkiSkidded')

SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])
