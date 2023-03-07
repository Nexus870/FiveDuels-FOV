local MouseLock = {
    Settings = {
        Enabled = false,
        Key = 't',
        Prediction = 0.220,
        AimPart = 'Head'
    }
}
 
local CurrentCamera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local Mouse = game.Players.LocalPlayer:GetMouse()
local Plr
 
function FindClosestPlayer()
    local closestPlayer
    local shortestDistance = math.huge
 
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and
            v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos = CurrentCamera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            if magnitude < shortestDistance then
                closestPlayer = v
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end
 
Mouse.KeyDown:Connect(function(KeyPressed)
    if KeyPressed == (MouseLock.Settings.Key) then
        if MouseLock.Settings.Enabled == true then
            MouseLock.Settings.Enabled = false
            Plr = FindClosestPlayer()
        else
            Plr = FindClosestPlayer()
            MouseLock.Settings.Enabled = true
 
        end
    end
end)
 
RunService.Stepped:connect(function()
    if MouseLock.Settings.Enabled == true then
        local Vector = CurrentCamera:WorldToScreenPoint(Plr.Character[MouseLock.Settings.AimPart].Position +
                                                            (Plr.Character[MouseLock.Settings.AimPart].Velocity *
                                                                MouseLock.Settings.Prediction))
        mousemoverel(Vector.X - Mouse.X, Vector.Y - Mouse.Y)
    end
 
end)
 
 
 
 
 
 
--[Main Variables]
 
local plrs = game["Players"]
local rs = game["RunService"]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
 
 
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = workspace.CurrentCamera
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera
local worldToViewportPoint = camera.worldToViewportPoint
local cc = Instance.new("ColorCorrectionEffect", game.Lighting)
local blur = Instance.new("BlurEffect", game.Lighting)
local sun = Instance.new("SunRaysEffect", game.Lighting)
blur.Size = 0
sun.Intensity = 0
 
--[Optimisation Variables]
 
local Drawingnew = Drawing.new
local Color3fromRGB = Color3.fromRGB
local Vector3new = Vector3.new
local Vector2new = Vector2.new
local mathfloor = math.floor
local mathceil = math.ceil
 
--[Setup Table]
 
local esp = {
    players = {},
    enabled = true,
    teamcheck = true,
    fontsize = 16,
    font = 0,
    settings = {
        name = {enabled = true, outline = true, color = Color3fromRGB(255, 255, 255), outlineColor = Color3fromRGB(94, 0, 255)},
        box = {enabled = true, outline = true, color = Color3fromRGB(131, 105, 165), outlineColor = Color3fromRGB(0, 0, 0)},
        healthbar = {enabled = true, outline = true, color = Color3fromRGB(111, 0, 255), outlineColor = Color3fromRGB(0, 0, 0)},
        healthtext = {enabled = true, outline = true, color = Color3fromRGB(255, 255, 255), outlineColor = Color3fromRGB(94, 0, 255)},
        distance = {enabled = true, outline = true, color = Color3fromRGB(255, 255, 255), outlineColor = Color3fromRGB(94, 0, 255)}
    }
}
 
esp.NewDrawing = function(type, properties)
    local newDrawing = Drawingnew(type)
 
    for i,v in next, properties or {} do
        newDrawing[i] = v
    end
 
    return newDrawing
end
 
esp.NewPlayer = function(v)
    esp.players[v] = {
        name = esp.NewDrawing("Text", {Color = Color3fromRGB(94, 0, 255), Outline = true, Center = true, Size = 13, Font = 0}),
        boxOutline = esp.NewDrawing("Square", {Color = Color3fromRGB(0, 0, 0), Thickness = 3}),
        box = esp.NewDrawing("Square", {Color = Color3fromRGB(108, 11, 204), Thickness = 1}),
        healthBarOutline = esp.NewDrawing("Line", {Color = Color3fromRGB(0, 0, 0), Thickness = 3}),
        healthBar = esp.NewDrawing("Line", {Color = Color3fromRGB(255, 255, 255), Thickness = 1}),
        healthText = esp.NewDrawing("Text", {Color = Color3fromRGB(94, 0, 255), Outline = true, Center = true, Size = 13, Font = 0}),
        distance = esp.NewDrawing("Text", {Color = Color3fromRGB(94, 0, 255), Outline = true, Center = true, Size = 13, Font = 0})
    }
end
 
for _,v in ipairs(plrs:GetPlayers()) do
    esp.NewPlayer(v)
end
 
plrs.PlayerAdded:Connect(function(v)
    esp.NewPlayer(v)
end)
 
plrs.PlayerRemoving:Connect(function(v)
    for i,v in pairs(esp.players[v]) do
        v:Remove()
    end
    esp.players[v] = nil
end)
 
local mainLoop = rs.RenderStepped:Connect(function()
    for i,v in pairs(esp.players) do
        if i ~= plr and i.Character and i.Character:FindFirstChild("Humanoid") and i.Character:FindFirstChild("HumanoidRootPart") and i.Character:FindFirstChild("Head") then
            local hum = i.Character.Humanoid
            local hrp = i.Character.HumanoidRootPart
            local head = i.Character.Head
 
            local Vector, onScreen = camera:WorldToViewportPoint(i.Character.HumanoidRootPart.Position)
 
            local Size = (camera:WorldToViewportPoint(hrp.Position - Vector3new(0, 3, 0)).Y - camera:WorldToViewportPoint(hrp.Position + Vector3new(0, 2.6, 0)).Y) / 2
            local BoxSize = Vector2new(mathfloor(Size * 1.5), mathfloor(Size * 1.9))
            local BoxPos = Vector2new(mathfloor(Vector.X - Size * 1.5 / 2), mathfloor(Vector.Y - Size * 1.6 / 2))
 
            local BottomOffset = BoxSize.Y + BoxPos.Y + 1
 
            if onScreen and esp.enabled then
                if esp.settings.name.enabled then
                    v.name.Position = Vector2new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 16)
                    v.name.Outline = esp.settings.name.outline
                    v.name.Text = tostring(i)
                    v.name.Color = esp.settings.name.color
                    v.name.OutlineColor = esp.settings.name.outlineColor
                    v.name.Font = esp.font
                    v.name.Size = esp.fontsize
 
                    v.name.Visible = true
                else
                    v.name.Visible = false
                end
 
                if esp.settings.distance.enabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    v.distance.Position = Vector2new(BoxSize.X / 2 + BoxPos.X, BottomOffset)
                    v.distance.Outline = esp.settings.distance.outline
                    v.distance.Text = "[" .. mathfloor((hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude) .. "m]"
                    v.distance.Color = esp.settings.distance.color
                    v.distance.OutlineColor = esp.settings.distance.outlineColor
                    BottomOffset = BottomOffset + 15
 
                    v.distance.Font = esp.font
                    v.distance.Size = esp.fontsize
 
                    v.distance.Visible = true
                else
                    v.distance.Visible = false
                end
 
                if esp.settings.box.enabled then
                    v.boxOutline.Size = BoxSize
                    v.boxOutline.Position = BoxPos
                    v.boxOutline.Visible = esp.settings.box.outline
                    v.boxOutline.Color = esp.settings.box.outlineColor
 
                    v.box.Size = BoxSize
                    v.box.Position = BoxPos
                    v.box.Color = esp.settings.box.color
                    v.box.Visible = true
                else
                    v.boxOutline.Visible = false
                    v.box.Visible = false
                end
 
                if esp.settings.healthbar.enabled then
                    v.healthBar.From = Vector2new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
                    v.healthBar.To = Vector2new(v.healthBar.From.X, v.healthBar.From.Y - (hum.Health / hum.MaxHealth) * BoxSize.Y)
                    v.healthBar.Color = esp.settings.healthbar.color
                    v.healthBar.Visible = true
 
                    v.healthBarOutline.From = Vector2new(v.healthBar.From.X, BoxPos.Y + BoxSize.Y + 1)
                    v.healthBarOutline.To = Vector2new(v.healthBar.From.X, (v.healthBar.From.Y - 1 * BoxSize.Y) -1)
                    v.healthBarOutline.Color = esp.settings.healthbar.outlineColor
                    v.healthBarOutline.Visible = esp.settings.healthbar.outline
                else
                    v.healthBarOutline.Visible = false
                    v.healthBar.Visible = false
                end
 
                if esp.settings.healthtext.enabled then
                    v.healthText.Text = tostring(mathfloor((hum.Health / hum.MaxHealth) * 100 + 0.5))
                    v.healthText.Position = Vector2new((BoxPos.X - 20), (BoxPos.Y + BoxSize.Y - 1 * BoxSize.Y) -1)
                    v.healthText.Color = esp.settings.healthtext.color
                    v.healthText.OutlineColor = esp.settings.healthtext.outlineColor
                    v.healthText.Outline = esp.settings.healthtext.outline
 
                    v.healthText.Font = esp.font
                    v.healthText.Size = esp.fontsize
 
                    v.healthText.Visible = true
                else
                    v.healthText.Visible = false
                end
 
                if esp.teamcheck then
                    if v.TeamColor ~= plr.TeamColor then
                        v.name.Visible = esp.settings.name.enabled
                        v.box.Visible = esp.settings.box.enabled
                        v.healthBar.Visible = esp.settings.healthbar.enabled
                        v.healthText.Visible = esp.settings.healthtext.enabled
                        v.distance.Visible = esp.settings.distance.enabled
                    else
                        v.name.Visible = false
                        v.boxOutline.Visible = false
                        v.box.Visible = false
                        v.healthBarOutline.Visible = false
                        v.healthBar.Visible = false
                        v.healthText.Visible = false
                        v.distance.Visible = false
                    end
                end
            else
                v.name.Visible = false
                v.boxOutline.Visible = false
                v.box.Visible = false
                v.healthBarOutline.Visible = false
                v.healthBar.Visible = false
                v.healthText.Visible = false
                v.distance.Visible = false
            end
        else
            v.name.Visible = false
            v.boxOutline.Visible = false
            v.box.Visible = false
            v.healthBarOutline.Visible = false
            v.healthBar.Visible = false
            v.healthText.Visible = false
            v.distance.Visible = false
        end
    end
end)
 
getgenv().esp = esp
 
 
 
--.gg/lockers runs you
--Made by sparkyz
 
getgenv().Prediction = 0.15038
getgenv().AimPart = "Head"
getgenv().Key = "T"
getgenv().DisableKey = "P"
 
getgenv().FOV = true
getgenv().ShowFOV = true
getgenv().FOVSize = 55
 
--// Variables (Service)
 
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local WS = game:GetService("Workspace")
local GS = game:GetService("GuiService")
local SG = game:GetService("StarterGui")
 
--// Variables (regular)
 
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera
local GetGuiInset = GS.GetGuiInset
 
local AimlockState = true
local Locked
local Victim
 
local SelectedKey = getgenv().Key
local SelectedDisableKey = getgenv().DisableKey
 
--// Notification function
 
function Notify(tx)
    SG:SetCore("SendNotification", {
        Title = "Cam Lock Enabled | nigger lock",
        Text = tx,
        Duration = 5
    })
end
 
--// Check if aimlock is loaded
 
if getgenv().Loaded == true then
    Notify("Aimlock is already loaded!")
    return
end
 
getgenv().Loaded = true
 
--// FOV Circle
 
local fov = Drawing.new("Circle")
fov.Filled = true
fov.Transparency = 0.2
fov.Thickness = 1
fov.Color = Color3.fromRGB(167, 169, 206)
fov.NumSides = 1000
 
--// Functions
 
function update()
    if getgenv().FOV == true then
        if fov then
            fov.Radius = getgenv().FOVSize * 2
            fov.Visible = getgenv().ShowFOV
            fov.Position = Vector2.new(Mouse.X, Mouse.Y + GetGuiInset(GS).Y)
 
            return fov
        end
    end
end
 
function WTVP(arg)
    return Camera:WorldToViewportPoint(arg)
end
 
function WTSP(arg)
    return Camera.WorldToScreenPoint(Camera, arg)
end
 
function getClosest()
    local closestPlayer
    local shortestDistance = math.huge
 
    for i, v in pairs(game.Players:GetPlayers()) do
        local notKO = v.Character:WaitForChild("BodyEffects")["K.O"].Value ~= true
        local notGrabbed = v.Character:FindFirstChild("GRABBING_COINSTRAINT") == nil
 
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild(getgenv().AimPart) and notKO and notGrabbed then
            local pos = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
 
            if (getgenv().FOV) then
                if (fov.Radius > magnitude and magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            else
                if (magnitude < shortestDistance) then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
    end
    return closestPlayer
end
 
--// Checks if key is down
 
Mouse.KeyDown:Connect(function(k)
    SelectedKey = SelectedKey:lower()
    SelectedDisableKey = SelectedDisableKey:lower()
    if k == SelectedKey then
        if AimlockState == true then
            Locked = not Locked
            if Locked then
                Victim = getClosest()
 
                Notify("Locked onto: "..tostring(Victim.Character.Humanoid.DisplayName))
            else
                if Victim ~= nil then
                    Victim = nil
 
                    Notify("Unlocked!")
                end
            end
        else
            Notify("Aimlock is not enabled!")
        end
    end
    if k == SelectedDisableKey then
        AimlockState = not AimlockState
    end
end)
 
--// Loop update FOV and loop camera lock onto target
 
RS.RenderStepped:Connect(function()
    update()
    if AimlockState == true then
        if Victim ~= nil then
            Camera.CFrame = CFrame.new(Camera.CFrame.p, Victim.Character[getgenv().AimPart].Position + Victim.Character[getgenv().AimPart].Velocity*getgenv().Prediction)
        end
    end
end)
	while wait() do
        if getgenv().AutoPrediction == true then
        local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local split = string.split(pingvalue,'(')
        local ping = tonumber(split[1])
            if ping < 225 then
            getgenv().Prediction = 1.4
        elseif ping < 215 then
            getgenv().Prediction = 1.2
	    elseif ping < 205 then
            getgenv().Prediction = 1.0
	    elseif ping < 190 then
            getgenv().Prediction = 0.10
        elseif ping < 180 then
            getgenv().Prediction = 0.12
	    elseif ping < 170 then
            getgenv().Prediction = 0.15
	    elseif ping < 160 then
            getgenv().Prediction = 0.18
	    elseif ping < 150 then
            getgenv().Prediction = 0.110
        elseif ping < 140 then
            getgenv().Prediction = 0.113
        elseif ping < 130 then
            getgenv().Prediction = 0.116
        elseif ping < 120 then
            getgenv().Prediction = 0.120
        elseif ping < 110 then
            getgenv().Prediction = 0.124
        elseif ping < 105 then
            getgenv().Prediction = 0.127
        elseif ping < 90 then
            getgenv().Prediction = 0.130
        elseif ping < 80 then
            getgenv().Prediction = 0.133
        elseif ping < 70 then
            getgenv().Prediction = 0.136
        elseif ping < 60 then
            getgenv().Prediction = 0.15038
        elseif ping < 50 then
            getgenv().Prediction = 0.15038
        elseif ping < 40 then
            getgenv().Prediction = 0.145
        elseif ping < 30 then
            getgenv().Prediction = 0.155
        elseif ping < 20 then
            getgenv().Prediction = 0.157
        end
        end
	end
 