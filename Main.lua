local Selection = game

local Player = game.Players.LocalPlayer

local character = Player.Character
local humanoid = character:WaitForChild("Humanoid")

local Mouse = Player:GetMouse()

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

local AutoBuy = false
local ClickResearsh = false

local PlayerTycoons = game.Workspace.PlayerTycoons
local PlayerTycoon = nil

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

function CreateFrame(x,y,xsize,ysize, Name)
	local Frame = Instance.new("Frame")
	Frame.Name = Name
	Frame.Visible = true
	Frame.Size = UDim2.new(xsize,0,ysize,0)
	Frame.Parent = ScreenGui
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
	local Frame = Instance.new("Frame")
	Frame.Name = Name
	Frame.Visible = false
	Frame.Size = UDim2.new(xsize,0,ysize,0)
	Frame.Parent = ScreenGui
	Frame.Position = UDim2.new(x,0,y,0)
	Frame.AnchorPoint = Vector2.new(0.5,0.5)

	local TopBar = Instance.new("Frame")
	TopBar.Position = UDim2.new(0.5,0,0,0)
	TopBar.Size = UDim2.new(1,0,0.05,0)
	TopBar.Name = "TopBar"
	TopBar.Parent = Frame
	TopBar.AnchorPoint = Vector2.new(0.5,0)
	TopBar.BackgroundColor3 = Color3.new(0.211765, 0.211765, 0.211765)

	local ReduceButton = Instance.new("TextButton")
	ReduceButton.Parent = TopBar
	ReduceButton.Text = "-"
	ReduceButton.Name = "ReduceButton"
	ReduceButton.BackgroundColor3 = Color3.new(0.211765, 0.211765, 0.211765)
	ReduceButton.Size = UDim2.new(0.05,0,1,0)

	local RemoveButton = Instance.new("TextButton")
	RemoveButton.Parent = TopBar
	RemoveButton.Text = "X"
	RemoveButton.Name = "RemoveButton"
	RemoveButton.BackgroundColor3 = Color3.new(1, 0, 0.0156863)
	RemoveButton.TextColor3 = Color3.new(1, 1, 1)
	RemoveButton.Size = UDim2.new(0.05,0,1,0)
	RemoveButton.Position = UDim2.new(0.05,0,0,0)
	
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
	return Button
end

local MenuFrame = CreateTabFrame(.5,.5, .7,.8,"Menu")
MenuFrame.Parent = ScreenGui
local BrowserFrame = CreateTabFrame(.5,.5,.7,.8,"BrowserFrame")

BrowserFrame.Parent = ScreenGui
BrowserFrame.TopBar:WaitForChild("RemoveButton"):Destroy()

local BrowserBrowsingLabel = CreateTextLabel(0.5,0.09,1,0.075, "3BrowserBrowsingLabel", "Game", Color3.new(0.67451, 0.67451, 0.67451), Color3.new(0, 0, 0))
BrowserBrowsingLabel.Parent = BrowserFrame

local BrowserInnerFrame = CreateScrollingFrame(0.5,0.55, 1,0.85,"BrowserInnerFrame")
BrowserInnerFrame.Parent = BrowserFrame

local GetGameFilesButton = CreateTextButton(0.06,0.15,0.1,0.075,"GetGameFilesButton", "Get game files",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
GetGameFilesButton.Parent = MenuFrame

local ClickResearchButton = CreateTextButton(0.06,0.25,0.1,0.075,"ClickResearchButton", "Click to research",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
ClickResearchButton.Parent = MenuFrame

local AutoBuyButton = CreateTextButton(0.20,0.25,0.1,0.075,"AutoBuyButton", "Auto Buy",Color3.new(0.294118, 0, 0.00392157),Color3.new(1, 1, 1))
AutoBuyButton.Parent = MenuFrame

local BrowserUIList = Instance.new("UIListLayout")
BrowserUIList.Parent = BrowserInnerFrame
BrowserUIList.FillDirection = Enum.FillDirection.Vertical

MenuFrame.TopBar.ReduceButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = false
end)

MenuFrame.TopBar.RemoveButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

BrowserFrame.TopBar.ReduceButton.MouseButton1Click:Connect(function()
	BrowserFrame.Visible = false
end)

ButtonFrame.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
end)

-- Button Functions

--GetWorkspace
function Refresh()
	BrowserInnerFrame.CanvasPosition = Vector2.new(0,0)
	
	BrowserBrowsingLabel.Text = Selection.Name
	
	for i,v in pairs(BrowserInnerFrame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") then
			v:Destroy()
		end
	end
	
	local ReturnButton = CreateTextButton(0,0,0.9,0.1,"1Return","Return",Color3.new(0, 1, 0),Color3.new(1, 1, 1))
	ReturnButton.Parent = BrowserInnerFrame
	
	ReturnButton.MouseButton1Click:Connect(function()
		if Selection ~= game then 
			Selection = Selection.Parent
			Refresh()
		else
			BrowserFrame.Visible = false
		end
	end)
	
	
	if Selection:IsA("ObjectValue") or Selection:IsA("IntValue") or Selection:IsA("StringValue") then
		local ValueFrame = CreateTextLabel(0,0,0.9,0.1,"2Value","Value: "..Selection.Value,Color3.new(0, 0.235294, 1),Color3.new(1, 1, 1))
		ValueFrame.Parent = BrowserInnerFrame
	end
	
	for i,v in pairs(Selection:GetChildren())do
		local Button = CreateTextButton(0,0,0.9,0.1,v.Name,v.Name.. " => "..v.ClassName,Color3.new(1, 1, 1),Color3.new(0, 0, 0))
		Button.Parent = BrowserInnerFrame
		
		Button.MouseButton1Click:Connect(function()
			Button.BackgroundColor3 = Color3.new(0.67451, 0.67451, 0.67451)
			Selection = v
			Refresh()
		end)
	end
end

GetGameFilesButton.MouseButton1Click:Connect(function()
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
				print(v)
			end
		end
	end
	
	AutoBuy = not AutoBuy
	if AutoBuy then
		AutoBuyButton.BackgroundColor3 = Color3.new(0, 1, 0)
	else
		AutoBuyButton.BackgroundColor3 = Color3.new(0.294118, 0, 0.00392157)
	end
	
	while AutoBuy do
		wait(1)
		for i,v in pairs(PlayerTycoon.Buttons:GetChildren())do
			print(v.Button.Color)
		end
	end
	
end)

-- Misc

Mouse.Button1Up:Connect(function()
	
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
