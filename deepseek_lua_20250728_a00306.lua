-- Premium Map GUI Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- Map settings
local MAP_SIZE = 5000
local MAP_SCALE_FACTOR = 0.2  -- How much real world translates to map
local MIN_ZOOM = 0.5
local MAX_ZOOM = 3
local DEFAULT_ZOOM = 1

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumMapGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.6, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner gradient
local CornerGradient = Instance.new("UIGradient")
CornerGradient.Rotation = 45
CornerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
})
CornerGradient.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0.05, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PREMIUM MAP SYSTEM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.1, 0, 1, 0)
CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextScaled = true
CloseButton.Parent = TitleBar

-- Map container
local MapContainer = Instance.new("Frame")
MapContainer.Name = "MapContainer"
MapContainer.Size = UDim2.new(1, 0, 0.95, 0)
MapContainer.Position = UDim2.new(0, 0, 0.05, 0)
MapContainer.BackgroundTransparency = 1
MapContainer.ClipsDescendants = true
MapContainer.Parent = MainFrame

-- Actual map frame
local MapFrame = Instance.new("Frame")
MapFrame.Name = "MapFrame"
MapFrame.Size = UDim2.new(1, 0, 1, 0)
MapFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MapFrame.BackgroundTransparency = 0.2
MapFrame.BorderSizePixel = 0
MapFrame.Parent = MapContainer

-- Grid lines
local GridLines = Instance.new("Frame")
GridLines.Name = "GridLines"
GridLines.Size = UDim2.new(1, 0, 1, 0)
GridLines.BackgroundTransparency = 1
GridLines.Parent = MapFrame

-- Center crosshair
local CenterCrosshair = Instance.new("Frame")
CenterCrosshair.Name = "CenterCrosshair"
CenterCrosshair.AnchorPoint = Vector2.new(0.5, 0.5)
CenterCrosshair.Size = UDim2.new(0, 2, 1, 0)
CenterCrosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterCrosshair.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CenterCrosshair.BackgroundTransparency = 0.5
CenterCrosshair.BorderSizePixel = 0
CenterCrosshair.Visible = false
CenterCrosshair.Parent = MapFrame

local CenterCrosshair2 = Instance.new("Frame")
CenterCrosshair2.Name = "CenterCrosshair2"
CenterCrosshair2.AnchorPoint = Vector2.new(0.5, 0.5)
CenterCrosshair2.Size = UDim2.new(1, 0, 0, 2)
CenterCrosshair2.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterCrosshair2.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CenterCrosshair2.BackgroundTransparency = 0.5
CenterCrosshair2.BorderSizePixel = 0
CenterCrosshair2.Visible = false
CenterCrosshair2.Parent = MapFrame

-- Waypoint marker
local WaypointMarker = Instance.new("Frame")
WaypointMarker.Name = "WaypointMarker"
WaypointMarker.AnchorPoint = Vector2.new(0.5, 0.5)
WaypointMarker.Size = UDim2.new(0, 10, 0, 10)
WaypointMarker.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
WaypointMarker.BackgroundTransparency = 0.3
WaypointMarker.BorderSizePixel = 0
WaypointMarker.Visible = false
WaypointMarker.Parent = MapFrame

local WaypointMarkerInner = Instance.new("Frame")
WaypointMarkerInner.Name = "WaypointMarkerInner"
WaypointMarkerInner.AnchorPoint = Vector2.new(0.5, 0.5)
WaypointMarkerInner.Size = UDim2.new(0, 6, 0, 6)
WaypointMarkerInner.Position = UDim2.new(0.5, 0, 0.5, 0)
WaypointMarkerInner.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
WaypointMarkerInner.BackgroundTransparency = 0.1
WaypointMarkerInner.BorderSizePixel = 0
WaypointMarkerInner.Parent = WaypointMarker

-- Player markers (will be created dynamically)
local PlayerMarkers = Instance.new("Folder")
PlayerMarkers.Name = "PlayerMarkers"
PlayerMarkers.Parent = MapFrame

-- Coordinates display
local CoordinatesDisplay = Instance.new("TextLabel")
CoordinatesDisplay.Name = "CoordinatesDisplay"
CoordinatesDisplay.Size = UDim2.new(0.3, 0, 0.05, 0)
CoordinatesDisplay.Position = UDim2.new(0.02, 0, 0.02, 0)
CoordinatesDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
CoordinatesDisplay.BackgroundTransparency = 0.5
CoordinatesDisplay.BorderSizePixel = 0
CoordinatesDisplay.Text = "X: 0 | Y: 0 | Z: 0"
CoordinatesDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordinatesDisplay.TextScaled = true
CoordinatesDisplay.Font = Enum.Font.Gotham
CoordinatesDisplay.TextXAlignment = Enum.TextXAlignment.Left
CoordinatesDisplay.Parent = MapFrame

-- Controls frame
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Size = UDim2.new(0.2, 0, 0.2, 0)
ControlsFrame.Position = UDim2.new(0.78, 0, 0.78, 0)
ControlsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ControlsFrame.BackgroundTransparency = 0.5
ControlsFrame.BorderSizePixel = 0
ControlsFrame.Parent = MapFrame

-- Zoom controls
local ZoomInButton = Instance.new("TextButton")
ZoomInButton.Name = "ZoomInButton"
ZoomInButton.Size = UDim2.new(0.4, 0, 0.4, 0)
ZoomInButton.Position = UDim2.new(0.55, 0, 0, 0)
ZoomInButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ZoomInButton.BorderSizePixel = 0
ZoomInButton.Text = "+"
ZoomInButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ZoomInButton.Font = Enum.Font.GothamBold
ZoomInButton.TextScaled = true
ZoomInButton.Parent = ControlsFrame

local ZoomOutButton = Instance.new("TextButton")
ZoomOutButton.Name = "ZoomOutButton"
ZoomOutButton.Size = UDim2.new(0.4, 0, 0.4, 0)
ZoomOutButton.Position = UDim2.new(0.55, 0, 0.55, 0)
ZoomOutButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ZoomOutButton.BorderSizePixel = 0
ZoomOutButton.Text = "-"
ZoomOutButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ZoomOutButton.Font = Enum.Font.GothamBold
ZoomOutButton.TextScaled = true
ZoomOutButton.Parent = ControlsFrame

-- Waypoint controls
local SetWaypointButton = Instance.new("TextButton")
SetWaypointButton.Name = "SetWaypointButton"
SetWaypointButton.Size = UDim2.new(0.4, 0, 0.4, 0)
SetWaypointButton.Position = UDim2.new(0, 0, 0, 0)
SetWaypointButton.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
SetWaypointButton.BorderSizePixel = 0
SetWaypointButton.Text = "Set WP"
SetWaypointButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SetWaypointButton.Font = Enum.Font.Gotham
SetWaypointButton.TextScaled = true
SetWaypointButton.Parent = ControlsFrame

local TeleportButton = Instance.new("TextButton")
TeleportButton.Name = "TeleportButton"
TeleportButton.Size = UDim2.new(0.4, 0, 0.4, 0)
TeleportButton.Position = UDim2.new(0, 0, 0.55, 0)
TeleportButton.BackgroundColor3 = Color3.fromRGB(80, 60, 60)
TeleportButton.BorderSizePixel = 0
TeleportButton.Text = "TP"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.Gotham
TeleportButton.TextScaled = true
TeleportButton.Parent = ControlsFrame

local ConfirmButton = Instance.new("TextButton")
ConfirmButton.Name = "ConfirmButton"
ConfirmButton.Size = UDim2.new(0.9, 0, 0.4, 0)
ConfirmButton.Position = UDim2.new(0.05, 0, 0.55, 0)
ConfirmButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ConfirmButton.BorderSizePixel = 0
ConfirmButton.Text = "Confirm"
ConfirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmButton.Font = Enum.Font.GothamBold
ConfirmButton.TextScaled = true
ConfirmButton.Parent = ControlsFrame

-- Toggle button (to show/hide the map)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.1, 0, 0.05, 0)
ToggleButton.Position = UDim2.new(0.02, 0, 0.02, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.BackgroundTransparency = 0.5
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "MAP"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextScaled = true
ToggleButton.Parent = ScreenGui

-- Variables
local mapVisible = false
local isDragging = false
local dragStartPos
local mapOffset = Vector2.new(0, 0)
local currentZoom = DEFAULT_ZOOM
local waypointPosition = nil
local centerConfirmed = false

-- Create grid lines
local function createGridLines()
    GridLines:ClearAllChildren()
    
    local lineCount = 10
    local containerSize = MapContainer.AbsoluteSize
    
    for i = 1, lineCount - 1 do
        -- Vertical lines
        local vLine = Instance.new("Frame")
        vLine.Size = UDim2.new(0, 1, 1, 0)
        vLine.Position = UDim2.new(i/lineCount, 0, 0, 0)
        vLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        vLine.BackgroundTransparency = 0.9
        vLine.BorderSizePixel = 0
        vLine.Parent = GridLines
        
        -- Horizontal lines
        local hLine = Instance.new("Frame")
        hLine.Size = UDim2.new(1, 0, 0, 1)
        hLine.Position = UDim2.new(0, 0, i/lineCount, 0)
        hLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hLine.BackgroundTransparency = 0.9
        hLine.BorderSizePixel = 0
        hLine.Parent = GridLines
    end
end

-- Update coordinates display
local function updateCoordinatesDisplay()
    if not mapVisible then return end
    
    local center = MapFrame.AbsolutePosition + MapFrame.AbsoluteSize / 2
    local mousePos = UserInputService:GetMouseLocation()
    local relativePos = (mousePos - center) / (MapFrame.AbsoluteSize / 2)
    
    -- Convert to world coordinates
    local worldX = relativePos.X * (MAP_SIZE / 2) / currentZoom - mapOffset.X
    local worldZ = relativePos.Y * (MAP_SIZE / 2) / currentZoom - mapOffset.Y
    
    CoordinatesDisplay.Text = string.format("X: %d | Y: 0 | Z: %d", math.floor(worldX), math.floor(worldZ))
end

-- Update player markers
local function updatePlayerMarkers()
    if not mapVisible then return end
    
    -- Clear existing markers
    for _, child in ipairs(PlayerMarkers:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Create markers for all players
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local position = humanoidRootPart.Position
                
                -- Convert world position to map position
                local mapX = (position.X + mapOffset.X) / (MAP_SIZE / 2) * currentZoom
                local mapZ = (position.Z + mapOffset.Y) / (MAP_SIZE / 2) * currentZoom
                
                -- Create marker
                local marker = Instance.new("Frame")
                marker.Name = otherPlayer.Name
                marker.AnchorPoint = Vector2.new(0.5, 0.5)
                marker.Size = UDim2.new(0, 8, 0, 8)
                marker.Position = UDim2.new(0.5 + mapX, 0, 0.5 + mapZ, 0)
                marker.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
                marker.BackgroundTransparency = 0.3
                marker.BorderSizePixel = 0
                marker.ZIndex = 10
                marker.Parent = PlayerMarkers
                
                local innerMarker = Instance.new("Frame")
                innerMarker.AnchorPoint = Vector2.new(0.5, 0.5)
                innerMarker.Size = UDim2.new(0, 4, 0, 4)
                innerMarker.Position = UDim2.new(0.5, 0, 0.5, 0)
                innerMarker.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
                innerMarker.BackgroundTransparency = 0.1
                innerMarker.BorderSizePixel = 0
                innerMarker.Parent = marker
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(2, 0, 0.5, 0)
                nameLabel.Position = UDim2.new(1, 5, 0.25, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = otherPlayer.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.Gotham
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = marker
            end
        end
    end
end

-- Set waypoint
local function setWaypoint()
    local center = MapFrame.AbsolutePosition + MapFrame.AbsoluteSize / 2
    local mousePos = UserInputService:GetMouseLocation()
    local relativePos = (mousePos - center) / (MapFrame.AbsoluteSize / 2)
    
    -- Convert to world coordinates
    local worldX = relativePos.X * (MAP_SIZE / 2) / currentZoom - mapOffset.X
    local worldZ = relativePos.Y * (MAP_SIZE / 2) / currentZoom - mapOffset.Y
    
    waypointPosition = Vector3.new(worldX, 0, worldZ)
    
    -- Update waypoint marker
    WaypointMarker.Visible = true
    WaypointMarker.Position = UDim2.new(0.5 + relativePos.X, 0, 0.5 + relativePos.Y, 0)
    
    -- Flash effect
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(WaypointMarker, tweenInfo, {BackgroundTransparency = 0})
    tween:Play()
    tween.Completed:Connect(function()
        local tweenBack = TweenService:Create(WaypointMarker, tweenInfo, {BackgroundTransparency = 0.3})
        tweenBack:Play()
    end)
end

-- Teleport to waypoint
local function teleportToWaypoint()
    if not waypointPosition then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.CFrame = CFrame.new(waypointPosition.X, waypointPosition.Y + 5, waypointPosition.Z)
    end
end

-- Confirm center
local function confirmCenter()
    centerConfirmed = true
    CenterCrosshair.Visible = true
    CenterCrosshair2.Visible = true
    
    -- Flash effect
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(CenterCrosshair, tweenInfo, {BackgroundTransparency = 0})
    local tween2 = TweenService:Create(CenterCrosshair2, tweenInfo, {BackgroundTransparency = 0})
    tween:Play()
    tween2:Play()
    tween.Completed:Connect(function()
        local tweenBack = TweenService:Create(CenterCrosshair, tweenInfo, {BackgroundTransparency = 0.5})
        local tweenBack2 = TweenService:Create(CenterCrosshair2, tweenInfo, {BackgroundTransparency = 0.5})
        tweenBack:Play()
        tweenBack2:Play()
    end)
end

-- Toggle map visibility
local function toggleMap()
    mapVisible = not mapVisible
    MainFrame.Visible = mapVisible
    
    if mapVisible then
        -- Center map on player when opened
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                mapOffset = Vector2.new(-humanoidRootPart.Position.X, -humanoidRootPart.Position.Z)
            end
        end
        
        createGridLines()
        updatePlayerMarkers()
    end
end

-- Zoom functions
local function zoomIn()
    if currentZoom < MAX_ZOOM then
        currentZoom = math.min(currentZoom + 0.2, MAX_ZOOM)
    end
end

local function zoomOut()
    if currentZoom > MIN_ZOOM then
        currentZoom = math.max(currentZoom - 0.2, MIN_ZOOM)
    end
end

-- Input handling
local function handleInput(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if mapVisible and UserInputService:IsMouseOverGUI() then
            isDragging = true
            dragStartPos = UserInputService:GetMouseLocation()
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton1Up then
        isDragging = false
    elseif input.UserInputType == Enum.UserInputType.MouseMovement then
        if isDragging then
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - dragStartPos
            dragStartPos = currentPos
            
            -- Adjust map offset based on drag
            mapOffset = mapOffset - Vector2.new(
                delta.X * (MAP_SIZE / MapFrame.AbsoluteSize.X) * currentZoom,
                delta.Y * (MAP_SIZE / MapFrame.AbsoluteSize.Y) * currentZoom
            )
        end
        updateCoordinatesDisplay()
    end
end

-- Connect events
ToggleButton.MouseButton1Click:Connect(toggleMap)
CloseButton.MouseButton1Click:Connect(toggleMap)
ZoomInButton.MouseButton1Click:Connect(zoomIn)
ZoomOutButton.MouseButton1Click:Connect(zoomOut)
SetWaypointButton.MouseButton1Click:Connect(setWaypoint)
TeleportButton.MouseButton1Click:Connect(teleportToWaypoint)
ConfirmButton.MouseButton1Click:Connect(confirmCenter)

UserInputService.InputBegan:Connect(handleInput)
UserInputService.InputChanged:Connect(handleInput)
UserInputService.InputEnded:Connect(handleInput)

-- Update loop
RunService.Heartbeat:Connect(function()
    if mapVisible then
        updatePlayerMarkers()
    end
end)

-- Initialize
MainFrame.Visible = false
createGridLines()

-- Add some styling
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = TitleBar

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 4)
buttonCorner.Parent = CloseButton

local controlButtonCorner = Instance.new("UICorner")
controlButtonCorner.CornerRadius = UDim.new(0, 4)
controlButtonCorner.Parent = ZoomInButton
controlButtonCorner:Clone().Parent = ZoomOutButton
controlButtonCorner:Clone().Parent = SetWaypointButton
controlButtonCorner:Clone().Parent = TeleportButton
controlButtonCorner:Clone().Parent = ConfirmButton

local markerCorner = Instance.new("UICorner")
markerCorner.CornerRadius = UDim.new(1, 0)
markerCorner.Parent = WaypointMarker
markerCorner:Clone().Parent = WaypointMarkerInner

-- Add shadow effects
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = -1
shadow.Parent = MainFrame

print("Premium Map GUI loaded successfully!")