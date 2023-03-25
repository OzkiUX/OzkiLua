--// Services
local ps = game:GetService("Players")
local rs = game:GetService("RunService")

--// Local Variables
local c = workspace.CurrentCamera
local lp = ps.LocalPlayer

local repo = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'Ozki Skidded',
    Center = true, 
    AutoShow = true,
})

local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Main'), 
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('xddd')


LeftGroupBox:AddLabel('Color'):AddColorPicker('ColorPicker', {
    Default = Color3.new(1, 0, 0), -- Bright green
    Title = 'Some color', -- Optional. Allows you to have a custom color picker title (when you open it)
})

LeftGroupBox:AddToggle('TeamCheck', {
    Text = 'Team Check - Not working rn',
    Default = false, -- Default value (true / false)
})

LeftGroupBox:AddToggle('NameESP', {
    Text = 'Name',
    Default = false, -- Default value (true / false)
})

LeftGroupBox:AddToggle('Tracer', {
    Text = 'Tracer',
    Default = false, -- Default value (true / false)
})

LeftGroupBox:AddToggle('Health', {
    Text = 'Health',
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

    local HeadOff = Vector2.new(0, 0.5, 0)
    local LegOff = Vector2.new(0,3,0)

    local root_pos, RootVis = c:WorldToViewportPoint(hrp.Position)
    local Head_pos = c:WorldToViewportPoint(head.Position + HeadOff)
    local leg_pos = c:WorldToViewportPoint(hrp.Position - LegOff)

    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true 
    text.Font = 2
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Size = 13

    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.fromRGB(255,255,255)
    line.Thickness = 1
    line.Transparency = 1

    local healthtext = Drawing.new("Text")
    healthtext.Visible = false
    healthtext.Center = true
    healthtext.Outline = true 
    healthtext.Font = 2
    healthtext.Color = Color3.fromRGB(255, 255, 255)
    healthtext.Size = 13

    local boxOutline = Drawing.new("Square")
    boxOutline.Visible = false
    boxOutline.Color = Color3.fromRGB(0,0,0)
    boxOutline.Thickness = 1
    boxOutline.Transparency = 1
    boxOutline.Filled = false

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(1,1,1)
    box.Thickness = 1
    box.Transparency = 1
    box.Filled = false

    local c1
    local c2
    local c3

    local function dc()
        text.Visible = false
        line.Visible = false
        healthtext.Visible = false

        healthtext:Remove()
        text:Remove()
        line:Remove()
        
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
    c1 = rs.RenderStepped:Connect(function()
        local hrp_pos,hrp_onscreen = c:WorldToViewportPoint(hrp.Position)

        if hrp_onscreen then
            -- NameESP
            if Toggles.NameESP.Value == true then
                text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
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
                line.Visible = true
            else
                line.Visible = false
            end

            if Toggles.Health.Value == true then
                healthtext.Position = Vector2.new(hrp_pos.X, hrp_pos.Y + 15)
                healthtext.Text = tostring(h.Health .. "/" .. h.MaxHealth)
                healthtext.Color = Options.ColorPicker.Value
                healthtext.Visible = true
            else
                healthtext.Visible = false
            end

        else
            line.Visible = false
            text.Visible = false
            healthtext.Visible = false
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