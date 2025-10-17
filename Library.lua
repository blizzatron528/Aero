-- // UI Yay \\ --
function getgenv() return _G end

local Aero = {
	
	Tabs  	  = {},
	Sections  = {},
	Dropdowns = {},
	
	Fonts = {
		Bold	 = Font.new("rbxassetid://12187364147", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		Medium	 = Font.new("rbxassetid://12187364147", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		Regular  = Font.new("rbxassetid://12187364147", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		SemiBold = Font.new("rbxassetid://12187364147", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	},
	
	InfoDisplay   = {},
	
	ThemeStorage  = {
		
		Tabs = { 
			Glow  = {},
			Icons = {}
		},
		
		Dropdowns = {
			Icons = {}
		},
		
		SideGlow  = {},
	},
	
	Themes = {
		
		MainColor = Color3.fromRGB(34, 115, 255),
		
		Tabs = {
			Glow  = Color3.fromRGB(94, 94, 255) ,
			Icon  = Color3.fromRGB(34, 115, 255)
		}
		
	}
	
}


-- // Services \\ --


local Players 	  	   = game:GetService("Players")
local RunService  	   = game:GetService("RunService")
local HttpService	   = game:GetService("HttpService")
local StatsService 	   = game:GetService("Stats")
local TweenService 	   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- // Variables \\ --

local Player = Players.LocalPlayer
local Mouse  = Player:GetMouse()
local Camera = workspace.CurrentCamera
local Spring = RunService:IsStudio() and require(workspace.spr) or loadstring(game:HttpGet("https://raw.githubusercontent.com/nyzuu/SprLib/main/spr.lua"))()

-- // Set LPH Variables \\ --

if not LPH_OBFUSCATED then
	LPH_JIT_MAX = function(...) return(...) end;
	LPH_NO_VIRTUALIZE = function(...) return(...) end;
end

-- // UI Functions \\ --


function createInstance(className, properties)
	local instance = Instance.new(className)
	for k, v in pairs(properties) do
		if typeof(k) ~= 'string' then
			continue
		end

		instance[k] = v
	end
	return instance
end

local function HasProperty(Instance, Property)
	local Good, _ = pcall(function()
		return Instance[Property]
	end)
	return Good
end

function ToRGB(color)  
	return color.R*255,color.G*255,color.B*255
end

local function RgbToHex(r, g, b)
	r = math.clamp(r, 0, 255)
	g = math.clamp(g, 0, 255)
	b = math.clamp(b, 0, 255)
	
	return string.format("#%02X%02X%02X", r, g, b)
end

local function CreateDrag(gui, Id)
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		TweenService:Create(gui, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play();
	end
	
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging and (Id and Aero.Sections[Id].CanDrag or true) then
			update(input)
		end
	end)
end


-- // Interface Logic \\ --

function Aero:Initialize()
	
	local AeroWindow = {}
	
	local ScreenGui = Instance.new("ScreenGui", RunService:IsStudio() and Player.PlayerGui or game:GetService("CoreGui"))
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local Main = createInstance("Frame", {
		Position = UDim2.new(0.244, 0, 0.204, 0),
		Size = UDim2.new(0, 868, 0, 647),
		Parent = ScreenGui,
		BackgroundColor3 = Color3.fromRGB(16, 18, 22),
		BorderSizePixel = 0,
		ZIndex = 3
	})
	
	CreateDrag(Main)
	
	local Logo = createInstance("ImageButton", {
		Name = "ImageButton",
		Position = UDim2.new(0.055, 0.000, 0.065, 0.000),
		Size = UDim2.new(0.000, 71.000, 0.000, 71.000),
		Parent = Main,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		Image = "rbxassetid://90211141777647",
		BorderSizePixel = 0,
		ZIndex = 5
	})
	
	local Title = createInstance("TextLabel", {
		Name = "TextLabel",
		Position = UDim2.new(0.257, 0.000, 0.000, 0.000),
		Size = UDim2.new(0.000, 133.000, 0.000, 87.000),
		Parent = Main,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		Text = 'Aero',
		AutomaticSize = Enum.AutomaticSize.X,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(216, 216, 216),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 47,
		BorderSizePixel = 0,
		ZIndex = 20
	})

	local TabHolder = createInstance("Frame", {
		Position = UDim2.new(0, 0, 0.128, 0),
		Size = UDim2.new(0, 223, 0, 564),
		Parent = Main,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(23, 26, 30),
		BorderSizePixel = 0,
		ZIndex = 4
	})
	
	local MainStroke = createInstance("UIStroke", {
		Parent = Main,
		Color = Color3.fromRGB(30, 33, 37),
		Thickness = 1,
		LineJoinMode = Enum.LineJoinMode.Round,
		Transparency = 0
	})

	local TabHolderCover = createInstance("Frame", {
		Name = "TabHolderCover",
		Position = UDim2.new(0, 0, 0.128, 0),
		Size = UDim2.new(0, 223, 0, 43),
		Parent = Main,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(23, 26, 30),
		BorderSizePixel = 0,
		ZIndex = 3
	})

	local Frame = createInstance("Frame", {
		Name = "Frame",
		Position = UDim2.new(0.258, 0, 0.003, 0),
		Size = UDim2.new(0, 644, 0, 80),
		Parent = Main,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 7
	})

	local UIListLayout_23 = createInstance("UIListLayout", {
		Parent = Frame,
		Padding = UDim.new(0, 12),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local Frame_24 = createInstance("Frame", {
		Name = "Frame_24",
		Position = UDim2.new(0.400, 0, 0.094, 0),
		Size = UDim2.new(0, 98, 0, 65),
		Parent = Frame,
		BackgroundColor3 = Color3.fromRGB(23, 26, 30),
		BorderSizePixel = 0,
		ZIndex = 8
	})

	local TabCorner_25 = createInstance("UICorner", {
		Parent = Frame_24,
		CornerRadius = UDim.new(0, 6)
	})

	local FPS = createInstance("TextLabel", {
		Name = "FPS",
		Position = UDim2.new(0, 0, 0.192, 0),
		Size = UDim2.new(0, 98, 0, 20),
		Parent = Frame_24,
		BackgroundTransparency = 1,
		FontFace = Aero.Fonts.SemiBold,
		Text = 'FPS : nil',
		AutomaticSize = Enum.AutomaticSize.X,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(147, 147, 147),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20,
		BorderSizePixel = 0,
		ZIndex = 9
	}); table.insert(Aero.InfoDisplay, FPS)

	local Ping = createInstance("TextLabel", {
		Name = "Ping",
		Position = UDim2.new(0, 0, 0.485, 0),
		Size = UDim2.new(0, 98, 0, 20),
		Parent = Frame_24,
		BackgroundTransparency = 1,
		FontFace = Aero.Fonts.SemiBold,
		Text = 'Ping : nil',
		AutomaticSize = Enum.AutomaticSize.X,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = Color3.fromRGB(147, 147, 147),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20,
		BorderSizePixel = 0,
		ZIndex = 9
	}); table.insert(Aero.InfoDisplay, Ping)

	local UIPadding_26 = createInstance("UIPadding", {
		Parent = Frame,
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12)
	})

	local Frame_27 = createInstance("Frame", {
		Name = "Frame_27",
		Position = UDim2.new(0.618, 0, 0.094, 0),
		Size = UDim2.new(0, 236, 0, 65),
		Parent = Frame,
		BackgroundColor3 = Color3.fromRGB(23, 26, 30),
		BorderSizePixel = 0,
		ZIndex = 8
	})

	local TabCorner_28 = createInstance("UICorner", {
		Parent = Frame_27,
		CornerRadius = UDim.new(0, 6)
	})

	local ProfileImage = createInstance("ImageLabel", {
		Name = "ProfileImage",
		Position = UDim2.new(0.053, 0, 0.500, 0),
		Size = UDim2.new(0, 40, 0, 40),
		Parent = Frame_27,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		Image = "rbxassetid://114767261807469",
		BorderSizePixel = 0,
		ZIndex = 9
	})

	local UICorner_29 = createInstance("UICorner", {
		Parent = ProfileImage,
		CornerRadius = UDim.new(0, 6)
	})

	local TextLabel = createInstance("TextLabel", {
		Name = "TextLabel",
		Position = UDim2.new(0.944, 0, 0.192, 0),
		Size = UDim2.new(0, 156, 0, 21),
		Parent = Frame_27,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		FontFace = Aero.Fonts.SemiBold,
		Text = 'xn90ubwbzuqegtn',
		AutomaticSize = Enum.AutomaticSize.X,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = Color3.fromRGB(216, 216, 216),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20,
		BorderSizePixel = 0,
		ZIndex = 9
	})

	local TextLabel_30 = createInstance("TextLabel", {
		Name = "TextLabel_30",
		Position = UDim2.new(0.283, 0, 0.518, 0),
		Size = UDim2.new(0, 156, 0, 18),
		Parent = Frame_27,
		BackgroundTransparency = 1,
		FontFace = Aero.Fonts.SemiBold,
		Text = 'Expiry : 1d, 4h, 23m, 5s',
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = Color3.fromRGB(147, 147, 147),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 15,
		BorderSizePixel = 0,
		ZIndex = 9
	})

	local TabHolderCover2 = createInstance("Frame", {
		Name = "TabHolderCover2",
		Position = UDim2.new(0.150, 0, 0.896, 0),
		Size = UDim2.new(0, 94, 0, 67),
		Parent = Main,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(23, 26, 30),
		BorderSizePixel = 0,
		ZIndex = 3
	})

	local ImageLabel_31 = createInstance("ImageLabel", {
		Name = "ImageLabel_31",
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0.257, 0, 1, 0),
		Parent = Main,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ImageColor3 = Color3.fromRGB(34, 115, 255),
		Image = "rbxassetid://110824124620140",
		BorderSizePixel = 0,
		ZIndex = 200
	})

	local UIGradient_32 = createInstance("UIGradient", {
		Parent = ImageLabel_31,
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		})
	})
	
	local Div1 = createInstance("Frame", {
		Name = "Div1",
		Position = UDim2.new(0, 0, 0.128, 0),
		Size = UDim2.new(0, 223, 0, 1),
		Parent = Main,
		BackgroundColor3 = Color3.fromRGB(30, 33, 37),
		BorderSizePixel = 0,
		ZIndex = 5
	})

	local Div2 = createInstance("Frame", {
		Name = "Div2",
		Position = UDim2.new(0.257, 0, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		Parent = Main,
		BackgroundColor3 = Color3.fromRGB(30, 33, 37),
		BorderSizePixel = 0,
		ZIndex = 5
	})

	local Grid = createInstance("ImageLabel", {
		Position = UDim2.new(0.258, 0, -0, 0),
		Size = UDim2.new(0, 644, 0, 646),
		Parent = Main,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromScale(0.4, 0.4),
		ImageColor3 = Color3.fromRGB(63, 63, 63),
		Image = "rbxassetid://15505245889",
		BorderSizePixel = 0,
		ZIndex = 3
	})

	local UIGradient = createInstance("UIGradient", {
		Parent = Grid,
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.0125, 0),
			NumberSequenceKeypoint.new(0.767, 0.813),
			NumberSequenceKeypoint.new(1, 1)
		})
	})

	local Glow1 = createInstance("ImageLabel", {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Parent = Grid,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ScaleType = Enum.ScaleType.Stretch,
		ImageColor3 = Color3.fromRGB(66, 255, 255),
		Image = "rbxassetid://110824124620140",
		BorderSizePixel = 0,
		ZIndex = 9
	})

	createInstance("UIGradient", {
		Parent = Glow1,
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		})
	})

	local Glow2 = createInstance("ImageLabel", {
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1.003, 0),
		Parent = Grid,
		BackgroundTransparency = 1,
		Rotation = 180,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ImageColor3 = Color3.fromRGB(34, 115, 255),
		Image = "rbxassetid://110824124620140",
		BorderSizePixel = 0,
		ZIndex = 9
	})

	createInstance("UIGradient", {
		Parent = Glow2,
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.597, 0.762),
			NumberSequenceKeypoint.new(1, 1),
		})
	})
	
	createInstance("UICorner", {
		Parent = Main,
		CornerRadius = UDim.new(0, 6)
	})
	
	createInstance("UICorner", {
		Parent = TabHolder,
		CornerRadius = UDim.new(0, 6)
	})
	
	createInstance("UIListLayout", {
		Parent = TabHolder,
		Padding = UDim.new(0, 10),
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	createInstance("UIPadding", {
		Parent = TabHolder,
		PaddingTop = UDim.new(0, 18)
	})
	
	
	function AeroWindow:Tab(Title, Image)
		
		local AeroTab = { Selected = false, Sections = 0 }
		
		table.insert(Aero.Tabs, AeroTab)
		
		local Tab = createInstance("ImageButton", {
			Position = UDim2.new(0.081, 0, 0.044, 0),
			Size = UDim2.new(0, 187, 0, 36),
			Parent = TabHolder,
			BackgroundTransparency = .7,
			BackgroundColor3 = Color3.fromRGB(23, 74, 212),
			BorderSizePixel = 0,
			AutoButtonColor = false,
			ZIndex = 5
		})

		local TransparencyGradient = createInstance("UIGradient", {
			Parent = Tab,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
			}),
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}),
			Offset = Vector2.new(1, 0)
		})

		createInstance("UICorner", {
			Parent = Tab,
			CornerRadius = UDim.new(0, 6)
		})

		local TabIcon = createInstance("ImageLabel", {
			Position = UDim2.new(0.064, 0, 0.194, 0),
			Size = UDim2.new(0, 22, 0, 22),
			Parent = Tab,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ImageColor3 = Color3.fromRGB(150, 152, 163),
			Image = "rbxassetid://"..Image,
			BorderSizePixel = 0,
			ZIndex = 6
		})

		local TabTitle = createInstance("TextLabel", {
			Position = UDim2.new(0.267, 0, 0, 0),
			Size = UDim2.new(0, 137, 0, 36),
			Parent = Tab,
			BackgroundTransparency = 1,
			FontFace = Aero.Fonts.SemiBold,
			Text = Title,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = Color3.fromRGB(150, 152, 163),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 20,
			BorderSizePixel = 0,
			ZIndex = 7
		})

		local Glow = createInstance("ImageLabel", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Tab,
			BackgroundTransparency = 1,
			ImageTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ImageColor3 = Color3.fromRGB(94, 94, 255),
			Image = "rbxassetid://17251150022",
			BorderSizePixel = 0,
			ZIndex = 9
		})

		local Glow2 = createInstance("ImageLabel", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Tab,
			BackgroundTransparency = 1,
			ImageTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ImageColor3 = Color3.fromRGB(94, 94, 255),
			Image = "rbxassetid://17251150022",
			BorderSizePixel = 0,
			ZIndex = 9
		})
		
		local Canvas = createInstance("Frame", {
			Position = UDim2.new(0.272, 0, 0.129, 0),
			Size = UDim2.new(0, 620, 0, 551),
			Parent = Main,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 10
		})

		local ScrollingFrame = createInstance("ScrollingFrame", {
			Position = UDim2.new(0, 0, 0, 16),
			Size = UDim2.new(0, 620, 0, 537),
			Parent = Canvas,
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			ScrollBarImageTransparency = 1,
			ClipsDescendants = true,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ZIndex = 11
		})

		createInstance("UIPadding", {
			Parent = ScrollingFrame,
			PaddingTop = UDim.new(0, 1),
			PaddingLeft = UDim.new(0, 1),
			PaddingRight = UDim.new(0, 1)
		})

		createInstance("UIListLayout", {
			Parent = ScrollingFrame,
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		
		local Left = createInstance("Frame", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0, 304, 1, 0),
			Parent = ScrollingFrame,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(17, 19, 23),
			BorderSizePixel = 0,
			ZIndex = 11
		})

		createInstance("UICorner", {
			Parent = Left,
			CornerRadius = UDim.new(0, 6)
		})
		
		createInstance("UIListLayout", {
			Parent = Left,
			Padding = UDim.new(0, 12),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local Right = createInstance("Frame", {
			Position = UDim2.new(0.519, 0, 0, 0),
			Size = UDim2.new(0, 304, 1, 0),
			Parent = ScrollingFrame,
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(17, 19, 23),
			LayoutOrder = 1,
			BorderSizePixel = 0,
			ZIndex = 11
		})

		createInstance("UICorner", {
			Parent = Right,
			CornerRadius = UDim.new(0, 6)
		})

		createInstance("UIListLayout", {
			Parent = Right,
			Padding = UDim.new(0, 12),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		
		function AeroTab:Enable()
			
			for _, Tab in Aero.Tabs do
				if Tab.Selected then
					Tab:Disable()
				end
			end
			
			for i, v in Aero.Dropdowns do
				v:HideOptions()
			end
			
			AeroTab.Selected = true
			Canvas.Visible = true
			
			Spring.target(TransparencyGradient, 1, 1.7, {
				Offset = Vector2.new(-1, 0)
			})
			
			Spring.target(Glow, 1, 3, {
				ImageTransparency = 0
			})
			
			Spring.target(Glow2, 1, 3, {
				ImageTransparency = 0
			})
			
			Spring.target(TabIcon, 1, 3, {
				ImageColor3 = Aero.Themes.Tabs.Icon
			})
			
			Spring.target(TabTitle, 1, 3, {
				TextColor3 = Color3.fromRGB(216, 216, 216)
			})
			
		end
		
		function AeroTab:Disable()
			
			AeroTab.Selected = false
			Canvas.Visible = false
			
			Spring.target(TransparencyGradient, 1, 1.7, {
				Offset = Vector2.new(1, 0)
			})
			
			Spring.target(Glow, 1, 3, {
				ImageTransparency = 1
			})

			Spring.target(Glow2, 1, 3, {
				ImageTransparency = 1
			})
			
			Spring.target(TabIcon, 1, 3, {
				ImageColor3 = Color3.fromRGB(150, 152, 163)
			})

			Spring.target(TabTitle, 1, 3, {
				TextColor3 = Color3.fromRGB(150, 152, 163)
			})
			
		end
		
		if #Aero.Tabs == 1 then
			AeroTab:Enable()
		end
		
		Tab.MouseButton1Down:Connect(function()
			AeroTab:Enable()
		end)
		
		
		function AeroTab:Section(Side, Title, Description)
			
			local AeroSection = {
				Id 			= HttpService:GenerateGUID(),
				CanDrag 	= false,
				LayoutIndex = AeroTab.Sections + 1
			}
			
			AeroTab.Sections = AeroSection.LayoutIndex
			Aero.Sections[AeroSection.Id] = AeroSection
			
			local Section = createInstance("ImageButton", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 304, 0, 99),
				Parent = Side:lower() == "left" and Left or Right,
				BackgroundTransparency = 0.15,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = AeroSection.LayoutIndex,
				BackgroundColor3 = Color3.fromRGB(17, 19, 23),
				BorderSizePixel = 0,
				AutoButtonColor = false,
				ZIndex = 11
			})
			
			CreateDrag(Section, AeroSection.Id)

			createInstance("UICorner", {
				Parent = Section,
				CornerRadius = UDim.new(0, 6)
			})

			local Header = createInstance("Frame", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 304, 0, 62),
				Parent = Section,
				BackgroundColor3 = Color3.fromRGB(17, 19, 23),
				BorderSizePixel = 0,
				ZIndex = 12
			})

			createInstance("UICorner", {
				Parent = Header,
				CornerRadius = UDim.new(0, 6)
			})

			local SectionDiv = createInstance("Frame", {
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 1),
				Parent = Header,
				AnchorPoint = Vector2.new(0, 1),
				BackgroundColor3 = Color3.fromRGB(30, 33, 37),
				BorderSizePixel = 0,
				ZIndex = 12
			})

			local PopoutIcon = createInstance("ImageButton", {
				Position = UDim2.new(0.906, 0, 0.116, 0),
				Size = UDim2.new(0, 21, 0, 21),
				Parent = Header,
				BackgroundTransparency = 1,
				ImageTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ImageColor3 = Color3.fromRGB(147, 147, 147),
				Image = "rbxassetid://134532413544422",
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ZIndex = 14
			})

			local SectionTitle = createInstance("TextLabel", {
				Position = UDim2.new(0.067, 0, 0, 0),
				Size = UDim2.new(0, 197, 0, 62),
				Parent = Header,
				BackgroundTransparency = 1,
				FontFace = Aero.Fonts.Regular,
				Text = "<font size='22'><b><font color='#2273ff'>"..Title.."\n</font></b></font><font size='18'><font color='#8f8f8f'>"..Description.."</font></font>",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				RichText = true,
				TextColor3 = Color3.fromRGB(34, 115, 255),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 22,
				BorderSizePixel = 0,
				ZIndex = 13
			})

			createInstance("UIStroke", {
				Parent = Section,
				Color = Color3.fromRGB(30, 33, 37),
				Thickness = 1,
				LineJoinMode = Enum.LineJoinMode.Round,
				Transparency = 0
			})

			local ContentHolder = createInstance("Frame", {
				Position = UDim2.new(0, 0, 0, 63),
				Size = UDim2.new(0, 304, 0, 36),
				Parent = Section,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				ZIndex = 11
			})

			createInstance("UIListLayout", {
				Parent = ContentHolder,
				Padding = UDim.new(0, 1),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			createInstance("UIPadding", {
				Parent = ContentHolder,
				PaddingBottom = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5)
			})
			
			
			-- // Section Windows \\ --
			
			Section.MouseEnter:Connect(function()
				Spring.target(PopoutIcon, 1, 3, {
					ImageTransparency = .5
				})
			end)
			
			Section.MouseLeave:Connect(function()
				Spring.target(PopoutIcon, 1, 3, {
					ImageTransparency = 1
				})
			end)
			
			local Instances = {}
			
			function AeroSection:SetTop(Value)
				
				Section.ZIndex = Value and 1000 or 11
				
				if #Instances < 1 then
					for i, v in Section:GetDescendants() do
						if HasProperty(v, "ZIndex") then
							Instances[i] = {Object = v, Value = v.ZIndex}
						end
					end
				end
				

				for i, v in Instances do
					v.Object.ZIndex = Value and 1000 or v.Value
				end
				
			end
			
			PopoutIcon.MouseButton1Down:Connect(function()
				AeroTab.CanDrag = not AeroTab.CanDrag
				
				if AeroTab.CanDrag then
					Section.Parent = ScreenGui
					PopoutIcon.Image = "rbxassetid://10747384394"
				else
					Section.Parent = Side:lower() == "left" and Left or Right
					PopoutIcon.Image = "rbxassetid://134532413544422"
				end
				AeroSection:SetTop(AeroTab.CanDrag)
			end)
			
			function AeroSection:Divider()
				
				local Divider = createInstance("Frame", {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 20),
					Parent = ContentHolder,
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					ZIndex = 13
				})

				local SectionDiv = createInstance("Frame", {
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 270, 0, 1),
					Parent = Divider,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(30, 33, 37),
					BorderSizePixel = 0,
					ZIndex = 12
				})
				
			end
			
			function AeroSection:Toggle(Title, Settings)
				
				local AeroToggle = {
					Value 	 = Settings.Default or false,
					Callback = Settings.Callback or function() end
				}
				
				local Toggle = createInstance("ImageButton", {
					Position = UDim2.new(0, 0, 0.211, 0),
					Size = UDim2.new(1, 0, 0, 30),
					Parent = ContentHolder,
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 13
				})

				local ToggleTitle = createInstance("TextLabel", {
					Position = UDim2.new(0.067, 0, 0, 0),
					Size = UDim2.new(0, 176, 0, 30),
					Parent = Toggle,
					BackgroundTransparency = 1,
					FontFace = Aero.Fonts.Regular,
					Text = Title,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(143, 143, 143),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 19,
					BorderSizePixel = 0,
					ZIndex = 13
				})

				local Background = createInstance("ImageLabel", {
					Position = UDim2.new(0.937, 0, 0.497, 0),
					Size = UDim2.new(0, 19, 0, 19),
					Parent = Toggle,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(24, 30, 42),
					ImageColor3 = Color3.fromRGB(24, 30, 42),
					Image = "rbxassetid://5656122127",
					BorderSizePixel = 0,
					ZIndex = 15
				})

				local Check = createInstance("ImageLabel", {
					Position = UDim2.new(0.500, 0, 0.500, 0),
					Size = UDim2.new(0, 14, 0, 14),
					Parent = Background,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					Image = "rbxassetid://10709790644",
					BorderSizePixel = 0,
					ZIndex = 16
				})
				
				function AeroToggle:Set(Value)
					if Value ~= nil then
						AeroToggle.Value = Value
					else
						AeroToggle.Value = not AeroToggle.Value
					end
					
					if AeroToggle.Value then
						
						Spring.target(Check, 1, 3, {
							ImageTransparency = 0
						})
						
						Spring.target(Background, 1, 3, {
							ImageColor3 = Aero.Themes.MainColor,
							ImageTransparency = 0.7
						})
						
						Spring.target(ToggleTitle, 1, 3, {
							TextColor3 = Color3.fromRGB(205, 205, 205)
						})
						
					else
						
						Spring.target(Check, 1, 3, {
							ImageTransparency = 1
						})
						
						Spring.target(Background, 1, 3, {
							ImageColor3 = Color3.fromRGB(24, 30, 42),
							ImageTransparency = 0
						})
						
						Spring.target(ToggleTitle, 1, 3, {
							TextColor3 = Color3.fromRGB(143, 143, 143)
						})
						
					end
					
					AeroToggle.Callback(AeroToggle.Value)
				end
				
				Toggle.MouseButton1Down:Connect(function()
					AeroToggle:Set()
				end)
				
				return AeroToggle
			end
			
			function AeroSection:Slider(Title, Settings)
				
				local AeroSlider = 	{
					Step	 = Settings.Step or 1,
					Value 	 = Settings.Default or 0,
					Minimum  = Settings.Minimum or 0,
					Maximum  = Settings.Maximum or 100,
					Callback = Settings.Callback or function() end
				}
				
				local Slider = createInstance("ImageButton", {
					Position = UDim2.new(0, 0, 0.260, 0),
					Size = UDim2.new(1, 0, 0, 48),
					Parent = ContentHolder,
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					AutoButtonColor = false,
					BorderSizePixel = 0,
					ZIndex = 13
				})

				local SliderTitle = createInstance("TextLabel", {
					Position = UDim2.new(0.067, 0, 0, 0),
					Size = UDim2.new(0, 176, 0, 30),
					Parent = Slider,
					BackgroundTransparency = 1,
					FontFace = Aero.Fonts.Regular,
					Text = Title or "No title passed",
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(143, 143, 143),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 19,
					BorderSizePixel = 0,
					ZIndex = 13
				})

				local SliderValue = createInstance("TextBox", {
					Position = UDim2.new(0.810, 0, 0, 0),
					Size = UDim2.new(0, 45, 0, 30),
					Parent = Slider,
					BackgroundTransparency = 1,
					FontFace = Aero.Fonts.Regular,
					Text = AeroSlider.Value,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(143, 143, 143),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 19,
					BorderSizePixel = 0,
					ZIndex = 13
				})

				local SliderBack = createInstance("Frame", {
					Position = UDim2.new(0.067, 0, 0.690, 0),
					Size = UDim2.new(0, 270, 0, 6),
					Parent = Slider,
					BackgroundColor3 = Color3.fromRGB(24, 30, 42),
					BorderSizePixel = 0,
					ZIndex = 16
				})

				createInstance("UICorner", {
					Parent = SliderBack,
					CornerRadius = UDim.new(1, 0)
				})

				local SliderMain = createInstance("Frame", {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 67, 0, 6),
					Parent = SliderBack,
					BackgroundColor3 = Color3.fromRGB(34, 115, 255),
					BorderSizePixel = 0,
					ZIndex = 17
				})

				local SliderMainCorner = createInstance("UICorner", {
					Parent = SliderMain,
					CornerRadius = UDim.new(1, 0)
				})

				local SliderGradient = createInstance("UIGradient", {
					Parent = SliderMain,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, .8)
					})
				})

				local Knob = createInstance("ImageLabel", {
					Position = UDim2.new(1, 0, 0.500, 0),
					Size = UDim2.new(0, 10, 0, 10),
					Parent = SliderMain,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					Image = "rbxassetid://5552526748",
					BorderSizePixel = 0,
					ZIndex = 18
				})
				
				
				-- // Thanks Makkara for slider logic since I cba :heart_eyes: \\ --
				
				SliderValue.FocusLost:Connect(function()
					local toNum; pcall(function() toNum = tonumber(SliderValue.Text) end)
					if toNum then
						AeroSlider:Set(math.clamp(SliderValue.Text, AeroSlider.Minimum, AeroSlider.Maximum))
					else
						SliderValue.Text = tostring(AeroSlider.Value)
					end
				end)

				local PercentVal = AeroSlider.Value
				
				if math.abs(AeroSlider.Minimum) ~= AeroSlider.Minimum then
					PercentVal = AeroSlider.Value + math.abs(AeroSlider.Minimum)
				elseif AeroSlider.Minimum ~= 0 then
					PercentVal = AeroSlider.Value - math.abs(AeroSlider.Minimum)
				end
				
				local Percent = (PercentVal/(AeroSlider.Maximum-AeroSlider.Minimum));

				local decimalPlaces = 0
				
				if AeroSlider.Step < 1 then
					decimalPlaces = string.match(tostring(AeroSlider.Step), "%.(%d+)") and #string.match(tostring(AeroSlider.Step), "%.(%d+)") or 0
				end

				local Connection;
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if(Connection) then
							Connection:Disconnect();
							Connection = nil;
						end;
					end;
				end)

				function AeroSlider:Set(Value)
					if math.abs(AeroSlider.Minimum) ~= AeroSlider.Minimum then
						Value = Value + math.abs(AeroSlider.Minimum)
					elseif AeroSlider.Minimum ~= 0 then
						Value = Value - math.abs(AeroSlider.Minimum)
					end

					local Percent = (Value/(AeroSlider.Maximum-AeroSlider.Minimum));
					local Steps = (AeroSlider.Maximum - AeroSlider.Minimum) / AeroSlider.Step
					local NearestStep = math.floor(Percent * Steps + 0.5) / Steps

					AeroSlider.Value = AeroSlider.Minimum + (AeroSlider.Maximum - AeroSlider.Minimum) * NearestStep

					Spring.target(SliderMain, 1, 4, {
						Size = UDim2.fromScale(NearestStep, 1)
					})

					local decimalPlaces = 0
					if AeroSlider.Step < 1 then
						decimalPlaces = string.match(tostring(AeroSlider.Step), "%.(%d+)") and #string.match(tostring(AeroSlider.Step), "%.(%d+)") or 0
					end

					AeroSlider.Value = tonumber(string.format("%.2f", AeroSlider.Value))
					if AeroSlider.Value == math.floor(AeroSlider.Value) then
						SliderValue.Text = tostring(AeroSlider.Value)
					else
						SliderValue.Text = string.format("%."..decimalPlaces.."f", AeroSlider.Value)
					end
					pcall(AeroSlider.Callback, AeroSlider.Value) 
				end

				AeroSlider:Set(AeroSlider.Value)

				Slider.MouseButton1Down:Connect(function()
					if(Connection) then
						Connection:Disconnect();
					end;

					Connection = RunService.Heartbeat:Connect(function()
						local Mouse = UserInputService:GetMouseLocation();
						Percent = math.clamp((Mouse.X - SliderBack.AbsolutePosition.X) / (SliderBack.AbsoluteSize.X), 0, 1);

						local Steps = (AeroSlider.Maximum - AeroSlider.Minimum) / AeroSlider.Step
						local NearestStep = math.floor(Percent * Steps + 0.5) / Steps

						AeroSlider.Value = Settings.Minimum + (AeroSlider.Maximum - AeroSlider.Minimum) * NearestStep

						AeroSlider:Set(AeroSlider.Value)
					end)
				end)
				
				return AeroSlider	
			end
			
			function AeroSection:Colorpicker(Title, Settings)
				
				local AeroColorpicker = {
					Value  		 = Settings.Default or Color3.fromRGB(255, 255, 255),
					Transparency = Settings.DefaultT or 0,
					Callback 	 = Settings.Callback or function() end,
					connections  = {},
					Component	 = "Colorpicker",
				}
				
				local Colorpicker = createInstance("ImageButton", {
					Name = "Colorpicker",
					Position = UDim2.new(0.000, 0.000, 0.667, 0.000),
					Size = UDim2.new(1.000, 0.000, 0.000, 68.000),
					Parent = ContentHolder,
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					ZIndex = 13
				})

				local Background = createInstance("Frame", {
					Name = "Background",
					Position = UDim2.new(0.056, 0.000, 0.000, 30.000),
					Size = UDim2.new(0.000, 277.000, 0.000, 30.000),
					Parent = Colorpicker,
					BackgroundColor3 = Color3.fromRGB(24, 30, 42),
					BorderSizePixel = 0,
					ZIndex = 16
				})

				local UICorner = createInstance("UICorner", {
					Parent = Background,
					CornerRadius = UDim.new(0, 6)
				})

				local Value = createInstance("TextLabel", {
					Name = "Value",
					Position = UDim2.new(0.153, 0.000, 0.000, 0.000),
					Size = UDim2.new(0.000, 152.000, 0.000, 30.000),
					Parent = Background,
					BackgroundTransparency = 1,
					FontFace = Aero.Fonts.Regular,
					Text = '#3e82ff',
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(143, 143, 143),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 17,
					BorderSizePixel = 0,
					ZIndex = 17
				})

				local Icon = createInstance("ImageLabel", {
					Name = "Icon",
					Position = UDim2.new(0.908, 0.000, 0.500, 0.000),
					Size = UDim2.new(0.000, 20.000, 0.000, 20.000),
					Parent = Background,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					ImageColor3 = Color3.fromRGB(205, 205, 205),
					Image = "rbxassetid://132862765101652",
					BorderSizePixel = 0,
					ZIndex = 18
				})

				local DisplayColor = createInstance("ImageLabel", {
					Name = "DisplayColor",
					Position = UDim2.new(0.070, 0.000, 0.500, 0.000),
					Size = UDim2.new(0.000, 17.000, 0.000, 17.000),
					Parent = Background,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					ImageColor3 = Color3.fromRGB(62, 130, 255),
					Image = "rbxassetid://5552526748",
					BorderSizePixel = 0,
					ZIndex = 18
				})

				local ColorPopout = createInstance("Frame", {
					Name = "ColorPopout",
					Position = UDim2.new(0.412, 0.000, 1.233, 0.000),
					Size = UDim2.new(0.867, 0.000, 4.887, 0.000),
					Parent = Background,
					Visible = false,
					BackgroundColor3 = Color3.fromRGB(16, 18, 22),
					BorderSizePixel = 0,
					ZIndex = 35
				})

				local sVSelection = createInstance("ImageButton", {
					Name = "sVSelection",
					Position = UDim2.new(0.041, 0.000, 0.043, 0.000),
					Size = UDim2.new(0.799, 0.000, 0.829, 0.000),
					Parent = ColorPopout,
					AutoButtonColor = false,
					BackgroundColor3 = Color3.fromRGB(71, 133, 202),
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					Image = "rbxassetid://11970108040",
					BorderSizePixel = 0,
					ZIndex = 111
				})

				local scStroke = createInstance("UIStroke", {
					Parent = sVSelection,
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 1,
					LineJoinMode = Enum.LineJoinMode.Round,
					Transparency = 0
				})

				local hUESelection = createInstance("ImageButton", {
					Name = "hUESelection",
					Position = UDim2.new(0.890, 0.000, 0.043, 0.000),
					Size = UDim2.new(0.088, 0.000, 0.829, 0.000),
					Parent = ColorPopout,
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					Image = "rbxassetid://11970136481",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					ZIndex = 111
				})

				local hueStroke = createInstance("UIStroke", {
					Parent = hUESelection,
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 1,
					LineJoinMode = Enum.LineJoinMode.Round,
					Transparency = 0
				})

				local SelectedColor = createInstance("Frame", {
					Name = "SelectedColor",
					Position = UDim2.new(0.890, 0.000, 0.920, 0.000),
					Size = UDim2.new(0.088, 0.000, 0.050, 0.000),
					Parent = ColorPopout,
					BackgroundColor3 = Color3.fromRGB(71, 133, 202),
					BorderSizePixel = 0,
					ZIndex = 112
				})

				local SelectedStroke = createInstance("UIStroke", {
					Parent = SelectedColor,
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 1,
					LineJoinMode = Enum.LineJoinMode.Round,
					Transparency = 0
				})

				local TranspSlider = createInstance("ImageButton", {
					Name = "TranspSlider",
					Position = UDim2.new(0.041, 0.000, 0.920, 0.000),
					Size = UDim2.new(0.799, 0.000, 0.050, 0.000),
					Parent = ColorPopout,
					AutoButtonColor = false,
					BackgroundColor3 = Color3.fromRGB(71, 133, 202),
					BorderSizePixel = 0,
					ZIndex = 112
				})

				local TranspStroke = createInstance("UIStroke", {
					Parent = TranspSlider,
					Color = Color3.fromRGB(0, 0, 0),
					Thickness = 1,
					LineJoinMode = Enum.LineJoinMode.Round,
					Transparency = 0
				})

				local UIAspectRatioConstraint = createInstance("UIAspectRatioConstraint", {
					AspectRatio = 1.114,
					Parent = ColorPopout
				})

				local UIStroke = createInstance("UIStroke", {
					Parent = ColorPopout,
					Color = Color3.fromRGB(30, 33, 37),
					Thickness = 1,
					LineJoinMode = Enum.LineJoinMode.Round,
					Transparency = 0
				})

				local UICorner_1 = createInstance("UICorner", {
					Parent = ColorPopout,
					CornerRadius = UDim.new(0, 6)
				})

				local ColorpickerTitle = createInstance("TextLabel", {
					Name = "ColorpickerTitle",
					Position = UDim2.new(0.067, 0.000, 0.000, 0.000),
					Size = UDim2.new(0.000, 176.000, 0.000, 30.000),
					Parent = Colorpicker,
					BackgroundTransparency = 1,
					FontFace = Aero.Fonts.Regular,
					Text = Title,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 19,
					BorderSizePixel = 0,
					ZIndex = 13
				})
				
				local TranspGrad = createInstance("UIGradient", {
					Parent = TranspSlider,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
					}),
					Transparency = NumberSequence.new(0, 1)
				})

				local UIAspectRatioConstraint = createInstance("UIAspectRatioConstraint", {
					AspectRatio = 1.114,
					Parent = ColorPopout
				})

				local sVSlider = Instance.new("Frame")
				sVSlider.Name = "SV_slider"
				sVSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				sVSlider.BackgroundTransparency = 1
				sVSlider.Position = UDim2.new(0.961, 0, 0.0187, 0)
				sVSlider.Size = UDim2.new(.02, 0, .02, 0)
				sVSlider.ZIndex = 200
				
				local UIAspectRatioConstraint = createInstance("UIAspectRatioConstraint", {
					AspectRatio = 1,
					Parent = sVSlider
				})

				local uICorner1 = Instance.new("UICorner")
				uICorner1.Name = "UICorner"
				uICorner1.CornerRadius = UDim.new(0, 100)
				uICorner1.Parent = sVSlider

				local uIStroke1 = Instance.new("UIStroke")
				uIStroke1.Name = "UIStroke"
				uIStroke1.Color = Color3.fromRGB(255, 255, 255)
				uIStroke1.Parent = sVSlider

				sVSlider.Parent = sVSelection

				local Hslider = Instance.new("Frame")
				Hslider.Name = "H_Slider"
				Hslider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				Hslider.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Hslider.Position = UDim2.new(0, 0, -0.0139, 0)
				Hslider.Size = UDim2.new(1, 0, .01, 0)
				Hslider.Parent = hUESelection
				Hslider.ZIndex = 200

				local SliderBack = Instance.new('Frame', TranspSlider)
				local SliderMain = Instance.new('Frame', SliderBack)

				SliderBack.Name = "SliderBack"
				SliderBack.Position = UDim2.new(0,0,0,0)
				SliderBack.Size = UDim2.new(1,0,1,0)
				SliderBack.BorderSizePixel = 0
				SliderBack.BackgroundTransparency = 1
				SliderBack.BorderColor3 = Color3.new(0,0,0)
				SliderBack.ZIndex = 109
				SliderMain.Name = "SliderMain"
				SliderMain.BackgroundTransparency = 1
				SliderMain.Position = UDim2.new(0,0,0,0)
				SliderMain.Size = UDim2.new(1,0,1,0)
				SliderMain.BackgroundColor3 = Color3.new(1,1,1)
				SliderMain.BorderSizePixel = 0
				SliderMain.BorderColor3 = Color3.new(0,0,0)
				SliderMain.ZIndex = 200

				local tslider = Instance.new("Frame")
				tslider.Name = "SV_slider"
				tslider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				tslider.AnchorPoint = Vector2.new(0, .5)
				tslider.Position = UDim2.new(0, 0, 0, 0)
				tslider.Size = UDim2.new(.03, 0, 1, 0)
				tslider.Parent = SliderBack
				tslider.BorderSizePixel = 0
				tslider.ZIndex = 200
				
				-- // Yes ts colorpicker logic pasted idgaf ts UI is free :sob_pray: \\ --
				
				ColorH = 1 - (math.clamp(Hslider.AbsolutePosition.Y - hUESelection.AbsolutePosition.Y, 0, hUESelection.AbsoluteSize.Y) / hUESelection.AbsoluteSize.Y)
				ColorS = (math.clamp(sVSlider.AbsolutePosition.X - sVSelection.AbsolutePosition.X, 0, sVSelection.AbsoluteSize.X) / sVSelection.AbsoluteSize.X)
				ColorV = 1 - (math.clamp(sVSlider.AbsolutePosition.Y - sVSelection.AbsolutePosition.Y, 0, sVSelection.AbsoluteSize.Y) / sVSelection.AbsoluteSize.Y)

				Colorpicker.MouseButton1Down:Connect(function()
					if ColorPopout.Visible then
						ColorPopout.Visible = false
					else
						ColorPopout.Visible = true
					end	
				end)

				function AeroColorpicker:UpdateColorPicker()
					R,G,B = ToRGB(SelectedColor.BackgroundColor3)
					SelectedColor.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					DisplayColor.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					Hslider.Position = UDim2.new(0,0,ColorH,0)
					sVSelection.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					TranspSlider.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					AeroColorpicker.Value = Color3.fromRGB(math.round(R*255), math.round(G*255), math.round(B*255))
					Value.Text = RgbToHex(AeroColorpicker.Value.R, AeroColorpicker.Value.G, AeroColorpicker.Value.B)
					AeroColorpicker.Callback(AeroColorpicker)
				end

				local Connection;
				table.insert(AeroColorpicker.connections, UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						pcall(function()
							Connection:Disconnect();
							Connection = nil;
						end)
					end
				end))

				--LPH_NO_VIRTUALIZE(function()
				table.insert(AeroColorpicker.connections, TranspSlider.MouseButton1Down:Connect(function()
					if(Connection) then
						Connection:Disconnect();
					end;

					Connection = RunService.Heartbeat:Connect(function()
						AeroColorpicker:findtransparency()
					end)
				end))

				function AeroColorpicker:findtransparency(v)
					if v == nil then
						local percentage = math.clamp((Mouse.X - SliderBack.AbsolutePosition.X) / (SliderBack.AbsoluteSize.X), 0, 1)
						local value = ((1 - 0) * percentage) + 0
						SliderMain.Size = UDim2.fromScale(percentage, 1)
						AeroColorpicker.Transparency = value
						SelectedColor.Transparency = value
						DisplayColor.ImageTransparency = value
						tslider.Position = UDim2.new(math.clamp(percentage, 0, .98), -tslider.Size.X.Offset / 2 , 0.5, -tslider.Size.Y.Offset / 2)
					else
						AeroColorpicker.Transparency = v
						SelectedColor.Transparency = v
						DisplayColor.ImageTransparency = v
						SliderMain.Size = UDim2.fromScale(((v - 0) / (1 - 0)), 1)
						tslider.Position = UDim2.new(math.clamp(v, 0, .98), -tslider.Size.X.Offset / 2 , 0.5, -tslider.Size.Y.Offset / 2)
					end
					AeroColorpicker.Callback(AeroColorpicker)
				end

				function AeroColorpicker:UpdateColor(R, G, B, transp)
					SelectedColor.BackgroundColor3 = Color3.new(R, G, B)
					DisplayColor.ImageColor3 = Color3.new(R, G, B)
					AeroColorpicker.Value = Color3.fromRGB(math.round(SelectedColor.BackgroundColor3.R*255), math.round(SelectedColor.BackgroundColor3.G*255), math.round(SelectedColor.BackgroundColor3.B*255))
					AeroColorpicker:findtransparency(transp)
					AeroColorpicker.Callback(AeroColorpicker)
				end
				
				do
					local Color = AeroColorpicker.Value
					AeroColorpicker:UpdateColor(Color.R, Color.G, Color.B)
				end

				function AeroColorpicker.SetValue(self,H,S,V)
					ColorH = H
					ColorS  = S
					ColorV = V
					self:UpdateColorPicker()
				end

				function AeroColorpicker:CallColorPicker()
					AeroColorpicker.Callback(AeroColorpicker)
				end

				local ColorInput, HueInput;
				
				sVSelection.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if ColorInput then
							ColorInput:Disconnect()
							ColorInput = nil;
						end
						ColorInput = RunService.RenderStepped:Connect(function()
							local ColorX = (math.clamp(Mouse.X - sVSelection.AbsolutePosition.X, 0, sVSelection.AbsoluteSize.X) / sVSelection.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - sVSelection.AbsolutePosition.Y, 0, sVSelection.AbsoluteSize.Y) / sVSelection.AbsoluteSize.Y)
							sVSlider.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = ColorX
							ColorV = 1 - ColorY
							AeroColorpicker:UpdateColorPicker()
						end)
					end
				end))

				--colorpicker.colorval = Selected_Color.BackgroundColor3

				sVSelection.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if ColorInput then
							ColorInput:Disconnect()
							ColorInput = nil;
						end
					end
				end)

				hUESelection.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if HueInput then
							HueInput:Disconnect()
							HueInput = nil;
						end

						HueInput = RunService.RenderStepped:Connect(function()
							local HueY = (math.clamp(Mouse.Y - hUESelection.AbsolutePosition.Y, 0, hUESelection.AbsoluteSize.Y) / hUESelection.AbsoluteSize.Y)
							ColorH =  HueY
							AeroColorpicker:UpdateColorPicker()
						end)
					end
				end))

				hUESelection.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if HueInput then
							HueInput:Disconnect()
							HueInput = nil
						end
					end
				end)

				return AeroColorpicker
			end
			
			function AeroSection:Dropdown(Title, Settings)
				
				local AeroDropdown = {
					Value	 = Settings.Default or "None",
					List  	 = Settings.List or {},
					Opened	 = false,
					Callback = Settings.Callback or function() end
				}
				
				table.insert(Aero.Dropdowns, AeroDropdown)
				
				local Dropdown = createInstance("ImageButton", {
					Position = UDim2.new(0, 0, 0.667, 0),
					Size = UDim2.new(1, 0, 0, 68),
					Parent = ContentHolder,
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					AutoButtonColor = false,
					ZIndex = 13
				})

				local Background = createInstance("Frame", {
					Position = UDim2.new(0.056, 0, 0, 30),
					Size = UDim2.new(0, 277, 0, 30),
					Parent = Dropdown,
					BackgroundColor3 = Color3.fromRGB(24, 30, 42),
					BorderSizePixel = 0,
					ZIndex = 16
				})

				local UICorner = createInstance("UICorner", {
					Parent = Background,
					CornerRadius = UDim.new(0, 6)
				})

				local SelectedOption = createInstance("TextLabel", {
					Position = UDim2.new(0.053, 0, 0, 0),
					Size = UDim2.new(0, 180, 0, 30),
					Parent = Background,
					BackgroundTransparency = 1,
					FontFace = Aero.Fonts.Regular,
					Text = AeroDropdown.Value,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(143, 143, 143),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 17,
					BorderSizePixel = 0,
					ZIndex = 17
				})

				local Arrow = createInstance("ImageLabel", {
					Position = UDim2.new(0.908, 0, 0.500, 0),
					Size = UDim2.new(0, 20, 0, 20),
					Parent = Background,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					ImageColor3 = Color3.fromRGB(205, 205, 205),
					Image = "rbxassetid://6034818372",
					BorderSizePixel = 0,
					ZIndex = 18
				})

				local DropdownTitle = createInstance("TextLabel", {
					Position = UDim2.new(0.067, 0, 0, 0),
					Size = UDim2.new(0, 176, 0, 30),
					Parent = Dropdown,
					BackgroundTransparency = 1,
					FontFace = Aero.Fonts.Regular,
					Text = Title or "Please return a title",
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = Color3.fromRGB(205, 205, 205),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 19,
					BorderSizePixel = 0,
					ZIndex = 13
				})

				local OptionsHolder = createInstance("ImageButton", {
					Position = UDim2.new(0.056, 0, 1.015, 0),
					Size = UDim2.new(0, 277, 0, 0),
					Parent = Dropdown,
					BackgroundColor3 = Color3.fromRGB(24, 30, 42),
					ClipsDescendants = true,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Visible = false,
					ZIndex = 25
				}); OptionsHolder:SetAttribute("Opened", false)

				createInstance("UICorner", {
					Parent = OptionsHolder
				})

				createInstance("UIListLayout", {
					Parent = OptionsHolder,
					Padding = UDim.new(0, 10),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				createInstance("UIPadding", {
					Parent = OptionsHolder,
					PaddingTop = UDim.new(0, 10)
				})
				
				local TotalSize = 10
				local Options 	= {}
				
				for i, v in AeroDropdown.List do

					TotalSize += 45
					
					local AeroOption = { Selected = false }
					
					table.insert(Options, AeroOption)
					
					local Option = createInstance("ImageButton", {
						Position = UDim2.new(0.068, 0, 1.265, 0),
						Size = UDim2.new(0, 253, 0, 35),
						Parent = OptionsHolder,
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(36, 45, 63),
						AutoButtonColor = false,
						BorderSizePixel = 0,
						ZIndex = 26
					})

					createInstance("UICorner", {
						Parent = Option
					})

					local ImageLabel = createInstance("ImageLabel", {
						Position = UDim2.new(0.050, 0, 0.500, 0),
						Size = UDim2.new(0, 14, 0, 14),
						Parent = Option,
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(0, 0.5),
						ImageTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						ImageColor3 = Aero.Themes.MainColor,
						Image = "rbxassetid://10709790644",
						BorderSizePixel = 0,
						ZIndex = 28
					})
					
					table.insert(Aero.ThemeStorage.Dropdowns.Icons, ImageLabel)

					local OptionTitle = createInstance("TextLabel", {
						Position = UDim2.new(0.050, 0, 0, 0),
						Size = UDim2.new(0.820, 0, 0, 33),
						Parent = Option,
						BackgroundTransparency = 1,
						FontFace = Aero.Fonts.Regular,
						Text = v,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Color3.fromRGB(143, 143, 143),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 17,
						BorderSizePixel = 0,
						ZIndex = 27
					})
					
					function AeroOption:Enable()
						
						for i, v in Options do
							v:Disable()
						end
						
						AeroOption.Selected = true
						
						Spring.target(Option, 1, 3, {
							BackgroundTransparency = 0
						})

						Spring.target(OptionTitle, 1, 3, {
							Position = UDim2.fromScale(.18, 0),
							TextColor3 = Color3.fromRGB(255, 255, 255)
						})

						Spring.target(ImageLabel, 1, 3, {
							ImageTransparency = 0
						})
						
						SelectedOption.Text = v
						Settings.Callback(v)
					end
					
					function AeroOption:Disable()
						
						AeroOption.Selected = false
						
						Spring.target(Option, 1, 3, {
							BackgroundTransparency = 1
						})

						Spring.target(OptionTitle, 1, 3, {
							Position = UDim2.fromScale(.050, 0),
							TextColor3 = Color3.fromRGB(143, 143, 143)
						})

						Spring.target(ImageLabel, 1, 3, {
							ImageTransparency = 1
						})
						
					end
					
					Option.MouseButton1Down:Connect(function()
						AeroOption:Enable()
					end)
					
					if AeroDropdown.Value == v then
						AeroOption:Enable()
					end
					
				end
				
				
				-- // Visibility Functions \\ --
				
				function AeroDropdown:ShowOptions()
					
					for i, v in Aero.Dropdowns do
						if v ~= AeroDropdown then
							v:HideOptions()
						end
					end
					
					OptionsHolder.Visible = true
					
					Spring.stop(OptionsHolder)
					
					Spring.target(OptionsHolder, 1, 3, {
						Size = UDim2.fromOffset(282, TotalSize)
					})
						
					--local Tween = TweenService:Create(OptionsHolder, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.fromOffset(282, TotalSize)}):Play()
					
					Spring.target(Arrow, 1, 3, {
						Rotation = 180
					})
					
				end
				
				function AeroDropdown:HideOptions()
					
					Spring.stop(OptionsHolder)
					
					Spring.target(OptionsHolder, 1, 3, {
						Size = UDim2.fromOffset(282, 0)
					})
					
					--local Tween = TweenService:Create(OptionsHolder, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.fromOffset(282, 0)})

					Spring.target(Arrow, 1, 3, {
						Rotation = 0
					})
					
					--Tween.Completed:Connect(function()
					--	OptionsHolder.Visible = false
					--end)
					
					--Tween:Play()
					
				end
				
				-- // Set Holder Visibility \\ --
				
				Dropdown.MouseButton1Down:Connect(function()

					if OptionsHolder:GetAttribute("Opened") then
						AeroDropdown:HideOptions()
					else
						AeroDropdown:ShowOptions()
					end
					
					OptionsHolder:SetAttribute("Opened", not OptionsHolder:GetAttribute("Opened"))
				end)
				
				return AeroDropdown
			end
			
			return AeroSection
		end
		
		return AeroTab
	end
	
	return AeroWindow
end

-- // Info Updating \\ --

task.spawn(function()

	if RunService:IsStudio() then return end
	
	local FPSCounter  = Aero.InfoDisplay.FPS
	local PingCounter = Aero.InfoDisplay.Ping
	local Stats 	  = StatsService.PerformanceStats
	
	RunService.Stepped(function(Delta)
		print(Delta)
		
		PingCounter = Stats.Ping:GetValue() / 1000
		
	end)
end)
