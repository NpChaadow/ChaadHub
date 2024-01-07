local BlackList = {
	"Folder",
	"FlagFolder",
	"ModelCache",
	"RenderingRoom",
	"reppedModels",
	"Vehicles",
	"Props",
	"Characters",
	"MouseFilter",
	"Tycoons",
	"DestructionDisplayModels",
	"AIs",
	"TycoonModels",
	"Flares",
	"XMAS",
	"WaterColliders",
	"SewerPipes",
	"Sewer",
	"RiverAssets",
	"PlacedTycoon",
	"PlacedTycoons",
	"Dogs",
	"Parts",
	"Paths",
	"OldMapSize",
	"ParkingLot",
	"WaterEffect",
	"EliteMissions",
	"TerrainCursorPart",
	"SafeZones",
	"B29Spawns",
	"DeathmatchArena",
	"AdPlacements",
	"ControlPoints",
	"DockAddition",
	"Fireworks",
	"BuildingStuff",
	"Borders",
	"AAVStages",
	"Event",
	"EliteMission1",
	"Zombies"}

local Player = game.Players.LocalPlayer
local character = Player.Character
local humanoid = character:WaitForChild("Humanoid")

local PlayerGui = Player:WaitForChild("PlayerGui")

local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Parent = PlayerGui

local ButtonFrame = Instance.new("TextButton")
ButtonFrame.Parent = ScreenGui
ButtonFrame.Size = UDim2.new(0.1,0,0.1,0)
ButtonFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
ButtonFrame.AnchorPoint = Vector2.new(0.5,0.5)
ButtonFrame.Text = "Menu"
ButtonFrame.BorderSizePixel = 0
ButtonFrame.BackgroundColor3 = Color3.new(0.537255, 0.270588, 1)
ButtonFrame.Position = UDim2.new(0.1,0,0.1,0)

local MainButtonUICorner = Instance.new("UICorner")
MainButtonUICorner.Parent = ButtonFrame

local gui = ButtonFrame

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

gui.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

function CheckBlacklisting(Name)

	for i,v in pairs(BlackList) do

		if Name == v then

			return false

		end

	end

	return true

end

local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "Menu"
MenuFrame.Visible = false
MenuFrame.Size = UDim2.new(0.7,0,0.8,0)
MenuFrame.Parent = ScreenGui
MenuFrame.Position = UDim2.new(0.5,0,0.5,0)
MenuFrame.AnchorPoint = Vector2.new(0.5,0.5)

local TopBar = Instance.new("Frame")
TopBar.Position = UDim2.new(0.5,0,0,0)
TopBar.Size = UDim2.new(1,0,0.05,0)
TopBar.Parent = MenuFrame
TopBar.AnchorPoint = Vector2.new(0.5,0)
TopBar.BackgroundColor3 = Color3.new(0.211765, 0.211765, 0.211765)

local ReduceButton = Instance.new("TextButton")
ReduceButton.Parent = TopBar
ReduceButton.Text = "-"
ReduceButton.BackgroundColor3 = Color3.new(0.211765, 0.211765, 0.211765)
ReduceButton.Size = UDim2.new(0.05,0,1,0)

local RemoveButton = Instance.new("TextButton")
RemoveButton.Parent = TopBar
RemoveButton.Text = "X"
RemoveButton.BackgroundColor3 = Color3.new(1, 0, 0.0156863)
RemoveButton.TextColor3 = Color3.new(1, 1, 1)
RemoveButton.Size = UDim2.new(0.05,0,1,0)
RemoveButton.Position = UDim2.new(0.05,0,0,0)

local GetWorkspace = Instance.new("TextButton")
GetWorkspace.Parent = MenuFrame
GetWorkspace.Position = UDim2.new(0.025,0,0.1,0)
GetWorkspace.Name = "GetWorkspace"
GetWorkspace.BackgroundColor3 = Color3.new(0.298039, 0.14902, 0.14902)
GetWorkspace.Text = "Get Workspace"
GetWorkspace.Size = UDim2.new(0.2,0,0.05,0)
GetWorkspace.TextColor3 = Color3.new(1, 1, 1)

ReduceButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = false
end)

RemoveButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

ButtonFrame.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
end)

GetWorkspace.MouseButton1Click:Connect(function()

	for i,v in pairs(workspace:GetChildren()) do

		local BlackListed = CheckBlacklisting(v.Name)

		if v:IsA("Folder") and BlackListed then

			print(v.Name)

			for a,b in pairs(v:GetChildren())do

				print(v.Name.." > ".. b.Name.." => "..b.ClassName)

			end

		end

	end
end)
