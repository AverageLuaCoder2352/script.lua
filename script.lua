-- ==============================
-- IMMORTALITY LORD FULL SCRIPT
-- Manual Sword & Separate Wings Animation
-- ==============================

local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rightHand = char:WaitForChild("RightHand")
local upperTorso = char:WaitForChild("UpperTorso")

-- ==============================
-- Sword & Wings (Exact names)
-- ==============================
local sword = char:FindFirstChild("Sword of the Golden God")
local wings = char:FindFirstChild("Wings") or Instance.new("Folder") -- fallback

local leftWing = wings:FindFirstChild("Left Solo Wing Golden Angel Huge Angelic Side Y2K")
local rightWing = wings:FindFirstChild("Right Solo Wing Golden Angel Huge Angelic Side Y2K")

-- ==============================
-- CHAT MESSAGE FUNCTION
-- ==============================
local function say(msg)
    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local channel = TextChatService.TextChannels.RBXGeneral
            if channel then channel:SendAsync(msg) end
        else
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end
    end)
end

-- ==============================
-- UI PANEL
-- ==============================
local function createImmortalityUI()
    local pg = lp:WaitForChild("PlayerGui")
    if pg:FindFirstChild("LordUI") then pg.LordUI:Destroy() end

    local sg = Instance.new("ScreenGui", pg)
    sg.Name = "LordUI"
    sg.ResetOnSpawn = false

    local textLabel = Instance.new("TextLabel", sg)
    textLabel.Size = UDim2.new(0, 450, 0, 60)
    textLabel.Position = UDim2.new(0.5, -225, 0, 50)
    textLabel.BackgroundTransparency = 0.5
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Text = "[Immortality Lord]: ui"
    textLabel.Font = Enum.Font.SpecialElite
    textLabel.TextSize = 28
    textLabel.Visible = false 
    Instance.new("UICorner", textLabel).CornerRadius = UDim.new(0, 12)
    return textLabel
end

local lordLabel = createImmortalityUI()
local function showUI(customText)
    lordLabel.Text = "[Immortality Lord]: " .. (customText or "ui")
    lordLabel.Visible = true
    task.wait(2)
    lordLabel.Visible = false
end

-- ==============================
-- CHAT LISTENER
-- ==============================
game:GetService("TextChatService").OnIncomingMessage = function(message)
    if message.TextSource and message.TextSource.UserId == lp.UserId then
        local words = string.split(message.Text, " ")
        for _, word in ipairs(words) do
            if word ~= "" then
                task.spawn(function() showUI(word) end)
                break 
            end
        end
    end
end

-- ==============================
-- MUSIC
-- ==============================
local driveUrl = "https://drive.google.com/uc?export=download&id=1kas9bAbixOypIPf66pgIgfBS8GZheKTK"
local musicFile = "immortality_final_v5.mp3"

local function playMusic()
    local success, musicData = pcall(function() return game:HttpGet(driveUrl) end)
    if success and #musicData > 1000 then
        writefile(musicFile, musicData)
        local sound = Instance.new("Sound", game:GetService("SoundService"))
        sound.SoundId = getcustomasset(musicFile)
        sound.Volume = 2
        sound.Looped = true
        sound:Play()
    end
end

-- ==============================
-- CONTROLLER
-- ==============================
local function createController()
    local sg = Instance.new("ScreenGui", lp.PlayerGui)
    sg.Name = "ControllerUI"
    sg.ResetOnSpawn = false
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 200, 0, 180)
    frame.Position = UDim2.new(0, 50, 1, -250)
    frame.BackgroundTransparency = 1

    local function createBtn(t, p, k)
        local b = Instance.new("TextButton", frame)
        b.Size = UDim2.new(0, 50, 0, 50)
        b.Position = p
        b.Text = t
        b.BackgroundColor3 = Color3.fromRGB(30,30,30)
        b.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", b)
        b.MouseButton1Down:Connect(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, k, false, game) end)
        b.MouseButton1Up:Connect(function() game:GetService("VirtualInputManager"):SendKeyEvent(false, k, false, game) end)
    end

    createBtn("W", UDim2.new(0, 60, 0, 0), Enum.KeyCode.W)
    createBtn("A", UDim2.new(0, 0, 0, 60), Enum.KeyCode.A)
    createBtn("S", UDim2.new(0, 60, 0, 60), Enum.KeyCode.S)
    createBtn("D", UDim2.new(0, 120, 0, 60), Enum.KeyCode.D)
    createBtn("Z", UDim2.new(0, 0, 0, 120), Enum.KeyCode.Z)
    createBtn("X", UDim2.new(0, 120, 0, 120), Enum.KeyCode.X)
end

-- ==============================
-- MANUAL SWORD & SEPARATE WINGS ANIMATION
-- ==============================
local swordEquipped = false
local leftAngle, rightAngle = 0, 0
local leftDir, rightDir = 1, -1

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F and sword then
        swordEquipped = not swordEquipped
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    -- Sword movement
    if sword then
        if swordEquipped then
            sword.CFrame = rightHand.CFrame * CFrame.new(0,0,0) * CFrame.Angles(0,math.rad(90),0)
        else
            sword.CFrame = upperTorso.CFrame * CFrame.new(0,1,0) * CFrame.Angles(0,math.rad(45),0)
        end
    end

    -- Left Wing
    if leftWing then
        leftAngle = leftAngle + deltaTime * 6 * leftDir
        if leftAngle > 0.5 then leftDir = -1 end
        if leftAngle < -0.5 then leftDir = 1 end
        leftWing.CFrame = upperTorso.CFrame * CFrame.new(leftWing.Position - upperTorso.Position) * CFrame.Angles(math.sin(leftAngle),0,0)
    end

    -- Right Wing
    if rightWing then
        rightAngle = rightAngle + deltaTime * 6 * rightDir
        if rightAngle > 0.5 then rightDir = -1 end
        if rightAngle < -0.5 then rightDir = 1 end
        rightWing.CFrame = upperTorso.CFrame * CFrame.new(rightWing.Position - upperTorso.Position) * CFrame.Angles(math.sin(rightAngle),0,0)
    end
end)

-- ==============================
-- MAIN FLOW
-- ==============================
task.spawn(function()
    say("By EmpressCyc / Golden boi")
    task.wait(1.5)

    -- Example -gh commands
    say("-gh 17796914871 94991868574945 82782532290014")
    task.wait(1)
    say("-gh 4773883146 126812480169504")

    task.wait(6) -- wait accessories to load
    createController()
    task.spawn(playMusic)

    -- Load main executor script
    local scriptUrl = "https://pastebin.com/raw/NqGgGjvD"
    loadstring(game:HttpGet(scriptUrl))()
end)
