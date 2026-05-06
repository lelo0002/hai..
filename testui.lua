local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/lelo0002/hai../refs/heads/main/roxylinoria.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/lelo0002/hai../refs/heads/main/theme.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = "roxy.win", Center = true, AutoShow = true, MenuFadeTime = 0.1, Resizable = true,
    ShowCustomCursor = false, NotifySide = "Bottom", Size = UDim2.new(0, 750, 0, 480)
})

for _, v in ipairs(Window.Holder:GetDescendants()) do
    if v:IsA("TextLabel") and v.Text:find("roxy.win") then v.RichText = true break end
end

local Tabs = { Combat = Window:AddTab("Combat"), Visuals = Window:AddTab("Visuals"), Misc = Window:AddTab("Misc"), ["UI Settings"] = Window:AddTab("Configs") }


local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("KeybindMenuOpen", {Default = Library.KeybindFrame.Visible, Text = "Open Keybind Menu", Callback = function(v) Library.KeybindFrame.Visible = v end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)

task.spawn(function()
    local current, visible = "roxy.win", true
    while true do
        if Library.Unloaded then break end
        local accent = Library.AccentColor
        local color = visible and "FFFFFF" or string.format("%02X%02X%02X", math.floor(accent.R * 255), math.floor(accent.G * 255), math.floor(accent.B * 255))
        local tag = '<font color="#' .. color .. '">$$</font>'
        Window:SetWindowTitle(tag .. " " .. current .. " " .. tag)
        visible = not visible
        task.wait(0.5)
    end
end)

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder('Roxy.win')
SaveManager:SetFolder('Roxy.win/Criminality')
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

Library:OnUnload(function()

    Library.Unloaded = true
end)

return { Library = Library, ThemeManager = ThemeManager, SaveManager = SaveManager, Options = Options, Toggles = Toggles, Window = Window, Tabs = Tabs }
