local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/kometa-anon/kometa/main/api/api.lua"))()
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kometa-anon/kometa/main/ui/finity.lua"))()
local bssapi = loadstring(game:HttpGet("https://raw.githubusercontent.com/kometa-anon/kometa/main/api/bssapi.lua"))()

if not isfolder("kometa") then makefolder("kometa") end
if isfile('kometa.txt') == false then (syn and syn.request or http_request)({ Url = "http://127.0.0.1:6463/rpc?v=1",Method = "POST",Headers = {["Content-Type"] = "application/json",["Origin"] = "https://discord.com"},Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER",args = {code = "2a5gVpcpzv"},nonce = game:GetService("HttpService"):GenerateGUID(false)}),writefile('kometa.txt', "discord")})end

-- Script temporary variables

local playerstatsevent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats
local statstable = playerstatsevent:InvokeServer()
local monsterspawners = game:GetService("Workspace").MonsterSpawners
local rarename
function rtsg() tab = game.ReplicatedStorage.Events.RetrievePlayerStats:InvokeServer() return tab end
function maskequip(mask) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = mask, ["Category"] = "Accessory"} game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end
local lasttouched = nil
local done = true
local hi = false

-- Script tables

local temptable = {
    version = "1.0.0",
    blackfield = "Ant Field",
    redfields = {},
    bluefields = {},
    whitefields = {},
    shouldiconvertballoonnow = false,
    balloondetected = false,
    puffshroomdetected = false,
    magnitude = 70,
    webhook = '',
    running = false,
    configname = "",
    tokenpath = game:GetService("Workspace").Collectibles,
    started = {
        vicious = false,
        mondo = false,
        windy = false,
        ant = false,
        monsters = false
    },
    detected = {
        vicious = false,
        windy = false
    },
    tokensfarm = false,
    converting = false,
    honeystart = 0,
    grib = nil,
    gribpos = CFrame.new(0,0,0),
    honeycurrent = statstable.Totals.Honey,
    dead = false,
    float = false,
    pepsigodmode = false,
    pepsiautodig = false,
    alpha = false,
    beta = false,
    myhiveis = false,
    invis = false,
    windy = nil,
    sprouts = {
        detected = false,
        coords
    },
    cache = {
        autofarm = false,
        killmondo = false,
        vicious = false,
        windy = false
    },
    allplanters = {},
    planters = {
        planter = {},
        cframe = {},
        activeplanters = {
            type = {},
            id = {}
        }
    },
    monstertypes = {"Ladybug", "Rhino", "Spider", "Scorpion", "Mantis", "Werewolf"},
    ["stopapypa"] = function(path, part)
        local Closest
        for i,v in next, path:GetChildren() do
            if v.Name ~= "PlanterBulb" then
                if Closest == nil then
                    Closest = v.Soil
                else
                    if (part.Position - v.Soil.Position).magnitude < (Closest.Position - part.Position).magnitude then
                        Closest = v.Soil
                    end
                end
            end
        end
        return Closest
    end,
    coconuts = {},
    crosshairs = {},
    crosshair = false,
    coconut = false,
    act = 0,
    ['touchedfunction'] = function(v)
        if lasttouched ~= v then
            if v.Parent.Name == "FlowerZones" then
                if v:FindFirstChild("ColorGroup") then
                    if tostring(v.ColorGroup.Value) == "Red" then
                        maskequip("Demon Mask")
                    elseif tostring(v.ColorGroup.Value) == "Blue" then
                        maskequip("Diamond Mask")
                    end
                else
                    maskequip("Gummy Mask")
                end
                lasttouched = v
            end
        end
    end,
    stats = {
        runningfor = 0,
        killedvicious = 0,
        killedwindy = 0;
        farmedsprouts = 0,
        farmedants = 0
    },
    oldtool = rtsg()["EquippedCollector"],
    ['gacf'] = function(part, st)
        coordd = CFrame.new(part.Position.X, part.Position.Y+st, part.Position.Z)
        return coordd
    end,
    ['feed'] = function(x, y, type, amount)
        if not amount then
            amount = 1
        end
        local bo = tonumber(x)
        local ba = tonumber(y)
        local be = type
        local br = tonumber(amount)

        game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg:InvokeServer(bo, ba, be, br)
    end,
    foundpopstar = false,
    item_names = {}
}
local planterst = {
    plantername = {},
    planterid = {}
}

if temptable.honeystart == 0 then temptable.honeystart = statstable.Totals.Honey end


for i,v in next, game:GetService("Workspace").MonsterSpawners:GetDescendants() do if v.Name == "TimerAttachment" then v.Name = "Attachment" end end
for i,v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do if v.Name == "RoseBush" then v.Name = "ScorpionBush" elseif v.Name == "RoseBush2" then v.Name = "ScorpionBush2" end end
for i,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do if v:FindFirstChild("ColorGroup") then if v:FindFirstChild("ColorGroup").Value == "Red" then table.insert(temptable.redfields, v.Name) elseif v:FindFirstChild("ColorGroup").Value == "Blue" then table.insert(temptable.bluefields, v.Name) end else table.insert(temptable.whitefields, v.Name) end end
local flowertable = {}
for _,z in next, game:GetService("Workspace").Flowers:GetChildren() do table.insert(flowertable, z.Position) end
local masktable = {}
for _,v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do if string.match(v.Name, "Mask") then table.insert(masktable, v.Name) end end
local collectorstable = {}
for _,v in next, getupvalues(require(game:GetService("ReplicatedStorage").Collectors).Exists) do for e,r in next, v do table.insert(collectorstable, e) end end
local fieldstable = {}
for _,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do table.insert(fieldstable, v.Name) end
local toystable = {}
for _,v in next, game:GetService("Workspace").Toys:GetChildren() do table.insert(toystable, v.Name) end
local spawnerstable = {}
for _,v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do table.insert(spawnerstable, v.Name) end
local accesoriestable = {}
for _,v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do if v.Name ~= "UpdateMeter" then table.insert(accesoriestable, v.Name) end end
for i,v in pairs(getupvalues(require(game:GetService("ReplicatedStorage").PlanterTypes).GetTypes)) do for e,z in pairs(v) do table.insert(temptable.allplanters, e) end end
for v,_ in next, rtsg().Eggs do table.insert(temptable.item_names, v) end
table.sort(fieldstable)
table.sort(accesoriestable)
table.sort(toystable)
table.sort(spawnerstable)
table.sort(masktable)
table.sort(temptable.allplanters)
table.sort(collectorstable)

-- float pad

local floatpad = Instance.new("Part", game:GetService("Workspace"))
floatpad.CanCollide = false
floatpad.Anchored = true
floatpad.Transparency = 1
floatpad.Name = "FloatPad"

-- cococrab

local cocopad = Instance.new("Part", game:GetService("Workspace"))
cocopad.Name = "Coconut Part"
cocopad.Anchored = true
cocopad.Transparency = 1
cocopad.Size = Vector3.new(10, 1, 10)
cocopad.Position = Vector3.new(-307.52117919922, 105.91863250732, 467.86791992188)

local popfolder = Instance.new("Folder", game:GetService("Workspace").Particles)
popfolder.Name = "PopStars"

-- antfarm

local antpart = Instance.new("Part", workspace)
antpart.Name = "Ant Autofarm Part"
antpart.Position = Vector3.new(96, 47, 553)
antpart.Anchored = true
antpart.Size = Vector3.new(128, 1, 50)
antpart.Transparency = 1
antpart.CanCollide = false

-- config

local kometa = {
    rares = {},
    priority = {},
    bestfields = {
        red = "Pepper Patch",
        white = "Coconut Field",
        blue = "Stump Field"
    },
    blacklistedfields = {},
    killerkometa = {},
    bltokens = {},
    webhooking = {
        convert = false,
        vicious = false,
        windy = false,
        playeradded = false,
        connectionlost = false
    },
    toggles = {
        autofarm = false,
        farmclosestleaf = false,
        farmbubbles = false,
        autodig = false,
        farmrares = false,
        farmtickets = false,
        rgbui = false,
        farmflower = false,
        farmfuzzy = false,
        farmcoco = false,
        farmflame = false,
        farmclouds = false,
        killmondo = false,
        killvicious = false,
        loopspeed = false,
        loopjump = false,
        autoquest = false,
        autoboosters = false,
        autodispense = false,
        clock = false,
        freeantpass = false,
        honeystorm = false,
        autodoquest = false,
        disableseperators = false,
        npctoggle = false,
        loopfarmspeed = false,
        mobquests = false,
        traincrab = false,
        avoidmobs = false,
        farmsprouts = false,
        enabletokenblacklisting = false,
        farmunderballoons = false,
        farmsnowflakes = false,
        collectgingerbreads = false,
        collectcrosshairs = false,
        farmpuffshrooms = false,
        tptonpc = false,
        donotfarmtokens = false,
        convertballoons = false,
        --autostockings = false,
        --autosamovar = false,
        --autoonettart = false,
        --autocandles = false,
        --autofeast = false,
        --autoplanters = false,
        autokillmobs = false,
        autoant = false,
        killwindy = false,
        godmode = false,
        disablerender = false,
        bloatfarm = false,
        autodonate = false
    },
    vars = {
        field = "Ant Field",
        donatit = {"Treat", 1},
        convertat = 100,
        farmspeed = 60,
        prefer = "Tokens",
        walkspeed = 70,
        jumppower = 70,
        npcprefer = "All Quests",
        farmtype = "Walk",
        monstertimer = 3
    },
    dispensesettings = {
        blub = false,
        straw = false,
        treat = false,
        coconut = false,
        glue = false,
        rj = false,
        white = false,
        red = false,
        blue = false
    },
    beessettings = {
        general = {
            x = 1,
            y = 1,
            amount = 1
        },
        usb = "",
        usbtoggle = false,
        ugb = false,
        foodtype = "Treat",
        af = false,
        mutation = "Convert Amount",
        umb = false
    }
}

local defaultkometa = kometa

-- functions

function statsget() local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() return stats end
function farm(trying, important)
    if important and kometa.toggles.bloatfarm and temptable.foundpopstar then api.tween(0.1, trying.CFrame) end
    if kometa.toggles.loopfarmspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kometa.vars.farmspeed end
    api.humanoid():MoveTo(trying.Position) 
    repeat task.wait() until (trying.Position-api.humanoidrootpart().Position).magnitude <=4 or not IsToken(trying) or not temptable.running
end

function disableall()
    if kometa.toggles.autofarm and not temptable.converting then
        temptable.cache.autofarm = true
        kometa.toggles.autofarm = false
    end
    if kometa.toggles.killmondo and not temptable.started.mondo then
        kometa.toggles.killmondo = false
        temptable.cache.killmondo = true
    end
    if kometa.toggles.killvicious and not temptable.started.vicious then
        kometa.toggles.killvicious = false
        temptable.cache.vicious = true
    end
    if kometa.toggles.killwindy and not temptable.started.windy then
        kometa.toggles.killwindy = false
        temptable.cache.windy = true
    end
end

function enableall()
    if temptable.cache.autofarm then
        kometa.toggles.autofarm = true
        temptable.cache.autofarm = false
    end
    if temptable.cache.killmondo then
        kometa.toggles.killmondo = true
        temptable.cache.killmondo = false
    end
    if temptable.cache.vicious then
        kometa.toggles.killvicious = true
        temptable.cache.vicious = false
    end
    if temptable.cache.windy then
        kometa.toggles.killwindy = true
        temptable.cache.windy = false
    end
end

function gettoken(v3)
    if not v3 then
        v3 = fieldposition
    end
    task.wait()
    if kometa.toggles.bloatfarm and temptable.foundpopstar then return end
    for e,r in next, game:GetService("Workspace").Collectibles:GetChildren() do
        itb = false
        if r:FindFirstChildOfClass("Decal") and kometa.toggles.enabletokenblacklisting then
            if api.findvalue(kometa.bltokens, string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
                itb = true
            end
        end
        if tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and not itb and (v3-r.Position).magnitude <= temptable.magnitude then
            farm(r)
        end
    end
end

function makesprinklers()
    sprinkler = rtsg().EquippedSprinkler
    e = 1
    if sprinkler == "Basic Sprinkler" or sprinkler == "The Supreme Saturator" then
        e = 1
    elseif sprinkler == "Silver Soakers" then
        e = 2
    elseif sprinkler == "Golden Gushers" then
        e = 3
    elseif sprinkler == "Diamond Drenchers" then
        e = 4
    end
    for i = 1, e do
        k = api.humanoid().JumpPower
        if e ~= 1 then api.humanoid().JumpPower = 70 api.humanoid().Jump = true task.wait(.2) end
        game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
        if e ~= 1 then api.humanoid().JumpPower = k task.wait(1) end
    end
end

function killmobs()
    for i,v in pairs(game:GetService("Workspace").MonsterSpawners:GetChildren()) do
        if v:FindFirstChild("Territory") then
            if v.Name ~= "Commando Chick" and v.Name ~= "CoconutCrab" and v.Name ~= "StumpSnail" and v.Name ~= "TunnelBear" and v.Name ~= "King Beetle Cave" and not v.Name:match("CaveMonster") and not v:FindFirstChild("TimerLabel", true).Visible then
                if v.Name:match("Werewolf") then
                    monsterpart = game:GetService("Workspace").Territories.WerewolfPlateau.w
                elseif v.Name:match("Mushroom") then
                    monsterpart = game:GetService("Workspace").Territories.MushroomZone.Part
                else
                    monsterpart = v.Territory.Value
                end
                api.humanoidrootpart().CFrame = monsterpart.CFrame
                repeat api.humanoidrootpart().CFrame = monsterpart.CFrame avoidmob() task.wait(1) until v:FindFirstChild("TimerLabel", true).Visible or api.humanoid().Health == 0
                for i = 1, 4 do gettoken(monsterpart.Position) end
            end
        end
    end
end

function IsToken(token)
    if not token then
        return false
    end
    if not token.Parent then return false end
    if token then
        if token.Orientation.Z ~= 0 then
            return false
        end
        if token:FindFirstChild("FrontDecal") then
        else
            return false
        end
        if not token.Name == "C" then
            return false
        end
        if not token:IsA("Part") then
            return false
        end
        return true
    else
        return false
    end
end

function check(ok)
    if not ok then
        return false
    end
    if not ok.Parent then return false end
    return true
end

function getplanters()
    table.clear(planterst.plantername)
    table.clear(planterst.planterid)
    for i,v in pairs(debug.getupvalues(require(game:GetService("ReplicatedStorage").LocalPlanters).LoadPlanter)[4]) do 
        if v.GrowthPercent == 1 and v.IsMine then
            table.insert(planterst.plantername, v.Type)
            table.insert(planterst.planterid, v.ActorID)
        end
    end
end

function farmant()
    antpart.CanCollide = true
    temptable.started.ant = true
    anttable = {left = true, right = false}
    temptable.oldtool = rtsg()['EquippedCollector']
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip",{["Mute"] = true,["Type"] = "Spark Staff",["Category"] = "Collector"})
    game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge")
    kometa.toggles.autodig = true
    acl = CFrame.new(127, 48, 547)
    acr = CFrame.new(65, 48, 534)
    task.wait(1)
    game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"})
    api.humanoidrootpart().CFrame = api.humanoidrootpart().CFrame + Vector3.new(0, 15, 0)
    task.wait(3)
    repeat
        task.wait()
        for i,v in next, game.Workspace.Toys["Ant Challenge"].Obstacles:GetChildren() do
            if v:FindFirstChild("Root") then
                if (v.Root.Position-api.humanoidrootpart().Position).magnitude <= 40 and anttable.left then
                    api.humanoidrootpart().CFrame = acr
                    anttable.left = false anttable.right = true
                    wait(.1)
                elseif (v.Root.Position-api.humanoidrootpart().Position).magnitude <= 40 and anttable.right then
                    api.humanoidrootpart().CFrame = acl
                    anttable.left = true anttable.right = false
                    wait(.1)
                end
            end
        end
    until game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value == false
    task.wait(1)
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip",{["Mute"] = true,["Type"] = temptable.oldtool,["Category"] = "Collector"})
    temptable.started.ant = false
    antpart.CanCollide = false
    temptable.stats.farmedants = temptable.stats.farmedants + 1
end

function collectplanters()
    getplanters()
    for i,v in pairs(planterst.plantername) do
        if api.partwithnamepart(v, game:GetService("Workspace").Planters) and api.partwithnamepart(v, game:GetService("Workspace").Planters):FindFirstChild("Soil") then
            soil = api.partwithnamepart(v, game:GetService("Workspace").Planters).Soil
            api.humanoidrootpart().CFrame = soil.CFrame
            game:GetService("ReplicatedStorage").Events.PlanterModelCollect:FireServer(planterst.planterid[i])
            task.wait(.5)
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = v.." Planter"})
            for i = 1, 5 do gettoken(soil.Position) end
            task.wait(2)
        end
    end
end

function getprioritytokens()
    task.wait()
    if temptable.running == false then
        for e,r in next, game:GetService("Workspace").Collectibles:GetChildren() do
            if r:FindFirstChildOfClass("Decal") then
                local aaaaaaaa = string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]
                if aaaaaaaa ~= nil and api.findvalue(kometa.priority, aaaaaaaa) then
                    if r.Name == game.Players.LocalPlayer.Name and not r:FindFirstChild("got it") or tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and not r:FindFirstChild("got it") then
                        farm(r) local val = Instance.new("IntValue",r) val.Name = "got it" break
                    end
                end
            end
        end
    end
end

function gethiveballoon()
    task.wait()
    result = false
    for i,hive in next, game:GetService("Workspace").Honeycombs:GetChildren() do
        task.wait()
        if hive:FindFirstChild("Owner") and hive:FindFirstChild("SpawnPos") then
            if tostring(hive.Owner.Value) == game.Players.LocalPlayer.Name then
                for e,balloon in next, game:GetService("Workspace").Balloons.HiveBalloons:GetChildren() do
                    task.wait()
                    if balloon:FindFirstChild("BalloonRoot") then
                        if (balloon.BalloonRoot.Position-hive.SpawnPos.Value.Position).magnitude < 15 then
                            result = true
                            break
                        end
                    end
                end
            end
        end
    end
    return result
end

function converthoney()
    task.wait(0)
    if temptable.converting then
        if game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then
            api.tween(1, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
            task.wait(.9)
            if game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 10 then game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking") end
            task.wait(.1)
        end
    end
end

function closestleaf()
    for i,v in next, game.Workspace.Flowers:GetChildren() do
        if temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

function getbubble()
    for i,v in next, game.workspace.Particles:GetChildren() do
        if string.find(v.Name, "Bubble") and temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v, true)
            break
        end
    end
end

function getballoons()
    for i,v in next, game:GetService("Workspace").Balloons.FieldBalloons:GetChildren() do
        if v:FindFirstChild("BalloonRoot") and v:FindFirstChild("PlayerName") then
            if v:FindFirstChild("PlayerName").Value == game.Players.LocalPlayer.Name then
                if tonumber((v.BalloonRoot.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
                    api.walkTo(v.BalloonRoot.Position)
                end
            end
        end
    end
end

function getflower()
    flowerrrr = flowertable[math.random(#flowertable)]
    if tonumber((flowerrrr-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude/1.4 and tonumber((flowerrrr-fieldposition).magnitude) <= temptable.magnitude/1.4 then 
        if temptable.running == false then 
            if kometa.toggles.loopfarmspeed then 
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kometa.vars.farmspeed 
            end 
            api.walkTo(flowerrrr) 
        end 
    end
end

function getcloud()
    for i,v in next, game:GetService("Workspace").Clouds:GetChildren() do
        e = v:FindFirstChild("Plane")
        if e and tonumber((e.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            api.walkTo(e.Position)
        end
    end
end

function getcoco(v)
    if temptable.coconut then repeat task.wait() until not temptable.coconut end
    temptable.coconut = true
    api.tween(.1, v.CFrame)
    repeat task.wait() api.walkTo(v.Position) until not v.Parent
    task.wait(.1)
    temptable.coconut = false
    table.remove(temptable.coconuts, table.find(temptable.coconuts, v))
end

function getfuzzy()
    pcall(function()
        for i,v in next, game.workspace.Particles:GetChildren() do
            if v.Name == "DustBunnyInstance" and temptable.running == false and tonumber((v.Plane.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
                if v:FindFirstChild("Plane") then
                    farm(v:FindFirstChild("Plane"))
                    break
                end
            end
        end
    end)
end

function getflame()
    for i,v in next, game:GetService("Workspace").PlayerFlames:GetChildren() do
        if tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            farm(v)
            break
        end
    end
end

function avoidmob()
    for i,v in next, game:GetService("Workspace").Monsters:GetChildren() do
        if v:FindFirstChild("Head") then
            if (v.Head.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 30 and api.humanoid():GetState() ~= Enum.HumanoidStateType.Freefall then
                game.Players.LocalPlayer.Character.Humanoid.Jump = true
            end
        end
    end
end

function getcrosshairs(v)
    if v.BrickColor ~= BrickColor.new("Lime green") and v.BrickColor ~= BrickColor.new("Flint") then
    if temptable.crosshair then repeat task.wait() until not temptable.crosshair end
    temptable.crosshair = true
    api.walkTo(v.Position)
    repeat task.wait() api.walkTo(v.Position) until not v.Parent or v.BrickColor == BrickColor.new("Forest green")
    task.wait(.1)
    temptable.crosshair = false
    table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    else
        table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    end
end

function makequests()
    for i,v in next, game:GetService("Workspace").NPCs:GetChildren() do
        if v.Name ~= "Ant Challenge Info" and v.Name ~= "Bubble Bee Man 2" and v.Name ~= "Wind Shrine" and v.Name ~= "Gummy Bear" then if v:FindFirstChild("Platform") then if v.Platform:FindFirstChild("AlertPos") then if v.Platform.AlertPos:FindFirstChild("AlertGui") then if v.Platform.AlertPos.AlertGui:FindFirstChild("ImageLabel") then
            image = v.Platform.AlertPos.AlertGui.ImageLabel
            button = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ActivateButton.MouseButton1Click
            if image.ImageTransparency == 0 then
                if kometa.toggles.tptonpc then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z)
                    task.wait(1)
                else
                    api.tween(2,CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z))
                    task.wait(3)
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z)
                task.wait(.1)
                for b,z in next, getconnections(button) do    z.Function()    end
                task.wait(8)
                if image.ImageTransparency == 0 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z)
                    task.wait(.1)
                    for b,z in next, getconnections(button) do    z.Function()    end
                end
                task.wait(2)
            end
        end     
    end end end end end
end

local ui = library.new(true, "kometa ☄️ | "..temptable.version)
ui.ChangeToggleKey(Enum.KeyCode.Semicolon)

local hometab = ui:Category("Home")
local farmtab = ui:Category("Farming")
local combtab = ui:Category("Combat")
local statstab = ui:Category("Statistics")
local wayptab = ui:Category("Waypoints")
local hivetab = ui:Category("Hive")
local misctab = ui:Category("Misc")
local extrtab = ui:Category("Extra")
local setttab = ui:Category("Settings")

local main = hometab:Sector("Main")
main:Cheat("Label", "Thanks you for using our script, "..api.nickname)
main:Cheat("Label", "Another official fork of kocmoc by notweuz")
main:Cheat("Label", "Script by mrdevl and .anon")
main:Cheat("Label", "Script version: "..temptable.version)
main:Cheat("Label", "Place version: "..game.PlaceVersion)
--information:Cheat("Button", "Discord Invite", function() setclipboard("https://discord.gg/2a5gVpcpzv") end)
--information:Cheat("Button", "Donation", function() setclipboard("https://qiwi.com/n/W33UZ") end)
local signs = hometab:Sector("Signs")
signs:Cheat("Label", "⚠️ - Not Safe Function")
signs:Cheat("Label", "⚙ - Configurable Function")
local links = hometab:Sector("Links")
links:Cheat("Button", "Discord Server", function() setclipboard("hhttps://discord.gg/2a5gVpcpzv") end, {text=""})
links:Cheat("Button", "Token IDs", function() setclipboard("https://pastebin.com/raw/wtHBD3ij") end, {text=""})

local farm = farmtab:Sector("Farming")
farm:Cheat("Dropdown", "Field", function(Option) temptable.tokensfarm = false kometa.vars.field = Option end, {options=fieldstable})
farm:Cheat("Slider", "Convert at:", function(Value) kometa.vars.convertat = Value end, {min = 0, max = 100, suffix = "%"})
farm:Cheat("Checkbox", "Autofarm", function(State) kometa.toggles.autofarm = not kometa.toggles.autofarm end)
farm:Cheat("Checkbox", "Autodig", function(State) kometa.toggles.autodig = State end)
farm:Cheat("Checkbox", "Auto Sprinkler", function(State) kometa.toggles.autosprinkler = State end)
farm:Cheat("Checkbox", "Farm Bubbles", function(State) kometa.toggles.farmbubbles = State end)
farm:Cheat("Checkbox", "Bubble Bloat Helper", function(State) kometa.toggles.bloatfarm = State end)
farm:Cheat("Checkbox", "Farm Flames", function(State) kometa.toggles.farmflame = State end)
farm:Cheat("Checkbox", "Farm Coconuts & Shower", function(State) kometa.toggles.farmcoco = State end)
farm:Cheat("Checkbox", "Farm Precise Crosshairs", function(State) kometa.toggles.collectcrosshairs = State end)
farm:Cheat("Checkbox", "Farm Fuzzy Bombs", function(State) kometa.toggles.farmfuzzy = State end)
farm:Cheat("Checkbox", "Farm Under Balloons", function(State) kometa.toggles.farmunderballoons = State end)
farm:Cheat("Checkbox", "Farm Under Clouds", function(State) kometa.toggles.farmclouds = State end)

local farmingtwo = farmtab:Sector("")
farmingtwo:Cheat("Checkbox", "Auto Dispenser ⚙", function(State) kometa.toggles.autodispense = State end)
farmingtwo:Cheat("Checkbox", "Auto Field Boosters ⚙", function(State) kometa.toggles.autoboosters = State end)
farmingtwo:Cheat("Checkbox", "Auto Wealth Clock", function(State) kometa.toggles.clock = State end)
--farmingtwo:Cheat("Auto Gingerbread Bears", function(State) kometa.toggles.collectgingerbreads = State end)
--farmingtwo:Cheat("Auto Samovar", function(State) kometa.toggles.autosamovar = State end)
--farmingtwo:Cheat("Auto Stockings", function(State) kometa.toggles.autostockings = State end)
farmingtwo:Cheat("Checkbox", "Replace Planters After Converting", function(State) kometa.toggles.autoplanters = State end)
--farmingtwo:Cheat("Auto Honey Candles", function(State) kometa.toggles.autocandles = State end)
--farmingtwo:Cheat("Auto Beesmas Feast", function(State) kometa.toggles.autofeast = State end)
--farmingtwo:Cheat("Auto Onett's Lid Art", function(State) kometa.toggles.autoonettart = State end)
farmingtwo:Cheat("Checkbox", "Auto Free Antpasses", function(State) kometa.toggles.freeantpass = State end)
farmingtwo:Cheat("Checkbox", "Farm Sprouts", function(State) kometa.toggles.farmsprouts = State end)
farmingtwo:Cheat("Checkbox", "Farm Puffshrooms", function(State) kometa.toggles.farmpuffshrooms = State end)
--farmingtwo:Cheat("Farm Snowflakes ⚠️", function(State) kometa.toggles.farmsnowflakes = State end)
farmingtwo:Cheat("Checkbox", "Farm Tickets ⚠️", function(State) kometa.toggles.farmtickets = State end)
farmingtwo:Cheat("Checkbox", "Teleport To Rares ⚠️", function(State) kometa.toggles.farmrares = State end)
farmingtwo:Cheat("Checkbox", "Auto Accept/Confirm Quests ⚙", function(State) kometa.toggles.autoquest = State end)
farmingtwo:Cheat("Checkbox", "Auto Do Quests ⚙", function(State) kometa.toggles.autodoquest = State end)
farmingtwo:Cheat("Checkbox", "Auto Honeystorm", function(State) kometa.toggles.honeystorm = State end)

local mobkill = combtab:Sector("Combat")
mobkill:Cheat("Checkbox", "Train Crab", function(State) if State then api.humanoidrootpart().CFrame = CFrame.new(-307.52117919922, 107.91863250732, 467.86791992188) end end)
mobkill:Cheat("Checkbox", "Train Snail", function(State) fd = game.Workspace.FlowerZones['Stump Field'] if State then api.humanoidrootpart().CFrame = CFrame.new(fd.Position.X, fd.Position.Y-6, fd.Position.Z) else api.humanoidrootpart().CFrame = CFrame.new(fd.Position.X, fd.Position.Y+2, fd.Position.Z) end end)
mobkill:Cheat("Checkbox", "Kill Mondo", function(State) kometa.toggles.killmondo = State end)
mobkill:Cheat("Checkbox", "Kill Vicious", function(State) kometa.toggles.killvicious = State end)
mobkill:Cheat("Checkbox", "Kill Windy", function(State) kometa.toggles.killwindy = State end)
mobkill:Cheat("Checkbox", "Auto Kill Mobs", function(State) kometa.toggles.autokillmobs = State end)
mobkill:Cheat("Checkbox", "Avoid Mobs", function(State) kometa.toggles.avoidmobs = State end)
mobkill:Cheat("Checkbox", "Auto Ant", function(State) kometa.toggles.autoant = State end)

local amks = combtab:Sector("Auto Kill Mobs Settings")
amks:Cheat("Textbox",'Kill Mobs After x Convertions', function(Value) kometa.vars.monstertimer = tonumber(Value) end, { placeholder = 'default = 3'})

local statssector = statstab:Sector("Statistics")
statssector:Cheat("Label", "Gained Honey")
statssector:Cheat("Label", "Elapsed Time")
statssector:Cheat("Label", "Farmed Sprouts")
statssector:Cheat("Label", "Killed Vicious")
statssector:Cheat("Label", "Killed Windy")
statssector:Cheat("Label", "Farmed Ants")

local mobstimers = statstab:Sector("Mob Timers")
mobstimers:Cheat("Label", "Coming soon!")

local wayp = wayptab:Sector("Waypoints")
wayp:Cheat("Dropdown", "Field Teleports", function(Option) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").FlowerZones:FindFirstChild(Option).CFrame end, {options = fieldstable})
wayp:Cheat("Dropdown", "Monster Teleports", function(Option) d = game:GetService("Workspace").MonsterSpawners:FindFirstChild(Option) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z) end, {options = spawnerstable})
wayp:Cheat("Dropdown", "Toys Teleports", function(Option) d = game:GetService("Workspace").Toys:FindFirstChild(Option).Platform game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z) end, {options = toystable})
wayp:Cheat("Button", "Teleport to hive", function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.SpawnPos.Value end, {placeholder = ' '})

local ghive = hivetab:Sector("Hive Position")
ghive:Cheat("Textbox", "X", function(Value) kometa.beessettings.general.x = Value end, {placeholder = ' '})
ghive:Cheat("Textbox", "Y", function(Value) kometa.beessettings.general.y = Value end, {placeholder = ' '})
ghive:Cheat("Textbox", "Amount", function(Value) kometa.beessettings.general.amount = Value end, {placeholder = ' '})
local arjhive = hivetab:Sector("Auto Royal Jelly")
arjhive:Cheat("Textbox", "Bee", function(Value) kometa.beessettings.usb = Value end, {placeholder = ' '})
arjhive:Cheat("Checkbox", "Until Selected Bee", function(State) kometa.beessettings.usbtoggle = State if not State then game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.TypeName.Text = "" end end)
local ugbhive = hivetab:Sector("Autofeed")
ugbhive:Cheat("Dropdown", "Food Type", function(Option) kometa.beessettings.foodtype = Option end, { options = {"Treat", "Sunflower Seed", "Blueberry", "Strawberry", "Bitterberry", "Pineapple"--[[,"GingerbreadBear"]]}})
ugbhive:Cheat("Checkbox", "Food Until Gifted", function(State) kometa.beessettings.ugb = State if not State then game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.TypeName.Text = "" end end)
ugbhive:Cheat("Checkbox", "Auto Feed", function(State) kometa.beessettings.af = State end)
local umhive = hivetab:Sector("Mutation Rolling")
umhive:Cheat("Dropdown", "Mutation", function(Option) kometa.beessettings.mutation = Option end, {options = {"Convert Amount", "Gather Amount", "Ability Rate", "Attack", "Energy"}})
umhive:Cheat("Checkbox", "Roll Until Mutation", function(State) kometa.beessettings.umb = State if not State then game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.MutationFrame.MutationLabel.Text.Text = "" end end)

local miscc = misctab:Sector("Misc")
miscc:Cheat("Button", "Ant Challenge Semi-Godmode", function() api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) task.wait(1) game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge") game.Players.LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(93.4228, 42.3983, 553.128) task.wait(2) game.Players.LocalPlayer.Character.Humanoid.Name = 1 local l = game.Players.LocalPlayer.Character["1"]:Clone() l.Parent = game.Players.LocalPlayer.Character l.Name = "Humanoid" task.wait() game.Players.LocalPlayer.Character["1"]:Destroy() api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) task.wait(8) api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) end, {text = ''})
miscc:Cheat("Checkbox", "Walk Speed", function(State) kometa.toggles.loopspeed = State end)
miscc:Cheat("Checkbox", "Jump Power", function(State) kometa.toggles.loopjump = State end)
miscc:Cheat("Checkbox", "Godmode", function(State) kometa.toggles.godmode = State if State then bssapi:Godmode(true) else bssapi:Godmode(false) end end)

local webhooking = misctab:Sector("Discord Webhooking")
webhooking:Cheat("Textbox", "Webhook", function(Value) temptable.webhook = Value end, {placeholder = ' '})
webhooking:Cheat("Button", "Remind Webhook", function() api.notify('kometa', 'Your webhook is '..temptable.webhook) end, {text = ''})
webhooking:Cheat("Checkbox", "Send After Converting", function(State) kometa.webhooking.convert = State end)
webhooking:Cheat("Checkbox", "Send On Vicious", function(State) kometa.webhooking.vicious = State end)
webhooking:Cheat("Checkbox", "Send On Windy", function(State) kometa.webhooking.windy = State end)
webhooking:Cheat("Checkbox", "Send When Player Joins Server", function(State) kometa.webhooking.playeradded = State end)
-- webhooking:Cheat("Checkbox", "Send On Connection Lost", function(State) kometa.webhooking.connectionlost = State end)

local misco = misctab:Sector("Other")
misco:Cheat("Dropdown", "Equip Accesories", function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end, {options = accesoriestable})
misco:Cheat("Dropdown", "Equip Masks", function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end, {options = masktable})
misco:Cheat("Dropdown", "Equip Collectors", function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Collector" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end, {options = collectorstable})
misco:Cheat("Dropdown", "Generate Amulet", function(Option) local A_1 = Option.." Generator" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end, {options = {"Supreme Star Amulet", "Diamond Star Amulet", "Gold Star Amulet","Silver Star Amulet","Bronze Star Amulet","Moon Amulet"}})
misco:Cheat("Button", "Export Stats Table", function() local StatCache = require(game.ReplicatedStorage.ClientStatCache)writefile("Stats_"..api.nickname..".json", StatCache:Encode()) end, {text = ''})

local extras = extrtab:Sector("Extras")
extras:Cheat("Textbox", "Glider Speed", function(Value) local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() stats.EquippedParachute = "Glider" local module = require(game:GetService("ReplicatedStorage").Parachutes) local st = module.GetStat local glidersTable = getupvalues(st) glidersTable[1]["Glider"].Speed = Value setupvalue(st, st[1]'Glider', glidersTable) end)
extras:Cheat("Textbox", "Glider Float", function(Value) local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() stats.EquippedParachute = "Glider" local module = require(game:GetService("ReplicatedStorage").Parachutes) local st = module.GetStat local glidersTable = getupvalues(st) glidersTable[1]["Glider"].Float = Value setupvalue(st, st[1]'Glider', glidersTable) end)
extras:Cheat("Button", "Invisibility", function(State) api.teleport(CFrame.new(0,0,0)) wait(1) if game.Players.LocalPlayer.Character:FindFirstChild('LowerTorso') then Root = game.Players.LocalPlayer.Character.LowerTorso.Root:Clone() game.Players.LocalPlayer.Character.LowerTorso.Root:Destroy() Root.Parent = game.Players.LocalPlayer.Character.LowerTorso api.teleport(game:GetService("Players").LocalPlayer.SpawnPos.Value) end end, {text = ''})
extras:Cheat("Checkbox", "Float", function(State) temptable.float = State end)

local optimize = extrtab:Sector("Optimization")
optimize:Cheat("Button", "Hide nickname", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kometa-anon/kometa/main/other/nicknamespoofer.lua"))()end, {text = ''})
optimize:Cheat("Button", "Boost FPS", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/kometa-anon/kometa/main/other/fpsboost.lua"))()end, {text = ''})
optimize:Cheat("Button", "Destroy Decals", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/kometa-anon/kometa/main/other/destroydecals.lua"))()end, {text = ''})
optimize:Cheat("Checkbox", "Disable 3D Render On Unfocus", function(State) kometa.toggles.disablerender = State end)
optimize:Cheat("Checkbox", "Disable 3D Render", function(State) game:GetService("RunService"):Set3dRenderingEnabled(not State) end)

local windsh = extrtab:Sector("Wind Shrine")
windsh:Cheat("Dropdown", "Item", function(Option) kometa.vars.donatit[1] = Option end, {options=temptable.item_names}) 
windsh:Cheat("Textbox", "Count", function(Value) kometa.vars.donatit[2] = tonumber(Value) end)
windsh:Cheat("Checkbox", "Auto Donate", function(State) kometa.toggles.autodonate = State end)
windsh:Cheat("Label", "") windsh:Cheat("Label", "") windsh:Cheat("Label", "") windsh:Cheat("Label", "") windsh:Cheat("Label", "") windsh:Cheat("Label", "")

local farmsettings = setttab:Sector("Autofarm Settings")
farmsettings:Cheat("Textbox", "Autofarming Walkspeed", function(Value) kometa.vars.farmspeed = Value end, {placeholder = "Default Value = 60"})
farmsettings:Cheat("Checkbox", "^ Loop Speed On Autofarming", function(State) kometa.toggles.loopfarmspeed = State end)
farmsettings:Cheat("Checkbox", "Don't Walk In Field", function(State) kometa.toggles.farmflower = State end)
farmsettings:Cheat("Checkbox", "Convert Hive Balloon", function(State) kometa.toggles.convertballoons = State end)
farmsettings:Cheat("Checkbox", "Don't Farm Tokens", function(State) kometa.toggles.donotfarmtokens = State end)
farmsettings:Cheat("Checkbox", "Enable Token Blacklisting", function(State) kometa.toggles.enabletokenblacklisting = State end)
farmsettings:Cheat("Slider", "Walk Speed", function(Value) kometa.vars.walkspeed = Value end, {min = 0, max = 120, suffix = " studs"})
farmsettings:Cheat("Slider", "Jump Power", function(Value) kometa.vars.jumppower = Value end, {min = 0, max = 120, suffix = " studs"})
local raresettings = setttab:Sector("Tokens Settings")
raresettings:Cheat("Textbox", "Asset ID", function(Value) rarename = Value end, {placeholder = 'rbxassetid'})
raresettings:Cheat("Button", "Add Rare", function()
    table.insert(kometa.rares, rarename)
    game.CoreGui.kometaUI.Container.Categories.Settings.R["Tokens Settings"].Container["Rares List"]:Destroy()
    raresettings:Cheat("Dropdown", "Rares List", function(Option)
    end, {
        options = kometa.rares
    })
end, {text = 'Add'})
raresettings:Cheat("Button", "Remove Rare", function()
    table.remove(kometa.rares, api.tablefind(kometa.rares, rarename))
    game.CoreGui.kometaUI.Container.Categories.Settings.R["Tokens Settings"].Container["Rares List"]:Destroy()
    raresettings:Cheat("Dropdown", "Rares List", function(Option)
    end, {
        options = kometa.rares
    })
end, {text = 'Remove'})
raresettings:Cheat("Button", "Add To Blacklist", function()
    table.insert(kometa.bltokens, rarename)
    game.CoreGui.kometaUI.Container.Categories.Settings.R["Tokens Settings"].Container["Tokens Blacklist"]:Destroy()
    raresettings:Cheat("Dropdown", "Tokens Blacklist", function(Option)
    end, {
        options = kometa.bltokens
    })
end, {text = 'Add'})
raresettings:Cheat("Button", "Remove From Blacklist", function()
    table.remove(kometa.bltokens, api.tablefind(kometa.bltokens, rarename))
    game.CoreGui.kometaUI.Container.Categories.Settings.R["Tokens Settings"].Container["Tokens Blacklist"]:Destroy()
    raresettings:Cheat("Dropdown", "Tokens Blacklist", function(Option)
    end, {
        options = kometa.bltokens
    })
end, {text = 'Remove'})
raresettings:Cheat("Dropdown", "Tokens Blacklist", function(Option) end, {options = kometa.bltokens})
raresettings:Cheat("Dropdown", "Rares List", function(Option) end, {options = kometa.rares})
local dispsettings = setttab:Sector("Auto Dispenser & Auto Boosters Settings")
dispsettings:Cheat("Checkbox", "Royal Jelly Dispenser", function(State) kometa.dispensesettings.rj = not kometa.dispensesettings.rj end)
dispsettings:Cheat("Checkbox", "Blueberry Dispenser",  function(State) kometa.dispensesettings.blub = not kometa.dispensesettings.blub end)
dispsettings:Cheat("Checkbox", "Strawberry Dispenser",  function(State) kometa.dispensesettings.straw = not kometa.dispensesettings.straw end)
dispsettings:Cheat("Checkbox", "Treat Dispenser",  function(State) kometa.dispensesettings.treat = not kometa.dispensesettings.treat end)
dispsettings:Cheat("Checkbox", "Coconut Dispenser",  function(State) kometa.dispensesettings.coconut = not kometa.dispensesettings.coconut end)
dispsettings:Cheat("Checkbox", "Glue Dispenser",  function(State) kometa.dispensesettings.glue = not kometa.dispensesettings.glue end)
dispsettings:Cheat("Checkbox", "Mountain Top Booster",  function(State) kometa.dispensesettings.white = not kometa.dispensesettings.white end)
dispsettings:Cheat("Checkbox", "Blue Field Booster",  function(State) kometa.dispensesettings.blue = not kometa.dispensesettings.blue end)
dispsettings:Cheat("Checkbox", "Red Field Booster",  function(State) kometa.dispensesettings.red = not kometa.dispensesettings.red end)
local guisettings = setttab:Sector("GUI Settings")
guisettings:Cheat("Keybind", "Set toggle button", function(Value) ui.ChangeToggleKey(Value) end, {text = 'Set New'})
guisettings:Cheat("Dropdown", "GUI Options (Dropdown)", function(Option) if Option == "Color Reset" then game:GetService("CoreGui").kometaUI.Container.BackgroundColor3 = Color3.fromRGB(32,32,33) else game.CoreGui.kometaUI:Destroy() temptable.tokensfarm = false end end, { options = { "Destroy GUI", "Color Reset" } })
-- guisettings:Cheat("Checkbox", "Disable Separators", function(State)
--     if Settings.disableseperators == false then
--         Settings.disableseperators = true
--         for i,v in pairs(game:GetService("CoreGui").kometaUI.Container:GetChildren()) do
--             if v.Name == "Separator" then
--                 v.Visible = false
--             end
--             task.wait()
--         end
--     else
--         for i,v in pairs(game:GetService("CoreGui").kometaUI.Container:GetChildren()) do
--             if v.Name == "Separator" then
--                 v.Visible = true
--             end
--             task.wait()
--         end
--         Settings.disableseperators = false
--     end
-- end)
guisettings:Cheat("Checkbox", "RGB GUI", function(State)
    if kometa.toggles.rgbui == false then
        kometa.toggles.rgbui = true
            while kometa.toggles.rgbui do
                for hue = 0, 255, 4 do
                    if kometa.toggles.rgbui then
                        game.CoreGui.kometaUI.Container.BorderColor3 = Color3.fromHSV(hue/256, 1, 1)
                        game.CoreGui.kometaUI.Container.BackgroundColor3 = Color3.fromHSV(hue/256, .5, .8)
                        task.wait()
                    end
                end
            end
        else
        end
        kometa.toggles.rgbui = false
end)
guisettings:Cheat("ColorPicker", "GUI Color", function(Value) game:GetService("CoreGui").kometaUI.Container.BackgroundColor3 = Value end)
guisettings:Cheat("Textbox", "GUI Transparency", function(Value)game:GetService("CoreGui").kometaUI.Container.BackgroundTransparency = Value for i,v in pairs(game:GetService("CoreGui").kometaUI.Container:GetChildren()) do    if v.Name == "Separator" then    v.BackgroundTransparency = Value end end	game:GetService("CoreGui").kometaUI.Container.Shadow.ImageTransparency = Value end, { placeholder = "between 0 and 1"})
local komets = setttab:Sector("Configs")
komets:Cheat("Textbox", "Config Name", function(Value) temptable.configname = Value end, {placeholder = 'ex: stumpconfig'})
komets:Cheat("Button", "Load Config", function() kometa = game:service'HttpService':JSONDecode(readfile("kometa/BSS_"..temptable.configname..".json")) end, {text = ' '})
komets:Cheat("Button", "Save Config", function() writefile("kometa/BSS_"..temptable.configname..".json",game:service'HttpService':JSONEncode(kometa)) end, {text = ' '})
komets:Cheat("Button", "Reset Config", function() kometa = defaultkometa end, {text = ' '})
local fieldsettings = setttab:Sector("Fields Settings")
fieldsettings:Cheat("Dropdown", "Best White Field", function(Option) kometa.bestfields.white = Option end, {options = temptable.whitefields})
fieldsettings:Cheat("Dropdown", "Best Red Field", function(Option) kometa.bestfields.red = Option end, {options = temptable.redfields})
fieldsettings:Cheat("Dropdown", "Best Blue Field", function(Option) kometa.bestfields.blue = Option end, {options = temptable.bluefields})
fieldsettings:Cheat("Dropdown", "Field", function(Option) temptable.blackfield = Option end, {options = fieldstable})
fieldsettings:Cheat("Button", "Add Field To Blacklist", function() table.insert(kometa.blacklistedfields, temptable.blackfield) game:GetService("CoreGui").kometaUI.Container.Categories.Settings.R["Fields Settings"].Container["Blacklisted Fields"]:Destroy() fieldsettings:Cheat("Dropdown", "Blacklisted Fields", function(Option) end, {options = kometa.blacklistedfields}) end, {text = ' '})
fieldsettings:Cheat("Button", "Remove Field From Blacklist", function() table.remove(kometa.blacklistedfields, api.tablefind(kometa.blacklistedfields, temptable.blackfield)) game:GetService("CoreGui").kometaUI.Container.Categories.Settings.R["Fields Settings"].Container["Blacklisted Fields"]:Destroy() fieldsettings:Cheat("Dropdown", "Blacklisted Fields", function(Option) end, {options = kometa.blacklistedfields}) end, {text = ' '})
fieldsettings:Cheat("Dropdown", "Blacklisted Fields", function(Option) end, {options = kometa.blacklistedfields})
local aqs = setttab:Sector("Auto Quest Settings")
aqs:Cheat("Dropdown", "Do NPC Quests", function(Option) kometa.vars.npcprefer = Option end, {options = {'All Quests', 'Bucko Bee', 'Brown Bear', 'Riley Bee', 'Polar Bear'}})
aqs:Cheat("Checkbox", "Teleport To NPC", function(State) kometa.toggles.tptonpc = State end)
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")
local pts = setttab:Sector("Autofarm Priority Tokens")
pts:Cheat("Textbox", "Asset ID", function(Value) rarename = Value end, {placeholder = 'rbxassetid'})
pts:Cheat("Button", "Add Token To Priority List", function() table.insert(kometa.priority, rarename) game:GetService("CoreGui").kometaUI.Container.Categories.Settings.R["Autofarm Priority Tokens"].Container["Priority List"]:Destroy() pts:Cheat("Dropdown", "Priority List", function(Option) end, {options = kometa.priority}) end, {text = ''})
pts:Cheat("Button", "Remove Token From Priority List", function() table.remove(kometa.priority, api.tablefind(kometa.priority, rarename)) game:GetService("CoreGui").kometaUI.Container.Categories.Settings.R["Autofarm Priority Tokens"].Container["Priority List"]:Destroy() pts:Cheat("Dropdown", "Priority List", function(Option) end, {options = kometa.priority}) end, {text = ''})
pts:Cheat("Dropdown", "Priority List", function(Option) end, {options = kometa.priority})

task.spawn(function() while task.wait() do
    if kometa.toggles.autofarm then
        --if kometa.toggles.farmcoco then getcoco() end
        --if kometa.toggles.collectcrosshairs then getcrosshairs() end
        if kometa.toggles.farmflame then getflame() end
        if kometa.toggles.farmfuzzy then getfuzzy() end
    end
end end)

game.Workspace.Particles.ChildAdded:Connect(function(v)
    if not temptable.started.vicious and not temptable.started.ant then
        if v.Name == "WarningDisk" and not temptable.started.vicious and kometa.toggles.autofarm and not temptable.started.ant and kometa.toggles.farmcoco and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and not temptable.converting then
            table.insert(temptable.coconuts, v)
            getcoco(v)
            gettoken()
        elseif v.Name == "Crosshair" and v ~= nil and v.BrickColor ~= BrickColor.new("Forest green") and not temptable.started.ant and v.BrickColor ~= BrickColor.new("Flint") and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and kometa.toggles.autofarm and kometa.toggles.collectcrosshairs and not temptable.converting then
            if #temptable.crosshairs <= 3 then
                table.insert(temptable.crosshairs, v)
                getcrosshairs(v)
                gettoken()
            end
        end
    end
end)

task.spawn(function() while task.wait() do
    if kometa.toggles.autofarm then
        temptable.magnitude = 70
        if game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true) then
        local pollenprglbl = game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true)
        maxpollen = tonumber(pollenprglbl.Text:match("%d+$"))
        local pollencount = game.Players.LocalPlayer.CoreStats.Pollen.Value
        pollenpercentage = pollencount/maxpollen*100
        fieldselected = game:GetService("Workspace").FlowerZones[kometa.vars.field]
        if kometa.toggles.autodoquest and game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests.Content:FindFirstChild("Frame") then
            for i,v in next, game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests:GetDescendants() do
                if v.Name == "Description" then
                    if string.match(v.Parent.Parent.TitleBar.Text, kometa.vars.npcprefer) or kometa.vars.npcprefer == "All Quests" and not string.find(v.Text, "Puffshroom") then
                        pollentypes = {'White Pollen', "Red Pollen", "Blue Pollen", "Blue Flowers", "Red Flowers", "White Flowers"}
                        text = v.Text
                        if api.returnvalue(fieldstable, text) and not string.find(v.Text, "Complete!") and not api.findvalue(kometa.blacklistedfields, api.returnvalue(fieldstable, text)) then
                            d = api.returnvalue(fieldstable, text)
                            fieldselected = game:GetService("Workspace").FlowerZones[d]
                            break
                        elseif api.returnvalue(pollentypes, text) and not string.find(v.Text, 'Complete!') then
                            d = api.returnvalue(pollentypes, text)
                            if d == "Blue Flowers" or d == "Blue Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kometa.bestfields.blue]
                                break
                            elseif d == "White Flowers" or d == "White Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kometa.bestfields.white]
                                break
                            elseif d == "Red Flowers" or d == "Red Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kometa.bestfields.red]
                                break
                            end
                        end
                    end
                end
            end
        else
            fieldselected = game:GetService("Workspace").FlowerZones[kometa.vars.field]
        end
        fieldpos = CFrame.new(fieldselected.Position.X, fieldselected.Position.Y+3, fieldselected.Position.Z)
        fieldposition = fieldselected.Position
        if temptable.sprouts.detected and temptable.sprouts.coords and kometa.toggles.farmsprouts then
            fieldposition = temptable.sprouts.coords.Position
            fieldpos = temptable.sprouts.coords
        end
        if kometa.toggles.farmpuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") then 
            if api.partwithnamepart("Mythic", game.Workspace.Happenings.Puffshrooms) then
                temptable.magnitude = 25 
                fieldpos = api.partwithnamepart("Mythic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            elseif api.partwithnamepart("Legendary", game.Workspace.Happenings.Puffshrooms) then
                temptable.magnitude = 25 
                fieldpos = api.partwithnamepart("Legendary", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            elseif api.partwithnamepart("Epic", game.Workspace.Happenings.Puffshrooms) then
                temptable.magnitude = 25 
                fieldpos = api.partwithnamepart("Epic", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            elseif api.partwithnamepart("Rare", game.Workspace.Happenings.Puffshrooms) then
                temptable.magnitude = 25 
                fieldpos = api.partwithnamepart("Rare", game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            else
                temptable.magnitude = 25 
                fieldpos = api.getbiggestmodel(game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                fieldposition = fieldpos.Position
            end
        end
        if tonumber(pollenpercentage) < tonumber(kometa.vars.convertat) then
            if not temptable.tokensfarm then
                api.tween(2, fieldpos)
                task.wait(2)
                temptable.tokensfarm = true
                if kometa.toggles.autosprinkler then makesprinklers() end
            else
                if kometa.toggles.killmondo then
                    while kometa.toggles.killmondo and game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") and not temptable.started.vicious and not temptable.started.monsters do
                        temptable.started.mondo = true
                        while game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") do
                            disableall()
                            game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = false 
                            mondopition = game.Workspace.Monsters["Mondo Chick (Lvl 8)"].Head.Position
                            api.tween(1, CFrame.new(mondopition.x, mondopition.y - 60, mondopition.z))
                            task.wait(1)
                            temptable.float = true
                        end
                        task.wait(.5) game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = true temptable.float = false api.tween(.5, CFrame.new(73.2, 176.35, -167)) task.wait(1)
                        for i = 0, 50 do 
                            gettoken(CFrame.new(73.2, 176.35, -167).Position) 
                        end 
                        enableall() 
                        api.tween(2, fieldpos) 
                        temptable.started.mondo = false
                    end
                end
                if (fieldposition-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > temptable.magnitude then
                    api.tween(2, fieldpos)
                    task.wait(2)
                    if kometa.toggles.autosprinkler then makesprinklers() end
                end
                getprioritytokens()
                if kometa.toggles.avoidmobs then avoidmob() end
                if kometa.toggles.farmclosestleaf then closestleaf() end
                if kometa.toggles.farmbubbles then getbubble() end
                if kometa.toggles.farmclouds then getcloud() end
                if kometa.toggles.farmunderballoons then getballoons() end
                if not kometa.toggles.donotfarmtokens and done then gettoken() end
                if not kometa.toggles.farmflower then getflower() end
            end
        elseif tonumber(pollenpercentage) >= tonumber(kometa.vars.convertat) then
            temptable.tokensfarm = false
            api.tween(2, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 9))
            task.wait(2)
            temptable.converting = true
            repeat
                converthoney()
            until game.Players.LocalPlayer.CoreStats.Pollen.Value == 0
            if kometa.toggles.convertballoons and gethiveballoon() then
                task.wait(6)
                repeat
                    task.wait()
                    converthoney()
                until gethiveballoon() == false or not kometa.toggles.convertballoons
            end
            temptable.converting = false
            temptable.act = temptable.act + 1
            if kometa.webhooking.convert then api.imagehook(temptable.webhook, "Total Honey: `"..game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.MeterHUD.HoneyMeter.Bar.TextLabel.Text.."`\nGained Honey: `"..api.suffixstring(temptable.honeycurrent - temptable.honeystart).."`\nElapsed Time: `"..api.toHMS(temptable.stats.runningfor).."`", "kometa ☄️", "https://static.wikia.nocookie.net/bee-swarm-simulator/images/f/f6/HoneyDrop.png/revision/latest/scale-to-width-down/90?cb=20200521143648&path-prefix=ru") end
            task.wait(6)
            if kometa.toggles.autoant and not game:GetService("Workspace").Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then farmant() end
            if kometa.toggles.autoquest then makequests() end
            if kometa.toggles.autoplanters then collectplanters() end
            if kometa.toggles.autokillmobs then 
                if temptable.act >= kometa.vars.monstertimer then
                    temptable.started.monsters = true
                    temptable.act = 0
                    killmobs() 
                    temptable.started.monsters = false
                end
            end
        end
    end
end end end)

task.spawn(function()
    while task.wait(1) do
		if kometa.toggles.killvicious and temptable.detected.vicious and temptable.converting == false and not temptable.started.monsters then
            temptable.started.vicious = true
            disableall()
			local vichumanoid = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
			for i,v in next, game.workspace.Particles:GetChildren() do
				for x in string.gmatch(v.Name, "Vicious") do
					if string.find(v.Name, "Vicious") then
						api.tween(1,CFrame.new(v.Position.x, v.Position.y, v.Position.z)) task.wait(1)
						api.tween(0.5, CFrame.new(v.Position.x, v.Position.y, v.Position.z)) task.wait(.5)
					end
				end
			end
			for i,v in next, game.workspace.Particles:GetChildren() do
				for x in string.gmatch(v.Name, "Vicious") do
                    while kometa.toggles.killvicious and temptable.detected.vicious do task.wait() if string.find(v.Name, "Vicious") then
                        for i=1, 4 do temptable.float = true vichumanoid.CFrame = CFrame.new(v.Position.x+10, v.Position.y, v.Position.z) task.wait(.3)
                        end
                    end end
                end
			end
            enableall()
			task.wait(1)
			temptable.float = false
            temptable.started.vicious = false
            temptable.stats.killedvicious = temptable.stats.killedvicious + 1
		end
	end
end)

task.spawn(function() while task.wait() do
    if kometa.toggles.killwindy and temptable.detected.windy and not temptable.converting and not temptable.started.vicious and not temptable.started.mondo and not temptable.started.monsters then
        temptable.started.windy = true
        wlvl = "" aw = false awb = false -- some variable for autowindy, yk?
        disableall()
        while kometa.toggles.killwindy and temptable.detected.windy do
            if not aw then
                for i,v in pairs(workspace.Monsters:GetChildren()) do
                    if string.find(v.Name, "Windy") then wlvl = v.Name aw = true -- we found windy!
                    end
                end
            end
            if aw then
                for i,v in pairs(workspace.Monsters:GetChildren()) do
                    if string.find(v.Name, "Windy") then
                        if v.Name ~= wlvl then
                            temptable.float = false task.wait(5) for i =1, 5 do gettoken(api.humanoidrootpart().Position) end -- collect tokens :yessir:
                            wlvl = v.Name
                        end
                    end
                end
            end
            if not awb then api.tween(1,temptable.gacf(temptable.windy, 5)) task.wait(1) awb = true end
            if awb and temptable.windy.Name == "Windy" then
                api.humanoidrootpart().CFrame = temptable.gacf(temptable.windy, 25) temptable.float = true task.wait()
            end
        end 
        enableall()
        temptable.stats.killedwindy = temptable.stats.killedwindy + 1
        temptable.float = false
        temptable.started.windy = false
    end
end end)

task.spawn(function() while task.wait(0.001) do
    if kometa.toggles.traincrab then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-259, 111.8, 496.4) * CFrame.fromEulerAnglesXYZ(0, 110, 90) temptable.float = true temptable.float = false end
    if kometa.toggles.autodig then workspace.NPCs.Onett.Onett["Porcelain Dipper"].ClickEvent:FireServer() if game.Players.LocalPlayer then if game.Players.LocalPlayer.Character then if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("ClickEvent", true) then clickevent = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("ClickEvent", true) or nil end end end if clickevent then clickevent:FireServer() end end end
    if kometa.toggles.farmrares then for k,v in next, game.workspace.Collectibles:GetChildren() do if v.CFrame.YVector.Y == 1 then if v.Transparency == 0 then decal = v:FindFirstChildOfClass("Decal") for e,r in next, kometa.rares do if decal.Texture == r or decal.Texture == "rbxassetid://"..r then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame break end end end end end end
    if kometa.toggles.farmtickets then for k,v in next, game.workspace.Collectibles:GetChildren() do if v.CFrame.YVector.Y == 1 then if v.Transparency == 0 then decal = v:FindFirstChildOfClass("Decal") if decal.Texture == '1674871631' or decal.Texture == "rbxassetid://1674871631" then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame break end end end end end
end end)

game:GetService("Workspace").Particles.Folder2.ChildAdded:Connect(function(child)
    if child.Name == "Sprout" then
        temptable.sprouts.detected = true
        temptable.sprouts.coords = child.CFrame
    end
end)
game:GetService("Workspace").Particles.Folder2.ChildRemoved:Connect(function(child)
    if child.Name == "Sprout" then
        task.wait(30)
        temptable.sprouts.detected = false
        temptable.sprouts.coords = ""
    end
    temptable.stats.farmedsprouts = temptable.stats.farmedsprouts + 1
end)

Workspace.Particles.ChildAdded:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = true
        if kometa.webhooking.vicious then api.imagehook(temptable.webhook, "Vicious Bee detected!", "kometa ☄️", "https://static.wikia.nocookie.net/bee-swarm-simulator/images/1/1f/Vicious_Bee.png/revision/latest/scale-to-width-down/350?cb=20181130115012&path-prefix=ru") end
    end
end)
Workspace.Particles.ChildRemoved:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = false
    end
end)
game:GetService("Workspace").NPCBees.ChildAdded:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3) temptable.windy = v temptable.detected.windy = true
        if kometa.webhooking.windy then api.imagehook(temptable.webhook, "Windy Bee detected!", "kometa ☄️", "https://static.wikia.nocookie.net/bee-swarm-simulator/images/8/85/Windy_Bee.png/revision/latest?cb=20200404000105") end
    end
end)
game:GetService("Workspace").NPCBees.ChildRemoved:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3) temptable.windy = nil temptable.detected.windy = false
    end
end)

task.spawn(function() while task.wait(.1) do
    if not temptable.converting then
        if kometa.toggles.autodonate then
            game.ReplicatedStorage.Events.WindShrineDonation:InvokeServer(kometa.vars.donatit[1], kometa.vars.donatit[2])
            game.ReplicatedStorage.Events.WindShrineTrigger:FireServer()
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-Vector3.new(-484, 142, 413)).magnitude < 35 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if kometa.toggles.autosamovar then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Samovar")
            platformm = game:GetService("Workspace").Toys.Samovar.Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if kometa.toggles.autostockings then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Stockings")
            platformm = game:GetService("Workspace").Toys.Stockings.Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if kometa.toggles.autoonettart then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Onett's Lid Art")
            platformm = game:GetService("Workspace").Toys["Onett's Lid Art"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if kometa.toggles.autocandles then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honeyday Candles")
            platformm = game:GetService("Workspace").Toys["Honeyday Candles"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
        if kometa.toggles.autofeast then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Beesmas Feast")
            platformm = game:GetService("Workspace").Toys["Beesmas Feast"].Platform
            for i,v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position-platformm.Position).magnitude < 25 and v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
    end
end end)

task.spawn(function() while task.wait(1) do
    temptable.stats.runningfor = temptable.stats.runningfor + 1
    temptable.honeycurrent = statsget().Totals.Honey
    if kometa.toggles.honeystorm then game.ReplicatedStorage.Events.ToyEvent:FireServer("Honeystorm") end
    if kometa.toggles.collectgingerbreads then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Gingerbread House") end
    if kometa.toggles.autodispense then
        if kometa.dispensesettings.rj then local A_1 = "Free Royal Jelly Dispenser" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end
        if kometa.dispensesettings.blub then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Blueberry Dispenser") end
        if kometa.dispensesettings.straw then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Strawberry Dispenser") end
        if kometa.dispensesettings.treat then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Treat Dispenser") end
        if kometa.dispensesettings.coconut then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Coconut Dispenser") end
        if kometa.dispensesettings.glue then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Glue Dispenser") end
    end
    if kometa.toggles.autoboosters then 
        if kometa.dispensesettings.white then game.ReplicatedStorage.Events.ToyEvent:FireServer("Field Booster") end
        if kometa.dispensesettings.red then game.ReplicatedStorage.Events.ToyEvent:FireServer("Red Field Booster") end
        if kometa.dispensesettings.blue then game.ReplicatedStorage.Events.ToyEvent:FireServer("Blue Field Booster") end
    end
    if kometa.toggles.clock then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Wealth Clock") end
    if kometa.toggles.freeantpass then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Free Ant Pass Dispenser") end
    game.CoreGui.kometaUI.Container.Categories.Statistics.L["Statistics"].Container["Gained Honey"].Title.Text = "Gained Honey: "..api.suffixstring(temptable.honeycurrent - temptable.honeystart)
    game.CoreGui.kometaUI.Container.Categories.Statistics.L["Statistics"].Container["Elapsed Time"].Title.Text = "Elapsed Time: "..api.toHMS(temptable.stats.runningfor)
    game.CoreGui.kometaUI.Container.Categories.Statistics.L["Statistics"].Container["Farmed Sprouts"].Title.Text = "Farmed Sprouts: "..temptable.stats.farmedsprouts
    game.CoreGui.kometaUI.Container.Categories.Statistics.L["Statistics"].Container["Killed Windy"].Title.Text = "Killed Windy: "..temptable.stats.killedwindy
    game.CoreGui.kometaUI.Container.Categories.Statistics.L["Statistics"].Container["Killed Vicious"].Title.Text = "Killed Vicious: "..temptable.stats.killedvicious
    game.CoreGui.kometaUI.Container.Categories.Statistics.L["Statistics"].Container["Farmed Ants"].Title.Text = "Farmed Ants: "..temptable.stats.farmedants
end end)

game:GetService('RunService').Heartbeat:connect(function() 
    if kometa.toggles.autoquest then firesignal(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click) end
    if kometa.toggles.loopspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kometa.vars.walkspeed end
    if kometa.toggles.loopjump then game.Players.LocalPlayer.Character.Humanoid.JumpPower = kometa.vars.jumppower end
end)

game:GetService('RunService').Heartbeat:connect(function()
    for i,v in next, game.Players.LocalPlayer.PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren() do for k,q in next, v:WaitForChild("GuiGrid"):GetDescendants() do if q.Name == "ObjContent" or q.Name == "ObjImage" then q.Visible = true end end end
end)

game:GetService('RunService').Heartbeat:connect(function() 
    if temptable.float then game.Players.LocalPlayer.Character.Humanoid.BodyTypeScale.Value = 0 floatpad.CanCollide = true floatpad.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y-3.75, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z) task.wait(0)  else floatpad.CanCollide = false end
end)

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)task.wait(1)vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

task.spawn(function()while task.wait() do
    if kometa.toggles.farmsnowflakes then
        task.wait(3)
        for i,v in next, temptable.tokenpath:GetChildren() do
            if v:FindFirstChildOfClass("Decal") and v:FindFirstChildOfClass("Decal").Texture == "rbxassetid://6087969886" and v.Transparency == 0 then
                api.humanoidrootpart().CFrame = CFrame.new(v.Position.X, v.Position.Y+3, v.Position.Z)
                break
            end
        end
    end
end end)

game.Players.PlayerAdded:Connect(function(player)
    if kometa.webhooking.playeradded then api.imagehook(temptable.webhook, player.Name.." joined your server", "kometa ☄️", "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png") end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if kometa.toggles.autofarm then
            temptable.dead = true
            kometa.toggles.autofarm = false
            temptable.converting = false
            temptable.farmtoken = false
        end
        if temptable.dead then
            task.wait(25)
            temptable.dead = false
            kometa.toggles.autofarm = true local player = game.Players.LocalPlayer
            temptable.converting = false
            temptable.tokensfarm = true
        end
    end)
end)

game:GetService("Workspace").Particles:FindFirstChild('PopStars').ChildAdded:Connect(function(v)
    task.wait(.1)
    if (v.Position-api.humanoidrootpart().Position).magnitude < 15 then
        temptable.foundpopstar = true
    end
end)

game:GetService("Workspace").Particles:FindFirstChild('PopStars').ChildRemoved:Connect(function(v)
    if (v.Position-api.humanoidrootpart().Position).magnitude < 15 then
        temptable.foundpopstar = false
    end
end)

for _,v in next, game.workspace.Collectibles:GetChildren() do
    if string.find(v.Name,"") then
        v:Destroy()
    end
end 

task.spawn(function() while task.wait() do
    pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    task.wait(0.00001)
    currentSpeed = (pos-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
    if currentSpeed > 0 then
        temptable.running = true
    else
        temptable.running = false
    end
end end)

task.spawn(function() while task.wait(.00000000000000001) do
    if kometa.beessettings.usbtoggle then
        if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.TypeName.Text:match(kometa.beessettings.usb) then
            temptable.feed(kometa.beessettings.general.x, kometa.beessettings.general.y, "RoyalJelly")
        end
    end
    if kometa.beessettings.ugb then
        if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.TypeName.Text:match("Gifted") then
            temptable.feed(kometa.beessettings.general.x, kometa.beessettings.general.y, kometa.beessettings.foodtype)
        end
    end
    if kometa.beessettings.af then
        temptable.feed(kometa.beessettings.general.x, kometa.beessettings.general.y, kometa.beessettings.foodtype, kometa.beessettings.general.amount)
    end
    if kometa.beessettings.umb then
        if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.MutationFrame.MutationLabel.Text:match(kometa.beessettings.mutation) then
            temptable.feed(kometa.beessettings.general.x, kometa.beessettings.general.y, "Bitterberry", kometa.beessettings.general.amount)
        end
    end
end end)

-- Rendering game

game:GetService("UserInputService").WindowFocused:Connect(function()
	if kometa.toggles.disablerender then
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)

game:GetService("UserInputService").WindowFocusReleased:Connect(function()
	if kometa.toggles.disablerender then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end
end)

hives = game.Workspace.Honeycombs:GetChildren() for i = #hives, 1, -1 do  v = game.Workspace.Honeycombs:GetChildren()[i] if v.Owner.Value == nil then game.ReplicatedStorage.Events.ClaimHive:FireServer(v.HiveID.Value) end end
if _G.autoload then if isfile("kometa/BSS_".._G.autoload..".json") then kometa = game:service'HttpService':JSONDecode(readfile("kometa/BSS_".._G.autoload..".json")) end end
for _, part in next, workspace:FindFirstChild("FieldDecos"):GetDescendants() do if part:IsA("BasePart") then part.CanCollide = false part.Transparency = part.Transparency < 0.5 and 0.5 or part.Transparency task.wait() end end
for _, part in next, workspace:FindFirstChild("Decorations"):GetDescendants() do if part:IsA("BasePart") and (part.Parent.Name == "Bush" or part.Parent.Name == "Blue Flower") then part.CanCollide = false part.Transparency = part.Transparency < 0.5 and 0.5 or part.Transparency task.wait() end end
for i,v in next, workspace.Decorations.Misc:GetDescendants() do if v.Parent.Name == "Mushroom" then v.CanCollide = false v.Transparency = 0.5 end end
game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.MutationFrame.MutationLabel.Text = ""