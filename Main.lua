local ContextActionService = game:GetService("ContextActionService")

local ButtonsBlacklist = {
	"AttackHusky",
	"AutoCollect",
	"DoubleCash",
	"SuperSoldier"
}

local Selection = game

local Player = game.Players.LocalPlayer

local character = Player.Character
local humanoid = character:WaitForChild("Humanoid")

local Mouse = Player:GetMouse()

local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Parent = Game.CoreGui

local ButtonFrameOutline = Instance.new("Frame")
ButtonFrameOutline.Parent = ScreenGui
ButtonFrameOutline.Size = UDim2.new(0.125,0,0.125,0)
ButtonFrameOutline.SizeConstraint = Enum.SizeConstraint.RelativeYY
ButtonFrameOutline.AnchorPoint = Vector2.new(0.5,0.5)
ButtonFrameOutline.BackgroundColor3 = Color3.new(1, 0, 0.384314)
ButtonFrameOutline.Position = UDim2.new(0.1,0,0.1,0)

local MainButtonOutlineUICorner = Instance.new("UICorner")
MainButtonOutlineUICorner.Parent = ButtonFrameOutline
MainButtonOutlineUICorner.CornerRadius = UDim.new(0.3,0)


local ButtonFrame = Instance.new("ImageButton")
ButtonFrame.Parent = ButtonFrameOutline
ButtonFrame.Size = UDim2.new(1,-4,1,-4)
ButtonFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
ButtonFrame.AnchorPoint = Vector2.new(0.5,0.5)
ButtonFrame.Image = "rbxassetid://16185622377"
ButtonFrame.Position = UDim2.new(0.5,0,0.5,0)

local MainButtonUICorner = Instance.new("UICorner")
MainButtonUICorner.Parent = ButtonFrame
MainButtonUICorner.CornerRadius = UDim.new(0.3,0)

local gui = ButtonFrame

local AutoBuy = false
local ClickResearsh = false
local AutoCollect = false
local AutoRebirth = false
local AntiAfk = false
local Aimbot = false
local AutoStab = false
local AutoFarmEvent = false

local AutoCrate = false
local CrateFound = false
local CratePos

local Iterations = 0

local PlayerTycoons = game.Workspace:FindFirstChild("PlayerTycoons")
local PlayerTycoon = nil
local TycoonPos

local EventFolder = workspace:FindFirstChild("CurrentEventCollectables")

local dragging
local dragInput
local dragStart
local startPos

local Waypoints

function GetClosestTarget(Position:Vector3,Distance:number	)
	
	local Target = nil
	local TargetPosition = nil
	
	local PartsInRadius = workspace:GetPartBoundsInRadius(Position,Distance)
	
	for i,v in pairs(PartsInRadius)do
		
		if v.Parent:FindFirstChildOfClass("Humanoid") ~= nil then
			print("A")
			local vHumanoid = v.Parent:FindFirstChildOfClass("Humanoid")
			
			if v.Parent ~= nil and vHumanoid ~= Player.Character.Humanoid and v.Parent.Name ~= "Worker" and v.Parent.Name ~= "Statue" and v.Parent.Name ~= "AISoldier" and v.Parent.Name ~= "Soldier1" and v.Parent.Name ~= "Animated" then
				
				if Target == nil then
					
					Target = v.Parent
					TargetPosition = v.Parent.PrimaryPart.Position
					
				end
				
				
				if (Position-v.Parent.PrimaryPart.Position).Magnitude < (TargetPosition-Position).Magnitude then
					
					Target = v.Parent
					TargetPosition = v.Parent.PrimaryPart.Position
					
				end
				
			end
			
		end
		
	end
	
	return Target
	
end

local function update(input)
	local delta = input.Position - dragStart
	gui.Parent.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

function fireproximityprompt(Obj, Amount, Skip) if Obj.ClassName == "ProximityPrompt" then Amount = Amount or 1 local PromptTime = Obj.HoldDuration if Skip then Obj.HoldDuration = 0 end for i = 1, Amount do Obj:InputHoldBegin() if not Skip then wait(Obj.HoldDuration) end Obj:InputHoldEnd() end Obj.HoldDuration = PromptTime else error("userdata<ProximityPrompt> expected") end end

function GoToPoint(StartPlot:Vector3,EndPlot:Vector3,Distance:Number,StepCooldown:Number)
	local NewDist = Distance
	local PreviousPos = StartPlot
	while character.PrimaryPart.Position ~= EndPlot and character.Humanoid.Health > 0 do
		local Direction = (character.PrimaryPart.Position - EndPlot).Unit *-1

		if (character.PrimaryPart.Position + Direction*NewDist - EndPlot).Magnitude < NewDist then
			character:MoveTo(EndPlot)
			break
		end

		character:MoveTo(character.PrimaryPart.Position + Direction*NewDist)

		if (PreviousPos-character.PrimaryPart.Position).Magnitude < Distance/4 then
			NewDist = NewDist+10
		else
			NewDist = Distance
		end

		PreviousPos = character.PrimaryPart.Position

		wait(StepCooldown)

	end

	if character.PrimaryPart.Position ~= EndPlot and character.Humanoid.Health > 0 then
		GoToPoint(StartPlot,EndPlot,Distance,StepCooldown)
	end
end

gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Parent.Position

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

function Outline(BorderWidth:number,BorderRadius:number,BorderColor:BrickColor,Frame:Frame, Name:string)
	local OutlineFrame = Instance.new("Frame")

	OutlineFrame.Position = Frame.Position
	OutlineFrame.Size = Frame.Size +UDim2.new(0,BorderWidth,0,BorderWidth)
	OutlineFrame.Parent = Frame.Parent
	OutlineFrame.BackgroundColor = BorderColor
	OutlineFrame.AnchorPoint = Frame.AnchorPoint
	OutlineFrame.Name = Name
	OutlineFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY

	Frame.Parent = OutlineFrame
	Frame.Position = UDim2.new(0.5,0,0.5,0)
	Frame.Size = UDim2.new(1,-BorderWidth,1,-BorderWidth)

	Corner(OutlineFrame,UDim.new(BorderRadius,0) )
	Corner(Frame, UDim.new(BorderRadius,0))
	
	return OutlineFrame
end

function Gradient(Parent:Instance,ColorSeq:ColorSequence, Rotation:number)
	local Gradient = Instance.new("UIGradient")

	Gradient.Color = ColorSeq
	Gradient.Parent = Parent
	Gradient.Rotation = Rotation
end

function Corner(Parent:Instance, Radius:UDim)
	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = Radius
	Corner.Parent = Parent
end

function CreateFrame(x,y,xsize,ysize, Name)
	local Frame = Instance.new("Frame")
	Frame.Name = Name
	Frame.Size = UDim2.new(xsize,0,ysize,0)
	Frame.Position = UDim2.new(x,0,y,0)
	Frame.AnchorPoint = Vector2.new(0.5,0.5)

	return Frame
end

function CreateScrollingFrame(x,y,xsize,ysize, Name)
	local Frame = Instance.new("ScrollingFrame")
	Frame.Name = Name
	Frame.Visible = true
	Frame.Size = UDim2.new(xsize,0,ysize,0)
	Frame.Parent = ScreenGui
	Frame.Position = UDim2.new(x,0,y,0)
	Frame.AnchorPoint = Vector2.new(0.5,0.5)
	Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y

	return Frame
end

function CreateTabFrame(x,y,xsize,ysize, Name)

	local Frame = CreateFrame(x,y,xsize,ysize,Name)
	Frame.Parent = ScreenGui

	Gradient(Frame,ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.new(0.705882, 0, 0)),
		ColorSequenceKeypoint.new(1,Color3.new(0.384314, 0, 0))
	}),90)

	local SideBar = CreateScrollingFrame(0,0.5,0.15,1,"SideBar")
	SideBar.Parent = Frame
	SideBar.AnchorPoint = Vector2.new(0,0.5)
	SideBar.BackgroundTransparency = 0.5
	SideBar.BorderSizePixel = 0
	SideBar.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
	SideBar.ScrollBarThickness = 5
	SideBar.BackgroundColor3 = Color3.new(0.333333, 0, 0)

	Corner(SideBar,UDim.new(0.0125,0))

	local ContentFrame = CreateFrame(0.575,0.575,0.85,0.85,"ContentFrame")
	ContentFrame.Parent = Frame
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.BorderSizePixel = 0

	local HubLabel = CreateTextLabel(0.4,0.070,0.5,0.16,"HubNameLabel","Chaad Hub v.0.2.2a",Color3.new(0.458824, 0.458824, 0.458824),Color3.new(1, 1, 1))
	HubLabel.BackgroundTransparency = 0.9
	HubLabel.Parent = Frame

	Corner(HubLabel, UDim.new(0.5,0))

	local ActionsButtonsContainer = CreateFrame(0.9,0.065,0.15,0.0804,"ActionsButtonsContainer")
	ActionsButtonsContainer.Parent = Frame
	ActionsButtonsContainer.BorderSizePixel = 0
	ActionsButtonsContainer.BackgroundTransparency = 1

	local ReduceButton = CreateTextButton(0.5,0,1,1,"ReduceButton","-",Color3.new(0.435294, 0.435294, 0.435294),Color3.new(1, 1, 1))
	ReduceButton.Parent = ActionsButtonsContainer
	ReduceButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ReduceButton.AnchorPoint = Vector2.new(0,0)

	Corner(ReduceButton,UDim.new(0.25,0))

	local RemoveButton = CreateTextButton(0,0,1,1,"RemoveButton","X",Color3.new(0.541176, 0, 0.00784314),Color3.new(1, 1, 1))
	RemoveButton.Parent = ActionsButtonsContainer
	RemoveButton.AnchorPoint = Vector2.new(0,0)
	RemoveButton.SizeConstraint = Enum.SizeConstraint.RelativeYY

	Corner(RemoveButton,UDim.new(0.25,0))

	return Frame
end

function CreateTextButton(x,y,xsize,ysize,name,text,backgroundColor,textColor)
	local Button = Instance.new("TextButton")
	Button.Name = name
	Button.Text = text
	Button.Position = UDim2.new(x,0,y,0)
	Button.Size = UDim2.new(xsize,0,ysize,0)
	Button.AnchorPoint = Vector2.new(0.5,0.5)
	Button.TextColor3 = textColor
	Button.BackgroundColor3 = backgroundColor
	Button.TextScaled = true
	return Button
end

function CreateImageButton(x,y,xsize,ysize,name,ImageId,backgroundColor)
	local Button = Instance.new("ImageButton")
	Button.Name = name
	Button.Image = ImageId
	Button.Position = UDim2.new(x,0,y,0)
	Button.Size = UDim2.new(xsize,0,ysize,0)
	Button.AnchorPoint = Vector2.new(0.5,0.5)
	Button.BackgroundColor3 = backgroundColor
	return Button
end

function CreateTextLabel(x,y,xsize,ysize,name,text,backgroundColor,textColor)
	local Button = Instance.new("TextLabel")
	Button.Name = name
	Button.Text = text
	Button.Position = UDim2.new(x,0,y,0)
	Button.Size = UDim2.new(xsize,0,ysize,0)
	Button.AnchorPoint = Vector2.new(0.5,0.5)
	Button.TextColor3 = textColor
	Button.BackgroundColor3 = backgroundColor
	Button.TextScaled = true
	Button.Font = Enum.Font.FredokaOne
	Button.FontFace.Bold = true

	return Button
end

function IsPartOfTable(Table, Check)
	for i,v in pairs(Table)do
		if v == Check then
			return true
		end
	end
	return false
end

local MenuFrame = CreateTabFrame(0.5,0.5, 1.1,0.7,"MenuInside")
Outline(8,0.0125,BrickColor.new(Color3.new(1, 0, 0.235294)),MenuFrame, "MenuFrameOutline")

local ContentFrame:Frame = MenuFrame.ContentFrame

function CloseAllFrameInMenuContent()
	for i,v in pairs(ContentFrame:GetChildren())do
		if v:IsA("Frame") or v:IsA("ScrollingFrame") then
			v.Visible = false
		end
	end
end


function CreateTextBox(x,y,xsize,ysize,Name,Text,BackgroundColor,TextColor,Placeholder)
	
	local Container = CreateFrame(x,y,xsize,ysize,Name)
	Container.ClipsDescendants = false
	
	local Label = CreateTextLabel(0,0.5,0.5,1,"Label",Text,BackgroundColor,TextColor)
	Label.AnchorPoint = Vector2.new(0,0.5)
	Label.Parent = Container
	Label.BorderSizePixel = 0
	
	local TextBox = Instance.new("TextBox")
	TextBox.Position = UDim2.new(0.5,0,0.5,0)
	TextBox.Size = UDim2.new(0.5,0,1,0)
	TextBox.AnchorPoint = Vector2.new(0,0.5)
	TextBox.Parent = Container
	TextBox.PlaceholderText = Placeholder
	TextBox.BorderSizePixel = 0
	TextBox.TextScaled = true
	TextBox.Text = ""
	TextBox.PlaceholderColor3 = Color3.new(0.333333, 0, 0)
	
	return Container
	
end

local ToolsButton = CreateImageButton(.5,0.1,0.5,0.5,"ToolsButton","rbxassetid://16244450805",Color3.new(0.4, 0, 0.00784314))
ToolsButton.Parent = MenuFrame.SideBar

Outline(6,0.25,BrickColor.new(Color3.new(1, 0, 0.0156863)),ToolsButton,"ToolsButtonOutline")
ToolsButton.Parent.SizeConstraint = Enum.SizeConstraint.RelativeXX
ToolsButton.SizeConstraint = Enum.SizeConstraint.RelativeXX

local FarmButton = CreateImageButton(.5,0.3,0.5,0.5,"FarmButton","rbxassetid://16244570101",Color3.new(0.4, 0, 0.00784314))
FarmButton.Parent = MenuFrame.SideBar

Outline(6,0.25,BrickColor.new(Color3.new(1, 0, 0.0156863)),FarmButton,"FarmButtonOutline")
FarmButton.Parent.SizeConstraint = Enum.SizeConstraint.RelativeXX
FarmButton.SizeConstraint = Enum.SizeConstraint.RelativeXX

local WorldButton = CreateImageButton(.5,0.5,0.5,0.5,"WorldButton","rbxassetid://16244610946",Color3.new(0.4, 0, 0.00784314))
WorldButton.Parent = MenuFrame.SideBar

Outline(6,0.25,BrickColor.new(Color3.new(1, 0, 0.0156863)),WorldButton,"WorldButtonOutline")
WorldButton.Parent.SizeConstraint = Enum.SizeConstraint.RelativeXX
WorldButton.SizeConstraint = Enum.SizeConstraint.RelativeXX

local PlayerButton = CreateImageButton(.5,0.7,0.5,0.5,"PlayerButton","rbxassetid://16244692448",Color3.new(0.4, 0, 0.00784314))
PlayerButton.Parent = MenuFrame.SideBar

Outline(6,0.25,BrickColor.new(Color3.new(1, 0, 0.0156863)),PlayerButton,"PlayerButtonOutline")
PlayerButton.Parent.SizeConstraint = Enum.SizeConstraint.RelativeXX
PlayerButton.SizeConstraint = Enum.SizeConstraint.RelativeXX

local CombatButton = CreateImageButton(.5,0.9,0.5,0.5,"CombatButton","rbxassetid://16244690064",Color3.new(0.4, 0, 0.00784314))
CombatButton.Parent = MenuFrame.SideBar

Outline(6,0.25,BrickColor.new(Color3.new(1, 0, 0.0156863)),CombatButton,"CombatButtonOutline")
CombatButton.Parent.SizeConstraint = Enum.SizeConstraint.RelativeXX
CombatButton.SizeConstraint = Enum.SizeConstraint.RelativeXX

local BrowserFrame = CreateFrame(0.5,0.5,1,1,"BrowserFrame")
BrowserFrame.Parent = ContentFrame
BrowserFrame.Visible = false
BrowserFrame.BorderSizePixel = 0
BrowserFrame.BackgroundTransparency = 1

local ToolsFrame = CreateScrollingFrame(.5,.5,1,1,"ToolsFrame")
ToolsFrame.Parent = ContentFrame
ToolsFrame.BackgroundTransparency = 1
ToolsFrame.Visible = false
ToolsFrame.BorderSizePixel = 0

local FarmFrame = CreateScrollingFrame(.5,.5,1,1,"FarmFrame")
FarmFrame.Parent = ContentFrame
FarmFrame.BackgroundTransparency = 1
FarmFrame.Visible = false
FarmFrame.BorderSizePixel = 0

local WorldFrame = CreateScrollingFrame(.5,.5,1,1,"WorldFrame")
WorldFrame.Parent = ContentFrame
WorldFrame.BackgroundTransparency = 1
WorldFrame.Visible = false
WorldFrame.BorderSizePixel = 0

local PlayerFrame = CreateScrollingFrame(.5,.5,1,1,"PlayerFrame")
PlayerFrame.Parent = ContentFrame
PlayerFrame.BackgroundTransparency = 1
PlayerFrame.Visible = false
PlayerFrame.BorderSizePixel = 0

local CombatFrame = CreateScrollingFrame(.5,.5,1,1,"CombatFrame")
CombatFrame.Parent = ContentFrame
CombatFrame.BackgroundTransparency = 1
CombatFrame.Visible = false
CombatFrame.BorderSizePixel = 0

local BrowserBrowsingLabel = CreateTextLabel(0.5,0.09,1,0.075, "BrowserBrowsingLabel", "Game", Color3.new(0.67451, 0.67451, 0.67451), Color3.new(0, 0, 0))
BrowserBrowsingLabel.Parent = BrowserFrame
BrowserBrowsingLabel.BorderSizePixel = 0

Corner(BrowserBrowsingLabel, UDim.new(0.125,0))

local BrowserInnerFrame = CreateScrollingFrame(0.5,0.55, 1,0.85,"BrowserInnerFrame")
BrowserInnerFrame.BackgroundColor3 = Color3.new(0.27451, 0, 0.00784314)
BrowserInnerFrame.Parent = BrowserFrame
BrowserInnerFrame.BorderSizePixel = 0

-- Tools Buttons

local GetGameFilesButton = CreateTextButton(0.2,0.15,.4,0.125,"GetGameFilesButton", "Get game files",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
GetGameFilesButton.Parent = ToolsFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),GetGameFilesButton,"GetGameFilesButtonOutline")

local ClickResearchButton = CreateTextButton(0.2,0.3,.4,0.125,"ClickResearchButton", "Click to research",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
ClickResearchButton.Parent = ToolsFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),ClickResearchButton,"ClickResearchButtonOutline")

local AntiAfkButton = CreateTextButton(0.2,.45,.4,0.125,"AntiAfkButton", "Anti-Afk",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AntiAfkButton.Parent = ToolsFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AntiAfkButton,"AntiAfkButtonOutline")

local GetRemoteEventsButton = CreateTextButton(0.2,.6,.4,.125,"GetRemoteEventsButton", "Get remote events",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
GetRemoteEventsButton.Parent = ToolsFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),GetRemoteEventsButton,"GetRemoteEventsButtonOutline")

--Farm Buttons

local AutoBuyButton = CreateTextButton(0.2,0.15,.4,0.125,"AutoBuyButton", "Auto buy",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AutoBuyButton.Parent = FarmFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AutoBuyButton,"AutoBuyButtonOutline")

local AutoCollectButton = CreateTextButton(0.2,0.3,.4,0.125,"AutoCollectButton", "Auto collect",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AutoCollectButton.Parent = FarmFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AutoCollectButton,"AutoCollectButtonOutline")

local AutoRebirthButton = CreateTextButton(0.2,0.45,.4,0.125,"AutoRebirthButton", "Auto rebirth",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AutoRebirthButton.Parent = FarmFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AutoRebirthButton,"AutoRebirthButtonOutline")

-- World Buttons

local AutoCrateButton = CreateTextButton(0.2,.15,.4,0.125,"AutoCrateButton", "Auto crate",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AutoCrateButton.Parent = WorldFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AutoCrateButton,"AutoCrateButtonOutline")

local AutoFarmEventButton = CreateTextButton(0.2,.30,.4,0.125,"AutoFarmEventButton", "Auto farm event",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AutoFarmEventButton.Parent = WorldFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AutoFarmEventButton,"AutoFarmEventButtonOutline")

-- Combat Buttons

local AimbotButton = CreateTextButton(0.2,.15,.4,0.125,"AimbotButton", "Aimbot",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AimbotButton.Parent = CombatFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AimbotButton,"AimbotButtonOutline")

local AimbotDistanceSettings = CreateTextBox(0.5,0.15,.4,0.125,"AimbotDistanceSettings","Aimbot Distance",Color3.new(1, 0, 0),Color3.new(1, 1, 1),"Number:")
AimbotDistanceSettings.Parent = CombatFrame
local AimbotDistanceSettingsOutline = Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AimbotDistanceSettings,"AimbotDistanceSettingsOutline")
Gradient(AimbotDistanceSettingsOutline,ColorSequence.new({
	ColorSequenceKeypoint.new(0,Color3.new(1, 0, 0.0156863)),
	ColorSequenceKeypoint.new(1,Color3.new(0.541176, 0, 0.00784314))
}), 0)

local AutoStabButton = CreateTextButton(0.2,.3,.4,0.125,"AutoStabButton", "Auto stab",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AutoStabButton.Parent = CombatFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),AutoStabButton,"AutoStabButtonOutline")

local KillAuraButton = CreateTextButton(0.2,.45,.4,0.125,"KillAuraButton", "Kill Aura",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
KillAuraButton.Parent = CombatFrame
Outline(4,0.125,BrickColor.new(Color3.new(1, 0, 0.0156863)),KillAuraButton,"KillAuraButtonOutline")


local BrowserUIList = Instance.new("UIListLayout")
BrowserUIList.Parent = BrowserInnerFrame
BrowserUIList.FillDirection = Enum.FillDirection.Vertical
BrowserUIList.Padding = UDim.new(0.01,0)
BrowserUIList.SortOrder = Enum.SortOrder.Name

ToolsButton.MouseButton1Click:Connect(function()
	CloseAllFrameInMenuContent()
	ToolsFrame.Visible = true
end)

FarmButton.MouseButton1Click:Connect(function()
	CloseAllFrameInMenuContent()
	FarmFrame.Visible = true
end)

WorldButton.MouseButton1Click:Connect(function()
	CloseAllFrameInMenuContent()
	WorldFrame.Visible = true
end)

PlayerButton.MouseButton1Click:Connect(function()
	CloseAllFrameInMenuContent()
	PlayerFrame.Visible = true
end)

CombatButton.MouseButton1Click:Connect(function()
	CloseAllFrameInMenuContent()
	CombatFrame.Visible = true
end)



MenuFrame.ActionsButtonsContainer.ReduceButton.MouseButton1Click:Connect(function()
	MenuFrame.Parent.Visible = false
end)

MenuFrame.ActionsButtonsContainer.RemoveButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

ButtonFrame.MouseButton1Click:Connect(function()
	MenuFrame.Parent.Visible = not MenuFrame.Parent.Visible
end)


function refreshPlayer()
  Player = Game:GetService("Players").LocalPlayer
  character = Player.Character
  humanoid = character:WaitForChild("Humanoid")
end
-- Button Functions

--GetWorkspace
function Refresh()
	BrowserInnerFrame.CanvasPosition = Vector2.new(0,0)

	BrowserBrowsingLabel.Text = Selection.Name

	for i,v in pairs(BrowserInnerFrame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("Frame") then
			v:Destroy()
		end
	end

	local ReturnButton = CreateTextButton(0,0,0.9,0.1,"00000000Return","Return",Color3.new(0, 1, 0),Color3.new(1, 1, 1))
	ReturnButton.Parent = BrowserInnerFrame
	Corner(ReturnButton,UDim.new(0.125,0))

	local BottomFillers = CreateFrame(0,0,0.9,0.4,"ZZZZZZZZZZZZFiller")
	BottomFillers.Parent = BrowserInnerFrame
	BottomFillers.BackgroundTransparency = 1
	Corner(BottomFillers,UDim.new(0.125,0))

	ReturnButton.MouseButton1Click:Connect(function()
		if Selection ~= game then 
			Selection = Selection.Parent
			Refresh()
		else
			BrowserFrame.Visible = false
			ToolsFrame.Visible = true
		end
	end)


	if Selection:IsA("ObjectValue") or Selection:IsA("IntValue") or Selection:IsA("StringValue") then
		local ValueFrame = CreateTextLabel(0,0,0.9,0.1,"2Value","Value: "..Selection.Value,Color3.new(0, 0.235294, 1),Color3.new(1, 1, 1))
		ValueFrame.Parent = BrowserInnerFrame
	end

	for i,v in pairs(Selection:GetChildren())do
		local Button = CreateTextButton(0,0,0.9,0.1,"A"..v.Name,v.Name.. " => "..v.ClassName,Color3.new(1, 0.607843, 0.615686),Color3.new(0, 0, 0))
		Button.Parent = BrowserInnerFrame
		Corner(Button,UDim.new(0.125,0))

		Button.MouseButton1Click:Connect(function()
			Button.BackgroundColor3 = Color3.new(0.407843, 0, 0.0117647)
			Selection = v
			Refresh()
		end)
	end
end

GetGameFilesButton.MouseButton1Click:Connect(function()
	CloseAllFrameInMenuContent()
	BrowserFrame.Visible = true
	Refresh()
end)

--Click To Reseach Button

ClickResearchButton.MouseButton1Click:Connect(function()
	ClickResearsh = not ClickResearsh
	if ClickResearsh then
		ClickResearchButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		ClickResearchButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end
end)

--AutoBuy

AutoBuyButton.MouseButton1Click:Connect(function()

	if PlayerTycoon == nil then
		for i,v in pairs(PlayerTycoons:GetChildren()) do
			if v.TycoonVals.Owner.Value == Player then
				PlayerTycoon = v
				TycoonPos = PlayerTycoon.Models.Giver.CollectButton.Position
			end
		end
	end

	AutoBuy = not AutoBuy
	if AutoBuy then
  		refreshPlayer()
		AutoBuyButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		AutoBuyButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end

	autoBuy()
end)

function autoBuy()
	while AutoBuy do

		wait(.25)

		for i,v in pairs(PlayerTycoon.ButtonFolder:GetChildren())do
   			refreshPlayer()
			wait(0.2)
			if AutoBuy == false then
				break
			end

			if CrateFound ~= true and AutoBuy then
				local Fnd = false

				if PlayerTycoon.ButtonFolder:FindFirstChild("Worker_1_Upgrade1") ~= nil then
					v = PlayerTycoon.ButtonFolder:FindFirstChild("Worker_1_Upgrade1")
				end
				if PlayerTycoon.ButtonFolder:FindFirstChild("Worker_2_Upgrade1") ~= nil then
					v = PlayerTycoon.ButtonFolder:FindFirstChild("Worker_2_Upgrade1")
				end
				if PlayerTycoon.ButtonFolder:FindFirstChild("01_Base_Floor_Upgrade") ~= nil then
					v = PlayerTycoon.ButtonFolder:FindFirstChild("01_Base_Floor_Upgrade")
				end
					
				if PlayerTycoon.ButtonFolder:FindFirstChild("02_Worker_01_Upgrade") ~= nil then
					v = PlayerTycoon.ButtonFolder:FindFirstChild("02_Worker_01_Upgrade")
				end
					
				if IsPartOfTable(ButtonsBlacklist,v.Name) then
					
				elseif v.Button.Color.R < v.Button.Color.G and v.Button.Color.B < ((v.Button.Color.R + v.Button.Color.G)/2) then
						
					Fnd = true
					GoToPoint(character.PrimaryPart.Position,v.Button.Position,30,0.1)
						
				else
						
					Fnd = false
					GoToPoint(character.PrimaryPart.Position,TycoonPos,30,0.1)
						
				end

				if Fnd == false then
					if PlayerTycoon.Models:FindFirstChild("Giver") ~= nil then
						GoToPoint(character.PrimaryPart.Position,PlayerTycoon.Models.Giver.CollectButton.Position,30,0.1)	
					else
						GoToPoint(character.PrimaryPart.Position,TycoonPos,30,0.1)
					end
				end
			end



		end
	end
	if AutoBuy then
		autoBuy()
	end

end

--Auto Collect

AutoCollectButton.MouseButton1Click:Connect(function()

	if PlayerTycoon == nil then
		for i,v in pairs(PlayerTycoons:GetChildren()) do
			if v.TycoonVals.Owner.Value == Player then
				PlayerTycoon = v
				TycoonPos = PlayerTycoon.Models.Giver.CollectButton.Position
			end
		end
	end

	AutoCollect = not AutoCollect
	if AutoCollect then
		AutoCollectButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		AutoCollectButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end

	while AutoCollect do
  refreshPlayer()
		wait(0.5)
		if CrateFound ~= true and AutoCollect then
			if PlayerTycoon.Models:FindFirstChild("Giver") ~= nil then
				GoToPoint(character.PrimaryPart.Position,PlayerTycoon.Models.Giver.CollectButton.Position,30,0.1)	
			else
				GoToPoint(character.PrimaryPart.Position,TycoonPos,30,0.1)
			end
		end

	end

end)

-- Auto Rebirth

AutoRebirthButton.MouseButton1Click:Connect(function()

	AutoRebirth = not AutoRebirth
	if AutoRebirth then
		AutoRebirthButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		AutoRebirthButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end

	while AutoRebirth do

		game:GetService("ReplicatedStorage").LocalRebirth:FireServer()
		wait(10)

		if Player.PlayerGui:FindFirstChild("BaseUI").Enabled == true then
			game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TycoonService"):WaitForChild("RF"):WaitForChild("SetBase"):InvokeServer(3)

			game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("TycoonService"):WaitForChild("RF"):WaitForChild("Select"):InvokeServer("France")

			game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ABTestingService"):WaitForChild("RF"):WaitForChild("GetGetLocalTycoonName"):InvokeServer(3)

			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Settings"):FireServer(true)

			game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("MissionService"):WaitForChild("RF"):WaitForChild("Get"):InvokeServer()

			game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.5.1"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("DailyLoginService"):WaitForChild("RF"):WaitForChild("Claim"):InvokeServer()

			Player.PlayerGui:FindFirstChild("BaseUI").Enabled = false
   refreshPlayer()
			wait(10)
		end

	end
end)

-- Auto Crate

AutoCrateButton.MouseButton1Click:Connect(function()

	AutoCrate = not AutoCrate
	if AutoCrate then
		AutoCrateButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		AutoCrateButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end

	while AutoCrate do
		if CrateFound then

			GoToPoint(character.PrimaryPart.Position,CratePos.Position + Vector3.new(0,20,0),40,0.1)

			wait(35)

			CrateFound = false
		else
			for i,v in pairs(workspace:GetChildren())do
				if v.Name == "Crate" and v:FindFirstChild("Main") ~= nil and CratePos ~= v.Main then

					CrateFound = true
					CratePos = v.Main
				end
			end
			wait(5)
		end

		wait(10)
	end

end)
-- Anti Afk

AntiAfkButton.MouseButton1Click:Connect(function()

	AntiAfk = not AntiAfk

	if AntiAfk then
		AntiAfkButton.BackgroundColor3 = Color3.new(0, 1, 0)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/KazeOnTop/Rice-Anti-Afk/main/Wind", true))()
	else
		game.CoreGui.Rice:Destroy()
		AntiAfkButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end
end)

-- Aimbot
AimbotButton.MouseButton1Click:Connect(function()

	Aimbot = not Aimbot
	if Aimbot then
		AimbotButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		AimbotButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end

	while Aimbot do
		
		local Target = GetClosestTarget(character.PrimaryPart.Position,250)
		
		print(Target)
		
		if Target ~= nil and Target.Humanoid ~= nil and Target.Humanoid.Health > 0 then
			
			if Target:FindFirstChild("Head") ~= nil then
				
				workspace.CurrentCamera.CFrame = CFrame.lookAt(character.PrimaryPart.Position,Target.Head.Position)
				
			end
			
		end
		wait(.0125)
		
	end
	

end)

--Auto Stab
AutoStabButton.MouseButton1Click:Connect(function()	
	AutoStab = not AutoStab
	if AutoStab then
		AutoStabButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		AutoStabButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end

	local Knife = Player.Backpack:FindFirstChild("HeatKnife")
	if Knife == nil then
		AutoStab = false
		AutoStabButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
		return
	end

	while AutoStab do
		local Target = GetClosestTarget(character.PrimaryPart.Position,250)
		
		if (Target.PrimaryPart.Position-character.PrimaryPart.Position).Magnitude > 4 then
			GoToPoint(character.PrimaryPart.Position,Target.PrimaryPart.Position + Vector3.new(2,0,2),40,0.1)
		end

		Knife.Parent = character
		workspace.CurrentCamera.CFrame = CFrame.lookAt(character.PrimaryPart.Position,Target.Head.Position)
		Knife:Activate()
		wait(0.33)



		wait(0.5)
	end
end)
--Auto Farm Event

AutoFarmEventButton.MouseButton1Click:Connect(function()
	AutoFarmEvent = not AutoFarmEvent
	if AutoFarmEvent then
		AutoFarmEventButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		AutoFarmEventButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end

	while AutoFarmEvent do
		for i,v in pairs(EventFolder:GetChildren()) do
			if v ~= nil and v:FindFirstChild("Hitbox") ~= nil and v.Hitbox:FindFirstChild("ProximityPrompt") ~= nil then
				while v:FindFirstChild("Hitbox") ~= nil and v.Hitbox:FindFirstChild("ProximityPrompt") ~= nil do
					if v:FindFirstChild("Hitbox") ~= nil and (v.Hitbox.Position-character.PrimaryPart.Position).Magnitude > 10 then
						GoToPoint(character.PrimaryPart.Position,v.Hitbox.Position + Vector3.new(0,5,0),45,0.2)
					end
					wait(1)
					fireproximityprompt(v.Hitbox:FindFirstChild("ProximityPrompt"),1,false)
					wait(1)
				end
			end
		end
		wait(1)
	end
end)

--Get Remote Event

GetRemoteEventsButton.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
end)

-- Misc

Mouse.Button1Up:Connect(function()
	if Mouse.Target == nil then
		return
	end

	if Mouse.Target.Parent == nil then
		return
	end

	if BrowserFrame.Visible == true then
		return
	end

	if MenuFrame.Visible == true then
		return
	end

	if ClickResearsh == false then
		return
	end

	Selection = Mouse.Target.Parent

	BrowserFrame.Visible = true
	Refresh()
end)
