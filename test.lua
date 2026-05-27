-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

player.CharacterAdded:Connect(function(char)
	character = char
end)

------------------------------------------------
-- State
------------------------------------------------
local noclip = false
local savedPosition = nil
local page = 1
local open = true
local infiniteJump = false
local friendTouch = false
local saveMarker

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ThunderUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,210,0,160)
frame.Position = UDim2.new(0.05,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

------------------------------------------------
-- TOP BAR
------------------------------------------------
local top = Instance.new("Frame")
top.Parent = frame
top.Size = UDim2.new(1,0,0,25)
top.BackgroundTransparency = 1

local close = Instance.new("TextButton")
close.Parent = top
close.Size = UDim2.new(0,22,0,22)
close.Position = UDim2.new(0,3,0,2)
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.Text = "✖"
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
close.TextSize = 12
Instance.new("UICorner", close).CornerRadius = UDim.new(0,6)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local title = Instance.new("TextLabel")
title.Parent = top
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,28,0,0)
title.BackgroundTransparency = 1
title.Text = "ましゅめろ💫👾⭐️"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

------------------------------------------------
-- Button helper
------------------------------------------------
local function createButton(text, y, color)
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Size = UDim2.new(1,-20,0,32)
	btn.Position = UDim2.new(0,10,0,y)
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.Text = text
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
	return btn
end

------------------------------------------------
-- Buttons
------------------------------------------------
local WallBtn = createButton("壁抜け : OFF",35,Color3.fromRGB(200,60,60))
local SaveBtn = createButton("セーブ",72,Color3.fromRGB(60,120,255))
local TpBtn = createButton("TP",109,Color3.fromRGB(170,85,255))

local JumpBtn = createButton("無限ジャンプ : OFF",35,Color3.fromRGB(255,170,0))
local FriendBtn = createButton("フレンド申請🤝 : OFF",72,Color3.fromRGB(80,170,255))
local LeaveBtn = createButton("ゲームを退出",109,Color3.fromRGB(255,80,80))

JumpBtn.Visible = false
FriendBtn.Visible = false
LeaveBtn.Visible = false

------------------------------------------------
-- Page button
------------------------------------------------
local PageBtn = Instance.new("TextButton")
PageBtn.Parent = frame
PageBtn.Size = UDim2.new(0,70,0,22)
PageBtn.Position = UDim2.new(1,-80,1,-12)
PageBtn.Text = "NEXT ▶"
PageBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
PageBtn.TextColor3 = Color3.new(1,1,1)
PageBtn.Font = Enum.Font.GothamBold
PageBtn.TextSize = 12
Instance.new("UICorner", PageBtn)

------------------------------------------------
-- UI Update
------------------------------------------------
local function updateUI()
	local p2 = (page == 2)

	if not open then
		WallBtn.Visible = false
		SaveBtn.Visible = false
		TpBtn.Visible = false
		JumpBtn.Visible = false
		FriendBtn.Visible = false
		LeaveBtn.Visible = false
		PageBtn.Visible = false
		return
	end

	PageBtn.Visible = true

	WallBtn.Visible = not p2
	SaveBtn.Visible = not p2
	TpBtn.Visible = not p2

	JumpBtn.Visible = p2
	FriendBtn.Visible = p2
	LeaveBtn.Visible = p2
end

------------------------------------------------
-- Page switch
------------------------------------------------
PageBtn.MouseButton1Click:Connect(function()
	page = page + 1

	if page > 3 then
		page = 1
	end

PageBtn.Text = (page == 3) and "◀ BACK" or "NEXT ▶"

	updateUI()
end)


	

------------------------------------------------
-- Wall
------------------------------------------------
WallBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	WallBtn.Text = noclip and "壁抜け : ON" or "壁抜け : OFF"
end)

RunService.Stepped:Connect(function()
	if noclip and character then
		for _,v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

------------------------------------------------
-- Save
------------------------------------------------
SaveBtn.MouseButton1Click:Connect(function()
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	savedPosition = hrp.CFrame

	if saveMarker then saveMarker:Destroy() end

	saveMarker = Instance.new("Part")
	saveMarker.Parent = workspace
	saveMarker.Anchored = true
	saveMarker.CanCollide = false
	saveMarker.Material = Enum.Material.Neon
	saveMarker.Color = Color3.fromRGB(0,170,255)
	saveMarker.Size = Vector3.new(3,3,3)
	saveMarker.CFrame = savedPosition + Vector3.new(0,2,0)
end)

------------------------------------------------
-- TP
------------------------------------------------
TpBtn.MouseButton1Click:Connect(function()
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if savedPosition and hrp then
		hrp.CFrame = savedPosition
	end
end)

------------------------------------------------
-- Infinite Jump
------------------------------------------------
UserInputService.JumpRequest:Connect(function()
	if infiniteJump and character and character:FindFirstChild("Humanoid") then
		character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

JumpBtn.MouseButton1Click:Connect(function()
	infiniteJump = not infiniteJump
	JumpBtn.Text = infiniteJump and "無限ジャンプ : ON" or "無限ジャンプ : OFF"
end)

------------------------------------------------
-- Friend Request
------------------------------------------------
local lastTap = 0
local debounce = false






--[[
UserInputService.TouchTap:Connect(function(touchPositions, gameProcessedEvent)
    if gameProcessedEvent then return end
    local now = tick()
    if now - lastTap < 0.3 then
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target and target.Parent then
            local targetPlayer = game.Players:GetPlayerFromCharacter(target.Parent)
            if targetPlayer and targetPlayer ~= player then
                local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local targetHRP = target.Parent:FindFirstChild("HumanoidRootPart")
                if myHRP and targetHRP then
                    local distance = (myHRP.Position - targetHRP.Position).Magnitude
                    if distance <= 8 then
                        debounce = true
                        pcall(function()
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Friend",
                                Text = "Requested"
                            })
                        end)
                        task.wait(3)
                        debounce = false
                    end
                end
            end
        end
    end
    lastTap = now
end)

FriendBtn.MouseButton1Click:Connect(function()
    friendTouch = not friendTouch
    FriendBtn.Text = friendTouch and "フレンド申請：ON" or "フレンド申請：OFF"
end)
--]]


------------------------------------------------
-- EXIT BUTTON
------------------------------------------------
LeaveBtn.MouseButton1Click:Connect(function()
	game:GetService("Players").LocalPlayer:Kick()
end)

------------------------------------------------
-- Fold
------------------------------------------------
local FoldBtn = Instance.new("TextButton")
FoldBtn.Parent = frame
FoldBtn.Size = UDim2.new(0,30,0,20)
FoldBtn.Position = UDim2.new(1,-35,0,3)
FoldBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
FoldBtn.Text = "▼"
FoldBtn.TextColor3 = Color3.new(1,1,1)
FoldBtn.Font = Enum.Font.GothamBold
FoldBtn.TextSize = 12
Instance.new("UICorner", FoldBtn).CornerRadius = UDim.new(0,6)

FoldBtn.MouseButton1Click:Connect(function()
	open = not open

	if open then
		frame.Size = UDim2.new(0,210,0,160)
		FoldBtn.Text = "▼"
	else
		frame.Size = UDim2.new(0,210,0,35)
		FoldBtn.Text = "▲"
	end

	updateUI()
end)

------------------------------------------------
-- Init
------------------------------------------------
updateUI()
