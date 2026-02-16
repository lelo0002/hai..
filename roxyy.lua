local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(18, 18, 22),
    Panel = Color3.fromRGB(22, 22, 28),
    Outline = Color3.fromRGB(60, 60, 70),
    Accent = Color3.fromRGB(120, 90, 255),
    Text = Color3.fromRGB(220, 220, 230),
    SubText = Color3.fromRGB(160, 160, 170)
}

local Font = Enum.Font.Code

local function Create(instance, props)
    local obj = Instance.new(instance)
    for i,v in pairs(props) do
        obj[i] = v
    end
    return obj
end

function Library:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "SplixLikeUI",
        Parent = game:GetService("CoreGui"),
        ResetOnSpawn = false
    })

    local Main = Create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.fromOffset(620, 420),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0
    })

    Create("UICorner", {CornerRadius = UDim.new(0,6), Parent = Main})
    Create("UIStroke", {Color = Theme.Outline, Thickness = 1, Parent = Main})

    local Glow = Create("UIStroke", {
        Parent = Main,
        Color = Theme.Accent,
        Thickness = 1,
        Transparency = 0.85
    })

    local Title = Create("TextLabel", {
        Parent = Main,
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.fromOffset(10, 6),
        BackgroundTransparency = 1,
        Text = title,
        Font = Font,
        TextSize = 16,
        TextXAlignment = Left,
        TextColor3 = Theme.Text
    })

    local TabsHolder = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.fromOffset(10, 44),
        BackgroundTransparency = 1
    })

    local TabsLayout = Create("UIListLayout", {
        Parent = TabsHolder,
        FillDirection = Horizontal,
        Padding = UDim.new(0,6)
    })

    local Pages = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1, -20, 1, -86),
        Position = UDim2.fromOffset(10, 80),
        BackgroundTransparency = 1
    })

    local Window = {}
    local CurrentPage

    function Window:AddTab(name)
        local Button = Create("TextButton", {
            Parent = TabsHolder,
            Size = UDim2.fromOffset(90, 28),
            BackgroundColor3 = Theme.Panel,
            Text = name,
            Font = Font,
            TextSize = 13,
            TextColor3 = Theme.SubText,
            AutoButtonColor = false
        })

        Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = Button})
        Create("UIStroke", {Color = Theme.Outline, Thickness = 1, Parent = Button})

        local Page = Create("Frame", {
            Parent = Pages,
            Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 1,
            Visible = false
        })

        local Layout = Create("UIListLayout", {
            Parent = Page,
            Padding = UDim.new(0,8)
        })

        Button.MouseButton1Click:Connect(function()
            if CurrentPage then
                CurrentPage.Visible = false
            end
            CurrentPage = Page
            Page.Visible = true
            for _,v in pairs(TabsHolder:GetChildren()) do
                if v:IsA("TextButton") then
                    v.TextColor3 = Theme.SubText
                end
            end
            Button.TextColor3 = Theme.Text
        end)

        if not CurrentPage then
            Button.TextColor3 = Theme.Text
            Page.Visible = true
            CurrentPage = Page
        end

        local Tab = {}

        function Tab:AddSection(text)
            local Section = Create("Frame", {
                Parent = Page,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Theme.Panel,
                AutomaticSize = Y
            })

            Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = Section})
            Create("UIStroke", {Color = Theme.Outline, Thickness = 1, Parent = Section})

            local Title = Create("TextLabel", {
                Parent = Section,
                Size = UDim2.new(1, -12, 0, 24),
                Position = UDim2.fromOffset(6, 6),
                BackgroundTransparency = 1,
                Text = text,
                Font = Font,
                TextSize = 13,
                TextXAlignment = Left,
                TextColor3 = Theme.Text
            })

            local Content = Create("Frame", {
                Parent = Section,
                Size = UDim2.new(1, -12, 0, 0),
                Position = UDim2.fromOffset(6, 30),
                BackgroundTransparency = 1,
                AutomaticSize = Y
            })

            local Layout = Create("UIListLayout", {
                Parent = Content,
                Padding = UDim.new(0,6)
            })

            local SectionAPI = {}

            function SectionAPI:AddToggle(text, default, callback)
                local Toggle = Create("TextButton", {
                    Parent = Content,
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = Theme.Background,
                    Text = "",
                    AutoButtonColor = false
                })

                Create("UICorner", {CornerRadius = UDim.new(0,4), Parent = Toggle})
                Create("UIStroke", {Color = Theme.Outline, Thickness = 1, Parent = Toggle})

                local Label = Create("TextLabel", {
                    Parent = Toggle,
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.fromOffset(8, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    Font = Font,
                    TextSize = 13,
                    TextXAlignment = Left,
                    TextColor3 = Theme.Text
                })

                local Box = Create("Frame", {
                    Parent = Toggle,
                    Size = UDim2.fromOffset(16,16),
                    Position = UDim2.new(1, -24, 0.5, -8),
                    BackgroundColor3 = default and Theme.Accent or Theme.Panel
                })

                Create("UICorner", {CornerRadius = UDim.new(0,3), Parent = Box})

                local State = default

                Toggle.MouseButton1Click:Connect(function()
                    State = not State
                    TweenService:Create(Box, TweenInfo.new(0.15), {
                        BackgroundColor3 = State and Theme.Accent or Theme.Panel
                    }):Play()
                    if callback then callback(State) end
                end)
            end

            return SectionAPI
        end

        return Tab
    end

    return Window
end

return Library
