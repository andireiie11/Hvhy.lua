local function PlayThatBitch()
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "IntroScreen"
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "IntroFrame"
    frame.Parent = screenGui
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = "IntroImage"
    imageLabel.Parent = frame
    imageLabel.Size = UDim2.new(0.1, 0, 0.1, 0)
    imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    imageLabel.Image = "rbxassetid://138783490120589"
    imageLabel.BackgroundTransparency = 1
    imageLabel.ImageTransparency = 1
 
    local aspectConstraint = Instance.new("UIAspectRatioConstraint")
    aspectConstraint.Parent = imageLabel

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = imageLabel
    uiScale.Scale = 1

    local tweenService = game:GetService("TweenService")
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Parent = game.Lighting
    blurEffect.Size = 60

    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeIn = tweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 0})
    local fadeOut = tweenService:Create(imageLabel, tweenInfo, {ImageTransparency = 1})
    local scaleTween = tweenService:Create(uiScale, tweenInfo, {Scale = 3.5})
    local blurTweenInfo = TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local blurTween = tweenService:Create(blurEffect, blurTweenInfo, {Size = 0})

    fadeIn:Play()
    fadeIn.Completed:Wait()

    scaleTween:Play()
    blurTween:Play()

    wait(3)

    fadeOut:Play()
    fadeOut.Completed:Wait()

    blurTween:Play()
    blurTween.Completed:Wait()

    blurEffect:Destroy()
    screenGui:Destroy()
end

PlayThatBitch()

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "Hvhy.wtf | Hood costums",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
    MinSize = Vector2.new(500, 300),
    MaxSize = Vector2.new(500, 300),
    Theme = {
        PrimaryColor = Color3.fromRGB(255, 0, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    }
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Misc = Window:AddTab("Misc"),
    Visuals = Window:AddTab("Visuals"),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local MiscGroupBox = Tabs.Misc:AddLeftGroupbox("Misc stuff")

MiscGroupBox:AddButton("Macro", function()
    local Player = game:GetService("Players").LocalPlayer
    local Mouse = Player:GetMouse()
    local SpeedGlitch = false

    Mouse.KeyDown:Connect(function(Key)
        if Key == "x" then  -- Change your keybind here
            SpeedGlitch = not SpeedGlitch
            if SpeedGlitch == true then
                repeat
                    game:GetService("RunService").Heartbeat:wait()
                    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", true, game)
                    game:GetService("RunService").Heartbeat:wait()
                    game:GetService("VirtualInputManager"):SendMouseWheelEvent("0", "0", false, game)
                    game:GetService("RunService").Heartbeat:wait()
                until SpeedGlitch == false
            end
        end
    end)
end)

MiscGroupBox:AddButton("Zomb anim", function()
    game:GetService("RunService").Stepped:Connect(function()
        local character = game.Players.LocalPlayer.Character.Animate
        character.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=616163682"
        character.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=1083218792"
        character.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=10921148939"
    end)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Utilities = {
    AutoStomp = false
}

-- Add the auto stomp groupbox and toggle
local MiscGroupBox = Tabs.Misc:AddLeftGroupbox("Misc stuff")

MiscGroupBox:AddToggle("AutoStompToggle", {
    Text = "Auto Stomp",
    Default = false,
    Tooltip = "Enable or disable auto stomp",
    Callback = function(value)
        Utilities.AutoStomp = value
    end
})

RunService.Stepped:Connect(function()
    if Utilities.AutoStomp then
        ReplicatedStorage.MainEvent:FireServer("Stomp")
    end
end)

local snowballPickUpEnabled = false

MiscGroupBox:AddToggle("SnowballPickUpToggle", {
    Text = "Snowball Pick Up",
    Default = false,
    Tooltip = "Enable or disable snowball pick up",
    Callback = function(value)
        snowballPickUpEnabled = value
    end
}):AddKeyPicker("SnowballPickUpKeybind", {
    Default = "P",
    Text = "Snowball Pick Up Keybind",
    Mode = "Toggle",
    Tooltip = "Set a custom keybind for snowball pick up",
    Callback = function(key)
        if snowballPickUpEnabled then
            game.ReplicatedStorage.MainEvent:FireServer("DoSnowballInteraction")
        end
    end
})

local danceAnimationId = "rbxassetid://10714340543"
local animationSpeed = 1 -- Default animation speed
local danceTrack = nil -- Store the dance track globally to avoid duplicates

local function setupDanceAnimation(character)
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
    local danceAnimation = Instance.new("Animation")
    danceAnimation.AnimationId = danceAnimationId

    -- Check if the dance track already exists to avoid duplicates
    if not danceTrack then
        danceTrack = animator:LoadAnimation(danceAnimation)
        danceTrack.Priority = Enum.AnimationPriority.Action
        danceTrack.Looped = true
        danceTrack:AdjustSpeed(animationSpeed)
    end

    local function toggleDance(play)
        if play then
            if not danceTrack.IsPlaying then
                danceTrack:Play()
            end
        else
            if danceTrack.IsPlaying then
                danceTrack:Stop()
            end
        end
    end

    MiscGroupBox:AddToggle("DanceAnimation", {
        Text = "Floss",
        Default = false,
        Callback = function(Value)
            toggleDance(Value)
        end
    })

    MiscGroupBox:AddSlider("AnimationSpeed", {
        Text = "Floss speed",
        Default = animationSpeed,
        Min = 0.1,
        Max = 3,
        Rounding = 1,
        Tooltip = "Adjust the speed of the dance animation",
        Callback = function(value)
            animationSpeed = value
            danceTrack:AdjustSpeed(animationSpeed)
        end
    })
end

-- Setup the dance animation for the current character
setupDanceAnimation(LocalPlayer.Character)

-- Ensure the dance animation is set up for new characters after respawn
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    wait(1) -- Wait for the character to fully load
    setupDanceAnimation(newCharacter)
end)

-- No Jump Cooldown Toggle
local JumpPower = 50
local JumpPowerEnabled = false

MiscGroupBox:AddToggle("NoJumpCooldown", {
    Text = "No Jump Cooldown",
    Default = false,
    Tooltip = "Disable jump cooldown",
    Callback = function(value)
        JumpPowerEnabled = value
        if JumpPowerEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = JumpPower
            end
        end
    end
})

local cloneref = getgenv().cloneref or function(...) return ... end

local Game = cloneref(game)

if not Game:IsLoaded() then Game.Loaded:Wait() end

--// Services \\--
local RunService = Game:GetService("RunService")
local Players = Game:GetService("Players")

--// LocalPlayer \\--
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local LocalHumanoid = LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:FindFirstChildWhichIsA("Humanoid") or LocalCharacter:WaitForChild("Humanoid")
local LocalRootPart = LocalHumanoid.RootPart or LocalCharacter:WaitForChild("HumanoidRootPart")

local function setupAntiSit()
    if LocalCharacter and LocalHumanoid and LocalRootPart then
        LocalHumanoid:GetPropertyChangedSignal("Sit"):Connect(function()
            if LocalHumanoid.Sit then
                task.wait(0.01)
                LocalHumanoid.Sit = false
            end
        end)
    end
end

--// LocalPlayer | CharacterAdded \\--
LocalPlayer.CharacterAdded:Connect(function(Character)
    LocalCharacter = Character
    LocalHumanoid = LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:FindFirstChildWhichIsA("Humanoid") or LocalCharacter:WaitForChild("Humanoid")
    LocalRootPart = LocalHumanoid.RootPart or LocalCharacter:WaitForChild("HumanoidRootPart")
    setupAntiSit()
end)

setupAntiSit()

MiscGroupBox:AddToggle("AntiSitToggle", {
    Text = "Anti Sit",
    Default = false,
    Tooltip = "Prevent the player from sitting",
    Callback = function(value)
        if value then
            setupAntiSit()
        else
            -- Disable Anti Sit functionality
            LocalHumanoid:GetPropertyChangedSignal("Sit"):Disconnect()
        end
    end
})

local voidProtectionEnabled = false

local function ToggleVoidProtection(bool)
    if bool then
        game.Workspace.FallenPartsDestroyHeight = 0/0
    else
        game.Workspace.FallenPartsDestroyHeight = -500
    end
end

MiscGroupBox:AddToggle('VoidProtectionToggle', {
    Text = 'Anti Void',
    Default = false,
    Tooltip = 'When enabled, parts will not be destroyed when falling into the void.',
    Callback = function(Value)
        voidProtectionEnabled = Value
        ToggleVoidProtection(voidProtectionEnabled) 
    end
})

local noclip = false
local function toggleNoclip()
    noclip = not noclip
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("MeshPart") or v:IsA("Part") or v:IsA("BasePart") then
            v.CanCollide = not noclip
        end
    end
end

MiscGroupBox:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
    Tooltip = "Enable or disable noclip",
    Callback = function(value)
        noclip = value
        toggleNoclip()
    end
})

-- Variables for the toxic chat feature
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")

local Toxic = {
    "Sit down, skid!",
    "Azure modded alert!",
    "Skid tryna tap me lool",
    "Hvhy on top skids",
    "Pipe down skiddy widdy",
    "Stop skidding ong",
    "Go use Hvhy not azure skidded"
}

local ChatVersion = TextChatService.ChatVersion
local ChatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
local TargetTextChannel = TextChatService.ChatInputBarConfiguration.TargetTextChannel

function sendRandomToxic()
    local message = Toxic[math.random(#Toxic)]
    print("Sending toxic: " .. message)

    if ChatVersion == Enum.ChatVersion.LegacyChatService and ChatEvent then
        ChatEvent.SayMessageRequest:FireServer(message, "All")
    elseif TargetTextChannel then
        TargetTextChannel:SendAsync(message)
    else
        print("Chat system not available.")
    end
end

local toxicConnection
local isToxicChatting = false

function toggleToxicChat(enabled)
    _G.toxicEnabled = enabled

    if _G.toxicEnabled then
        if not toxicConnection then
            toxicConnection = RunService.Heartbeat:Connect(function()
                if isToxicChatting == false then
                    isToxicChatting = true
                    sendRandomToxic()
                    task.wait(0.8)
                    isToxicChatting = false
                end
            end)
        end
    else
        if toxicConnection then
            toxicConnection:Disconnect()
            toxicConnection = nil
        end
    end
end

MiscGroupBox:AddToggle('MyToggle', {
    Text = 'Trash talk',
    Default = false,
    Tooltip = 'Sends best lines',
    Callback = toggleToxicChat
})

RunService.Stepped:Connect(function()
    if antiStompEnabled then
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health < 3 then
                player.Character.Humanoid.Health = 0
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if JumpPowerEnabled then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.JumpPower ~= JumpPower then
            humanoid.JumpPower = JumpPower
        end
    end
end)

local SpeedController = {
    localPlayer = game:GetService("Players").LocalPlayer,
    Cmultiplier = 1,
    isSpeedActive = false,
    isFunctionalityEnabled = false,
}

local LeftGroupBox = Tabs.Misc:AddRightGroupbox('Movement')

local SpeedController = {
    localPlayer = game:GetService("Players").LocalPlayer,
    Cmultiplier = 1,
    isSpeedActive = false,
    isFunctionalityEnabled = false,
}

LeftGroupBox:AddToggle("functionalityEnabled", {
    Text = "Enable/Disable Speed",
    Default = false,
    Tooltip = "Enable or disable the speed thingy.",
    Callback = function(value)
        SpeedController.isFunctionalityEnabled = value
    end
})

LeftGroupBox:AddToggle("speedEnabled", {
    Text = "Speed Keybind",
    Default = false,
    Tooltip = "It makes you go fast.",
    Callback = function(value)
        SpeedController.isSpeedActive = value
    end
}):AddKeyPicker("speedToggleKey", {
    Default = "C",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "Speed KeyBind",
    Tooltip = "CFrame keybind.",
    Callback = function(value)
        SpeedController.isSpeedActive = value
    end
})

LeftGroupBox:AddSlider("cframespeed", {
    Text = "CFrame Multiplier",
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Tooltip = "The CFrame speed.",
    Callback = function(value)
        SpeedController.Cmultiplier = value
    end,
})

task.spawn(function()
    while true do
        task.wait()
        
        if SpeedController.isFunctionalityEnabled then
            local character = SpeedController.localPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoid = character:FindFirstChild("Humanoid")
                if SpeedController.isSpeedActive and humanoid and humanoid.MoveDirection.Magnitude > 0 then
                    local moveDirection = humanoid.MoveDirection.Unit
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + moveDirection * SpeedController.Cmultiplier
                end
            end
        end
    end
end)


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Maid = loadstring(game:HttpGet('https://raw.githubusercontent.com/Quenty/NevermoreEngine/main/src/maid/src/Shared/Maid.lua'))()

shared.Maid = shared.Maid or Maid.new()
local Maid = shared.Maid
Maid:DoCleaning()
shared.Active = false  -- Ensure flying is initially disabled

local Ignore = false

local Offset = 4

local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Character = LocalPlayer.Character or LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local CurrentPoint = Character:GetPivot()

local task = table.clone(task)

local OldDelay = task.delay

function task.delay(Time, Function)
    local Enabled = true
    
    OldDelay(Time, function()
        if Enabled then
            Function()
        end
    end)
    
    return {
        Cancel = function()
            Enabled = false
        end,
        Activate = function()
            Enabled = false
            Function()
        end
    }
end
local wait = task.wait

local function StopVelocity()
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end
    
    HumanoidRootPart.Velocity = Vector3.zero
end

Maid:GiveTask(LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
end))

Maid:GiveTask(RunService.Stepped:Connect(function()
    if shared.Active then
        StopVelocity()
        local CameraCFrame = Camera.CFrame
        
        CurrentPoint = CFrame.new(CurrentPoint.Position, CurrentPoint.Position + CameraCFrame.LookVector)
        Character:PivotTo(CurrentPoint)
    end
end))

local CurrentTask = nil

local KeyBindStarted = {
    [Enum.KeyCode.W] = {
        ["FLY_FORWARD"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.W) do
                RunService.Stepped:Wait()
                if Ignore then continue end
                
                CurrentPoint = CurrentPoint * CFrame.new(0, 0, -Offset)
            end
        end
    },
    [Enum.KeyCode.S] = {
        ["FLY_BACK"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.S) do
                RunService.Stepped:Wait()
                if Ignore then continue end
                
                CurrentPoint = CurrentPoint * CFrame.new(0, 0, Offset)
            end
        end
    },
    [Enum.KeyCode.A] = {
        ["FLY_LEFT"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.A) do
                RunService.Stepped:Wait()
                if Ignore then continue end

                CurrentPoint = CurrentPoint * CFrame.new(-Offset, 0, 0)
            end
        end
    },
    [Enum.KeyCode.D] = {
        ["FLY_RIGHT"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.D) do
                RunService.Stepped:Wait()
                if Ignore then continue end
                
                CurrentPoint = CurrentPoint * CFrame.new(Offset, 0, 0)
            end
        end
    }
}

local KeyBindEnded = {
    [Enum.KeyCode.Space] = {
        ["IGNORE_OFF"] = function()
            Ignore = false
        end
    }
}

Maid:GiveTask(UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
    if not GameProcessedEvent then
        if Input.UserInputType == Enum.UserInputType.Keyboard and KeyBindStarted[Input.KeyCode] then
            for _, Function in pairs(KeyBindStarted[Input.KeyCode]) do
                task.spawn(Function)
            end
        elseif KeyBindStarted[Input.UserInputType] then
            for _, Function in pairs(KeyBindStarted[Input.UserInputType]) do
                task.spawn(Function)
            end
        end
    end
end))

Maid:GiveTask(UserInputService.InputEnded:Connect(function(Input, GameProcessedEvent)
    if not GameProcessedEvent then
        if Input.UserInputType == Enum.UserInputType.Keyboard and KeyBindEnded[Input.KeyCode] then
            for _, Function in pairs(KeyBindEnded[Input.KeyCode]) do
                task.spawn(Function)
            end
        elseif KeyBindEnded[Input.UserInputType] then
            for _, Function in pairs(KeyBindEnded[Input.UserInputType]) do
                task.spawn(Function)
            end
        end
    end
end))

local flySettings = {
    enabled = false,
    speed = 30
}

LeftGroupBox:AddToggle("EnableCFrameFly", {
    Text = "Enable/Disable CFrame Fly",
    Default = flySettings.enabled,
    Tooltip = "Enable or disable the CFrame fly functionality.",
    Callback = function(value)
        flySettings.enabled = value
        shared.Active = value
        if value then
            -- Teleport to the same position when flying is turned on
            local character = LocalPlayer.Character
            if character then
                CurrentPoint = character:GetPivot()
            end
        end
    end
})

LeftGroupBox:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = flySettings.speed,
    Min = 30,
    Max = 250,
    Rounding = 0,
    Tooltip = "Adjust the speed of the CFrame fly.",
    Callback = function(value)
        flySettings.speed = value
        Offset = value / 10
    end
})

LeftGroupBox:AddLabel('Keybind'):AddKeyPicker('ToggleFly', {
    Default = 'F',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Toggle Fly',
    Tooltip = 'Key to toggle fly on or off',
    Callback = function(value)
        if flySettings.enabled then
            shared.Active = not shared.Active
            local character = LocalPlayer.Character
            if shared.Active then
                -- Teleport to the same position when flying is turned on
                if character then
                    CurrentPoint = character:GetPivot()
                end
            else
                -- Teleport to the same position when flying is turned off
                if character then
                    character:PivotTo(CurrentPoint)
                end
            end
        end
    end
})

local SpinbotGroupBox = Tabs.Misc:AddRightGroupbox('Spinbot')

getgenv().SpinbotEnabled = false
getgenv().SpinSpeed = 10

local function toggleSpinbot(state)
    if state then
        if not getgenv().SpinConnection then
            getgenv().SpinConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and not getgenv().Flying then
                    LocalPlayer.Character.Humanoid.AutoRotate = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(getgenv().SpinSpeed), 0)
                end
            end)
        end
    else
        if getgenv().SpinConnection then
            getgenv().SpinConnection:Disconnect()
            getgenv().SpinConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.AutoRotate = true
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if getgenv().SpinbotEnabled then
        toggleSpinbot(true)
    end
end)

SpinbotGroupBox:AddToggle('SpinbotToggle', {
    Text = 'Spinbot',
    Default = false,
    Callback = function(state)
        getgenv().SpinbotEnabled = state
        toggleSpinbot(state)
    end,
})

SpinbotGroupBox:AddSlider('SpinSpeedSlider', {
    Text = 'Spin Speed',
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Callback = function(value)
        getgenv().SpinSpeed = value
    end,
})

DesyncBox = Tabs.Misc:AddRightGroupbox("Anti Aim")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

desync_setback = Instance.new("Part")
desync_setback.Name = "Desync Setback"
desync_setback.Parent = workspace
desync_setback.Size = Vector3.new(2, 2, 1)
desync_setback.CanCollide = false
desync_setback.Anchored = true
desync_setback.Transparency = 1

desync = {
    enabled = false,
    mode = "Void",
    teleportPosition = Vector3.new(0, 0, 0),
    old_position = nil,
    voidSpamActive = false,
    toggleEnabled = false
}

function resetCamera()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

function toggleDesync(state)
    desync.enabled = state
    if desync.enabled then
        workspace.CurrentCamera.CameraSubject = desync_setback
        Library:Notify("Desync Enabled '" .. desync.mode .. "' Hvhy.wtf ", 2)
    else
        resetCamera()
        Library:Notify("Desync Disabled '" .. desync.mode .. "' Hvhy.wtf  ", 2)
    end
end

function setDesyncMode(mode)
    desync.mode = mode
end

DesyncBox:AddToggle('DesyncToggle', {
    Text = 'Anti Aim',
    Default = false,
    Callback = function(state)
        desync.toggleEnabled = state
        if not state then
            toggleDesync(false)
        end
    end,
}):AddKeyPicker('DesyncKeybind', {
    Default = 'V',
    Text = 'Desync',
    Mode = 'Toggle',
    Callback = function(state)
        if not desync.toggleEnabled or UserInputService:GetFocusedTextBox() then return end
        toggleDesync(not desync.enabled)
    end,
})

DesyncBox:AddDropdown('DesyncMethodDropdown', {
    Values = {"Destroy Cheaters", "Underground", "Void Spam", "Void"},
    Default = "Void",
    Multi = false,
    Text = 'Method',
    Callback = function(selected)
        setDesyncMode(selected)
    end
})

RunService.Heartbeat:Connect(function()
    if desync.enabled and LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            desync.old_position = rootPart.CFrame

            if desync.mode == "Destroy Cheaters" then
                desync.teleportPosition = Vector3.new(11223344556677889900, 1, 1)

            elseif desync.mode == "Underground" then
                desync.teleportPosition = rootPart.Position - Vector3.new(0, 12, 0)

            elseif desync.mode == "Void Spam" then
                desync.teleportPosition = math.random(1, 2) == 1 and desync.old_position.Position or Vector3.new(
                    math.random(10000, 50000),
                    math.random(10000, 50000),
                    math.random(10000, 50000)
                )

            elseif desync.mode == "Void" then
                desync.teleportPosition = Vector3.new(
                    rootPart.Position.X + math.random(-444444, 444444),
                    rootPart.Position.Y + math.random(-444444, 444444),
                    rootPart.Position.Z + math.random(-44444, 44444)
                )
            end

            if desync.mode ~= "Rotation" then
                rootPart.CFrame = CFrame.new(desync.teleportPosition)
                workspace.CurrentCamera.CameraSubject = desync_setback

                RunService.RenderStepped:Wait()

                desync_setback.CFrame = desync.old_position * CFrame.new(0, rootPart.Size.Y / 2 + 0.5, 0)
                rootPart.CFrame = desync.old_position
            end
        end
    end
end)

local GameData = {
    Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        TweenService = game:GetService("TweenService"),
        CoreGui = game:GetService("CoreGui"),
        ReplicatedStorage = game:GetService("ReplicatedStorage")
    },
    LocalPlayer = game:GetService("Players").LocalPlayer,
    Camera = game.Workspace.CurrentCamera,
    MainEvent = game:GetService("ReplicatedStorage"):FindFirstChild("MainEvent"),
    MousePosUpdate = game:GetService("ReplicatedStorage"):FindFirstChild("MousePosUpdate"),
    OldHealth = {},
    SoundEnabled = false,
    SelectedSound = "rbxassetid://6565371338",
    ElectricEffectEnabled = false,
    ExplosionEffectEnabled = false,
    FireballEffectEnabled = false,
    SparkleEffectEnabled = false
}

local function create_curvy_slash_effect(position)
    if not GameData.ElectricEffectEnabled then return end
    for i = 1, 3 do
        local slash = Instance.new("Part")
        slash.Size = Vector3.new(0.3, math.random(6, 10), 0.3)
        slash.Anchored = true
        slash.CanCollide = false
        slash.Material = Enum.Material.Neon
        slash.Color = Color3.fromRGB(0, 100, 255) -- Electric blue
        slash.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(math.random(-30, 30)), math.rad(math.random(0, 360)), 0)
        slash.Parent = game.Workspace
        
        local curveTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local curveTarget = {CFrame = slash.CFrame * CFrame.Angles(0, math.rad(90), math.rad(math.random(-20, 20)))}
        local transparencyTween = game:GetService("TweenService"):Create(slash, curveTweenInfo, {Transparency = 1, Size = Vector3.new(0.1, slash.Size.Y * 1.5, 0.1)})
        
        local curveTween = game:GetService("TweenService"):Create(slash, curveTweenInfo, curveTarget)
        curveTween:Play()
        curveTween.Completed:Connect(function()
            transparencyTween:Play()
        end)
        
        transparencyTween.Completed:Connect(function()
            slash:Destroy()
        end)
    end
end

local function create_explosion_effect(position)
    if not GameData.ExplosionEffectEnabled then return end
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = 10
    explosion.BlastPressure = 1000
    explosion.DestroyJointRadiusPercent = 0
    explosion.ExplosionType = Enum.ExplosionType.NoCraters
    explosion.Parent = game.Workspace
end

local function create_fireball_effect(position)
    if not GameData.FireballEffectEnabled then return end
    local fireball = Instance.new("Part")
    fireball.Shape = Enum.PartType.Ball
    fireball.Size = Vector3.new(1, 1, 1)
    fireball.Color = Color3.fromRGB(255, 0, 0)
    fireball.Position = position
    fireball.Anchored = true
    fireball.CanCollide = false
    fireball.Material = Enum.Material.SmoothPlastic
    fireball.Parent = game.Workspace
    
    local fire = Instance.new("Fire")
    fire.Size = 10
    fire.Heat = 15
    fire.Parent = fireball
    
    local targetPosition = position + Vector3.new(0, 20, 0) -- Fireball trajectory
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local moveTween = game:GetService("TweenService"):Create(fireball, tweenInfo, {Position = targetPosition})
    
    moveTween:Play()
    moveTween.Completed:Connect(function()
        fireball:Destroy()
    end)
end

local function create_sparkle_effect(position)
    if not GameData.SparkleEffectEnabled then return end
    local sparkle = Instance.new("ParticleEmitter")
    sparkle.Texture = "rbxassetid://2260239096" -- Sparkle texture
    sparkle.Size = NumberSequence.new(0.5, 2)
    sparkle.Lifetime = NumberRange.new(0.5, 1)
    sparkle.Rate = 100
    sparkle.Speed = NumberRange.new(5, 10)
    sparkle.Parent = game.Workspace
    sparkle.Position = position
    wait(1)
    sparkle:Destroy()
end

local function on_hit(targetPlayer, hitPosition)
    if targetPlayer == GameData.LocalPlayer then return end -- Only apply hit effects for other players
    if targetPlayer and targetPlayer.Character and hitPosition then
        create_curvy_slash_effect(hitPosition)
        create_explosion_effect(hitPosition)
        create_fireball_effect(hitPosition)
        create_sparkle_effect(hitPosition)
        
        if GameData.SoundEnabled then
            local sound = Instance.new("Sound")
            sound.SoundId = GameData.SelectedSound
            sound.Volume = 10
            sound.Parent = GameData.LocalPlayer:FindFirstChild("PlayerGui") or GameData.Services.CoreGui
            sound:Play()
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
        end
    end
end

GameData.Services.RunService.RenderStepped:Connect(function()
    for _, player in pairs(GameData.Services.Players:GetPlayers()) do
        if player ~= GameData.LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            if humanoid and head then
                local oldHealth = GameData.OldHealth[player] or humanoid.Health
                if humanoid.Health < oldHealth then
                    local hitPosition = head.Position
                    on_hit(player, hitPosition)
                end
                GameData.OldHealth[player] = humanoid.Health
            end
        end
    end
end)

-- UI Integration
local HitEffectsGroupBox = Tabs.Misc:AddLeftGroupbox("Hit Effects")

HitEffectsGroupBox:AddToggle("HitEffectToggle", {
    Text = "Electric Slash Effect",
    Default = false,
    Tooltip = "Displays a cool animated curvy slash effect when you hit a target.",
    Callback = function(state)
        GameData.ElectricEffectEnabled = state
    end
})

local CamlockGroupBox = Tabs.Main:AddLeftGroupbox("Camlock")

local camlockTable = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    LocalPlayer = game:GetService("Players").LocalPlayer,
    Camera = workspace.CurrentCamera,
    Mouse = game:GetService("Players").LocalPlayer:GetMouse(),
    isLockedOn = false,
    targetPlayer = nil,
    lockEnabled = false,
    aimLockEnabled = false,
    smoothingFactor = 0.1,
    predictionFactor = 0.0,
    bodyPartSelected = "Head",
    teamCheckEnabled = false
}

local function getBodyPart(character, part)
    return character:FindFirstChild(part) and part or "Head"
end

local function isOppositeTeam(player)
    if not camlockTable.teamCheckEnabled then return true end
    return player.Team ~= camlockTable.LocalPlayer.Team
end

local function getNearestPlayerToMouse()
    if not camlockTable.aimLockEnabled then return nil end 
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local mousePosition = camlockTable.Camera:ViewportPointToRay(camlockTable.Mouse.X, camlockTable.Mouse.Y).Origin

    for _, player in pairs(camlockTable.Players:GetPlayers()) do
        if 
            player ~= camlockTable.LocalPlayer 
            and player.Character 
            and player.Character:FindFirstChild(camlockTable.bodyPartSelected) 
            and isOppositeTeam(player)
        then
            local part = player.Character[camlockTable.bodyPartSelected]
            local screenPosition, onScreen = camlockTable.Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(camlockTable.Mouse.X, camlockTable.Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    nearestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return nearestPlayer
end

local function toggleLockOnPlayer()
    if not camlockTable.lockEnabled or not camlockTable.aimLockEnabled then return end

    if camlockTable.isLockedOn then
        camlockTable.isLockedOn = false
        camlockTable.targetPlayer = nil
    else
        camlockTable.targetPlayer = getNearestPlayerToMouse()
        if camlockTable.targetPlayer and camlockTable.targetPlayer.Character then
            local part = getBodyPart(camlockTable.targetPlayer.Character, camlockTable.bodyPartSelected)
            if camlockTable.targetPlayer.Character:FindFirstChild(part) then
                camlockTable.isLockedOn = true
            end
        end
    end
end

camlockTable.RunService.RenderStepped:Connect(function()
    if 
        camlockTable.aimLockEnabled 
        and camlockTable.lockEnabled 
        and camlockTable.isLockedOn 
        and camlockTable.targetPlayer 
        and camlockTable.targetPlayer.Character 
    then
        local partName = getBodyPart(camlockTable.targetPlayer.Character, camlockTable.bodyPartSelected)
        local part = camlockTable.targetPlayer.Character:FindFirstChild(partName)

        if part and camlockTable.targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local predictedPosition = part.Position + (part.AssemblyLinearVelocity * camlockTable.predictionFactor)
            local currentCameraPosition = camlockTable.Camera.CFrame.Position

            camlockTable.Camera.CFrame = CFrame.new(currentCameraPosition, predictedPosition) * CFrame.new(0, 0, camlockTable.smoothingFactor)
        else
            camlockTable.isLockedOn = false
            camlockTable.targetPlayer = nil
        end
    end
end)

CamlockGroupBox:AddToggle("aimLock_Enabled", {
    Text = "Enable/Disable AimLock",
    Default = false,
    Tooltip = "Toggle the AimLock feature on or off.",
    Callback = function(value)
        camlockTable.aimLockEnabled = value
        if not camlockTable.aimLockEnabled then
            camlockTable.lockEnabled = false
            camlockTable.isLockedOn = false
            camlockTable.targetPlayer = nil
        end
    end,
})

CamlockGroupBox:AddToggle("aim_Enabled", {
    Text = "AimLock Keybind",
    Default = false,
    Tooltip = "Toggle AimLock on or off.",
    Callback = function(value)
        camlockTable.lockEnabled = value
        if not camlockTable.lockEnabled then
            camlockTable.isLockedOn = false
            camlockTable.targetPlayer = nil
        end
    end,
}):AddKeyPicker("aim_Enabled_KeyPicker", {
    Default = "Q", 
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "AimLock Key",
    Tooltip = "Key to toggle AimLock",
    Callback = function()
        toggleLockOnPlayer()
    end,
})

CamlockGroupBox:AddSlider("Prediction", {
    Text = "Prediction Factor",
    Default = 0.0,
    Min = 0,
    Max = 0.9,
    Rounding = 3,
    Tooltip = "Adjust prediction for target movement.",
    Callback = function(value)
        camlockTable.predictionFactor = value
    end,
})

CamlockGroupBox:AddInput("Smoothing", {
    Text = "Camera Smoothing",
    Default = "0.1",
    Tooltip = "Adjust camera smoothing factor. Set to 0 for no smoothness.",
    Placeholder = "Enter smoothing value",
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue then
            camlockTable.smoothingFactor = numValue
        end
    end,
})

CamlockGroupBox:AddDropdown("BodyParts", {
    Values = {"Head", "UpperTorso", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg", "LeftUpperArm"},
    Default = "Head",
    Multi = false,
    Text = "Target Body Part",
    Tooltip = "Select which body part to lock onto.",
    Callback = function(value)
        camlockTable.bodyPartSelected = value
    end,
})

CamlockGroupBox:AddToggle("teamCheck", {
    Text = "Team Check",
    Default = false,
    Tooltip = "Only aimlock on players from the opposing team.",
    Callback = function(value)
        camlockTable.teamCheckEnabled = value
    end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local cache = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().ForceHitEnabled = false -- Default: OFF
local TargetPlayer = nil -- Stores the current locked-on player
local repl = ReplicatedStorage
local me = Players.LocalPlayer

-- 🎯 Find Closest Enemy (ForceField Check)
local function findClosestToCursor()
    local ClosestPlayer, SmallestAngle = nil, math.huge
    local MousePos = UserInputService:GetMouseLocation()

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character then
            local Character = Player.Character
            if Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
                if not Character:FindFirstChildOfClass("ForceField") then
                    local Part = Character:FindFirstChild("Head") -- Always aim at Head
                    if Part then
                        local ScreenPos, onScreen = Camera:WorldToViewportPoint(Part.Position)
                        if onScreen then
                            local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                            if Distance < SmallestAngle then
                                ClosestPlayer, SmallestAngle = Player, Distance
                            end
                        end
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

-- 🔦 Apply Highlight to Targeted Player
local function applyHighlight(target)
    -- Check if the target already has a highlight
    if target and target.Character then
        if not target.Character:FindFirstChild("Highlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Parent = target.Character
            highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Blue Highlight
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
        end
    end
end

-- 🔥 Hook Tool Firing with New Argument
local function hookTool(tool)
    if not tool then return end

    tool.Activated:Connect(function()
        if getgenv().ForceHitEnabled and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
            local Headd = TargetPlayer.Character.Head
            local Root = me.Character and me.Character:FindFirstChild("HumanoidRootPart")

            if Root then
                local args = {
                    [1] = "Shoot",
                    [2] = {
                        [1] = {
                            [1] = {
                                ["Instance"] = Headd,
                                ["Normal"] = Root.CFrame.LookVector.unit,
                                ["Position"] = Root.Position
                            }
                        },
                        [2] = {
                            [1] = {
                                ["thePart"] = Headd,
                                ["theOffset"] = CFrame.new(Root.CFrame.LookVector.unit * 0.5)
                            }
                        },
                        [3] = Root.Position + Root.CFrame.LookVector * 10,
                        [4] = Root.Position,
                        [5] = os.clock()
                    }
                }
                repl.MainEvent:FireServer(unpack(args))
            end
        end
    end)
end

-- 🔄 Hook Tools in Backpack & Equipped
local function setupToolConnections()
    for _, tool in pairs(me.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            hookTool(tool)
        end
    end

    me.Backpack.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            hookTool(child)
        end
    end)

    if me.Character then
        local equippedTool = me.Character:FindFirstChildOfClass("Tool")
        if equippedTool then
            hookTool(equippedTool)
        end
    end

    me.CharacterAdded:Connect(function(character)
        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                hookTool(child)
            end
        end)
    end)
end

setupToolConnections() -- Run once at start

-- 🛡 Keep Highlight Even If Target Is Stomped
local function monitorTarget()
    while true do
        if TargetPlayer and TargetPlayer.Character then
            applyHighlight(TargetPlayer) -- Reapply highlight if removed
        end
        wait(1) -- Check every second
    end
end

spawn(monitorTarget) -- Run in separate thread

-- Add the key picker to the Force Hit section
local MainGroupBox = Tabs.Main:AddRightGroupbox("Force Hit")

MainGroupBox:AddToggle("ForceHitToggle", {
    Text = "Force Hit",
    Default = false,
    Tooltip = "Enable or disable Force Hit",
    Callback = function(value)
        getgenv().ForceHitEnabled = value
        if getgenv().ForceHitEnabled then
            TargetPlayer = findClosestToCursor()
            if TargetPlayer then
                applyHighlight(TargetPlayer)
            end
        else
            TargetPlayer = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end
        end
    end
}):AddKeyPicker("ForceHitKeybind", {
    Default = "E",
    Text = "Force Hit Keybind",
    Mode = "Toggle",
    Tooltip = "Set a custom keybind for Force Hit",
    Callback = function(key)
        getgenv().ForceHitEnabled = not getgenv().ForceHitEnabled
        if getgenv().ForceHitEnabled then
            TargetPlayer = findClosestToCursor()
            if TargetPlayer then
                applyHighlight(TargetPlayer)
            end
        else
            TargetPlayer = nil
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local speaker = Players.LocalPlayer
local bringT = {}

local toggle = false

function getClosestPlayerToMouse()
    local mouse = speaker:GetMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= speaker and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = player.Character.HumanoidRootPart.Position
            local mousePosition = Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z)
            local distance = (playerPosition - mousePosition).magnitude

            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart")
end

function isNumber(val)
    return tonumber(val) ~= nil
end

function FindInTable(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

local function toggleBring()
    if not toggle then
        bringT = {} -- Clear the bring table when disabled
        return
    end

    local target = getClosestPlayerToMouse()
    if target and not FindInTable(bringT, target.Name) then
        table.insert(bringT, target.Name)

        task.spawn(function()
            local plrName = target.Name
            local pchar = target.Character
            local distance = 6
            local lDelay = 0

            repeat
                if Players:FindFirstChild(plrName) then
                    pchar = Players[plrName].Character
                    if pchar and getRoot(pchar) and speaker.Character and getRoot(speaker.Character) then
                        getRoot(pchar).CFrame = getRoot(speaker.Character).CFrame + Vector3.new(distance, 1, 0)
                    end
                    task.wait(lDelay)
                else
                    for i, b in ipairs(bringT) do
                        if b == plrName then
                            table.remove(bringT, i)
                        end
                    end
                end
            until not toggle or not FindInTable(bringT, plrName)
        end)
    end
end

MainGroupBox:AddToggle("DbSniperToggle", {
    Text = "Enable Db Sniper",
    Default = false,
    Tooltip = "Enable or disable Db Sniper functionality",
    Callback = function(value)
        toggle = value
        if not toggle then
            bringT = {} -- Clear the bring table when disabled
        end
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.C and not gameProcessed then
        toggle = not toggle
        if toggle then
            toggleBring()
        else
            bringT = {} -- Clear the bring table when disabled
        end
    end
end)

MainGroupBox:AddLabel("Press C to enable Db Sniper")

local TwoTapGroupBox = Tabs.Main:AddRightGroupbox("2 Tap Method")

TwoTapGroupBox:AddToggle("TwoTapToggle", {
    Text = "2 Tap (put hitpart to head)",
    Default = false,
    Tooltip = "Enable or disable 2 Tap method",
    Callback = function(value)
        if value then
            while true do
                for Index, Child in ipairs(game:GetService("Players"):GetPlayers()) do
                    if Child.UserId == game:GetService("Players").LocalPlayer.UserId then continue end
                    local Character = Child.Character or Child.CharacterAdded:Wait()

                    if Character then
                        Child:ClearCharacterAppearance()
                    end
                end
                wait(2)
            end
        end
    end
})

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind'
})

MenuGroup:AddToggle('KeybindListToggle', {
    Text = 'Show Keybind List',
    Default = false,
    Callback = function(state)
        Library.KeybindFrame.Visible = state
    end
})

MenuGroup:AddButton('Rejoin Server', function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)

Library:SetWatermarkVisibility(true)

local StatsService = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local StartTime = tick()

local function getExecutor()
    if syn then return "Synapse X"
    elseif secure_call then return "ScriptWare"
    elseif identifyexecutor then return identifyexecutor()
    else return "Unknown" end
end

local function getGameName(placeId)
    local success, result = pcall(function()
        return MarketplaceService:GetProductInfo(placeId).Name
    end)
    return success and result or "Unknown Game"
end

local WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    local Ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
    local Executor = getExecutor()
    local Uptime = math.floor(tick() - StartTime)
    local UptimeFormatted = string.format("%02d:%02d", math.floor(Uptime / 60), Uptime % 60)
    local GameName = getGameName(game.PlaceId)

    Library:SetWatermark(("| Hvhy.wtf |  %s | %s (%d) | Uptime: %s | FPS %d | %d ms"):format(
        Executor, GameName, game.PlaceId, UptimeFormatted, math.floor(FPS), Ping
    ))
end)

local Options = Options or {}
Options.MenuKeybind = Options.MenuKeybind or {}

Library.ToggleKeybind = Options.MenuKeybind 

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()


local Toggles = Toggles or {}
local Options = Options or {}

local ESPGroupBox = Tabs.Visuals:AddRightGroupbox('ESP Settings')

local espSettings = {
    showBox = false,
    showChams = false,
    showHealthBar = false,
    showDistance = false,
    showName = false,
    showTracers = false,
    tracerPosition = "Mouse",
    tracerThickness = 1
}

ESPGroupBox:AddToggle('ShowBox', {
    Text = 'Show Box',
    Default = espSettings.showBox,
    Tooltip = 'Show or hide a box around players.',
    Callback = function(value)
        espSettings.showBox = value
    end
})

-- Add tracer functionality
ESPGroupBox:AddToggle('ShowTracers', {
    Text = 'Show Tracers',
    Default = false,
    Tooltip = 'Show or hide tracers to players.',
    Callback = function(value)
        espSettings.showTracers = value
    end
})

ESPGroupBox:AddDropdown('TracerPosition', {
    Values = { 'Mouse', 'Center', 'Bottom' },
    Default = 1,
    Multi = false,
    Text = 'Tracer Position',
    Tooltip = 'Select the starting position of the tracers.',
    Callback = function(value)
        espSettings.tracerPosition = value
    end
})

ESPGroupBox:AddSlider('TracerThickness', {
    Text = 'Tracer Thickness',
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Tooltip = 'Adjust the thickness of the tracers.',
    Callback = function(value)
        espSettings.tracerThickness = value
    end
})

ESPGroupBox:AddToggle('ShowChams', {
    Text = 'Show Chams',
    Default = espSettings.showChams,
    Tooltip = 'Show or hide body chams around players.',
    Callback = function(value)
        espSettings.showChams = value
    end
})

ESPGroupBox:AddToggle('ShowHealthBar', {
    Text = 'Show Health Bar',
    Default = espSettings.showHealthBar,
    Tooltip = 'Show or hide the health bar of players.',
    Callback = function(value)
        espSettings.showHealthBar = value
    end
})

ESPGroupBox:AddToggle('ShowName', {
    Text = 'Show Name',
    Default = espSettings.showName,
    Tooltip = 'Show or hide the name of players.',
    Callback = function(value)
        espSettings.showName = value
    end
})

ESPGroupBox:AddToggle('ShowDistance', {
    Text = 'Show Distance',
    Default = espSettings.showDistance,
    Tooltip = 'Show or hide the distance to players.',
    Callback = function(value)
        espSettings.showDistance = value
    end
})

--// Universal Box ESP (Works on Arsenal and other games)

-- settings
local settings = {
defaultcolor = Color3.fromRGB(255,0,0),
teamcheck = false,
teamcolor = true
};

-- services
local runService = game:GetService("RunService");
local players = game:GetService("Players");

-- variables
local localPlayer = players.LocalPlayer;
local camera = workspace.CurrentCamera;

-- functions
local newVector2, newColor3, newDrawing = Vector2.new, Color3.new, Drawing.new;
local tan, rad = math.tan, math.rad;
local round = function(...) local a = {}; for i,v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end;
local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end;

local espCache = {};
local function createEsp(player)
local drawings = {};

drawings.box = newDrawing("Square");
drawings.box.Thickness = 1;
drawings.box.Filled = false;
drawings.box.Color = settings.defaultcolor;
drawings.box.Visible = false;
drawings.box.ZIndex = 2;

drawings.boxoutline = newDrawing("Square");
drawings.boxoutline.Thickness = 3;
drawings.boxoutline.Filled = false;
drawings.boxoutline.Color = newColor3();
drawings.boxoutline.Visible = false;
drawings.boxoutline.ZIndex = 1;

drawings.healthBar = newDrawing("Line");
drawings.healthBar.Thickness = 2;
drawings.healthBar.Color = Color3.fromRGB(0, 255, 0);
drawings.healthBar.Visible = false;
drawings.healthBar.ZIndex = 2;

drawings.name = newDrawing("Text");
drawings.name.Size = 13;
drawings.name.Color = Color3.fromRGB(255, 255, 255);
drawings.name.Outline = true;
drawings.name.Center = true;
drawings.name.Visible = false;
drawings.name.ZIndex = 2;

drawings.distance = newDrawing("Text");
drawings.distance.Size = 13;
drawings.distance.Color = Color3.fromRGB(255, 255, 255);
drawings.distance.Outline = true;
drawings.distance.Center = true;
drawings.distance.Visible = false;
drawings.distance.ZIndex = 2;

drawings.chams = Instance.new("Highlight");
drawings.chams.FillColor = settings.defaultcolor;
drawings.chams.OutlineColor = Color3.new(0, 0, 0);
drawings.chams.FillTransparency = 0.5;
drawings.chams.OutlineTransparency = 0;
drawings.chams.Enabled = false;
drawings.chams.Parent = player.Character;

drawings.tracer = newDrawing("Line");
drawings.tracer.Thickness = espSettings.tracerThickness;
drawings.tracer.Color = settings.defaultcolor;
drawings.tracer.Visible = false;
drawings.tracer.ZIndex = 2;

espCache[player] = drawings;
end

local function removeEsp(player)
if rawget(espCache, player) then
    for _, drawing in next, espCache[player] do
        drawing:Remove();
    end
    espCache[player] = nil;
end
end

local function updateEsp(player, esp)
    local character = player and player.Character
    if character then
        local cframe = character:GetModelCFrame()
        local position, visible, depth = wtvp(cframe.Position)
        esp.box.Visible = visible and espSettings.showBox
        esp.boxoutline.Visible = visible and espSettings.showBox
        esp.healthBar.Visible = visible and espSettings.showHealthBar
        esp.name.Visible = visible and espSettings.showName
        esp.distance.Visible = visible and espSettings.showDistance
        esp.chams.Enabled = visible and espSettings.showChams
        esp.tracer.Visible = visible and espSettings.showTracers

        if cframe and visible then
            local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000
            local width, height = round(4 * scaleFactor, 5 * scaleFactor)
            local x, y = round(position.X, position.Y)

            esp.box.Size = newVector2(width, height)
            esp.box.Position = newVector2(round(x - width / 2, y - height / 2))
            esp.box.Color = settings.teamcolor and player.TeamColor.Color or settings.defaultcolor

            esp.boxoutline.Size = esp.box.Size
            esp.boxoutline.Position = esp.box.Position

            local health = character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").Health or 0
            local maxHealth = character:FindFirstChildOfClass("Humanoid") and character:FindFirstChildOfClass("Humanoid").MaxHealth or 100
            local healthPercent = health / maxHealth
            esp.healthBar.From = newVector2(x - width / 2 - 5, y - height / 2 + height * (1 - healthPercent))
            esp.healthBar.To = newVector2(x - width / 2 - 5, y + height / 2)

            local textSize = math.clamp(16 / (depth / 100), 8, 16) -- Adjust text size based on distance
            esp.name.Text = player.Name
            esp.name.Position = newVector2(x, y - height / 2 - 15)
            esp.name.Size = textSize

            esp.distance.Text = string.format("%.1f", depth)
            esp.distance.Position = newVector2(x, y + height / 2 + 15)
            esp.distance.Size = textSize

            -- Update chams color based on health
            esp.chams.FillColor = Color3.fromRGB(255 * (1 - healthPercent), 0, 0)

            -- Update tracer
            local tracerFrom
            if espSettings.tracerPosition == "Mouse" then
                tracerFrom = Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)
            elseif espSettings.tracerPosition == "Center" then
                tracerFrom = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            else
                tracerFrom = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
            end
            esp.tracer.From = tracerFrom
            esp.tracer.To = Vector2.new(x, y)
            esp.tracer.Color = settings.teamcolor and player.TeamColor.Color or settings.defaultcolor
            esp.tracer.Thickness = espSettings.tracerThickness
        end
    else
        esp.box.Visible = false
        esp.boxoutline.Visible = false
        esp.healthBar.Visible = false
        esp.name.Visible = false
        esp.distance.Visible = false
        esp.chams.Enabled = false
        esp.tracer.Visible = false
    end
end

-- main
for _, player in next, players:GetPlayers() do
if player ~= localPlayer then
    createEsp(player);
end
end

players.PlayerAdded:Connect(function(player)
createEsp(player);
end);

players.PlayerRemoving:Connect(function(player)
removeEsp(player);
end)

runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
for player, drawings in next, espCache do
    if settings.teamcheck and player.Team == localPlayer.Team then
        continue;
    end

    if drawings and player ~= localPlayer then
        updateEsp(player, drawings);
    end
end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Auras = Tabs.Visuals:AddRightGroupbox("Self")
utility = utility or {}

local Settings = {
    Visuals = {
        SelfESP = {
            Trail = {
                Color = Color3.fromRGB(255, 110, 0),
                Color2 = Color3.fromRGB(255, 0, 0), -- Second color for gradient
                LifeTime = 1.6,
                Width = 0.1
            },
            Aura = {
                Color = Color3.fromRGB(152, 0, 252)
            }
        }
    }
}

utility.trail_character = function(Bool)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if Bool then
        if not humanoidRootPart:FindFirstChild("BlaBla") then
            local BlaBla = Instance.new("Trail", humanoidRootPart)
            BlaBla.Name = "BlaBla"
            humanoidRootPart.Material = Enum.Material.Neon

            local attachment0 = Instance.new("Attachment", humanoidRootPart)
            attachment0.Position = Vector3.new(0, 1, 0)

            local attachment1 = Instance.new("Attachment", humanoidRootPart)
            attachment1.Position = Vector3.new(0, -1, 0)

            BlaBla.Attachment0 = attachment0
            BlaBla.Attachment1 = attachment1
            BlaBla.Color = ColorSequence.new(Settings.Visuals.SelfESP.Trail.Color, Settings.Visuals.SelfESP.Trail.Color2) -- Gradient effect
            BlaBla.Lifetime = Settings.Visuals.SelfESP.Trail.LifeTime
            BlaBla.Transparency = NumberSequence.new(0, 0)
            BlaBla.LightEmission = 0.2
            BlaBla.Brightness = 10
            BlaBla.WidthScale = NumberSequence.new{
                NumberSequenceKeypoint.new(0, Settings.Visuals.SelfESP.Trail.Width),
                NumberSequenceKeypoint.new(1, 0)
            }
        end
    else
        for _, child in ipairs(humanoidRootPart:GetChildren()) do
            if child:IsA("Trail") and child.Name == 'BlaBla' then
                child:Destroy()
            end
        end
    end
end

local function onCharacterAdded(character)
    if getgenv().trailEnabled then
        utility.trail_character(true)
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

Auras:AddToggle("TrailToggle", {
    Text = "Trail",
    Default = false,
    Callback = function(state)
        getgenv().trailEnabled = state
        utility.trail_character(state)
    end
}):AddColorPicker("TrailColor", {
    Text = "Trail Color",
    Default = Settings.Visuals.SelfESP.Trail.Color,
    Callback = function(color)
        Settings.Visuals.SelfESP.Trail.Color = color
        if getgenv().trailEnabled then
            utility.trail_character(false)
            utility.trail_character(true)
        end
    end
}):AddColorPicker("TrailColor2", {
    Text = "Trail Color 2",
    Default = Settings.Visuals.SelfESP.Trail.Color2,
    Callback = function(color)
        Settings.Visuals.SelfESP.Trail.Color2 = color
        if getgenv().trailEnabled then
            utility.trail_character(false)
            utility.trail_character(true)
        end
    end
})

Auras:AddSlider("TrailLifetime", {
    Text = "Trail Lifetime",
    Default = 1.6,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Callback = function(value)
        Settings.Visuals.SelfESP.Trail.LifeTime = value
        if getgenv().trailEnabled then
            utility.trail_character(false)
            utility.trail_character(true)
        end
    end
})

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait() -- Wait for the character if not loaded

local ForcefieldSettings = {
    Color = Color3.fromRGB(255, 255, 255)
}

local function ApplyForcefield(Char)
    for _, Item in ipairs(Char:GetDescendants()) do
        if Item:IsA("BasePart") or Item:IsA("MeshPart") then
            -- Apply forcefield material and color
            Item.Material = Enum.Material.ForceField
            Item.Color = ForcefieldSettings.Color
        end
    end
end

local function RemoveForcefield(Char)
    for _, Item in ipairs(Char:GetDescendants()) do
        if Item:IsA("BasePart") or Item:IsA("MeshPart") then
            -- Reset material and color
            Item.Material = Enum.Material.Plastic
            Item.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end

local forcefieldEnabled = false

Auras:AddToggle('ForcefieldToggle', {
    Text = 'Forcefield Material',
    Default = false,
    Tooltip = 'Enable or disable forcefield material on your character.',
    Callback = function(value)
        forcefieldEnabled = value
        if forcefieldEnabled then
            ApplyForcefield(Character)
        else
            RemoveForcefield(Character)
        end
    end
})

local HitEffectModule = {
    Locals = {
        HitEffect = {
            Type = {}
        }
    }
}

local Attachment = Instance.new("Attachment")
HitEffectModule.Locals.HitEffect.Type["Skibidi RedRizz"] = Attachment
local swirl = Instance.new("ParticleEmitter", Attachment)
swirl.Name = "swirl"
swirl.Lifetime = NumberRange.new(2)
swirl.SpreadAngle = Vector2.new(-360, 360)
swirl.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.5), NumberSequenceKeypoint.new(1, 1)})
swirl.LightEmission = 10
swirl.Color = ColorSequence.new(Settings.Visuals.SelfESP.Aura.Color)
swirl.VelocitySpread = -360
swirl.Squash = NumberSequence.new(0)
swirl.Speed = NumberRange.new(0.01)
swirl.Size = NumberSequence.new(7)
swirl.ZOffset = -1
swirl.ShapeInOut = Enum.ParticleEmitterShapeInOut.InAndOut
swirl.Rate = 40
swirl.LockedToPart = true
swirl.Texture = "rbxassetid://10558425570"
swirl.RotSpeed = NumberRange.new(200)
swirl.Orientation = Enum.ParticleOrientation.VelocityPerpendicular

local Bolts = Instance.new("ParticleEmitter", Attachment)
Bolts.Name = "Bolts"
Bolts.Lifetime = NumberRange.new(0.333)
Bolts.LockedToPart = true
Bolts.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.88), NumberSequenceKeypoint.new(0.055, 0.98),
    NumberSequenceKeypoint.new(0.111, 0.17), NumberSequenceKeypoint.new(0.166, 0.39),
    NumberSequenceKeypoint.new(0.222, 0.12), NumberSequenceKeypoint.new(0.277, 0.92),
    NumberSequenceKeypoint.new(0.333, 0.41), NumberSequenceKeypoint.new(0.388, 0.21),
    NumberSequenceKeypoint.new(0.444, 0.78), NumberSequenceKeypoint.new(0.499, 0.23),
    NumberSequenceKeypoint.new(0.555, 0.78), NumberSequenceKeypoint.new(0.610, 0.81),
    NumberSequenceKeypoint.new(0.666, 0.91), NumberSequenceKeypoint.new(0.721, 0.87),
    NumberSequenceKeypoint.new(0.777, 0.41), NumberSequenceKeypoint.new(0.832, 0.30),
    NumberSequenceKeypoint.new(0.888, 0.16), NumberSequenceKeypoint.new(0.943, 0.39),
    NumberSequenceKeypoint.new(0.999, 0.70), NumberSequenceKeypoint.new(1, 1)
})
Bolts.LightEmission = 1
Bolts.Color = ColorSequence.new(Settings.Visuals.SelfESP.Aura.Color)
Bolts.Speed = NumberRange.new(0)
Bolts.Size = NumberSequence.new(4.8)
Bolts.Rate = 12
Bolts.Texture = "rbxassetid://1084955012"
Bolts.Rotation = NumberRange.new(-180, 180)

local Bubble = Instance.new("ParticleEmitter", Attachment)
Bubble.Name = "Bubble"
Bubble.Lifetime = NumberRange.new(1)
Bubble.LockedToPart = true
Bubble.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(1, 1)})
Bubble.LightEmission = 1
Bubble.Color = ColorSequence.new(Settings.Visuals.SelfESP.Aura.Color)
Bubble.Speed = NumberRange.new(0)
Bubble.Size = NumberSequence.new(4)
Bubble.Rate = 6
Bubble.Texture = "rbxassetid://1084955488"
Bubble.Rotation = NumberRange.new(-180, 180)

local function applyAura(auraName)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    Attachment.Parent = humanoidRootPart

    if getgenv().auraEnabled then
        swirl.Enabled = auraName == "Wind"
        Bolts.Enabled = auraName == "Bolts"
        Bubble.Enabled = auraName == "Bubble"
        humanoidRootPart.Material = Enum.Material.Neon
    else
        swirl.Enabled = false
        Bolts.Enabled = false
        Bubble.Enabled = false
    end
end

local function onCharacterAdded(character)
    if getgenv().auraEnabled then
        applyAura(getgenv().selectedAura or "Skibidi RedRizz")
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

Auras:AddToggle("AuraToggle", {
    Text = "Auras",
    Default = false,
    Callback = function(state)
        getgenv().auraEnabled = state
        applyAura(getgenv().selectedAura or "Skibidi RedRizz")
    end
}):AddColorPicker("AuraColor", {
    Text = "Aura Color",
    Default = Settings.Visuals.SelfESP.Aura.Color,
    Callback = function(color)
        Settings.Visuals.SelfESP.Aura.Color = color
        swirl.Color = ColorSequence.new(color)
        Bolts.Color = ColorSequence.new(color)
        Bubble.Color = ColorSequence.new(color)
        if getgenv().auraEnabled then
            applyAura(getgenv().selectedAura or "Skibidi RedRizz")
        end
    end
})

Auras:AddDropdown("AuraType", {
    Text = "Select Aura",
    Values = {"Wind", "Bolts", "Bubble"},
    Default = "Bubble",
    Callback = function(selected)
        getgenv().selectedAura = selected
        if getgenv().auraEnabled then
            applyAura(selected)
        end
    end
})

local VisualsGroupBox = Tabs.Visuals:AddLeftGroupbox('Crosshair')

local SPACING, LENGTH, THICK, COLOR, ROT_SPEED = 5, 100, 2, Color3.new(0.066667, 0.160784, 1.000000), 350
local rotate = false
local crosshairPosition = "Mouse"
local crosshairLines = {}
local angle = 0
local crosshairEnabled = false
local showTextBelowCrosshair = false
local crosshairText1 = "hvhy."
local crosshairText2 = "wtf"
local crosshairTextLabel1 = nil
local crosshairTextLabel2 = nil
local crosshairTextSize = 20
local crosshairTextColor1 = Color3.new(1, 1, 1) -- Default white color
local crosshairTextColor2 = Color3.new(0.5, 0, 1) -- Purple color for "cc"

local function createCrosshair()
    if #crosshairLines == 0 then
        crosshairLines = {
            Drawing.new("Line"),
            Drawing.new("Line"),
            Drawing.new("Line"),
            Drawing.new("Line")
        }

        for _, line in next, crosshairLines do
            line.Visible = crosshairEnabled
            line.Thickness = THICK
            line.Color = COLOR
        end
    end

    if not crosshairTextLabel1 then
        crosshairTextLabel1 = Drawing.new("Text")
        crosshairTextLabel1.Visible = false
        crosshairTextLabel1.Color = crosshairTextColor1
        crosshairTextLabel1.Size = crosshairTextSize
        crosshairTextLabel1.Center = true
        crosshairTextLabel1.Outline = true
    end

    if not crosshairTextLabel2 then
        crosshairTextLabel2 = Drawing.new("Text")
        crosshairTextLabel2.Visible = false
        crosshairTextLabel2.Color = crosshairTextColor2
        crosshairTextLabel2.Size = crosshairTextSize
        crosshairTextLabel2.Center = true
        crosshairTextLabel2.Outline = true
    end
end

local function updateCrosshair(dt)
    if not crosshairEnabled then return end

    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
    local screenCenter = Vector2.new(game:GetService("Workspace").CurrentCamera.ViewportSize.X / 2, game:GetService("Workspace").CurrentCamera.ViewportSize.Y / 2)

    if rotate then
        angle = angle + ROT_SPEED * dt
    end

    local rad = math.rad(angle)
    local cosA, sinA = math.cos(rad), math.sin(rad)

    local function rot(x, y)
        return Vector2.new(cosA * x - sinA * y, sinA * x + cosA * y)
    end

    local points = {
        {Vector2.new(0, -LENGTH / 2 - SPACING), Vector2.new(0, -SPACING)},
        {Vector2.new(0, SPACING), Vector2.new(0, LENGTH / 2 + SPACING)},
        {Vector2.new(-LENGTH / 2 - SPACING, 0), Vector2.new(-SPACING, 0)},
        {Vector2.new(SPACING, 0), Vector2.new(LENGTH / 2 + SPACING, 0)}
    }

    for i, line in next, crosshairLines do
        local startPoint = rot(points[i][1].X, points[i][1].Y)
        local endPoint = rot(points[i][2].X, points[i][2].Y)

        if crosshairPosition == "Mouse" then
            line.From = mousePos + startPoint
            line.To = mousePos + endPoint
        elseif crosshairPosition == "Center" then
            line.From = screenCenter + startPoint
            line.To = screenCenter + endPoint
        end
    end

    if showTextBelowCrosshair then
        crosshairTextLabel1.Visible = true
        crosshairTextLabel2.Visible = true
        crosshairTextLabel1.Text = crosshairText1
        crosshairTextLabel2.Text = crosshairText2
        crosshairTextLabel1.Size = crosshairTextSize
        crosshairTextLabel2.Size = crosshairTextSize
        if crosshairPosition == "Mouse" then
            crosshairTextLabel1.Position = mousePos + Vector2.new(-20, LENGTH / 2 + SPACING + 20)
            crosshairTextLabel2.Position = mousePos + Vector2.new(59, LENGTH / 2 + SPACING + 20) -- Slightly to the left
        elseif crosshairPosition == "Center" then
            crosshairTextLabel1.Position = screenCenter + Vector2.new(-20, LENGTH / 2 + SPACING + 20)
            crosshairTextLabel2.Position = screenCenter + Vector2.new(59, LENGTH / 2 + SPACING + 20) -- Slightly to the left
        end
    else
        crosshairTextLabel1.Visible = false
        crosshairTextLabel2.Visible = false
    end
end

VisualsGroupBox:AddToggle('CrosshairToggle', {
    Text = 'Enable Crosshair',
    Default = false,
    Callback = function(Value)
        crosshairEnabled = Value
        if Value then
            createCrosshair()  
            for _, line in next, crosshairLines do
                line.Visible = true 
            end
        else
            for _, line in next, crosshairLines do
                line.Visible = false
            end
            if crosshairTextLabel1 then
                crosshairTextLabel1.Visible = false
            end
            if crosshairTextLabel2 then
                crosshairTextLabel2.Visible = false
            end
        end
    end
}):AddColorPicker('CrosshairColor', {
    Default = Color3.new(0.066667, 0.160784, 1.000000),
    Text = 'Crosshair Color',
    Callback = function(Value)
        COLOR = Value
        for _, line in next, crosshairLines do
            line.Color = COLOR
        end
    end
})

VisualsGroupBox:AddToggle('Rotation', {
    Text = 'Rotation',
    Default = false,
    Callback = function(Value)
        rotate = Value
    end
})

VisualsGroupBox:AddSlider('GapSlider', {
    Text = 'Gap',
    Default = 5,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        SPACING = Value
    end
})

VisualsGroupBox:AddSlider('LengthSlider', {
    Text = 'Length',
    Default = 100,
    Min = 50,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        LENGTH = Value
    end
})

VisualsGroupBox:AddSlider('ThicknessSlider', {
    Text = 'Thickness',
    Default = 2,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        THICK = Value
        for _, line in next, crosshairLines do
            line.Thickness = THICK
        end
    end
})

VisualsGroupBox:AddSlider('RotationSpeedSlider', {
    Text = 'Rotation Speed',
    Default = 350,
    Min = 100,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        ROT_SPEED = Value
    end
})

VisualsGroupBox:AddDropdown('PositionDropdown', {
    Values = { 'Mouse', 'Center' },
    Default = 1,
    Multi = false, 
    Text = 'Position',
    Tooltip = nil,
    Callback = function(Value)
        crosshairPosition = Value
    end
})

VisualsGroupBox:AddToggle('ShowTextBelowCrosshair', {
    Text = 'Show Text Below Crosshair',
    Default = false,
    Callback = function(Value)
        showTextBelowCrosshair = Value
    end
})

RunService.RenderStepped:Connect(function(s)
    updateCrosshair(s)
end)
-- kys nigga

local Workspace, RunService, Players, CoreGui, Lighting = cloneref(game:GetService("Workspace")), cloneref(game:GetService("RunService")), cloneref(game:GetService("Players")), game:GetService("CoreGui"), cloneref(game:GetService("Lighting"))

local Skybox = {
   Default = {"591058823", "591059876", "591058104", "591057861", "591057625", "591059642"},
    Vapor = {"1417494030", "1417494146", "1417494253", "1417494402", "1417494499", "1417494643"},
    Redshift = {"401664839", "401664862", "401664960", "401664881", "401664901", "401664936"},
    Desert = {"1013852", "1013853", "1013850", "1013851", "1013849", "1013854"},
    Minecraft = {"1876545003", "1876544331", "1876542941", "1876543392", "1876543764", "1876544642"},
    SpongeBob = {"7633178166", "7633178166", "7633178166", "7633178166", "7633178166", "7633178166"},
    Blaze = {"150939022", "150939038", "150939047", "150939056", "150939063", "150939082"},
    ["Among Us"] = {"5752463190", "5752463190", "5752463190", "5752463190", "5752463190", "5752463190"},
    ["Space Wave"] = {"16262356578", "16262358026", "16262360469", "16262362003", "16262363873", "16262366016"},
    ["The void"] = {"1233158420", "1233158838", "1233157105", "1233157640", "1233157995", "1233159158"},
    ["Turquoise sky"] = {"47974894", "47974690", "47974821", "47974776", "47974859", "47974909"},
    ["Dark Night"] = {"6285719338", "6285721078", "6285722964", "6285724682", "6285726335", "6285730635"},
    ["Bright Pink"] = {"271042516", "271077243", "271042556", "271042310", "271042467", "271077958"},
}

local function applySkybox(skyboxName)
    local Sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    local skyboxData = Skybox[skyboxName]
    for i, prop in ipairs({"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}) do
        Sky[prop] = "rbxassetid://" .. skyboxData[i]
    end
    Lighting.GlobalShadows = false
end

local skyboxOptions = {}
for skyboxName, _ in pairs(Skybox) do
    table.insert(skyboxOptions, skyboxName)
end

local sldbox = Tabs.Visuals:AddLeftGroupbox("Visuals")

sldbox:AddSlider("world_fog", {
    Text = "Fog Density",
    Default = 0.5, 
    Min = 0, 
    Max = 1, 
    Rounding = 2,
    Tooltip = "Adjust the fog density",
    Callback = function(value)
        game.Lighting.FogEnd = value * 1000 
        game.Lighting.FogStart = value * 500 
    end,
})

sldbox:AddSlider("world_time", {
    Text = "Clock Time",
    Default = 12, 
    Min = 0,
    Max = 24, 
    Rounding = 1,
    Tooltip = "Adjust the time of day",
    Callback = function(value)
        game.Lighting.ClockTime = value 
    end,
})

local camera = game.Workspace.CurrentCamera
local function updateFOV(fovValue)
    camera.FieldOfView = fovValue
end

sldbox:AddSlider("fov_slider", {
    Text = "FOV",
    Default = 70, 
    Min = 30, 
    Max = 120, 
    Rounding = 2,
    Tooltip = "adjust your field of view",
    Callback = updateFOV
})

local skyboxEnabled = false
local selectedSkybox = skyboxOptions[1]

local function toggleSkybox(state)
    skyboxEnabled = state
    if skyboxEnabled then
        applySkybox(selectedSkybox)
    else
        local sky = Lighting:FindFirstChildOfClass("Sky")
        if sky then
            sky:Destroy()
        end
    end
end

sldbox:AddToggle("SkyboxToggle", {
    Text = "Enable Skybox",
    Default = false,
    Tooltip = "Toggle to enable or disable the selected skybox",
    Callback = toggleSkybox
})

sldbox:AddDropdown("SkyboxDropdown", {
    Values = skyboxOptions,
    Default = skyboxOptions[1],
    Multi = false,
    Text = "Skyboxes",
    Tooltip = "Select a skybox",
    Callback = function(selected)
        selectedSkybox = selected
        if skyboxEnabled then
            applySkybox(selectedSkybox)
        end
    end
})

sldbox:AddToggle("Purple Ambience", {
    Text = "Nebula Theme",
    Default = false,
    Tooltip = "Toggle to transform your world into a stunning nebula theme thingy",
    Callback = function(state)
        local lighting = game:GetService("Lighting")
        local StarterGui = game:GetService("StarterGui")

        if state then
            if not _G.AmbienceToggled then
                -- Store original (default) lighting settings
                _G.OriginalLightingSettings = {
                    Ambient = lighting.Ambient,
                    OutdoorAmbient = lighting.OutdoorAmbient,
                    Brightness = lighting.Brightness,
                    ColorShift_Bottom = lighting.ColorShift_Bottom,
                    ColorShift_Top = lighting.ColorShift_Top,
                    FogColor = lighting.FogColor,
                    FogStart = lighting.FogStart,
                    FogEnd = lighting.FogEnd,
                    TimeOfDay = lighting.TimeOfDay,
                }

                -- Apply the altered royal purple lighting settings
                lighting.Ambient = Color3.fromRGB(5, 0, 130) -- Purple ambient
                lighting.OutdoorAmbient = Color3.fromRGB(75, 0, 130) -- Darker purple outdoor ambient
                lighting.Brightness = 4
                lighting.ColorShift_Bottom = Color3.fromRGB(50, 0, 100)
                lighting.ColorShift_Top = Color3.fromRGB(100, 0, 150)
                lighting.FogColor = Color3.fromRGB(100, 0, 150)
                lighting.FogStart = 0
                lighting.FogEnd = 380
                lighting.TimeOfDay = "15:00:00" -- Set time to 3:00 PM (afternoon)

                -- Ensure the sun is not removed
                if not lighting:FindFirstChildOfClass("SunRaysEffect") then
                    local sunRays = Instance.new("SunRaysEffect")
                    sunRays.Parent = lighting
                end

                -- Set the flag to indicate that the lighting has been altered
                _G.AmbienceToggled = true
            end
        else
            -- Reset the lighting back to the original settings
            lighting.Ambient = _G.OriginalLightingSettings.Ambient
            lighting.OutdoorAmbient = _G.OriginalLightingSettings.OutdoorAmbient
            lighting.Brightness = _G.OriginalLightingSettings.Brightness
            lighting.ColorShift_Bottom = _G.OriginalLightingSettings.ColorShift_Bottom
            lighting.ColorShift_Top = _G.OriginalLightingSettings.ColorShift_Top
            lighting.FogColor = _G.OriginalLightingSettings.FogColor
            lighting.FogStart = _G.OriginalLightingSettings.FogStart
            lighting.FogEnd = _G.OriginalLightingSettings.FogEnd
            lighting.TimeOfDay = _G.OriginalLightingSettings.TimeOfDay

            -- Reset skybox to default (if it exists)
            local sky = lighting:FindFirstChildOfClass("Sky")
            if sky then
                sky:Destroy()
            end

            -- Reset the flag to indicate the lighting has been restored
            _G.AmbienceToggled = false
        end
    end
})

Library:Notify("enjoy yall be playing on god")



























--nice try skidding lil niggy wiggy