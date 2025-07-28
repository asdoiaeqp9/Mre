-- Premium VIP Map GUI System
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- Map settings
local MAP_SIZE = 5000
local MIN_ZOOM = 0.3
local MAX_ZOOM = 3
local DEFAULT_ZOOM = 0.8
local PLAYER_MARKER_SIZE = 12
local WAYPOINT_MARKER_SIZE = 14

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VIPMapSystem_"..HttpService:GenerateGUID(false)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.65, 0, 0.75, 0)
MainFrame.Position = UDim2.new(0.175, 0, 0.125, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Glass morphic effect
local GlassFrame = Instance.new("Frame")
GlassFrame.Name = "GlassFrame"
GlassFrame.Size = UDim2.new(1, 0, 1, 0)
GlassFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
GlassFrame.BackgroundTransparency = 0.85
GlassFrame.BorderSizePixel = 0
GlassFrame.Parent = MainFrame

local GlassBlur = Instance.new("ImageLabel")
GlassBlur.Name = "GlassBlur"
GlassBlur.Size = UDim2.new(1, 0, 1, 0)
GlassBlur.BackgroundTransparency = 1
GlassBlur.Image = "rbxassetid://8992231223"
GlassBlur.ImageTransparency = 0.3
GlassBlur.ScaleType = Enum.ScaleType.Slice
GlassBlur.SliceCenter = Rect.new(100, 100, 100, 100)
GlassBlur.Parent = GlassFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0.06, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 200))
})
TitleGradient.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "VIP MAP SYSTEM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "VersionLabel"
VersionLabel.Size = UDim2.new(0.2, 0, 1, 0)
VersionLabel.Position = UDim2.new(0.8, 0, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v1.0.0"
VersionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
VersionLabel.TextScaled = true
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
VersionLabel.Parent = TitleBar

-- Close button
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.06, 0, 0.8, 0)
CloseButton.Position = UDim2.new(0.94, 0, 0.1, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(924, 724)
CloseButton.ImageRectSize = Vector2.new(36, 36)
CloseButton.Parent = TitleBar

-- Map container
local MapContainer = Instance.new("Frame")
MapContainer.Name = "MapContainer"
MapContainer.Size = UDim2.new(1, 0, 0.94, 0)
MapContainer.Position = UDim2.new(0, 0, 0.06, 0)
MapContainer.BackgroundTransparency = 1
MapContainer.ClipsDescendants = true
MapContainer.Parent = MainFrame

-- Actual map frame (this will be much larger than container for dragging)
local MapFrame = Instance.new("Frame")
MapFrame.Name = "MapFrame"
MapFrame.Size = UDim2.new(2, 0, 2, 0) -- Larger than container for dragging
MapFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MapFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MapFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
MapFrame.BackgroundTransparency = 0.2
MapFrame.BorderSizePixel = 0
MapFrame.Parent = MapContainer

-- Grid lines
local GridLines = Instance.new("Frame")
GridLines.Name = "GridLines"
GridLines.Size = UDim2.new(1, 0, 1, 0)
GridLines.BackgroundTransparency = 1
GridLines.Parent = MapFrame

-- Center marker
local CenterMarker = Instance.new("ImageLabel")
CenterMarker.Name = "CenterMarker"
CenterMarker.AnchorPoint = Vector2.new(0.5, 0.5)
CenterMarker.Size = UDim2.new(0, 24, 0, 24)
CenterMarker.Position = UDim2.new(0.5, 0, 0.5, 0)
CenterMarker.BackgroundTransparency = 1
CenterMarker.Image = "rbxassetid://3926305904"
CenterMarker.ImageRectOffset = Vector2.new(84, 204)
CenterMarker.ImageRectSize = Vector2.new(36, 36)
CenterMarker.ImageColor3 = Color3.fromRGB(255, 80, 80)
CenterMarker.Parent = MapFrame

-- Waypoint marker
local WaypointMarker = Instance.new("ImageLabel")
WaypointMarker.Name = "WaypointMarker"
WaypointMarker.AnchorPoint = Vector2.new(0.5, 0.5)
WaypointMarker.Size = UDim2.new(0, WAYPOINT_MARKER_SIZE, 0, WAYPOINT_MARKER_SIZE)
CenterMarker.BackgroundTransparency = 1
WaypointMarker.Image = "rbxassetid://3926305904"
WaypointMarker.ImageRectOffset = Vector2.new(324, 124)
WaypointMarker.ImageRectSize = Vector2.new(36, 36)
WaypointMarker.ImageColor3 = Color3.fromRGB(80, 255, 80)
WaypointMarker.Visible = false
WaypointMarker.ZIndex = 10
WaypointMarker.Parent = MapFrame

-- Player markers (will be created dynamically)
local PlayerMarkers = Instance.new("Folder")
PlayerMarkers.Name = "PlayerMarkers"
PlayerMarkers.Parent = MapFrame

-- Coordinates display
local CoordinatesDisplay = Instance.new("Frame")
CoordinatesDisplay.Name = "CoordinatesDisplay"
CoordinatesDisplay.Size = UDim2.new(0.35, 0, 0.06, 0)
CoordinatesDisplay.Position = UDim2.new(0.02, 0, 0.02, 0)
CoordinatesDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
CoordinatesDisplay.BackgroundTransparency = 0.6
CoordinatesDisplay.BorderSizePixel = 0
CoordinatesDisplay.Parent = MapFrame

local CoordLabel = Instance.new("TextLabel")
CoordLabel.Name = "CoordLabel"
CoordLabel.Size = UDim2.new(1, 0, 1, 0)
CoordLabel.BackgroundTransparency = 1
CoordLabel.Text = "X: 0 | Y: 0 | Z: 0"
CoordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordLabel.TextScaled = true
CoordLabel.Font = Enum.Font.GothamMedium
CoordLabel.TextXAlignment = Enum.TextXAlignment.Left
CoordLabel.Parent = CoordinatesDisplay

-- Controls frame
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Size = UDim2.new(0.18, 0, 0.22, 0)
ControlsFrame.Position = UDim2.new(0.8, 0, 0.76, 0)
ControlsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ControlsFrame.BackgroundTransparency = 0.6
ControlsFrame.BorderSizePixel = 0
ControlsFrame.Parent = MapFrame

-- Zoom controls
local ZoomInButton = createIconButton("ZoomIn", "+", UDim2.new(0.4, 0, 0.3, 0), UDim2.new(0.55, 0, 0, 0), Color3.fromRGB(80, 180, 80))
local ZoomOutButton = createIconButton("ZoomOut", "-", UDim2.new(0.4, 0, 0.3, 0), UDim2.new(0.55, 0, 0.35, 0), Color3.fromRGB(180, 80, 80))

-- Waypoint controls
local SetWaypointButton = createIconButton("SetWaypoint", "📍", UDim2.new(0.4, 0, 0.3, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(80, 80, 180))
local TeleportButton = createIconButton("Teleport", "🚀", UDim2.new(0.4, 0, 0.3, 0), UDim2.new(0, 0, 0.35, 0), Color3.fromRGB(180, 120, 80))
local CenterButton = createIconButton("Center", "⌖", UDim2.new(0.4, 0, 0.3, 0), UDim2.new(0.55, 0, 0.7, 0), Color3.fromRGB(120, 80, 180))

-- Player tracker toggle
local TrackerButton = createIconButton("Tracker", "👥", UDim2.new(0.4, 0, 0.3, 0), UDim2.new(0, 0, 0.7, 0), Color3.fromRGB(80, 180, 180))

-- Toggle button (to show/hide the map)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.08, 0, 0.05, 0)
ToggleButton.Position = UDim2.new(0.02, 0, 0.02, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ToggleButton.BackgroundTransparency = 0.5
ToggleButton.BorderSizePixel = 0
ToggleButton.Image = "rbxassetid://3926305904"
ToggleButton.ImageRectOffset = Vector2.new(84, 4)
ToggleButton.ImageRectSize = Vector2.new(36, 36)
ToggleButton.Parent = ScreenGui

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Name = "ToggleLabel"
ToggleLabel.Size = UDim2.new(1, 0, 0.5, 0)
ToggleLabel.Position = UDim2.new(0, 0, 0.5, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "MAP"
ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.TextScaled = true
ToggleLabel.Parent = ToggleButton

-- Player context menu (appears when clicking a player)
local PlayerContextMenu = Instance.new("Frame")
PlayerContextMenu.Name = "PlayerContextMenu"
PlayerContextMenu.Size = UDim2.new(0.15, 0, 0.3, 0)
PlayerContextMenu.Position = UDim2.new(0.8, 0, 0.1, 0)
PlayerContextMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PlayerContextMenu.BackgroundTransparency = 0.1
PlayerContextMenu.BorderSizePixel = 0
PlayerContextMenu.Visible = false
PlayerContextMenu.Parent = ScreenGui

local ContextTitle = Instance.new("TextLabel")
ContextTitle.Name = "ContextTitle"
ContextTitle.Size = UDim2.new(1, 0, 0.15, 0)
ContextTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ContextTitle.BorderSizePixel = 0
ContextTitle.Text = "PLAYER ACTIONS"
ContextTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ContextTitle.Font = Enum.Font.GothamBold
ContextTitle.TextScaled = true
ContextTitle.Parent = PlayerContextMenu

local TeleportToPlayerBtn = createContextButton("TeleportToPlayer", "Teleport To Player", 0.15, Color3.fromRGB(80, 180, 80))
local ESPPlayerBtn = createContextButton("ESPPlayer", "ESP Player", 0.3, Color3.fromRGB(180, 80, 180))
local TracerPlayerBtn = createContextButton("TracerPlayer", "Tracer Player", 0.45, Color3.fromRGB(80, 180, 180))
local LoopTPPlayerBtn = createContextButton("LoopTPPlayer", "Loop TP to Player", 0.6, Color3.fromRGB(180, 180, 80))
local CloseContextBtn = createContextButton("CloseContext", "Close", 0.85, Color3.fromRGB(180, 80, 80))

-- Variables
local mapVisible = false
local isDragging = false
local dragStartPos
local mapOffset = Vector2.new(0, 0)
local currentZoom = DEFAULT_ZOOM
local waypointPosition = nil
local selectedPlayer = nil
local playerESP = {}
local playerTracers = {}
local loopTP = false
local trackPlayers = true

-- Helper function to create icon buttons
local function createIconButton(name, text, size, position, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.Parent = ControlsFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Transparency = 0.8
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    return button
end

-- Helper function to create context menu buttons
local function createContextButton(name, text, yPosition, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0.9, 0, 0.12, 0)
    button.Position = UDim2.new(0.05, 0, yPosition, 0)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextScaled = true
    button.Parent = PlayerContextMenu
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    return button
end

-- Create grid lines
local function createGridLines()
    GridLines:ClearAllChildren()
    
    local lineCount = 20
    local containerSize = MapContainer.AbsoluteSize
    local lineTransparency = 0.92
    
    for i = 1, lineCount - 1 do
        -- Vertical lines
        local vLine = Instance.new("Frame")
        vLine.Size = UDim2.new(0, 1, 1, 0)
        vLine.Position = UDim2.new(i/lineCount, 0, 0, 0)
        vLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        vLine.BackgroundTransparency = lineTransparency
        vLine.BorderSizePixel = 0
        vLine.ZIndex = 2
        vLine.Parent = GridLines
        
        -- Horizontal lines
        local hLine = Instance.new("Frame")
        hLine.Size = UDim2.new(1, 0, 0, 1)
        hLine.Position = UDim2.new(0, 0, i/lineCount, 0)
        hLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hLine.BackgroundTransparency = lineTransparency
        hLine.BorderSizePixel = 0
        hLine.ZIndex = 2
        hLine.Parent = GridLines
    end
end

-- Update coordinates display
local function updateCoordinatesDisplay()
    if not mapVisible then return end
    
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local pos = humanoidRootPart.Position
            CoordLabel.Text = string.format("X: %d | Y: %d | Z: %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
        end
    end
end

-- Update player markers
local function updatePlayerMarkers()
    if not mapVisible or not trackPlayers then return end
    
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
                local marker = Instance.new("ImageButton")
                marker.Name = otherPlayer.Name
                marker.AnchorPoint = Vector2.new(0.5, 0.5)
                marker.Size = UDim2.new(0, PLAYER_MARKER_SIZE, 0, PLAYER_MARKER_SIZE)
                marker.Position = UDim2.new(0.5 + mapX, 0, 0.5 + mapZ, 0)
                marker.BackgroundTransparency = 1
                marker.Image = "rbxassetid://3926305904"
                marker.ImageRectOffset = Vector2.new(4, 964)
                marker.ImageRectSize = Vector2.new(36, 36)
                marker.ImageColor3 = otherPlayer.Team and otherPlayer.Team.Color or Color3.fromRGB(100, 200, 255)
                marker.ZIndex = 10
                marker.Parent = PlayerMarkers
                
                -- Player name label
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "NameLabel"
                nameLabel.Size = UDim2.new(2, 0, 0.8, 0)
                nameLabel.Position = UDim2.new(1.2, 0, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = otherPlayer.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.Gotham
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = marker
                
                -- Click event for context menu
                marker.MouseButton1Click:Connect(function()
                    selectedPlayer = otherPlayer
                    PlayerContextMenu.Visible = true
                    ContextTitle.Text = string.upper(otherPlayer.Name)
                    
                    -- Position context menu near the marker but within screen bounds
                    local markerPos = marker.AbsolutePosition
                    local menuPos = Vector2.new(
                        math.clamp(markerPos.X, 0, ScreenGui.AbsoluteSize.X - PlayerContextMenu.AbsoluteSize.X),
                        math.clamp(markerPos.Y, 0, ScreenGui.AbsoluteSize.Y - PlayerContextMenu.AbsoluteSize.Y)
                    )
                    
                    PlayerContextMenu.Position = UDim2.new(
                        0, menuPos.X,
                        0, menuPos.Y
                    )
                end)
            end
        end
    end
end

-- Set waypoint at current center
local function setWaypointAtCenter()
    waypointPosition = Vector3.new(-mapOffset.X, 0, -mapOffset.Y)
    
    -- Update waypoint marker
    WaypointMarker.Visible = true
    WaypointMarker.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    -- Pulse animation
    local tweenIn = TweenService:Create(WaypointMarker, TweenInfo.new(0.2), {
        Size = UDim2.new(0, WAYPOINT_MARKER_SIZE * 1.5, 0, WAYPOINT_MARKER_SIZE * 1.5),
        ImageTransparency = 0
    })
    
    local tweenOut = TweenService:Create(WaypointMarker, TweenInfo.new(0.2), {
        Size = UDim2.new(0, WAYPOINT_MARKER_SIZE, 0, WAYPOINT_MARKER_SIZE),
        ImageTransparency = 0.2
    })
    
    tweenIn:Play()
    tweenIn.Completed:Connect(function()
        tweenOut:Play()
    end)
end

-- Teleport to waypoint
local function teleportToWaypoint()
    if not waypointPosition then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        -- Get current Y position (so we don't fall through the ground)
        local currentY = humanoidRootPart.Position.Y
        humanoidRootPart.CFrame = CFrame.new(waypointPosition.X, currentY, waypointPosition.Z)
        
        -- Pulse animation
        local tweenIn = TweenService:Create(WaypointMarker, TweenInfo.new(0.15), {
            Size = UDim2.new(0, WAYPOINT_MARKER_SIZE * 1.8, 0, WAYPOINT_MARKER_SIZE * 1.8),
            ImageColor3 = Color3.fromRGB(255, 255, 100)
        })
        
        local tweenOut = TweenService:Create(WaypointMarker, TweenInfo.new(0.15), {
            Size = UDim2.new(0, WAYPOINT_MARKER_SIZE, 0, WAYPOINT_MARKER_SIZE),
            ImageColor3 = Color3.fromRGB(80, 255, 80)
        })
        
        tweenIn:Play()
        tweenIn.Completed:Connect(function()
            tweenOut:Play()
        end)
    end
end

-- Center map on player
local function centerOnPlayer()
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            mapOffset = Vector2.new(-humanoidRootPart.Position.X, -humanoidRootPart.Position.Z)
            
            -- Pulse animation
            local tweenIn = TweenService:Create(CenterMarker, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 30, 0, 30),
                ImageTransparency = 0
            })
            
            local tweenOut = TweenService:Create(CenterMarker, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 24, 0, 24),
                ImageTransparency = 0.3
            })
            
            tweenIn:Play()
            tweenIn.Completed:Connect(function()
                tweenOut:Play()
            end)
        end
    end
end

-- Toggle player tracking
local function togglePlayerTracking()
    trackPlayers = not trackPlayers
    TrackerButton.TextColor3 = trackPlayers and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    
    if not trackPlayers then
        -- Clear all player markers
        for _, child in ipairs(PlayerMarkers:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
    end
end

-- Toggle map visibility
local function toggleMap()
    mapVisible = not mapVisible
    MainFrame.Visible = mapVisible
    
    if mapVisible then
        centerOnPlayer()
        createGridLines()
        updatePlayerMarkers()
    else
        PlayerContextMenu.Visible = false
    end
end

-- Zoom functions
local function zoomIn()
    if currentZoom < MAX_ZOOM then
        currentZoom = math.min(currentZoom + 0.2, MAX_ZOOM)
        
        -- Pulse animation
        local tween = TweenService:Create(ZoomInButton, TweenInfo.new(0.1), {
            Size = UDim2.new(0.42, 0, 0.32, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(ZoomInButton, TweenInfo.new(0.1), {
                Size = UDim2.new(0.4, 0, 0.3, 0)
            }):Play()
        end)
    end
end

local function zoomOut()
    if currentZoom > MIN_ZOOM then
        currentZoom = math.max(currentZoom - 0.2, MIN_ZOOM)
        
        -- Pulse animation
        local tween = TweenService:Create(ZoomOutButton, TweenInfo.new(0.1), {
            Size = UDim2.new(0.42, 0, 0.32, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(ZoomOutButton, TweenInfo.new(0.1), {
                Size = UDim2.new(0.4, 0, 0.3, 0)
            }):Play()
        end)
    end
end

-- Player ESP functions
local function createESP(targetPlayer)
    if playerESP[targetPlayer] then return end
    
    local character = targetPlayer.Character
    if not character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_"..targetPlayer.Name
    highlight.Adornee = character
    highlight.FillColor = targetPlayer.Team and targetPlayer.Team.Color or Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
    playerESP[targetPlayer] = highlight
end

local function removeESP(targetPlayer)
    if not playerESP[targetPlayer] then return end
    
    playerESP[targetPlayer]:Destroy()
    playerESP[targetPlayer] = nil
end

local function toggleESP(targetPlayer)
    if playerESP[targetPlayer] then
        removeESP(targetPlayer)
        ESPPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        createESP(targetPlayer)
        ESPPlayerBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end

-- Player Tracer functions
local function createTracer(targetPlayer)
    if playerTracers[targetPlayer] then return end
    
    local character = targetPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local tracer = Instance.new("Part")
    tracer.Name = "Tracer_"..targetPlayer.Name
    tracer.Size = Vector3.new(0.1, 0.1, 0.1)
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Transparency = 0.5
    tracer.Color = targetPlayer.Team and targetPlayer.Team.Color or Color3.fromRGB(255, 0, 0)
    tracer.Parent = workspace
    
    local beam = Instance.new("Beam")
    beam.Name = "TracerBeam"
    beam.FaceCamera = true
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.Color = ColorSequence.new(tracer.Color)
    beam.Parent = tracer
    
    -- Connect beam to player and local player
    local localRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if localRoot then
        beam.Attachment0 = Instance.new("Attachment")
        beam.Attachment0.Parent = localRoot
        beam.Attachment1 = Instance.new("Attachment")
        beam.Attachment1.Parent = humanoidRootPart
    end
    
    playerTracers[targetPlayer] = {
        Part = tracer,
        Beam = beam,
        Connection = RunService.Heartbeat:Connect(function()
            if character and humanoidRootPart and humanoidRootPart.Parent then
                tracer.Position = humanoidRootPart.Position
            else
                -- Player probably respawned
                removeTracer(targetPlayer)
                createTracer(targetPlayer)
            end
        end)
    }
end

local function removeTracer(targetPlayer)
    if not playerTracers[targetPlayer] then return end
    
    playerTracers[targetPlayer].Connection:Disconnect()
    playerTracers[targetPlayer].Part:Destroy()
    playerTracers[targetPlayer] = nil
end

local function toggleTracer(targetPlayer)
    if playerTracers[targetPlayer] then
        removeTracer(targetPlayer)
        TracerPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        createTracer(targetPlayer)
        TracerPlayerBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end

-- Loop TP to player
local function toggleLoopTP(targetPlayer)
    loopTP = not loopTP
    
    if loopTP then
        LoopTPPlayerBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        local loopConnection
        loopConnection = RunService.Heartbeat:Connect(function()
            if not loopTP then
                loopConnection:Disconnect()
                return
            end
            
            local targetChar = targetPlayer.Character
            local localChar = player.Character
            
            if targetChar and localChar then
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                local localRoot = localChar:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and localRoot then
                    localRoot.CFrame = targetRoot.CFrame
                end
            end
        end)
    else
        LoopTPPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Teleport to player
local function teleportToPlayer(targetPlayer)
    local targetChar = targetPlayer.Character
    local localChar = player.Character
    
    if targetChar and localChar then
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and localRoot then
            localRoot.CFrame = targetRoot.CFrame
            
            -- Pulse animation on teleport button
            local tweenIn = TweenService:Create(TeleportToPlayerBtn, TweenInfo.new(0.15), {
                TextColor3 = Color3.fromRGB(255, 255, 0)
            })
            
            local tweenOut = TweenService:Create(TeleportToPlayerBtn, TweenInfo.new(0.15), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            })
            
            tweenIn:Play()
            tweenIn.Completed:Connect(function()
                tweenOut:Play()
            end)
        end
    end
end

-- Input handling for map dragging
local function handleInput(input, gameProcessed)
    if gameProcessed or not mapVisible then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if UserInputService:IsMouseOverGUI() then
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
            
            -- Adjust map offset based on drag (scaled by zoom)
            mapOffset = mapOffset + Vector2.new(
                delta.X * (MAP_SIZE / MapContainer.AbsoluteSize.X) * (1/currentZoom),
                delta.Y * (MAP_SIZE / MapContainer.AbsoluteSize.Y) * (1/currentZoom)
            )
        end
    end
end

-- Connect events
ToggleButton.MouseButton1Click:Connect(toggleMap)
CloseButton.MouseButton1Click:Connect(toggleMap)
ZoomInButton.MouseButton1Click:Connect(zoomIn)
ZoomOutButton.MouseButton1Click:Connect(zoomOut)
SetWaypointButton.MouseButton1Click:Connect(setWaypointAtCenter)
TeleportButton.MouseButton1Click:Connect(teleportToWaypoint)
CenterButton.MouseButton1Click:Connect(centerOnPlayer)
TrackerButton.MouseButton1Click:Connect(togglePlayerTracking)

-- Context menu events
TeleportToPlayerBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        teleportToPlayer(selectedPlayer)
    end
end)

ESPPlayerBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        toggleESP(selectedPlayer)
    end
end)

TracerPlayerBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        toggleTracer(selectedPlayer)
    end
end)

LoopTPPlayerBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        toggleLoopTP(selectedPlayer)
    end
end)

CloseContextBtn.MouseButton1Click:Connect(function()
    PlayerContextMenu.Visible = false
end)

UserInputService.InputBegan:Connect(handleInput)
UserInputService.InputChanged:Connect(handleInput)
UserInputService.InputEnded:Connect(handleInput)

-- Close context menu when clicking elsewhere
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and PlayerContextMenu.Visible then
        if not UserInputService:IsMouseOverGUI(PlayerContextMenu) then
            PlayerContextMenu.Visible = false
        end
    end
end)

-- Update loop
RunService.Heartbeat:Connect(function()
    if mapVisible then
        updateCoordinatesDisplay()
        updatePlayerMarkers()
    end
end)

-- Initialize
MainFrame.Visible = false
createGridLines()

-- Add styling
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = CloseButton

local mapCorner = Instance.new("UICorner")
mapCorner.CornerRadius = UDim.new(0, 8)
mapCorner.Parent = MapFrame

local coordCorner = Instance.new("UICorner")
coordCorner.CornerRadius = UDim.new(0, 6)
coordCorner.Parent = CoordinatesDisplay

local controlCorner = Instance.new("UICorner")
controlCorner.CornerRadius = UDim.new(0, 8)
controlCorner.Parent = ControlsFrame

local contextCorner = Instance.new("UICorner")
contextCorner.CornerRadius = UDim.new(0, 8)
contextCorner.Parent = PlayerContextMenu

-- Add shadow effects
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = -1
shadow.Parent = MainFrame

local contextShadow = Instance.new("ImageLabel")
contextShadow.Name = "Shadow"
contextShadow.Size = UDim2.new(1, 10, 1, 10)
contextShadow.Position = UDim2.new(0, -5, 0, -5)
contextShadow.BackgroundTransparency = 1
contextShadow.Image = "rbxassetid://1316045217"
contextShadow.ImageColor3 = Color3.new(0, 0, 0)
contextShadow.ImageTransparency = 0.7
contextShadow.ScaleType = Enum.ScaleType.Slice
contextShadow.SliceCenter = Rect.new(10, 10, 118, 118)
contextShadow.ZIndex = -1
contextShadow.Parent = PlayerContextMenu

print("VIP Map System initialized successfully!")