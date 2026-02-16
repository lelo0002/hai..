local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {
	Open = true,
	Accent = Color3.fromRGB(84, 101, 255), -- Approximating the blueish-purple
	Font = Enum.Font.Lato, -- Clean font
}

local Theme = {
	Background = Color3.fromRGB(15, 15, 20),
	Header = Color3.fromRGB(20, 20, 25),
	Section = Color3.fromRGB(18, 18, 22),
	Stroke = Color3.fromRGB(35, 35, 45),
	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(150, 150, 160),
	Accent = Color3.fromRGB(100, 115, 255), -- Bright blue/purple
	AccentDark = Color3.fromRGB(60, 65, 140),
	ToggleBg = Color3.fromRGB(30, 30, 35)
}

-- Utility Functions
local function Create(class, properties)
	local instance = Instance.new(class)
	for k, v in pairs(properties) do
		instance[k] = v
	end
	return instance
end

local function MakeDraggable(topbar, object)
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then return (function() dragging = false end)() end
			end)
		end
	end)
	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)
end

function Library:CreateWindow(options)
	local TitleName = options.Name or "nebula.tech"
	
	local ScreenGui = Create("ScreenGui", {
		Name = "NebulaUI",
		Parent = game:GetService("CoreGui"),
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false
	})
	
	local Main = Create("Frame", {
		Name = "Main",
		Parent = ScreenGui,
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(600, 450),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
	
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Main})
	Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = Main})
	
	-- Top Bar
	local TopBar = Create("Frame", {
		Name = "TopBar",
		Parent = Main,
		BackgroundColor3 = Theme.Header,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 30)
	})
	Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = TopBar})
	-- Fix corner bottom
	local TopBarFiller = Create("Frame", {
		Parent = TopBar,
		BackgroundColor3 = Theme.Header,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 10),
		Position = UDim2.new(0, 0, 1, -10),
		ZIndex = 1
	}) 
	
	local Title = Create("TextLabel", {
		Parent = TopBar,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		Font = Library.Font,
		Text = TitleName .. " - " .. os.date("%b %d %Y"),
		TextColor3 = Theme.SubText,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 2
	})
	
	MakeDraggable(TopBar, Main)

	-- Tab Container Area
	local TabContainer = Create("Frame", {
		Name = "TabContainer",
		Parent = Main,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 35),
		Size = UDim2.new(1, -20, 0, 25)
	})
	
	local TabListing = Create("UIListLayout", {
		Parent = TabContainer,
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	
	-- Content Area
	local ContentContainer = Create("Frame", {
		Name = "ContentContainer",
		Parent = Main,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 65),
		Size = UDim2.new(1, -20, 1, -75)
	})

	local Window = {
		Tabs = {}
	}
	
	function Window:AddTab(name)
		local Tab = {
			Active = false
		}
		
		-- Tab Button
		local Button = Create("TextButton", {
			Name = name,
			Parent = TabContainer,
			BackgroundColor3 = Theme.Header,
			Size = UDim2.new(0, 0, 1, 0), -- Width set dynamically or fixed? Let's auto-scale or fixed.
			Font = Library.Font,
			Text = name,
			TextColor3 = Theme.SubText,
			TextSize = 13,
			AutoButtonColor = false
		})
		-- Auto scale width based on count? Or just fixed. Let's do Flex width if possible, but UIGrid is easier. 
		-- actually, let's just make them share width.
		local flexWidth = 1 / 3 -- Assuming 3 tabs max usually, but let's just make it look like the picture.
		-- The picture has them filling the width.
		Button.Size = UDim2.new(0, 180, 1, 0) -- Approximate
		
		Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = Button})
		local BtnStroke = Create("UIStroke", {
			Color = Theme.Stroke,
			Thickness = 1,
			Parent = Button,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		})
		
		-- Tab Content Page
		local Page = Create("Frame", {
			Name = name .. "_Page",
			Parent = ContentContainer,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = false
		})
		
		-- Columns (Left and Right)
		local LeftColumn = Create("Frame", {
			Name = "Left",
			Parent = Page,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, -5, 1, 0),
			Position = UDim2.new(0, 0, 0, 0)
		})
		local LeftList = Create("UIListLayout", {
			Parent = LeftColumn,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		
		local RightColumn = Create("Frame", {
			Name = "Right",
			Parent = Page,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, -5, 1, 0),
			Position = UDim2.new(0.5, 5, 0, 0)
		})
		local RightList = Create("UIListLayout", {
			Parent = RightColumn,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		
		function Tab:Activate()
			-- Reset all tabs
			for _, t in pairs(Window.Tabs) do
				t.Button.TextColor3 = Theme.SubText
				t.Button.BackgroundColor3 = Theme.Header
				t.Page.Visible = false
				t.Active = false
			end
			
			-- Activate this
			Tab.Active = true
			Button.TextColor3 = Theme.Accent
			-- Button.BackgroundColor3 = Theme.Section -- Optional highlight
			Page.Visible = true
		end
		
		Button.MouseButton1Click:Connect(function()
			Tab:Activate()
		end)
		
		Tab.Button = Button
		Tab.Page = Page
		
		table.insert(Window.Tabs, Tab)
		if #Window.Tabs == 1 then Tab:Activate() end
		
		-- Group/Section Creator
		function Tab:AddGroup(options)
			local Side = options.Side or "Left"
			local GroupName = options.Name or "Group"
			local ParentCol = (Side == "Left" and LeftColumn) or RightColumn
			
			local GroupFrame = Create("Frame", {
				Name = GroupName,
				Parent = ParentCol,
				BackgroundColor3 = Theme.Header,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0), -- Autosize
				AutomaticSize = Enum.AutomaticSize.Y
			})
			Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = GroupFrame})
			Create("UIStroke", {Color = Theme.Stroke, Thickness = 1, Parent = GroupFrame})
			
			-- Header with Line
			local Header = Create("Frame", {
				Parent = GroupFrame,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 24)
			})
			local TitleLbl = Create("TextLabel", {
				Parent = Header,
				Text = GroupName,
				Font = Library.Font,
				TextSize = 13,
				TextColor3 = Theme.Text,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0)
			})
			-- Gradient Line/Decoration
			local Line = Create("Frame", {
				Parent = Header,
				BackgroundColor3 = Theme.Accent,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundTransparency = 0.5
			})
			
			local Container = Create("Frame", {
				Parent = GroupFrame,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 8, 0, 30),
				Size = UDim2.new(1, -16, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
			local ContainerLayout = Create("UIListLayout", {
				Parent = Container,
				Padding = UDim.new(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			
			-- Padding bottom for the group
			local Padding = Create("UIPadding", {
				Parent = GroupFrame,
				PaddingBottom = UDim.new(0, 8)
			})
			
			local Group = {}
			
			function Group:AddToggle(text, default, callback)
				local ToggleCheck = default or false
				
				local ToggleFrame = Create("Frame", {
					Parent = Container,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 18)
				})
				
				local Box = Create("TextButton", {
					Parent = ToggleFrame,
					BackgroundColor3 = ToggleCheck and Theme.Accent or Theme.ToggleBg,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 14, 0, 14),
					Position = UDim2.new(0, 0, 0, 2),
					Text = "",
					AutoButtonColor = false
				})
				Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = Box})
				
				local Label = Create("TextLabel", {
					Parent = ToggleFrame,
					Text = text,
					Font = Library.Font,
					TextSize = 13,
					TextColor3 = ToggleCheck and Theme.Text or Theme.SubText,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -20, 1, 0),
					Position = UDim2.new(0, 20, 0, 0),
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local function Update()
					TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = ToggleCheck and Theme.Accent or Theme.ToggleBg}):Play()
					TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = ToggleCheck and Theme.Text or Theme.SubText}):Play()
					if callback then callback(ToggleCheck) end
				end
				
				Box.MouseButton1Click:Connect(function()
					ToggleCheck = not ToggleCheck
					Update()
				end)
				
				-- Return object if needed to update externally
			end
			
			function Group:AddSlider(text, options, callback)
				local min = options.min or 0
				local max = options.max or 100
				local default = options.default or min
				local suffix = options.suffix or ""
				
				local Value = default
				
				local SliderFrame = Create("Frame", {
					Parent = Container,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 32)
				})
				
				local Label = Create("TextLabel", {
					Parent = SliderFrame,
					Text = text,
					Font = Library.Font,
					TextColor3 = Theme.SubText,
					TextSize = 13,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 14),
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local ValueLabel = Create("TextLabel", {
					Parent = SliderFrame,
					Text = tostring(Value) .. suffix,
					Font = Library.Font,
					TextColor3 = Theme.Text,
					TextSize = 13,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 14),
					TextXAlignment = Enum.TextXAlignment.Right
				})
				
				local SlideBg = Create("Frame", {
					Parent = SliderFrame,
					BackgroundColor3 = Theme.ToggleBg,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 6),
					Position = UDim2.new(0, 0, 0, 22)
				})
				Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = SlideBg})
				
				local SlideFill = Create("Frame", {
					Parent = SlideBg,
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel = 0,
					Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
				})
				Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = SlideFill})
				
				local Trigger = Create("TextButton", {
					Parent = SlideBg,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Text = ""
				})
				
				local dragging = false
				
				local function Update(input)
					local pos = UDim2.new(math.clamp((input.Position.X - SlideBg.AbsolutePosition.X) / SlideBg.AbsoluteSize.X, 0, 1), 0, 1, 0)
					TweenService:Create(SlideFill, TweenInfo.new(0.1), {Size = pos}):Play()
					
					local newVal = math.floor(min + ((max - min) * pos.X.Scale))
					Value = newVal
					ValueLabel.Text = tostring(Value) .. suffix
					if callback then callback(Value) end
				end
				
				Trigger.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						Update(input)
					end
				end)
				
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)
				
				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						Update(input)
					end
				end)
			end
			
			function Group:AddDropdown(text, options, callback)
				local Dropped = false
				local Items = options.values or {}
				local Selected = options.default or Items[1]
				
				local DropdownFrame = Create("Frame", {
					Parent = Container,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 36),
					AutomaticSize = Enum.AutomaticSize.Y
				})
				
				local Label = Create("TextLabel", {
					Parent = DropdownFrame,
					Text = text,
					Font = Library.Font,
					TextColor3 = Theme.SubText,
					TextSize = 13,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 14),
					TextXAlignment = Enum.TextXAlignment.Left
				})
				
				local Interactive = Create("TextButton", {
					Parent = DropdownFrame,
					BackgroundColor3 = Theme.ToggleBg,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 20),
					Position = UDim2.new(0, 0, 0, 16),
					Text = "   " .. tostring(Selected),
					TextColor3 = Theme.Text,
					TextSize = 13,
					Font = Library.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutoButtonColor = false
				})
				Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = Interactive})
				
				local Icon = Create("ImageLabel", {
					Parent = Interactive,
					BackgroundTransparency = 1,
					Image = "rbxassetid://6031090990", -- Arrow down
					Size = UDim2.new(0, 14, 0, 14),
					Position = UDim2.new(1, -18, 0.5, -7),
					ImageColor3 = Theme.SubText
				})
				
				local OptionList = Create("Frame", {
					Parent = DropdownFrame,
					BackgroundColor3 = Theme.Header,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0),
					Position = UDim2.new(0, 0, 1, 2),
					Visible = false,
					ZIndex = 5
				})
				local OptionLayout = Create("UIListLayout", {
					Parent = OptionList,
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = OptionList})
				
				local function RefreshOptions()
					for _, v in pairs(OptionList:GetChildren()) do
						if v:IsA("TextButton") then v:Destroy() end
					end
					
					for i, v in pairs(Items) do
						local OptBtn = Create("TextButton", {
							Parent = OptionList,
							BackgroundColor3 = Theme.Header,
							BackgroundTransparency = 0,
							Size = UDim2.new(1, 0, 0, 20),
							Text = v,
							TextColor3 = (v == Selected) and Theme.Accent or Theme.SubText,
							Font = Library.Font,
							TextSize = 13,
							ZIndex = 6,
							AutoButtonColor = false
						})
						
						OptBtn.MouseEnter:Connect(function()
							OptBtn.BackgroundColor3 = Theme.Section
						end)
						OptBtn.MouseLeave:Connect(function()
							OptBtn.BackgroundColor3 = Theme.Header
						end)
						
						OptBtn.MouseButton1Click:Connect(function()
							Selected = v
							Interactive.Text = "   " .. tostring(Selected)
							Dropped = false
							OptionList.Visible = false
							DropdownFrame.Size = UDim2.new(1, 0, 0, 36)
							if callback then callback(v) end
						end)
					end
					OptionList.Size = UDim2.new(1, 0, 0, #Items * 20)
				end
				
				Interactive.MouseButton1Click:Connect(function()
					Dropped = not Dropped
					OptionList.Visible = Dropped
					RefreshOptions()
					if Dropped then
						-- In a real scrolling setup, we'd need to resize content, but since this is overlay (ZIndex), 
						-- we might just let it float. However, ListLayouts don't like floating children breaking flow usually 
						-- unless we handle it carefully. For simplicity in this replicate, we push content down.
						DropdownFrame.Size = UDim2.new(1, 0, 0, 36 + (OptionList.Size.Y.Offset))
					else
						DropdownFrame.Size = UDim2.new(1, 0, 0, 36)
					end
				end)
			end
			
			return Group
		end
		
		return Tab
	end
	
	return Window
end

