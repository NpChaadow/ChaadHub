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

ButtonFrame.MouseButton1Click:Connect(function()

	for i,v in pairs(workspace:GetChildren()) do

		local BlackListed = CheckBlacklisting(v.Name)

		if v:IsA("Folder") and BlackListed then

			print(v.Name)

			for a,b in pairs(v:GetChildren())do

				print(v.Name.." > ".. b.Name.." => "..b.ClassName)

			end

		end

	end

	local FireWorkFolder = workspace.FireworkSpawns
	for i,v in pairs(FireWorkFolder.Firework1:GetChildren())do
		print(v.Name.."=>"..v.ClassName)
	end

	local Firework = FireWorkFolder.Firework5
	print(Firework.Main.Position)
	character.PrimaryPart.CFrame = Firework.FireworkModel.CFrame
	--workspace.ChildAdded:Connect(function(NewChild)
	--print(NewChild.Name)
	--print(NewChild.Parent.Name)
	--end)
end)

function CheckBlacklisting(Name)

	for i,v in pairs(BlackList) do

		if Name == v then

			return false

		end

	end

	return true

end

