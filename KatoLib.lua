local Kato = {}
Kato.__index = Kato

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

--------------------------------------------------
-- COLORS
--------------------------------------------------

local Theme = {
	Background = Color3.fromRGB(15,10,24),
	Secondary = Color3.fromRGB(26,20,35),
	Accent = Color3.fromRGB(138,43,226),

	Text = Color3.fromRGB(255,255,255),
	SubText = Color3.fromRGB(160,157,171),

	Border = Color3.fromRGB(170,90,255)
}

--------------------------------------------------
-- UTILS
--------------------------------------------------

local function Create(Class, Props)
	local Obj = Instance.new(Class)

	for Property,Value in pairs(Props or {}) do
		Obj[Property] = Value
	end

	return Obj
end

local function Corner(Object, Radius)
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, Radius)
	UICorner.Parent = Object
	return UICorner
end

local function Stroke(Object, Color, Thickness)
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color
	UIStroke.Thickness = Thickness or 1
	UIStroke.Parent = Object
	return UIStroke
end

local function Tween(Object, Time, Properties)
	TweenService:Create(
		Object,
		TweenInfo.new(
			Time,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		Properties
	):Play()
end

--------------------------------------------------
-- DRAG SYSTEM
--------------------------------------------------

local function MakeDraggable(Frame, Handle)

	local Dragging = false
	local DragStart
	local StartPos

	Handle.InputBegan:Connect(function(Input)

		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then

			Dragging = true
			DragStart = Input.Position
			StartPos = Frame.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)

		end

	end)

	UserInputService.InputChanged:Connect(function(Input)

		if not Dragging then
			return
		end

		if Input.UserInputType ~= Enum.UserInputType.MouseMovement
			and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local Delta = Input.Position - DragStart

		Frame.Position = UDim2.new(
			StartPos.X.Scale,
			StartPos.X.Offset + Delta.X,
			StartPos.Y.Scale,
			StartPos.Y.Offset + Delta.Y
		)

	end)

end

--------------------------------------------------
-- WINDOW
--------------------------------------------------

function Kato:CreateWindow(Config)

	local Player = Players.LocalPlayer

	local ScreenGui = Create("ScreenGui",{
		Name = "KatoUI",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})

	ScreenGui.Parent = Player.PlayerGui

--------------------------------------------------
-- BLUR
--------------------------------------------------

	local Blur = Lighting:FindFirstChild("KatoBlur")

	if not Blur then
		Blur = Instance.new("BlurEffect")
		Blur.Name = "KatoBlur"
		Blur.Size = 0
		Blur.Parent = Lighting
	end

	Tween(Blur,.35,{
		Size = 18
	})

--------------------------------------------------
-- MAIN
--------------------------------------------------

	local Main = Create("Frame",{
		Name = "Main",
		AnchorPoint = Vector2.new(.5,.5),

		Size = UDim2.fromScale(.58,.66),
		Position = UDim2.fromScale(.5,.5),

		BackgroundColor3 = Theme.Background
	})

	Main.Parent = ScreenGui

	Corner(Main,14)

	local MainStroke = Stroke(
		Main,
		Theme.Accent,
		1.5
	)

--------------------------------------------------
-- GLOW
--------------------------------------------------

	local Glow = Create("ImageLabel",{
		BackgroundTransparency = 1,

		Image = "rbxassetid://5028857084",

		ScaleType = Enum.ScaleType.Slice,

		SliceCenter = Rect.new(
			24,
			24,
			276,
			276
		),

		ImageTransparency = .25,

		ImageColor3 = Theme.Accent,

		Size = UDim2.new(
			1,
			30,
			1,
			30
		),

		Position = UDim2.new(
			0,
			-15,
			0,
			-15
		),

		ZIndex = 0
	})

	Glow.Parent = Main

--------------------------------------------------
-- HEADER
--------------------------------------------------

	local Header = Create("Frame",{
		Size = UDim2.new(
			1,
			0,
			0,
			80
		),

		BackgroundTransparency = 1
	})

	Header.Parent = Main

--------------------------------------------------
-- LOGO
--------------------------------------------------

	local Logo = Create("ImageLabel",{
		BackgroundTransparency = 1,

		Size = UDim2.fromOffset(
			44,
			44
		),

		Position = UDim2.new(
			0,
			20,
			0,
			18
		),

		Image = Config.Logo or ""
	})

	Logo.Parent = Header

--------------------------------------------------
-- TITLE
--------------------------------------------------

	local Title = Create("TextLabel",{
		BackgroundTransparency = 1,

		Position = UDim2.new(
			0,
			78,
			0,
			12
		),

		Size = UDim2.new(
			0,
			300,
			0,
			32
		),

		Text = Config.Title or "Kato Script",

		TextXAlignment = Enum.TextXAlignment.Left,

		TextColor3 = Theme.Text,

		Font = Enum.Font.GothamBold,

		TextSize = 20
	})

	Title.Parent = Header

	local Subtitle = Create("TextLabel",{
		BackgroundTransparency = 1,

		Position = UDim2.new(
			0,
			78,
			0,
			40
		),

		Size = UDim2.new(
			0,
			300,
			0,
			20
		),

		Text = Config.Subtitle or "Premium UI",

		TextColor3 = Theme.SubText,

		TextXAlignment = Enum.TextXAlignment.Left,

		Font = Enum.Font.Gotham,

		TextSize = 14
	})

	Subtitle.Parent = Header

--------------------------------------------------
-- CLOSE BUTTON
--------------------------------------------------

	local Close = Create("TextButton",{
		Text = "✕",

		Font = Enum.Font.GothamBold,

		TextSize = 24,

		TextColor3 = Theme.Text,

		BackgroundColor3 = Theme.Secondary,

		AnchorPoint = Vector2.new(1,0),

		Position = UDim2.new(
			1,
			-16,
			0,
			18
		),

		Size = UDim2.fromOffset(
			40,
			40
		)
	})

	Close.Parent = Header
	Corner(Close,10)

--------------------------------------------------
-- MINIMIZE
--------------------------------------------------

	local Minimize = Close:Clone()

	Minimize.Text = "—"

	Minimize.Position = UDim2.new(
		1,
		-64,
		0,
		18
	)

	Minimize.Parent = Header

--------------------------------------------------
-- DIVIDER
--------------------------------------------------

	local Divider = Create("Frame",{
		BackgroundColor3 = Theme.Accent,

		BackgroundTransparency = .5,

		BorderSizePixel = 0,

		Position = UDim2.new(
			0,
			0,
			0,
			79
		),

		Size = UDim2.new(
			1,
			0,
			0,
			1
		)
	})

	Divider.Parent = Main

--------------------------------------------------
-- DRAG
--------------------------------------------------

	MakeDraggable(Main, Header)

--------------------------------------------------
-- RETURN
--------------------------------------------------

	local Window = {}

	Window.Gui = ScreenGui
	Window.Main = Main

	return Window

end

return Kato
