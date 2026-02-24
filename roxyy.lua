local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/lelo0002/hai../refs/heads/main/roxylinoria.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/lelo0002/hai../refs/heads/main/theme.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options

local L = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local PlayersFolder = workspace:WaitForChild("Players")

local HudGui = PlayerGui:WaitForChild("HudScreenGui")
local Hud = HudGui.Main.DisplayStatus

local player = LocalPlayer
L.HideSleevesEnabled = false
L.AimbotEnabled = false
L.StickyAim = false
L.WallCheck = false
L.CachedTarget = nil
L.NextTargetUpdate = 0
L.MaxAimDistance = 500
L.CurrentFont = 2
L.SnapLineMethod = "Gun Barrel"
L.GunBarrel = nil
L.FovPositionMethod = "Mouse"
L.HasKnife = false

local FontMap = {
	["UI"] = 0,
	["System"] = 1,
	["Plex"] = 2,
	["Monospace"] = 3
}

local SafeFonts = {0, 1, 2, 3}

L.NameCache = {}
L.AimbotType = "Closest To Mouse"
L.Smoothness = 0.1
L.HideArmsEnabled = false
L.ArmTransparencyOriginals = {}
L.AimVelocity = 1200
L.TEAM = {
	PHANTOMS = Color3.fromRGB(155,182,255),
	GHOSTS = Color3.fromRGB(231,183,88)
}

L.BODY_COLOR = {
	PHANTOMS = Color3.fromRGB(54,75,90),
	GHOSTS = Color3.fromRGB(89,69,56)
}

L.SnapEnabled = false
L.ShowFOV = false
L.FOVRadius = 120
L.FOVColor = Color3.fromRGB(255,255,255)
L.AimKey = Enum.UserInputType.MouseButton2
L.HoldingKey = false
L.LockedTarget = nil
L.TARGET_UPDATE_RATE = 0.08

L.MESH_IDS = {
	Head = "6178917497",
	Torso = "11232478007"
}

L.OriginalClockTime = Lighting.ClockTime
L.CustomClockTimeEnabled = false
L.CustomClockTimeValue = 12

L.SelectedAimPart = "Head"
L.TARGET_MESH_ID = L.MESH_IDS[L.SelectedAimPart]
L.CurrentHumanoid = nil

L.DynamicFOVEnabled = false
L.DynamicFOVMultiplier = 1.85
L.DynamicFOVSpeedIn = 0.05
L.DynamicFOVSpeedOut = 0.05
L.SelectedSleeveTexture = "rbxassetid://2163189692"
local SleeveTextureIds = {
	Default = "rbxassetid://2163189692",
	Beach = "rbxassetid://7582881674",
	Camo = "rbxassetid://819001409"
}
L.ChamsType = "AlwaysOnTop"
L.CurrentFOVRadius = L.FOVRadius

L.KillConnection = nil
L.LastLockedModel = nil
L.KillNotifyEnabled = false

L.RayParams = RaycastParams.new()
L.RayParams.FilterType = Enum.RaycastFilterType.Exclude
L.RayParams.IgnoreWater = true



L.TARGET_WALKSPEED = 24
L.WalkSpeedEnabled = false
L.WSConnection = nil
L.WSChangedConn = nil

L.MasterEnabled = false
L.HighlightEnabled = false
L.WeaponMasterEnabled = false

L.ArmHighlights = {}
L.ArmsMaterialEnabled = false
L.ArmsMaterialColor = Color3.fromRGB(131,147,255)
L.ArmsMaterialEnum = Enum.Material.ForceField
L.ArmOriginals = {}

L.MaterialMap = {
	ForceField = Enum.Material.ForceField,
	Neon = Enum.Material.Neon,
	SmoothPlastic = Enum.Material.SmoothPlastic,
	Glass = Enum.Material.Glass,
	Metal = Enum.Material.Metal
}

L.FillColor = Color3.fromRGB(131,147,255)
L.OutlineColor = Color3.fromRGB(255,255,255)
L.HighlightFillTransparency = 0.4

L.WeaponHighlights = {}
L.WeaponHighlightEnabled = false
L.WeaponMaterialEnabled = false
L.WeaponMaterialColor = Color3.fromRGB(131,147,255)
L.WeaponMaterialEnum = Enum.Material.ForceField
L.WeaponMaterialOriginals = {}

L.HideGunEnabled = false
L.HideGunOriginals = {}

L.HealthESPEnabled = false
L.HealthHighColor = Color3.fromRGB(0,255,0)
L.HealthLowColor = Color3.fromRGB(255,0,0)

L.WeaponMaterialMap = {
	ForceField = Enum.Material.ForceField,
	Neon = Enum.Material.Neon,
	SmoothPlastic = Enum.Material.SmoothPlastic,
	Glass = Enum.Material.Glass,
	Metal = Enum.Material.Metal
}

L.WeaponFillColor = Color3.fromRGB(131,147,255)
L.WeaponOutlineColor = Color3.fromRGB(255,255,255)
L.WeaponFillTransparency = 0.4

L.OriginalValues = {
	Ambient = Lighting.Ambient
}

L.CAmbientColor = Color3.fromRGB(131,147,255)
L.ChamsEnabled = false
L.ViewModelEnabled = false

L.Offset = Vector3.zero
L.Roots = {}
L.BaseCF = {}
L.LastScan = 0
L.ScanInterval = 0.25

L.ChamsColor = Color3.fromRGB(131,147,255)
L.ChamsTransparency = 0.5
L.ChamsShrinkDefault = 1.2

L.DistanceESPEnabled = false
L.DistanceMax = 750
L.DistanceTextColor = Color3.fromRGB(255,255,255)
L.DistanceDrawings = {}
L.DistanceTorsoCache = {}
L.DistanceTeamTick = 0

L.ActiveChams = {}
L.ChamsLastTeamCheck = 0

L.NameESPEnabled = false

L.SkyboxEnabled = false
L.SelectedSky = "Pink"
L.Skyboxes = {
    Space = {
        Bk = "rbxassetid://159454299",
        Dn = "rbxassetid://159454296",
        Ft = "rbxassetid://159454293",
        Lf = "rbxassetid://159454286",
        Rt = "rbxassetid://159454300",
        Up = "rbxassetid://159454288"
    },
    Dark = {
        Bk = "rbxassetid://12064107",
        Dn = "rbxassetid://12064152",
        Ft = "rbxassetid://12064121",
        Lf = "rbxassetid://12063984",
        Rt = "rbxassetid://12064115",
        Up = "rbxassetid://12064131"
    },
    Pink = {
        Bk = "rbxassetid://11427769401",
        Dn = "rbxassetid://11427770685",
        Ft = "rbxassetid://11427769401",
        Lf = "rbxassetid://11427769401",
        Rt = "rbxassetid://11427769401",
        Up = "rbxassetid://11427771954"
    },
    PurpleNebula = {
        Bk = "rbxassetid://129876530632297",
        Dn = "rbxassetid://108406529909981",
        Ft = "rbxassetid://104400530594543",
        Lf = "rbxassetid://73372229972523",
        Rt = "rbxassetid://87408857415924",
        Up = "rbxassetid://137817405681365"
    },
    Red = {
        Bk = "rbxassetid://401664839",
        Dn = "rbxassetid://401664862",
        Ft = "rbxassetid://401664960",
        Lf = "rbxassetid://401664881",
        Rt = "rbxassetid://401664901",
        Up = "rbxassetid://401664936"
    },
    White = {
        Bk = "rbxassetid://6213159304",
        Dn = "rbxassetid://6213218651",
        Ft = "rbxassetid://6213159304",
        Lf = "rbxassetid://6213159304",
        Rt = "rbxassetid://6213159304",
        Up = "rbxassetid://6213176544"
    },
    Cartoon1 = {
        Bk = "rbxassetid://15114954171",
        Dn = "rbxassetid://15114958869",
        Ft = "rbxassetid://15114963740",
        Lf = "rbxassetid://15114957947",
        Rt = "rbxassetid://15114955238",
        Up = "rbxassetid://15114948718"
    },
    Cartoon2 = {
        Bk = "rbxassetid://6295671271",
        Dn = "rbxassetid://6295671382",
        Ft = "rbxassetid://6295671136",
        Lf = "rbxassetid://6295670996",
        Rt = "rbxassetid://6295671509",
        Up = "rbxassetid://6295671667"
    },
    PurpleClouds = {
        Bk = "rbxassetid://151165214",
        Dn = "rbxassetid://151165197",
        Ft = "rbxassetid://151165224",
        Lf = "rbxassetid://151165191",
        Rt = "rbxassetid://151165206",
        Up = "rbxassetid://151165227"
    },
    CloudySkies = {
        Bk = "rbxassetid://151165214",
        Dn = "rbxassetid://151165197",
        Ft = "rbxassetid://151165224",
        Lf = "rbxassetid://151165191",
        Rt = "rbxassetid://151165206",
        Up = "rbxassetid://151165227"
    },
    PurpleAndBlue = {
        Bk = "rbxassetid://149397692",
        Dn = "rbxassetid://149397686",
        Ft = "rbxassetid://149397697",
        Lf = "rbxassetid://149397684",
        Rt = "rbxassetid://149397688",
        Up = "rbxassetid://149397702"
    },
    VividSkies = {
        Bk = "rbxassetid://271042516",
        Dn = "rbxassetid://271077243",
        Ft = "rbxassetid://271042556",
        Lf = "rbxassetid://271042310",
        Rt = "rbxassetid://271042467",
        Up = "rbxassetid://271077958"
    },
    Twighlight = {
        Bk = "rbxassetid://264908339",
        Dn = "rbxassetid://264907909",
        Ft = "rbxassetid://264909420",
        Lf = "rbxassetid://264909758",
        Rt = "rbxassetid://264908886",
        Up = "rbxassetid://264907379"
    },
    Vaporwave = {
        Bk = "rbxassetid://1417494030",
        Dn = "rbxassetid://1417494146",
        Ft = "rbxassetid://1417494253",
        Lf = "rbxassetid://1417494402",
        Rt = "rbxassetid://1417494499",
        Up = "rbxassetid://1417494643"
    },
    Clouds = {
        Bk = "rbxassetid://570557514",
        Dn = "rbxassetid://570557775",
        Ft = "rbxassetid://570557559",
        Lf = "rbxassetid://570557620",
        Rt = "rbxassetid://570557672",
        Up = "rbxassetid://570557727"
    },
    NightSky = {
        Bk = "rbxassetid://12064107",
        Dn = "rbxassetid://12064152",
        Ft = "rbxassetid://12064121",
        Lf = "rbxassetid://12063984",
        Rt = "rbxassetid://12064115",
        Up = "rbxassetid://12064131"
    },
    SettingSun = {
        Bk = "rbxassetid://626460377",
        Dn = "rbxassetid://626460216",
        Ft = "rbxassetid://626460513",
        Lf = "rbxassetid://626473032",
        Rt = "rbxassetid://626458639",
        Up = "rbxassetid://626460625"
    },
    FadeBlue = {
        Bk = "rbxassetid://153695414",
        Dn = "rbxassetid://153695352",
        Ft = "rbxassetid://153695452",
        Lf = "rbxassetid://153695320",
        Rt = "rbxassetid://153695383",
        Up = "rbxassetid://153695471"
    },
    ElegantMorning = {
        Bk = "rbxassetid://153767241",
        Dn = "rbxassetid://153767216",
        Ft = "rbxassetid://153767266",
        Lf = "rbxassetid://153767200",
        Rt = "rbxassetid://153767231",
        Up = "rbxassetid://153767288"
    },
    Neptune = {
        Bk = "rbxassetid://218955819",
        Dn = "rbxassetid://218953419",
        Ft = "rbxassetid://218954524",
        Lf = "rbxassetid://218958493",
        Rt = "rbxassetid://218957134",
        Up = "rbxassetid://218950090"
    },
    Redshift = {
        Bk = "rbxassetid://401664839",
        Dn = "rbxassetid://401664862",
        Ft = "rbxassetid://401664960",
        Lf = "rbxassetid://401664881",
        Rt = "rbxassetid://401664901",
        Up = "rbxassetid://401664936"
    },
    AestheticNight = {
        Bk = "rbxassetid://1045964490",
        Dn = "rbxassetid://1045964368",
        Ft = "rbxassetid://1045964655",
        Lf = "rbxassetid://1045964655",
        Rt = "rbxassetid://1045964655",
        Up = "rbxassetid://1045962969"
    }
}
L.NameDrawings = {}
L.NameHeadCache = {}

L.NoJumpCooldownEnabled = false
L.HoldingJump = false

L.BoxESPEnabled = false
L.BoxDrawings = {}
L.BoxOutlineDrawings = {}
L.BoxColor = Color3.fromRGB(255,255,255)
L.BoxThickness = 0.5
L.BoxOutlineThickness = 3
L.BoxMaxDistance = L.DistanceMax

L.GunshotOverride = false
L.SelectedSound = "Minecraft experience"
L.SoundVolume = 1
L.SoundBackup = {}
L.ValidSoundIds = {}

L.SoundMap = {
	["Minecraft experience"] = "rbxassetid://7151570575",
	Neverlose = "rbxassetid://8726881116",
	Gamesense = "rbxassetid://4817809188",
	One = "rbxassetid://7380502345",
	Bell = "rbxassetid://6534947240",
	Rust = "rbxassetid://1255040462",
	TF2 = "rbxassetid://2868331684",
	Slime = "rbxassetid://6916371803",
	["Among Us"] = "rbxassetid://5700183626",
	Minecraft = "rbxassetid://4018616850",
	["CS:GO"] = "rbxassetid://6937353691",
	Saber = "rbxassetid://8415678813",
	Baimware = "rbxassetid://3124331820",
	Osu = "rbxassetid://7149255551",
	["TF2 Critical"] = "rbxassetid://296102734",
	Bat = "rbxassetid://3333907347",
	["Call of Duty"] = "rbxassetid://5952120301",
	Bubble = "rbxassetid://6534947588",
	Pick = "rbxassetid://1347140027",
	Pop = "rbxassetid://198598793",
	Bruh = "rbxassetid://4275842574",
	["[Bamboo]"] = "rbxassetid://3769434519",
	Crowbar = "rbxassetid://546410481",
	Weeb = "rbxassetid://6442965016",
	Beep = "rbxassetid://8177256015",
	Bambi = "rbxassetid://8437203821",
	Stone = "rbxassetid://3581383408",
	["Old Fatality"] = "rbxassetid://6607142036",
	Click = "rbxassetid://8053704437",
	Ding = "rbxassetid://7149516994",
	Snow = "rbxassetid://6455527632",
	Laser = "rbxassetid://7837461331",
	Mario = "rbxassetid://2815207981",
	Steve = "rbxassetid://4965083997",
	Snowdrake = "rbxassetid://7834724809",
	Default = "rbxassetid://4581728529"
}
L.HitSoundSelected = "rbxassetid://8726881116"
L.HitSoundVolume = 1
L.HitSoundOverride = false
L.HitSoundBackup = {}
L.HitSoundMap = {
	["Minecraft experience"] = "rbxassetid://7151570575",
	Neverlose = "rbxassetid://8726881116",
	Gamesense = "rbxassetid://4817809188",
	One = "rbxassetid://7380502345",
	Bell = "rbxassetid://6534947240",
	Rust = "rbxassetid://1255040462",
	TF2 = "rbxassetid://2868331684",
	Slime = "rbxassetid://6916371803",
	["Among Us"] = "rbxassetid://5700183626",
	Minecraft = "rbxassetid://4018616850",
	["CS:GO"] = "rbxassetid://6937353691",
	Saber = "rbxassetid://8415678813",
	Baimware = "rbxassetid://3124331820",
	Osu = "rbxassetid://7149255551",
	["TF2 Critical"] = "rbxassetid://296102734",
	Bat = "rbxassetid://3333907347",
	["Call of Duty"] = "rbxassetid://5952120301",
	Bubble = "rbxassetid://6534947588",
	Pick = "rbxassetid://1347140027",
	Pop = "rbxassetid://198598793",
	Bruh = "rbxassetid://4275842574",
	["[Bamboo]"] = "rbxassetid://3769434519",
	Crowbar = "rbxassetid://546410481",
	Weeb = "rbxassetid://6442965016",
	Beep = "rbxassetid://8177256015",
	Bambi = "rbxassetid://8437203821",
	Stone = "rbxassetid://3581383408",
	["Old Fatality"] = "rbxassetid://6607142036",
	Click = "rbxassetid://8053704437",
	Ding = "rbxassetid://7149516994",
	Snow = "rbxassetid://6455527632",
	Laser = "rbxassetid://7837461331",
	Mario = "rbxassetid://2815207981",
	Steve = "rbxassetid://4965083997",
	Snowdrake = "rbxassetid://7834724809",
	Default = "rbxassetid://4581728529"
}
L.KillSoundSelected = "rbxassetid://4817809188"
L.KillSoundVolume = 1
L.KillSoundOverride = false
L.KillSoundBackup = {}
L.KillSoundMap = {
	["Minecraft experience"] = "rbxassetid://7151570575",
	Neverlose = "rbxassetid://8726881116",
	Gamesense = "rbxassetid://4817809188",
	One = "rbxassetid://7380502345",
	Bell = "rbxassetid://6534947240",
	Rust = "rbxassetid://1255040462",
	TF2 = "rbxassetid://2868331684",
	Slime = "rbxassetid://6916371803",
	["Among Us"] = "rbxassetid://5700183626",
	Minecraft = "rbxassetid://4018616850",
	["CS:GO"] = "rbxassetid://6937353691",
	Saber = "rbxassetid://8415678813",
	Baimware = "rbxassetid://3124331820",
	Osu = "rbxassetid://7149255551",
	["TF2 Critical"] = "rbxassetid://296102734",
	Bat = "rbxassetid://3333907347",
	["Call of Duty"] = "rbxassetid://5952120301",
	Bubble = "rbxassetid://6534947588",
	Pick = "rbxassetid://1347140027",
	Pop = "rbxassetid://198598793",
	Bruh = "rbxassetid://4275842574",
	["[Bamboo]"] = "rbxassetid://3769434519",
	Crowbar = "rbxassetid://546410481",
	Weeb = "rbxassetid://6442965016",
	Beep = "rbxassetid://8177256015",
	Bambi = "rbxassetid://8437203821",
	Stone = "rbxassetid://3581383408",
	["Old Fatality"] = "rbxassetid://6607142036",
	Click = "rbxassetid://8053704437",
	Ding = "rbxassetid://7149516994",
	Snow = "rbxassetid://6455527632",
	Laser = "rbxassetid://7837461331",
	Mario = "rbxassetid://2815207981",
	Steve = "rbxassetid://4965083997",
	Snowdrake = "rbxassetid://7834724809",
	Default = "rbxassetid://4581728529"
}
if not L.HitSoundSelected then
	L.HitSoundSelected = "rbxassetid://8726881116"
end
if not L.KillSoundSelected then
	L.KillSoundSelected = "rbxassetid://4817809188"
end

local WeaponRoots = {
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["TWO HAND BLUNT"],
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["ASSAULT RIFLE"],
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["BATTLE RIFLE"],
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.CARBINE,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.DMR,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.FRAGMENTATION,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["HIGH EXPLOSIVE"],
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.IMPACT,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.LMG,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["MACHINE PISTOLS"],
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["ONE HAND BLADE"],
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["ONE HAND BLUNT"],
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.OTHER,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.PDW,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.PISTOLS,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.REVOLVERS,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase.SHOTGUN,
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["SNIPER RIFLE"],
	ReplicatedStorage.Content.ProductionContent.WeaponDatabase["TWO HAND BLADE"]
}

L.CrosshairTop = true
L.CrosshairRight = true
L.CrosshairBottom = true
L.CrosshairLeft = true

local STYLE_SIDES = {
	["1"] = {Top=true, Right=true, Bottom=true, Left=true},
	["2"] = {Top=true, Right=false, Bottom=true, Left=false},
	["3"] = {Top=true, Right=true, Bottom=true, Left=false}
}

L.CrosshairEnabled = false
L.CrosshairColor = Color3.fromRGB(255,255,255)
L.CrosshairSpin = false
L.CrosshairSize = 25
L.CrosshairSpinSpeed = 25
L.CrosshairThickness = 2
L.CrosshairGap = 6
L.CrosshairSides = {Top=true, Bottom=true, Left=true, Right=true}
L.CrosshairPositionMode = "Center Of Screen"
L.SilentEnabled = false
L.SilentHolding = false
L.SilentSticky = false
L.SilentWallCheck = false
L.SilentHitChance = 50
L.SilentPriority = "Closest To Mouse"
L.SilentShowFOV = false
L.SilentDynamicFOV = false
L.SilentFOVRadius = 120
L.SilentCurrentFOV = 120
L.SilentFOVColor = Color3.fromRGB(255,255,255)
L.SilentSnapEnabled = false
L.SilentSnapColor = Color3.fromRGB(255,255,255)
L.SilentSnapOriginMethod = "Gun Barrel"
L.SilentFOVOriginMethod = "Gun Barrel"
L.SilentLockedPart = nil
L.SilentMaxAimDistance = 500
L.SilentOriginalCF = nil
L.SilentHeartbeat = nil
L.SILENT_MESH_IDS = {
	Head = "6178917497",
	Torso = "11232478007"
}
L.SilentAimPart = "Head"
L.SILENT_TARGET_MESH = L.SILENT_MESH_IDS[L.SilentAimPart]

				local function cleanupHumanoid()
					if L.WSChangedConn then L.WSChangedConn:Disconnect() L.WSChangedConn = nil end
				end
				local function hookHumanoid(humanoid)
					cleanupHumanoid()
					L.CurrentHumanoid = humanoid
					humanoid.WalkSpeed = L.TARGET_WALKSPEED
					L.WSChangedConn = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
						if L.WalkSpeedEnabled and humanoid.WalkSpeed ~= L.TARGET_WALKSPEED then
							humanoid.WalkSpeed = L.TARGET_WALKSPEED
						end
					end)
				end
				local function findHumanoid()
					local ignore = workspace:FindFirstChild("Ignore")
					if not ignore then return nil end
					for _, obj in ipairs(ignore:GetDescendants()) do
						if obj:IsA("Humanoid") and obj.Parent and obj.Parent:FindFirstChild("HumanoidRootPart") then
							return obj
						end
					end
				end
				local function startWalkSpeedLock()
					if L.WSConnection then return end
					L.WSConnection = RunService.RenderStepped:Connect(function()
						if not L.WalkSpeedEnabled then return end
						if not L.CurrentHumanoid or not L.CurrentHumanoid:IsDescendantOf(workspace) then
							local hum = findHumanoid()
							if hum then hookHumanoid(hum) end
							return
						end
						if L.CurrentHumanoid.WalkSpeed ~= L.TARGET_WALKSPEED then
							L.CurrentHumanoid.WalkSpeed = L.TARGET_WALKSPEED
						end
					end)
				end
				local function stopWalkSpeedLock()
					L.WalkSpeedEnabled = false
					cleanupHumanoid()
					if L.WSConnection then L.WSConnection:Disconnect() L.WSConnection = nil end
					L.CurrentHumanoid = nil
				end
				local function ClearAll()
					for _, h in pairs(L.ArmHighlights) do pcall(function() h:Destroy() end) end
					table.clear(L.ArmHighlights)
				end
				local function SetSleeveSlotsTransparency(value)
					for _, obj in ipairs(Camera:GetChildren()) do
						if obj:IsA("Model") then
							local sleeves = obj:FindFirstChild("Sleeves", true)
							if sleeves and sleeves:IsA("MeshPart") then
								if sleeves.Transparency ~= value then
									sleeves.Transparency = value
								end
								for _, tex in ipairs(sleeves:GetChildren()) do
									if tex:IsA("Texture") and tex.Name == "Slot1" and tex.Transparency ~= value then
										tex.Transparency = value
									end
								end
							end
						end
					end
				end
				local function CreateHighlight(part)
					if L.ArmHighlights[part] or not L.HighlightEnabled then return end
					if not part:IsA("MeshPart") or part.Name ~= "SkinTone" then return end
					local h = Instance.new("Highlight")
					h.Adornee = part
					h.FillColor = L.FillColor
					h.OutlineColor = L.OutlineColor
					h.FillTransparency = L.HighlightFillTransparency
					h.OutlineTransparency = 0
					h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					h.Parent = part
					L.ArmHighlights[part] = h
				end
				local function getArmModels()
					local arms = {}
					for _, obj in ipairs(Camera:GetChildren()) do
						if obj:IsA("Model") then
							if obj:FindFirstChild("SkinTone", true) then
								table.insert(arms, obj)
							end
						end
					end
					return arms
				end
				local function applyArmMaterial()
					for _, model in ipairs(getArmModels()) do
						for _, part in ipairs(model:GetDescendants()) do
							if part:IsA("MeshPart") then
								if not L.ArmOriginals[part] then
									L.ArmOriginals[part] = { Material = part.Material, Color = part.Color }
								end
								if part.Material ~= L.ArmsMaterialEnum then
									part.Material = L.ArmsMaterialEnum
								end
								if part.Color ~= L.ArmsMaterialColor then
									part.Color = L.ArmsMaterialColor
								end
							end
						end
					end
				end
				local function restoreArmMaterial()
					for part, data in pairs(L.ArmOriginals) do
						if part and part:IsDescendantOf(Camera) then
							part.Material = data.Material
							part.Color = data.Color
						end
					end
					table.clear(L.ArmOriginals)
				end
				RunService.Heartbeat:Connect(function()
					if L.MasterEnabled and L.ArmsMaterialEnabled then
						applyArmMaterial()
					elseif not L.MasterEnabled then
						restoreArmMaterial()
					end
				end)
RunService.Heartbeat:Connect(function()
	if not L.MasterEnabled then
		for part, h in pairs(L.ArmHighlights) do
			pcall(function() h:Destroy() end)
			L.ArmHighlights[part] = nil
		end
		return
	end

	if L.HideSleevesEnabled then
		SetSleeveSlotsTransparency(1)
	end

	for part, h in pairs(L.ArmHighlights) do
		if not part or not part:IsDescendantOf(Camera) or not L.HighlightEnabled then
			pcall(function() h:Destroy() end)
			L.ArmHighlights[part] = nil
		end
	end

	if not L.HighlightEnabled then return end

	for _, obj in ipairs(Camera:GetDescendants()) do
		if obj:IsA("MeshPart") and obj.Name == "SkinTone" then
			CreateHighlight(obj)
		end
	end
end)

local function modelHasSleeves(model)
	return model:FindFirstChild("Sleeves", true) ~= nil
end
local function getWeaponModel()
	for _, model in ipairs(Camera:GetChildren()) do
		if model:IsA("Model") and not modelHasSleeves(model) then
			return model
		end
	end
	return nil
end
				local function clearWeaponHighlights()
					for _, h in pairs(L.WeaponHighlights) do pcall(function() h:Destroy() end) end
					table.clear(L.WeaponHighlights)
				end
				local function applyWeaponHighlight(model)
					if not model or L.WeaponHighlights[model] or not L.WeaponHighlightEnabled then return end
					local h = Instance.new("Highlight")
					h.Adornee = model
					h.FillColor = L.WeaponFillColor
					h.OutlineColor = L.WeaponOutlineColor
					h.FillTransparency = L.WeaponFillTransparency
					h.OutlineTransparency = 0
					h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					h.Parent = model
					L.WeaponHighlights[model] = h
				end
				RunService.Heartbeat:Connect(function()
					if not L.WeaponMasterEnabled then return end
					local weaponModel = getWeaponModel()
					for model, h in pairs(L.WeaponHighlights) do
						if not model or not model:IsDescendantOf(Camera) or not L.WeaponHighlightEnabled or model ~= weaponModel then
							pcall(function() h:Destroy() end)
							L.WeaponHighlights[model] = nil
						end
					end
					if not L.WeaponHighlightEnabled then return end
					if weaponModel then applyWeaponHighlight(weaponModel) end
				end)
				local function applyWeaponMaterial(model)
					if not model then return end
					for _, part in ipairs(model:GetDescendants()) do
						if part:IsA("MeshPart") then
							if not L.WeaponMaterialOriginals[part] then
								L.WeaponMaterialOriginals[part] = {
									Material = part.Material,
									Color = part.Color
								}
							end
							if part.Material ~= L.WeaponMaterialEnum then
								part.Material = L.WeaponMaterialEnum
							end
							if part.Color ~= L.WeaponMaterialColor then
								part.Color = L.WeaponMaterialColor
							end
						end
					end
				end
				local function restoreWeaponMaterial()
					for part, data in pairs(L.WeaponMaterialOriginals) do
						if part and part:IsDescendantOf(Camera) then
							part.Material = data.Material
							part.Color = data.Color
						end
					end
					table.clear(L.WeaponMaterialOriginals)
				end
				local function applyHideGun(model)
					if not model then return end
					for _, part in ipairs(model:GetDescendants()) do
						if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") then
							if not L.HideGunOriginals[part] then
								L.HideGunOriginals[part] = {
									Trans = part.Transparency,
									LTrans = part:IsA("BasePart") and part.LocalTransparencyModifier or nil
								}
							end
							if part.Transparency ~= 1 then
								part.Transparency = 1
							end
							if part:IsA("BasePart") and part.LocalTransparencyModifier ~= 1 then
								part.LocalTransparencyModifier = 1
							end
						end
					end
				end
				local function restoreHideGun()
					for part, data in pairs(L.HideGunOriginals) do
						if part and part:IsDescendantOf(Camera) then
							if type(data) == "table" then
								part.Transparency = data.Trans
								if part:IsA("BasePart") and data.LTrans then
									part.LocalTransparencyModifier = data.LTrans
								end
							else
								part.Transparency = data
							end
						end
					end
					table.clear(L.HideGunOriginals)
				end
				RunService.Heartbeat:Connect(function()
					if L.WeaponMasterEnabled then
						local weaponModel = getWeaponModel()
						if weaponModel then
							if L.WeaponMaterialEnabled then
								applyWeaponMaterial(weaponModel)
							end
						end
					end
					if not L.WeaponMasterEnabled or not L.WeaponMaterialEnabled then
						restoreWeaponMaterial()
					end
					if not L.WeaponMasterEnabled or not L.HideGunEnabled then
						restoreHideGun()
					end
				end)
				RunService.RenderStepped:Connect(function()
					if L.WeaponMasterEnabled and L.HideGunEnabled then
						local weaponModel = getWeaponModel()
						if weaponModel then
							applyHideGun(weaponModel)
						end
					end
				end)

				local SnapOutline = Drawing.new("Line")
				SnapOutline.Thickness = 3
				SnapOutline.Color = Color3.new(0, 0, 0)
				SnapOutline.Transparency = 1
				SnapOutline.Visible = false
				local SnapLine = Drawing.new("Line")
				SnapLine.Thickness = 1
				SnapLine.Color = Color3.fromRGB(255, 255, 255)
				SnapLine.Transparency = 1
				SnapLine.Visible = false
				local FOVOutline = Drawing.new("Circle")
				FOVOutline.Filled = false
				FOVOutline.Thickness = 3
				FOVOutline.Color = Color3.new(0,0,0)
				FOVOutline.Transparency = 1
				FOVOutline.Visible = false
				local FOVCircle = Drawing.new("Circle")
				FOVCircle.Filled = false
				FOVCircle.Thickness = 1
				FOVCircle.Color = L.FOVColor
				FOVCircle.Transparency = 1
				FOVCircle.Visible = false
				local function isOnScreen(part)
					local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
					return onScreen
				end
				local function isVisible(part)
					if not L.WallCheck then
						return true
					end
					if not part or not part:IsA("BasePart") or not part:IsDescendantOf(workspace) then
						return false
					end
					if not isOnScreen(part) then
						return false
					end
					local origin = Camera.CFrame.Position
					local targetPos = part.Position
					local direction = targetPos - origin
					local distance = direction.Magnitude
					direction = direction.Unit * (distance + 0.5)
					local params = RaycastParams.new()
					params.FilterType = Enum.RaycastFilterType.Exclude
					params.FilterDescendantsInstances = {
						LocalPlayer.Character,
						Camera
					}
					params.IgnoreWater = true
					local result = workspace:Raycast(origin, direction, params)
					if not result then
						return true
					end
					if result.Instance:IsDescendantOf(part.Parent) then
						return true
					end
					local tolerance = part.Size.Magnitude * 0.75
					if (result.Position - targetPos).Magnitude <= tolerance then
						return true
					end
					return false
				end
				local LocalTeam = nil
				local validPatternSleeves = nil
				local function getLocalTeam()
					if validPatternSleeves and validPatternSleeves:IsDescendantOf(Camera) then
						local tex = validPatternSleeves:FindFirstChild("Slot1")
						if tex and tex:IsA("Texture") then
							local c = tex.Color3
							if c == L.TEAM.PHANTOMS then return "PHANTOMS"
							elseif c == L.TEAM.GHOSTS then return "GHOSTS" end
						end
					end
					for _, obj in ipairs(Camera:GetDescendants()) do
						if obj:IsA("MeshPart") and obj.Name == "Sleeves" then
							validPatternSleeves = obj
							for _, tex in ipairs(obj:GetChildren()) do
								if tex:IsA("Texture") and tex.Name == "Slot1" then
									local c = tex.Color3
									if c == L.TEAM.PHANTOMS then
										return "PHANTOMS"
									elseif c == L.TEAM.GHOSTS then
										return "GHOSTS"
									end
								end
							end
						end
					end
					return nil
				end
				local function isEnemy(part)
					if not LocalTeam then return false end
					if not part or not part:IsDescendantOf(workspace) then return false end
					local pparent = part.Parent
					local torso
					for _, p in ipairs(pparent:GetChildren()) do
						if p:IsA("MeshPart") and p.MeshId and p.MeshId:find(L.MESH_IDS.Torso) then
							torso = p
							break
						end
					end
					if not torso then return false end
					local torsoColor = torso.Color
					if LocalTeam == "PHANTOMS" then
						return torsoColor == L.BODY_COLOR.GHOSTS
					elseif LocalTeam == "GHOSTS" then
						return torsoColor == L.BODY_COLOR.PHANTOMS
					end
					return false
				end
				local function checkEnemyByModel(model)
					local torso = L.DistanceTorsoCache and L.DistanceTorsoCache[model]
					if torso == false then return false end
					if not torso or not torso:IsDescendantOf(model) then
						for _,v in ipairs(model:GetDescendants()) do
							if v:IsA("MeshPart") and v.MeshId and v.MeshId:find(L.MESH_IDS.Torso) then
								torso = v
								if L.DistanceTorsoCache then L.DistanceTorsoCache[model] = v end
								break
							end
						end
					end
					if not torso then 
						if L.DistanceTorsoCache then L.DistanceTorsoCache[model] = false end
						return false 
					end
					if not LocalTeam then return false end
					local c = torso.Color
					if LocalTeam == "PHANTOMS" then return c == L.BODY_COLOR.GHOSTS
					elseif LocalTeam == "GHOSTS" then return c == L.BODY_COLOR.PHANTOMS end
					return false
				end
				L.AimPartCache = L.AimPartCache or {}
				local function getCachedTargetPart(model)
					local c = L.AimPartCache[model]
					if c == false then return nil end
					if c and c:IsDescendantOf(model) and c.MeshId:find(L.TARGET_MESH_ID) then return c end
					for _, v in ipairs(model:GetDescendants()) do
						if v:IsA("MeshPart") and v.MeshId and v.MeshId:find(L.TARGET_MESH_ID) then
							L.AimPartCache[model] = v
							return v
						end
					end
					L.AimPartCache[model] = false
					return nil
				end
				local function getTargetParts()
					local t = {}
					for model, _ in pairs(L.NameDrawings or {}) do
						if checkEnemyByModel(model) then
							local part = getCachedTargetPart(model)
							if part then
								t[#t+1] = part
							end
						end
					end
					return t
				end
local function getClosestTarget()
	local camPos = Camera.CFrame.Position

	local origin
	if L.FovPositionMethod == "Gun Barrel" then
		if L.HasKnife or not L.GunBarrel or not L.GunBarrel:IsDescendantOf(Camera) then
			return nil
		end

		local forwardOffset = 7.5
		local worldPos = L.GunBarrel.Position + (L.GunBarrel.CFrame.LookVector * forwardOffset)

		local v, onScreen = Camera:WorldToViewportPoint(worldPos)
		if not onScreen then
			return nil
		end

		origin = Vector2.new(v.X, v.Y)
	else
		origin = UserInputService:GetMouseLocation()
	end

	local closest = nil
	local shortest = math.huge

	for _, part in ipairs(getTargetParts()) do
		if part and part:IsDescendantOf(workspace) then
			local worldDist = (camPos - part.Position).Magnitude
			if worldDist <= L.MaxAimDistance then
				local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
				if onScreen and isVisible(part) then
					local screenDist = (Vector2.new(pos.X, pos.Y) - origin).Magnitude
					if screenDist <= L.FOVRadius then
						if L.AimbotType == "Closest To You" then
							if worldDist < shortest then
								shortest = worldDist
								closest = part
							end
						else
							if screenDist < shortest then
								shortest = screenDist
								closest = part
							end
						end
					end
				end
			end
		end
	end

	return closest
end
				UserInputService.InputBegan:Connect(function(input, gpe)
					if gpe then return end
					if input.KeyCode == L.AimKey or input.UserInputType == L.AimKey then
						L.HoldingKey = true
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.KeyCode == L.AimKey or input.UserInputType == L.AimKey then
						L.HoldingKey = false
						L.LockedTarget = nil
						L.LastLockedModel = nil
						if L.KillConnection then
							L.KillConnection:Disconnect()
							L.KillConnection = nil
						end
					end
				end)
				RunService.Heartbeat:Connect(function()
					local newTeam = getLocalTeam()
					if newTeam and LocalTeam ~= newTeam then
						table.clear(L.EnemyCache)
						LocalTeam = newTeam
					end
				end)
				
local function applyHideArms()
	for _, model in ipairs(getArmModels()) do
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "Sleeves" then
				if not L.ArmTransparencyOriginals[part] then
					L.ArmTransparencyOriginals[part] = part.Transparency
				end
				if part.Transparency ~= 1 then
					part.Transparency = 1
				end
			end
		end
	end
end
local function restoreHideArms()
	for part, transparency in pairs(L.ArmTransparencyOriginals) do
		if part and part:IsDescendantOf(Camera) then
			part.Transparency = transparency
		end
	end
	table.clear(L.ArmTransparencyOriginals)
end

RunService.Heartbeat:Connect(function()
	if not L.MasterEnabled then
		restoreHideArms()
		SetSleeveSlotsTransparency(0)
		return
	end

	if L.HideArmsEnabled then
		applyHideArms()
	else
		restoreHideArms()
	end

	if L.HideSleevesEnabled then
		SetSleeveSlotsTransparency(1)
	else
		if not L.HideArmsEnabled then
			SetSleeveSlotsTransparency(0)
		end
	end
end)
local insert = table.insert
local ipairs = ipairs
local pairs = pairs
local clock = os.clock

L.ActiveChams = L.ActiveChams or {}
L.ChamsTicks = L.ChamsTicks or {}
L.CachedOnScreen = L.CachedOnScreen or {}
L.EnemyCache = L.EnemyCache or {}

L.StreamingHold = L.StreamingHold or {}
local STREAM_HOLD_TIME = 0.35

local function getTorso(model)
	local c=L.DistanceTorsoCache[model]
	if c == false then return nil end
	if c and c:IsDescendantOf(model) then return c end
	for _,v in ipairs(model:GetDescendants()) do
		if v:IsA("MeshPart") and v.MeshId and v.MeshId:find(L.MESH_IDS.Torso) then
			L.DistanceTorsoCache[model]=v
			return v
		end
	end
	L.DistanceTorsoCache[model]=false
	return nil
end





local function clearChams(model)
	local boxes = L.ActiveChams[model]
	if not boxes then return end
	for i = 1, #boxes do
		local b = boxes[i]
		if b and b.Parent then
			b:Destroy()
		end
	end
	L.ActiveChams[model] = nil
	L.ChamsTicks[model] = nil
	L.CachedOnScreen[model] = nil
end

local function isValidModel(model)
	return model:IsA("Model") and model:FindFirstChildWhichIsA("BasePart", true)
end

local function isEnemyModel(model)
	local cached = L.EnemyCache[model]
	if cached ~= nil then
		return cached
	end
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("MeshPart") and isEnemy(part) then
			L.EnemyCache[model] = true
			return true
		end
	end
	L.EnemyCache[model] = false
	return false
end

local function createBox(model, part, shrink)
	local boxes = L.ActiveChams[model]
	if not boxes then
		boxes = {}
		L.ActiveChams[model] = boxes
	end
	for i = 1, #boxes do
		local b = boxes[i]
		if b.Adornee == part then
			return b
		end
	end
	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = part
	box.AlwaysOnTop = (L.ChamsType == "AlwaysOnTop")
	box.ZIndex = box.AlwaysOnTop and 10 or 0
	box.Size = part.Size / shrink
	box.Color3 = L.ChamsColor
	box.Transparency = L.ChamsTransparency
	box.Parent = part
	insert(boxes, box)
	return box
end

local function applyChams(model)
	clearChams(model)
	local shrink = (L.ChamsType == "Occluded") and (L.ChamsShrinkDefault / 1.2) or L.ChamsShrinkDefault
	local boxes = {}
	L.ActiveChams[model] = boxes
	local color = L.ChamsColor
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local box = createBox(model, part, shrink)
			box.Color3 = color
		end
	end
end

local lastColor = L.ChamsColor
local lastTransparency = L.ChamsTransparency
local lastShrink = L.ChamsShrinkDefault
local lastType = L.ChamsType
local lastUpdate = 0
local lastCacheClean = 0

RunService.Heartbeat:Connect(function()
	if not L.ChamsEnabled then return end
	local now = clock()
	if now - lastUpdate < 0.09 then return end
	lastUpdate = now
	

	local colorChanged = lastColor ~= L.ChamsColor
	local transparencyChanged = lastTransparency ~= L.ChamsTransparency
	local shrinkChanged = lastShrink ~= L.ChamsShrinkDefault
	local typeChanged = lastType ~= L.ChamsType

	local shrink = (L.ChamsType == "Occluded") and (L.ChamsShrinkDefault / 1.2) or L.ChamsShrinkDefault
	local alwaysOnTop = (L.ChamsType == "AlwaysOnTop")
	local zIndex = alwaysOnTop and 10 or 0

	for model, boxes in pairs(L.ActiveChams) do
		if not model:IsDescendantOf(PlayersFolder) then
			local t = L.StreamingHold[model]
			if not t then
				L.StreamingHold[model] = clock()
			elseif clock() - t > STREAM_HOLD_TIME then
				L.StreamingHold[model] = nil
				clearChams(model)
				L.EnemyCache[model] = nil
			end
		else
			L.StreamingHold[model] = nil
			local torso = getTorso(model)
			
			local onScreen = true
			if torso then
				onScreen = isOnScreen(torso)
			end

			local finalColor = L.ChamsColor

			for i = 1, #boxes do
				local b = boxes[i]
				local a = b.Adornee
				if a then
					if b.Color3 ~= finalColor then
						b.Color3 = finalColor
					end
					if transparencyChanged then
						b.Transparency = L.ChamsTransparency
					end
					if shrinkChanged then
						b.Size = a.Size / shrink
					end
					if typeChanged then
						b.AlwaysOnTop = alwaysOnTop
						b.ZIndex = zIndex
					end
					if b.Visible ~= onScreen then
						b.Visible = onScreen
					end
				end
			end
		end
	end

	lastColor = L.ChamsColor
	lastTransparency = L.ChamsTransparency
	lastShrink = L.ChamsShrinkDefault
	lastType = L.ChamsType
end)

L.ChamsHooked = L.ChamsHooked or {}
local function hookModelRealtime(model)
	if not isValidModel(model) then return end
	if L.ChamsHooked[model] then return end
	L.ChamsHooked[model] = true

	local function refresh()
		L.EnemyCache[model] = nil
		if L.ChamsEnabled and isEnemyModel(model) then
			applyChams(model)
		else
			clearChams(model)
		end
	end
	refresh()
	
	model.DescendantAdded:Connect(function(d)
		if not L.ChamsEnabled or not d:IsA("BasePart") or not isEnemyModel(model) then return end
		local shrink = (L.ChamsType == "Occluded") and (L.ChamsShrinkDefault / 1.2) or L.ChamsShrinkDefault
		local box = createBox(model, d, shrink)
		box.Color3 = L.ChamsColor
	end)

	model.DescendantRemoving:Connect(function(d)
		if not d:IsA("BasePart") then return end
		local boxes = L.ActiveChams[model]
		if boxes then
			for i = #boxes, 1, -1 do
				local b = boxes[i]
				if not b or b.Adornee == d or not b.Parent then
					if b then b:Destroy() end
					table.remove(boxes, i)
				end
			end
		end
	end)

	model.AncestryChanged:Connect(function()
		L.StreamingHold[model] = nil
		refresh()
	end)
end

local function processChams(model)
	if not model or not isValidModel(model) then return end
	L.EnemyCache[model] = nil
	hookModelRealtime(model)
	if L.ChamsEnabled and isEnemyModel(model) then
		local color = L.ChamsColor
		for _, part in ipairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				local shrink = (L.ChamsType == "Occluded") and (L.ChamsShrinkDefault / 1.2) or L.ChamsShrinkDefault
				local box = createBox(model, part, shrink)
				box.Color3 = color
				box.Transparency = L.ChamsTransparency
				box.AlwaysOnTop = (L.ChamsType == "AlwaysOnTop")
				box.ZIndex = box.AlwaysOnTop and 10 or 0
			end
		end
	end
end

local function hookChamsFolder(folder)
	if not folder then return end
	for _, model in ipairs(folder:GetChildren()) do
		processChams(model)
	end
	folder.ChildAdded:Connect(function(m)
		if not m then return end
		processChams(m)
	end)
	folder.ChildRemoved:Connect(function(m)
		if not m then return end
		clearChams(m)
		L.EnemyCache[m] = nil
		L.ChamsHooked[m] = nil
	end)
end

for _, folder in ipairs(PlayersFolder:GetChildren()) do
	if folder and folder:IsA("Folder") then
		hookChamsFolder(folder)
	end
end

PlayersFolder.ChildAdded:Connect(function(folder)
	if folder and folder:IsA("Folder") then
		hookChamsFolder(folder)
	end
end)

				local function createDistance(model)
					if L.DistanceDrawings[model] then return end
					local d=Drawing.new("Text")
					d.Center=true
					d.Outline=true
					d.Size=13
					if table.find(SafeFonts, L.CurrentFont) then d.Font = L.CurrentFont end
					d.Color=L.DistanceTextColor
					d.Visible=false
					L.DistanceDrawings[model]=d
				end
				local function removeDistance(model)
					if L.DistanceDrawings[model] then
						L.DistanceDrawings[model]:Remove()
						L.DistanceDrawings[model]=nil
					end
					L.DistanceTorsoCache[model]=nil
				end
				local function hookDistanceModel(model)
					if not model:IsA("Model") then return end
					createDistance(model)
					for _,c in ipairs(model:GetChildren()) do
						if c:IsA("Model") then
							createDistance(c)
						end
					end
				end
				for _,folder in ipairs(PlayersFolder:GetChildren()) do
					if folder:IsA("Folder") then
						for _,model in ipairs(folder:GetChildren()) do
							hookDistanceModel(model)
						end
						folder.ChildAdded:Connect(hookDistanceModel)
						folder.ChildRemoved:Connect(removeDistance)
					end
				end
				PlayersFolder.ChildAdded:Connect(function(folder)
					if folder:IsA("Folder") then
						folder.ChildAdded:Connect(hookDistanceModel)
						folder.ChildRemoved:Connect(removeDistance)
					end
				end)

				local function getNameHead(model)
					local c = L.NameHeadCache[model]
					if c == false then return nil end
					if c and c:IsDescendantOf(model) then return c end
					for _, v in ipairs(model:GetDescendants()) do
						if v:IsA("MeshPart") and v.MeshId and v.MeshId:find(L.MESH_IDS.Head) then
							L.NameHeadCache[model] = v
							return v
						end
					end
					L.NameHeadCache[model] = false
					return nil
				end
				local function getPlayerName(model)
	local cached = L.NameCache[model]
	if cached ~= nil then
		return cached == false and nil or cached
	end

	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("TextLabel") and v.Name == "PlayerTag" then
			L.NameCache[model] = v.Text
			return v.Text
		end
	end
	L.NameCache[model] = false
	return nil
end
				local function createName(model)
					if L.NameDrawings[model] then return end
					local t = Drawing.new("Text")
					t.Center = true
					t.Outline = true
					t.Size = 13
					if table.find(SafeFonts, L.CurrentFont) then t.Font = L.CurrentFont end
					t.Color = L.NameTextColor or Color3.new(1,1,1)
					t.Visible = false
					L.NameDrawings[model] = t
				end
				local function removeName(model)
					if L.NameDrawings[model] then
						L.NameDrawings[model]:Remove()
						L.NameDrawings[model] = nil
					end
					L.NameHeadCache[model] = nil
				end
				local function hookNameModel(model)
					if not model:IsA("Model") then return end
					createName(model)
					for _, c in ipairs(model:GetChildren()) do
						if c:IsA("Model") then
							createName(c)
						end
					end
				end
				for _, folder in ipairs(PlayersFolder:GetChildren()) do
					if folder:IsA("Folder") then
						for _, model in ipairs(folder:GetChildren()) do
							hookNameModel(model)
						end
						folder.ChildAdded:Connect(hookNameModel)
						folder.ChildRemoved:Connect(removeName)
					end
				end
				PlayersFolder.ChildAdded:Connect(function(folder)
					if folder:IsA("Folder") then
						folder.ChildAdded:Connect(hookNameModel)
						folder.ChildRemoved:Connect(removeName)
					end
				end)
local FOVCachedTarget = nil
local FOVNextTargetUpdate = 0

RunService.RenderStepped:Connect(function(dt)
	local mousePos = UserInputService:GetMouseLocation()
	local baseFOV = L.FOVRadius
	local targetFOV = baseFOV

	if L.DynamicFOVEnabled and L.HoldingKey then
		targetFOV = baseFOV * L.DynamicFOVMultiplier
	end

	local speed = (targetFOV > L.CurrentFOVRadius) and L.DynamicFOVSpeedIn or L.DynamicFOVSpeedOut
	L.CurrentFOVRadius = L.CurrentFOVRadius + (targetFOV - L.CurrentFOVRadius) * speed

	local fovOrigin
	local validFovOrigin = false

	if L.FovPositionMethod == "Gun Barrel" then
		if not L.HasKnife and L.GunBarrel and L.GunBarrel:IsDescendantOf(Camera) then
			local forwardOffset = 7.5
			local worldPos = L.GunBarrel.Position + (L.GunBarrel.CFrame.LookVector * forwardOffset)
			local v, onScreen = Camera:WorldToViewportPoint(worldPos)
			if onScreen then
				fovOrigin = Vector2.new(v.X, v.Y)
				validFovOrigin = true
			end
		end
		if not validFovOrigin and not L.HasKnife then
			if L.LastGunBarrelTime and (os.clock() - L.LastGunBarrelTime) < 1 then
			else
				fovOrigin = mousePos
				validFovOrigin = true
			end
		end
	else
		fovOrigin = mousePos
		validFovOrigin = true
	end

	if L.FOVLockOnTarget and L.AimbotEnabled then
		local now = os.clock()

		if L.HoldingKey and L.LockedTarget and L.LockedTarget:IsDescendantOf(workspace) then
			FOVCachedTarget = L.LockedTarget
			FOVNextTargetUpdate = now + L.TARGET_UPDATE_RATE
		elseif now >= FOVNextTargetUpdate then
			FOVCachedTarget = getClosestTarget()
			FOVNextTargetUpdate = now + L.TARGET_UPDATE_RATE
		end

		if FOVCachedTarget and FOVCachedTarget:IsDescendantOf(workspace) then
			local pos, onScreen = Camera:WorldToViewportPoint(FOVCachedTarget.Position)
			if onScreen then
				fovOrigin = Vector2.new(pos.X, pos.Y)
				validFovOrigin = true
			end
		end
	end

	FOVCircle.Visible = validFovOrigin and L.ShowFOV
	FOVOutline.Visible = validFovOrigin and L.ShowFOV

	if validFovOrigin then
		FOVCircle.Position = fovOrigin
		FOVOutline.Position = fovOrigin
		FOVCircle.Radius = L.CurrentFOVRadius
		FOVOutline.Radius = L.CurrentFOVRadius
		FOVCircle.Color = L.FOVColor
	end

	if not L.AimbotEnabled or not L.HoldingKey or not validFovOrigin then
		L.LockedTarget = nil
		return
	end

	local now = os.clock()

	if L.StickyAim then
		if not L.LockedTarget or not L.LockedTarget:IsDescendantOf(workspace) then
			if now >= L.NextTargetUpdate then
				L.LockedTarget = getClosestTarget()
				L.CachedTarget = L.LockedTarget
				L.NextTargetUpdate = now + L.TARGET_UPDATE_RATE
			else
				L.LockedTarget = L.CachedTarget
			end
		end
	else
		if now >= L.NextTargetUpdate then
			L.LockedTarget = getClosestTarget()
			L.CachedTarget = L.LockedTarget
			L.NextTargetUpdate = now + L.TARGET_UPDATE_RATE
		else
			L.LockedTarget = L.CachedTarget
		end
	end

if L.LockedTarget then
	local pos = Camera:WorldToViewportPoint(L.LockedTarget.Position)
	local targetPos = Vector2.new(pos.X, pos.Y)

	local diff = targetPos - mousePos
	local dist = diff.Magnitude

	if dist > 0 then
		local maxStep = L.AimVelocity * dt

		local move
		if dist <= maxStep then
			move = diff
		else
			move = diff.Unit * maxStep
		end

		mousemoverel(move.X, move.Y)
	end
end
end)

				local OriginalSky = Lighting:FindFirstChild("OriginalSkyBackup")
				if not OriginalSky then
					local current = Lighting:FindFirstChildOfClass("Sky")
					if current then
						OriginalSky = current:Clone()
						OriginalSky.Name = "OriginalSkyBackup"
						OriginalSky.Parent = Lighting
					end
				end
				local function ApplySky(name)
					local data = L.Skyboxes[name]
					if not data then return end
					local sky = Lighting:FindFirstChildOfClass("Sky")
					if sky then sky:Destroy() end
					sky = Instance.new("Sky")
					sky.SkyboxBk = data.Bk
					sky.SkyboxDn = data.Dn
					sky.SkyboxFt = data.Ft
					sky.SkyboxLf = data.Lf
					sky.SkyboxRt = data.Rt
					sky.SkyboxUp = data.Up
					sky.Parent = Lighting
				end
				local function RestoreSky()
					local sky = Lighting:FindFirstChildOfClass("Sky")
					if sky then sky:Destroy() end
					if OriginalSky then
						OriginalSky:Clone().Parent = Lighting
					end
				end
				if L.SkyboxEnabled then
					ApplySky(L.SelectedSky)
				else
					RestoreSky()
				end
RunService.RenderStepped:Connect(function(dt)
	if not L.SnapEnabled then
		SnapLine.Visible = false
		SnapOutline.Visible = false
		return
	end

	local now = os.clock()

	if L.LockedTarget then
		L.CachedTarget = L.LockedTarget
	elseif now >= L.NextTargetUpdate then
		L.CachedTarget = getClosestTarget()
		L.NextTargetUpdate = now + L.TARGET_UPDATE_RATE
	end

	local target = L.CachedTarget
	if not target or not target:IsDescendantOf(workspace) then
		SnapLine.Visible = false
		SnapOutline.Visible = false
		return
	end

	local pos, onScreen = Camera:WorldToViewportPoint(target.Position)
	if not onScreen then
		SnapLine.Visible = false
		SnapOutline.Visible = false
		return
	end

	local origin

	if L.SnapLineMethod == "Gun Barrel" then
		if L.HasKnife or not L.GunBarrel or not L.GunBarrel:IsDescendantOf(Camera) then
			SnapLine.Visible = false
			SnapOutline.Visible = false
			return
		end

		local v, onscreen = Camera:WorldToViewportPoint(L.GunBarrel.Position)
		if not onscreen then
			SnapLine.Visible = false
			SnapOutline.Visible = false
			return
		end

		origin = Vector2.new(v.X, v.Y)
	else
		origin = UserInputService:GetMouseLocation()
	end

	if not L.HoldingKey then
		local dist = (Vector2.new(pos.X, pos.Y) - origin).Magnitude
		if dist > L.FOVRadius then
			SnapLine.Visible = false
			SnapOutline.Visible = false
			return
		end
	end

	local targetPos = Vector2.new(pos.X, pos.Y)

	SnapOutline.From = origin
	SnapOutline.To = targetPos
	SnapOutline.Visible = true

	SnapLine.From = origin
	SnapLine.To = targetPos
	SnapLine.Visible = true
end)

				UserInputService.InputBegan:Connect(function(input, gp)
					if gp then return end
					if input.KeyCode == Enum.KeyCode.Space then
						L.HoldingJump = true
					end
				end)
				UserInputService.InputEnded:Connect(function(input)
					if input.KeyCode == Enum.KeyCode.Space then
						L.HoldingJump = false
						local humanoid = findHumanoid()
						if humanoid then
							humanoid.Jump = false
						end
					end
				end)
				RunService.Heartbeat:Connect(function()
					if not L.NoJumpCooldownEnabled or not L.HoldingJump then return end
					local humanoid = findHumanoid()
					if humanoid and humanoid.Health > 0 then
						humanoid.Jump = true
					end
				end)
				local function collect()
					table.clear(L.Roots)
					table.clear(L.BaseCF)
					for _, model in ipairs(Camera:GetChildren()) do
						if model:IsA("Model") then
							local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
							if root then
								model.PrimaryPart = root
								L.Roots[#L.Roots + 1] = root
								L.BaseCF[root] = root.CFrame
							end
						end
					end
				end
				RunService:BindToRenderStep(
					"ViewModelUpdater",
					Enum.RenderPriority.Last.Value,
					function(dt)
						if not L.ViewModelEnabled then return end
						L.LastScan += dt
						if L.LastScan >= L.ScanInterval then
							L.LastScan = 0
							collect()
						end
						for _, root in ipairs(L.Roots) do
							local base = L.BaseCF[root]
							if root and base then
								root.CFrame = Camera.CFrame * CFrame.new(L.Offset) * (Camera.CFrame:Inverse() * base)
							end
						end
					end
				)
				local function reset()
					for root, cf in pairs(L.BaseCF) do
						if root and root:IsDescendantOf(Camera) then
							root.CFrame = cf
						end
					end
				end
				local function createBox1(model)
					if L.BoxDrawings[model] then return end
					
					local outlines = {}
					local boxes = {}
					for i = 1, 8 do
						local outline = Drawing.new("Line")
						outline.Color = Color3.new(0, 0, 0)
						outline.Thickness = L.BoxOutlineThickness
						outline.Visible = false
						outlines[i] = outline

						local box = Drawing.new("Line")
						box.Color = L.BoxColor
						box.Thickness = L.BoxThickness
						box.Visible = false
						boxes[i] = box
					end

					L.BoxOutlineDrawings[model] = outlines
					L.BoxDrawings[model] = boxes
				end
				local function removeBox(model)
					if L.BoxDrawings[model] then
						for _, line in ipairs(L.BoxDrawings[model]) do
							line:Remove()
						end
						L.BoxDrawings[model] = nil
					end
					if L.BoxOutlineDrawings[model] then
						for _, line in ipairs(L.BoxOutlineDrawings[model]) do
							line:Remove()
						end
						L.BoxOutlineDrawings[model] = nil
					end
				end
				local function hookBoxModel(model)
					if not model:IsA("Model") then return end
					createBox1(model)
					for _, c in ipairs(model:GetChildren()) do
						if c:IsA("Model") then
							createBox1(c)
						end
					end
				end
				for _, folder in ipairs(PlayersFolder:GetChildren()) do
					if folder:IsA("Folder") then
						for _, model in ipairs(folder:GetChildren()) do
							hookBoxModel(model)
						end
						folder.ChildAdded:Connect(hookBoxModel)
						folder.ChildRemoved:Connect(removeBox)
					end
				end
				PlayersFolder.ChildAdded:Connect(function(folder)
					if folder:IsA("Folder") then
						folder.ChildAdded:Connect(hookBoxModel)
						folder.ChildRemoved:Connect(removeBox)
					end
				end)

				for _, root in ipairs(WeaponRoots) do
					for _, obj in ipairs(root:GetDescendants()) do
						if obj:IsA("ModuleScript") then
							local ok, data = pcall(require, obj)
							if ok and type(data) == "table" and type(data.firesoundid) == "string" then
								L.ValidSoundIds[data.firesoundid] = true
							end
						end
					end
				end

				local function applySound(s)
					if not s:IsA("Sound") then return end
					if not L.ValidSoundIds[s.SoundId] then return end
					if not L.SoundBackup[s] then
						L.SoundBackup[s] = {
							Id = s.SoundId,
							Volume = s.Volume
						}
					end
					local id = L.SoundMap[L.SelectedSound]
					if id and s.SoundId ~= id then
						s.SoundId = id
					end
					s.Volume = L.SoundVolume
				end

				local function restoreSound(s)
					local old = L.SoundBackup[s]
					if old then
						s.SoundId = old.Id
						s.Volume = old.Volume
						L.SoundBackup[s] = nil
					end
				end

				local function scan(m)
					for _, v in ipairs(m:GetDescendants()) do
						if v:IsA("Sound") then
							if L.GunshotOverride then
								applySound(v)
							else
								restoreSound(v)
							end
						end
					end
				end

				RunService.RenderStepped:Connect(function()
					local cam = Camera
					if not cam then return end
					for _, obj in ipairs(cam:GetChildren()) do
						if obj:IsA("Model") then
							scan(obj)
						end
					end
				end)
				local AmmoLabel = Instance.new("TextLabel")
				AmmoLabel.Name = "AmmoCounter"
				AmmoLabel.AnchorPoint = Vector2.new(0.5, 1)
				AmmoLabel.Position = UDim2.new(0.5, 0, 0.95, -350)
				AmmoLabel.Size = UDim2.new(0, 150, 0, 50)
				AmmoLabel.BackgroundTransparency = 1
				AmmoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				AmmoLabel.Font = Enum.Font.Code
				AmmoLabel.TextSize = 15
				AmmoLabel.Text = "0/0"
				AmmoLabel.Visible = false
				AmmoLabel.TextStrokeTransparency = 0
				AmmoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
				AmmoLabel.ZIndex = 999
				AmmoLabel.Parent = HudGui

				L.HealthDrawings = L.HealthDrawings or {}
				L.HealthOutlineDrawings = L.HealthOutlineDrawings or {}

				local BAR_WIDTH = 2
				local OUTLINE_WIDTH = 4

				local function createHealth(model)
					if L.HealthDrawings[model] then return end

					local outline = Drawing.new("Square")
					outline.Color = Color3.new(0, 0, 0)
					outline.Thickness = 1
					outline.Filled = false
					outline.Visible = false

					local bar = Drawing.new("Square")
					bar.Thickness = 0
					bar.Filled = true
					bar.Visible = false

					L.HealthOutlineDrawings[model] = outline
					L.HealthDrawings[model] = bar
				end

				local function removeHealth(model)
					if L.HealthDrawings[model] then
						L.HealthDrawings[model]:Remove()
						L.HealthDrawings[model] = nil
					end
					if L.HealthOutlineDrawings[model] then
						L.HealthOutlineDrawings[model]:Remove()
						L.HealthOutlineDrawings[model] = nil
					end
				end

				L.HealthCache = L.HealthCache or {}
				local function getHealthScale(model)
					local ch = L.HealthCache[model]
					if ch == false then return 1 end
					if ch and ch:IsDescendantOf(model) then
						local scale = ch.Size.X.Scale
						if scale ~= scale then return 1 end
						return math.clamp(scale, 0, 1)
					end

					for _, d in ipairs(model:GetDescendants()) do
						if d:IsA("Frame") and d.Name == "Percent" then
							local health = d:FindFirstAncestor("Health")
							if health then
								local tag = health:FindFirstAncestor("PlayerTag")
								if tag and tag:FindFirstAncestor("NameTagGui") then
									L.HealthCache[model] = d
									local scale = d.Size.X.Scale
									if scale ~= scale then return 1 end
									return math.clamp(scale, 0, 1)
								end
							end
						end
					end
					L.HealthCache[model] = false
					return 1
				end

				local function hookHealthModel(model)
					if not model:IsA("Model") then return end
					createHealth(model)
					for _, c in ipairs(model:GetChildren()) do
						if c:IsA("Model") then
							createHealth(c)
						end
					end
				end

				for _, folder in ipairs(PlayersFolder:GetChildren()) do
					if folder:IsA("Folder") then
						for _, model in ipairs(folder:GetChildren()) do
							hookHealthModel(model)
						end
						folder.ChildAdded:Connect(hookHealthModel)
						folder.ChildRemoved:Connect(removeHealth)
					end
				end

				PlayersFolder.ChildAdded:Connect(function(folder)
					if folder:IsA("Folder") then
						folder.ChildAdded:Connect(hookHealthModel)
						folder.ChildRemoved:Connect(removeHealth)
					end
				end)

				local lastESPUpdate = 0
				RunService.RenderStepped:Connect(function(dt)
					local now = os.clock()
					local distEnabled = L.DistanceESPEnabled
					local nameEnabled = L.NameESPEnabled
					local boxEnabled = L.BoxESPEnabled
					local healthEnabled = L.HealthESPEnabled
					if now - lastESPUpdate < 1/60 then return end
					lastESPUpdate = now

					for _, t in pairs(L.DistanceDrawings) do if not distEnabled then t.Visible = false end end
					for _, t in pairs(L.NameDrawings) do if not nameEnabled then t.Visible = false end end
					for _, boxLines in pairs(L.BoxDrawings) do
						if not boxEnabled then
							for _, line in ipairs(boxLines) do line.Visible = false end
						end
					end
					for _, outlineLines in pairs(L.BoxOutlineDrawings) do
						if not boxEnabled then
							for _, line in ipairs(outlineLines) do line.Visible = false end
						end
					end
					for _, h in pairs(L.HealthDrawings) do if not healthEnabled then h.Visible = false end end
					for _, o in pairs(L.HealthOutlineDrawings) do if not healthEnabled then o.Visible = false end end

					if not (distEnabled or nameEnabled or boxEnabled or healthEnabled) then return end

					local camPos = Camera.CFrame.Position
					local maxDist = L.DistanceMax or 750

					for model, _ in pairs(L.DistanceDrawings) do
						local textName = L.NameDrawings[model]
						local textDist = L.DistanceDrawings[model]
						local boxes = L.BoxDrawings[model]
						local outlines = L.BoxOutlineDrawings[model]
						local healthBar = L.HealthDrawings[model]
						local healthOutline = L.HealthOutlineDrawings[model]

						local function hideESP()
							if textName then textName.Visible = false end
							if textDist then textDist.Visible = false end
							if boxes then for _, l in ipairs(boxes) do l.Visible = false end end
							if outlines then for _, l in ipairs(outlines) do l.Visible = false end end
							if healthBar then healthBar.Visible = false end
							if healthOutline then healthOutline.Visible = false end
						end

						if not model:IsDescendantOf(PlayersFolder) then
							hideESP()
							continue
						end

						local torso = getTorso(model)
						if not torso or not isEnemy(torso) then
							hideESP()
							continue
						end

						local dist = (camPos - torso.Position).Magnitude
						if dist > maxDist or not isOnScreen(torso) then
							hideESP()
							continue
						end

						local topWorld = torso.Position + Vector3.new(0, 3, 0)
						local bottomWorld = torso.Position - Vector3.new(0, 3.5, 0)
						local nameWorld = torso.Position + Vector3.new(0, 3.5, 0)

						local topPos, topVis = Camera:WorldToViewportPoint(topWorld)
						local bottomPos, bottomVis = Camera:WorldToViewportPoint(bottomWorld)

						if not topVis or not bottomVis then
							hideESP()
							continue
						end

						local height = math.abs(topPos.Y - bottomPos.Y)
						local width = height * 0.55
						local x = topPos.X - width / 2
						local y = topPos.Y

						if textName and nameEnabled then
							local name = getPlayerName(model)
							if name then
								local namePos, _ = Camera:WorldToViewportPoint(nameWorld)
								textName.Position = Vector2.new(namePos.X, namePos.Y - 15)
								textName.Text = name
								textName.Visible = true
							else
								textName.Visible = false
							end
						elseif textName then textName.Visible = false end

						if textDist and distEnabled then
							textDist.Position = Vector2.new(bottomPos.X, bottomPos.Y)
							textDist.Text = math.floor(dist).."s"
							textDist.Color = L.DistanceTextColor
							textDist.Visible = true
						elseif textDist then textDist.Visible = false end

						if boxes and outlines and boxEnabled then
							local boxType = L.BoxType or "Full"
							local lineCount = boxType == "Corner" and 8 or 4

							for i = 1, 8 do
								local isVisible = i <= lineCount
								boxes[i].Visible = isVisible
								outlines[i].Visible = isVisible
								if isVisible then
									boxes[i].Color = L.BoxColor
									outlines[i].Color = Color3.new(0,0,0)
								end
							end

							if boxType == "Corner" then
								local tl = Vector2.new(x, y)
								local tr = Vector2.new(x + width, y)
								local bl = Vector2.new(x, y + height)
								local br = Vector2.new(x + width, y + height)
								local lw = width / 3
								local lh = height / 4

								local edges = {
									{tl, tl + Vector2.new(lw, 0)},
									{tl, tl + Vector2.new(0, lh)},
									{tr, tr - Vector2.new(lw, 0)},
									{tr, tr + Vector2.new(0, lh)},
									{bl, bl + Vector2.new(lw, 0)},
									{bl, bl - Vector2.new(0, lh)},
									{br, br - Vector2.new(lw, 0)},
									{br, br - Vector2.new(0, lh)}
								}

								for i = 1, 8 do
									boxes[i].From = edges[i][1]
									boxes[i].To = edges[i][2]
									outlines[i].From = boxes[i].From
									outlines[i].To = boxes[i].To
								end
							else
								-- Full (2D Square)
								local tl = Vector2.new(x, y)
								local tr = Vector2.new(x + width, y)
								local br = Vector2.new(x + width, y + height)
								local bl = Vector2.new(x, y + height)

								boxes[1].From, boxes[1].To = tl, tr
								boxes[2].From, boxes[2].To = tr, br
								boxes[3].From, boxes[3].To = br, bl
								boxes[4].From, boxes[4].To = bl, tl

								for i = 1, 4 do
									outlines[i].From = boxes[i].From
									outlines[i].To = boxes[i].To
								end
							end
						elseif boxes then
							for _, l in ipairs(boxes) do l.Visible = false end
							for _, l in ipairs(outlines) do l.Visible = false end
						end

						if healthBar and healthOutline and healthEnabled then
							local healthScale = getHealthScale(model)
							local barHeight = height * healthScale
							local barX = x - 5
							local barY = y + (height - barHeight)

							healthBar.Size = Vector2.new(BAR_WIDTH, barHeight)
							healthBar.Position = Vector2.new(barX, barY)
							healthBar.Color = L.HealthLowColor:Lerp(L.HealthHighColor, healthScale)
							healthBar.Visible = true

							healthOutline.Size = Vector2.new(OUTLINE_WIDTH, height + 2)
							healthOutline.Position = Vector2.new(barX - 1, y - 1)
							healthOutline.Visible = true
						elseif healthBar then
							healthBar.Visible = false
							healthOutline.Visible = false
						end
					end
				end)
local function applyFontSafe(drawing, font)
    if table.find(SafeFonts, font) then
        drawing.Font = font
    end
end

local function updateAllFonts(fontId)
    L.CurrentFont = fontId

    for _, d in pairs(L.DistanceDrawings) do
        applyFontSafe(d, fontId)
    end

    for _, d in pairs(L.NameDrawings) do
        applyFontSafe(d, fontId)
    end
end
local BARREL_MESH_ID = "12272787618"
local nextGunCheck = 0
RunService.Heartbeat:Connect(function()
	local now = os.clock()

	if now >= nextGunCheck then
		local knifeFound = false
		for _, m in ipairs(Camera:GetChildren()) do
			if m:IsA("Model") and m:FindFirstChild("Trigger", true) then
				knifeFound = true
				break
			end
		end
		L.HasKnife = knifeFound
	end

	if L.SnapLineMethod ~= "Gun Barrel" and L.FovPositionMethod ~= "Gun Barrel" and L.SilentSnapOriginMethod ~= "Gun Barrel" and L.SilentFOVOriginMethod ~= "Gun Barrel" and L.CrosshairPositionMode ~= "Gun Barrel" then
		L.GunBarrel = nil
		return
	end

	if L.GunBarrel and L.GunBarrel:IsDescendantOf(Camera) then
		L.LastGunBarrelTime = now
		return
	end

	if now >= nextGunCheck then
		nextGunCheck = now + 0.25

		local found = nil
		for _, obj in ipairs(Camera:GetDescendants()) do
			if obj:IsA("SpecialMesh") and obj.MeshId:find(BARREL_MESH_ID) then
				local p = obj.Parent
				if p and p:IsA("BasePart") then
					found = p
					L.LastGunBarrelTime = now
					break
				end
			end
		end
		L.GunBarrel = found
	end
end)
local lines = {}
for i = 1, 4 do
    lines[i] = Drawing.new("Line")
    lines[i].Thickness = 2
    lines[i].Color = L.CrosshairColor
    lines[i].ZIndex = 2
    lines[i].Visible = false
end

local outlines = {}
for i = 1, 4 do
    outlines[i] = Drawing.new("Line")
    outlines[i].Thickness = 4
    outlines[i].Color = Color3.new(0,0,0)
    outlines[i].ZIndex = 1
    outlines[i].Visible = false
end

local flapLines = {}
for i = 1, 4 do
    flapLines[i] = Drawing.new("Line")
    flapLines[i].Thickness = 2
    flapLines[i].Color = L.CrosshairColor
    flapLines[i].ZIndex = 2
    flapLines[i].Visible = false
end

local flapOutlines = {}
for i = 1, 4 do
    flapOutlines[i] = Drawing.new("Line")
    flapOutlines[i].Thickness = 4
    flapOutlines[i].Color = Color3.new(0,0,0)
    flapOutlines[i].ZIndex = 1
    flapOutlines[i].Visible = false
end

local dot = Drawing.new("Circle")
dot.Filled = true
dot.Thickness = 1
dot.Color = L.CrosshairColor
dot.ZIndex = 2
dot.Visible = false

local dotOutline = Drawing.new("Circle")
dotOutline.Filled = true
dotOutline.Thickness = 1
dotOutline.Color = Color3.new(0,0,0)
dotOutline.ZIndex = 1
dotOutline.Visible = false

local angle = 0
local SIDE_ORDER = {"Top","Right","Bottom","Left"}
local ANGLES = {0,90,180,270}

local cachedTarget = nil
local nextTargetUpdate = 0

local function getDefaultCrosshairCenter(camera)
    if L.CrosshairPositionMode == "Center Of Screen" then
        local size = camera.ViewportSize
        return Vector2.new(size.X/2, size.Y/2)

    elseif L.CrosshairPositionMode == "Gun Barrel" then
        if L.HasKnife or not L.GunBarrel or not L.GunBarrel:IsDescendantOf(Camera) then
            return nil
        end

        local forwardOffset = 7.5
        local worldPos = L.GunBarrel.Position + (L.GunBarrel.CFrame.LookVector * forwardOffset)
        local v, onScreen = camera:WorldToViewportPoint(worldPos)
        if not onScreen then
            return nil
        end

        return Vector2.new(v.X, v.Y)
    else
        local mousePos = UserInputService:GetMouseLocation()
        return Vector2.new(mousePos.X, mousePos.Y)
    end
end

local function getCrosshairCenter()
    local camera = Workspace.CurrentCamera
    if not camera then return Vector2.new(0,0) end

    if L.CrosshairLockOnTarget and L.AimbotEnabled then
        local now = os.clock()

        if L.HoldingKey and L.LockedTarget and L.LockedTarget:IsDescendantOf(workspace) then
            cachedTarget = L.LockedTarget
            nextTargetUpdate = now + L.TARGET_UPDATE_RATE
        elseif now >= nextTargetUpdate then
            cachedTarget = getClosestTarget()
            nextTargetUpdate = now + L.TARGET_UPDATE_RATE
        end

        if cachedTarget and cachedTarget:IsDescendantOf(workspace) then
            local pos, onScreen = camera:WorldToViewportPoint(cachedTarget.Position)
            if onScreen then
                return Vector2.new(pos.X, pos.Y)
            end
        end
    end

    local fallback = getDefaultCrosshairCenter(camera)
    return fallback or Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
end

RunService.RenderStepped:Connect(function(dt)
    if not L.CrosshairEnabled then
        for i = 1,4 do
            lines[i].Visible = false
            outlines[i].Visible = false
            flapLines[i].Visible = false
            flapOutlines[i].Visible = false
        end
        if dot then dot.Visible = false end
        if dotOutline then dotOutline.Visible = false end
        return
    end

    local center = getCrosshairCenter()

    if L.CrosshairSpin then
        angle = (angle + dt * L.CrosshairSpinSpeed) % 360
    else
        angle = 0
    end

    local size = L.CrosshairSize
    local gap = L.CrosshairGap
    local thickness = L.CrosshairThickness
    local sides = STYLE_SIDES[L.CrosshairStyle] or STYLE_SIDES["1"]

    if L.CrosshairStyle == "4" then
        for i = 1,4 do
            lines[i].Visible = false
            outlines[i].Visible = false
            flapLines[i].Visible = false
            flapOutlines[i].Visible = false
        end
        local dotRadius = math.max(1, math.floor(thickness * 1.5))
        dot.Radius = dotRadius
        dot.Position = center
        dot.Color = L.CrosshairColor
        dot.Visible = true

        dotOutline.Radius = dotRadius + 1
        dotOutline.Position = center
        dotOutline.Visible = true
        return
    else
        dot.Visible = false
        dotOutline.Visible = false
    end

    for i = 1,4 do
        lines[i].Thickness = thickness
        outlines[i].Thickness = thickness + 2
        flapLines[i].Thickness = thickness
        flapOutlines[i].Thickness = thickness + 2

        local sideName = SIDE_ORDER[i]

        if sides[sideName] then
            local rad = math.rad(angle + ANGLES[i])
            local dir = Vector2.new(math.cos(rad), math.sin(rad))
            local from = center + dir * gap
            local to = center + dir * (gap + size)

            if L.CrosshairStyle == "5" then
                local perp = Vector2.new(-dir.Y, dir.X)
                local offset = math.max(2, size)
                from = center
                to = center + dir * (gap + size)
                
                flapLines[i].From = to
                flapLines[i].To = to + perp * offset
                flapLines[i].Color = L.CrosshairColor
                flapLines[i].Visible = true
                
                flapOutlines[i].From = to
                flapOutlines[i].To = to + perp * offset
                flapOutlines[i].Visible = true
            else
                flapLines[i].Visible = false
                flapOutlines[i].Visible = false
            end

            lines[i].From = from
            lines[i].To = to
            lines[i].Color = L.CrosshairColor
            lines[i].Visible = true

            outlines[i].From = from
            outlines[i].To = to
            outlines[i].Visible = true
        else
            lines[i].Visible = false
            outlines[i].Visible = false
            flapLines[i].Visible = false
            flapOutlines[i].Visible = false
        end
    end
end)

local SilentSnapOutline = Drawing.new("Line")
SilentSnapOutline.Thickness = 3
SilentSnapOutline.Color = Color3.new(0,0,0)
SilentSnapOutline.Transparency = 1
SilentSnapOutline.Visible = false

local SilentSnapLine = Drawing.new("Line")
SilentSnapLine.Thickness = 1
SilentSnapLine.Color = Color3.fromRGB(255,255,255)
SilentSnapLine.Transparency = 1
SilentSnapLine.Visible = false

local SilentFOVOutline = Drawing.new("Circle")
SilentFOVOutline.Filled = false
SilentFOVOutline.Thickness = 3
SilentFOVOutline.Color = Color3.new(0,0,0)
SilentFOVOutline.Transparency = 1
SilentFOVOutline.Visible = false

local SilentFOVCircle = Drawing.new("Circle")
SilentFOVCircle.Filled = false
SilentFOVCircle.Thickness = 1
SilentFOVCircle.Color = L.SilentFOVColor
SilentFOVCircle.Transparency = 1
SilentFOVCircle.Visible = false

local SilentLocalTeam = nil

function L:ResolveBarrelMotor()
	if self.GunBarrelMotor or not self.GunBarrel then return end

	for _, d in ipairs(self.GunBarrel:GetDescendants()) do
		if d:IsA("Motor6D") then
			self.GunBarrelMotor = d
			self.GunBarrelMotorOriginal = d.Transform
			return
		end
	end

	for _, d in ipairs(self.GunBarrel:GetDescendants()) do
		if d:IsA("Weld") then
			self.GunBarrelMotor = d
			self.GunBarrelMotorOriginal = d.C0
			return
		end
	end
end

local function GetSilentScreenOrigin()
	if L.SilentFOVOriginMethod == "Gun Barrel" then
		if L.HasKnife then return nil, false, nil end
		if L.GunBarrel and L.GunBarrel:IsDescendantOf(Camera) then
			local p = L.GunBarrel.Position + (L.GunBarrel.CFrame.LookVector * 7.5)
			local v, onScreen = Camera:WorldToViewportPoint(p)
			if onScreen then
				return Vector2.new(v.X, v.Y), true, p
			end
		end
		if L.LastGunBarrelTime and (os.clock() - L.LastGunBarrelTime) < 1 then
			return nil, false, nil
		end
		local m = UserInputService:GetMouseLocation()
		return m, true, nil
	end
	local m = UserInputService:GetMouseLocation()
	return m, true, L.GunBarrel and L.GunBarrel.Position or nil
end

local function SilentGetLocalTeam()
	return LocalTeam or getLocalTeam()
end

local function SilentIsEnemy(part)
	return isEnemy(part)
end

local function SilentIsVisible(part)
	if not L.SilentWallCheck then return true end
	local origin = Camera.CFrame.Position
	local dir = part.Position - origin
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
	params.IgnoreWater = true
	local result = workspace:Raycast(origin, dir, params)
	return not result or result.Instance:IsDescendantOf(part.Parent)
end

L.SilentAimPartCache = L.SilentAimPartCache or {}
local function getCachedSilentTargetPart(model)
	local c = L.SilentAimPartCache[model]
	if c == false then return nil end
	if c and c:IsDescendantOf(model) and c.MeshId:find(L.SILENT_TARGET_MESH) then return c end
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("MeshPart") and v.MeshId and v.MeshId:find(L.SILENT_TARGET_MESH) then
			L.SilentAimPartCache[model] = v
			return v
		end
	end
	L.SilentAimPartCache[model] = false
	return nil
end

local function SilentGetTargetParts()
	local t = {}
	for model, _ in pairs(L.NameDrawings or {}) do
		if checkEnemyByModel(model) then
			local p = getCachedSilentTargetPart(model)
			if p then t[#t+1] = p end
		end
	end
	return t
end

function L:GetSilentClosestTarget()
	local origin, valid, worldOrigin = GetSilentScreenOrigin()
	if not valid or not worldOrigin then return nil end

	local closest, shortest = nil, math.huge
	for _, part in ipairs(SilentGetTargetParts()) do
		if part and part:IsDescendantOf(workspace) then
			local wDist = (worldOrigin - part.Position).Magnitude
			if wDist <= L.SilentMaxAimDistance then
				local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
				if onScreen and SilentIsVisible(part) then
					local sDist = (Vector2.new(pos.X,pos.Y) - origin).Magnitude
					if sDist <= L.SilentCurrentFOV then
						local d = (L.SilentPriority == "Closest To You") and wDist or sDist
						if d < shortest then
							shortest = d
							closest = part
						end
					end
				end
			end
		end
	end
	return closest
end

function L:SilentApply()
	if math.random(1,100) > L.SilentHitChance then return end
	if not self.SilentLockedPart then return end

	local weapon = getWeaponModel()
	if not weapon or not weapon.PrimaryPart then return end

	if not self.SilentOriginalCF then
		self.SilentOriginalCF = weapon:GetPivot()
	end

	local origin = weapon.PrimaryPart.Position
	local target = self.SilentLockedPart.Position

	local lookCF = CFrame.lookAt(origin, target)

	weapon:PivotTo(lookCF)
end

function L:SilentRestore()
	local weapon = getWeaponModel()
	if weapon and self.SilentOriginalCF then
		weapon:PivotTo(self.SilentOriginalCF)
	end
	self.SilentOriginalCF = nil
end

function L:StartSilentAim()
	if self.SilentHeartbeat then return end

	self.SilentHeartbeat = RunService.Heartbeat:Connect(function()
		if not self.SilentEnabled or not self.SilentHolding or L.HasKnife then
			self:SilentRestore()
			return
		end

		self.SilentLockedPart = self:GetSilentClosestTarget()

		if self.SilentLockedPart then
			self:SilentApply()
		else
			self:SilentRestore()
		end
	end)
end
local weapon = getWeaponModel()
if weapon then
	if not weapon.PrimaryPart then
		weapon.PrimaryPart = weapon:FindFirstChildWhichIsA("BasePart", true)
	end
end
function L:StopSilentAim()
	if self.SilentHeartbeat then
		self.SilentHeartbeat:Disconnect()
		self.SilentHeartbeat = nil
	end
	self:SilentRestore()
	self.SilentLockedPart = nil
end

UserInputService.InputBegan:Connect(function(input,gpe)
	if not gpe and input.UserInputType == Enum.UserInputType.MouseButton2 then
		L.SilentHolding = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		L.SilentHolding = false
		L:SilentRestore()
	end
end)

RunService.Heartbeat:Connect(function()
	SilentLocalTeam = SilentGetLocalTeam()
end)

RunService.RenderStepped:Connect(function()
	local now = os.clock()
	local base = L.SilentFOVRadius
	local target = (L.SilentDynamicFOV and L.SilentHolding) and base * 1.5 or base
	L.SilentCurrentFOV += (target - L.SilentCurrentFOV) * 0.15

	local origin, valid = GetSilentScreenOrigin()
	SilentFOVCircle.Visible = valid and L.SilentShowFOV
	SilentFOVOutline.Visible = valid and L.SilentShowFOV

	if valid then
		SilentFOVCircle.Position = origin
		SilentFOVOutline.Position = origin
		SilentFOVCircle.Radius = L.SilentCurrentFOV
		SilentFOVOutline.Radius = L.SilentCurrentFOV
		SilentFOVCircle.Color = L.SilentFOVColor
	end

	local snapTarget = nil
	if L.SilentSnapEnabled and valid then
		if not L.SilentNextTargetUpdate then L.SilentNextTargetUpdate = 0 end
		if now >= L.SilentNextTargetUpdate then
			snapTarget = L:GetSilentClosestTarget()
			L.SilentCachedTarget = snapTarget
			L.SilentNextTargetUpdate = now + L.TARGET_UPDATE_RATE
		else
			snapTarget = L.SilentCachedTarget
		end
		
		if snapTarget and snapTarget:IsDescendantOf(workspace) then
			local pos, onScreen = Camera:WorldToViewportPoint(snapTarget.Position)
			if onScreen then
				local dist = (Vector2.new(pos.X, pos.Y) - origin).Magnitude
				if L.SilentHolding or dist <= (L.SilentCurrentFOV * 1.5) then
					SilentSnapLine.Visible = true
					SilentSnapOutline.Visible = true
					SilentSnapLine.From = origin
					SilentSnapLine.To = Vector2.new(pos.X,pos.Y)
					SilentSnapOutline.From = origin
					SilentSnapOutline.To = Vector2.new(pos.X,pos.Y)
				else
					SilentSnapLine.Visible = false
					SilentSnapOutline.Visible = false
				end
			else
				SilentSnapLine.Visible = false
				SilentSnapOutline.Visible = false
			end
		else
			SilentSnapLine.Visible = false
			SilentSnapOutline.Visible = false
		end
	else
		SilentSnapLine.Visible = false
		SilentSnapOutline.Visible = false
	end
end)

local function applyHitSound(s)
	if not s:IsA("Sound") then return end
	if s.Name ~= "hitmarker" then return end
	if not L.HitSoundBackup[s] then
		L.HitSoundBackup[s] = {Id=s.SoundId,Volume=s.Volume}
	end
	local id = L.HitSoundMap[L.HitSoundSelected]
	if id and s.SoundId ~= id then
		s.SoundId = id
	end
	s.Volume = L.HitSoundVolume
end

local function restoreHitSound(s)
	local old = L.HitSoundBackup[s]
	if old then
		s.SoundId = old.Id
		s.Volume = old.Volume
		L.HitSoundBackup[s] = nil
	end
end

local function applyKillSound(s)
	if not s:IsA("Sound") then return end
	if s.Name ~= "killshot" and s.Name ~= "headshotkill" then return end
	if not L.KillSoundBackup[s] then
		L.KillSoundBackup[s] = {Id=s.SoundId,Volume=s.Volume}
	end
	local id = L.KillSoundMap[L.KillSoundSelected]
	if id and s.SoundId ~= id then
		s.SoundId = id
	end
	s.Volume = L.KillSoundVolume
end

local function restoreKillSound(s)
	local old = L.KillSoundBackup[s]
	if old then
		s.SoundId = old.Id
		s.Volume = old.Volume
		L.KillSoundBackup[s] = nil
	end
end
local CachedSlots = {}
local OriginalColors = {}

local function CacheSleeves()
	table.clear(CachedSlots)
	table.clear(OriginalColors)
	for _, obj in ipairs(Camera:GetDescendants()) do
		if obj:IsA("MeshPart") and obj.Name == "Sleeves" then
			for _, tex in ipairs(obj:GetChildren()) do
				if tex:IsA("Texture") and tex.Name == "Slot1" then
					table.insert(CachedSlots, tex)
					OriginalColors[tex] = tex.Color3
				end
			end
		end
	end
end

local function Apply()
	if #CachedSlots == 0 then
		CacheSleeves()
	end

	local texId
	if L.MasterEnabled then
		texId = SleeveTextureIds[L.SelectedSleeveTexture or "Default"]
	else
		texId = SleeveTextureIds.Default
	end

	if not texId then
		warn("sleeves arent found.. WTF!!")
		return
	end

	for _, tex in ipairs(CachedSlots) do
		if tex:IsDescendantOf(Camera) then
			tex.Texture = texId
			if L.MasterEnabled and L.SleeveColor then
				tex.Color3 = L.SleeveColor
			else
				tex.Color3 = OriginalColors[tex] or tex.Color3
			end
		end
	end
end

Camera.DescendantAdded:Connect(function(obj)
	if obj:IsA("Texture") and obj.Name == "Slot1" then
		if obj.Parent and obj.Parent:IsA("MeshPart") and obj.Parent.Name == "Sleeves" then
			table.insert(CachedSlots, obj)
			OriginalColors[obj] = obj.Color3
			Apply()
		end
	end
end)

local lastState = L.MasterEnabled
game:GetService("RunService").Stepped:Connect(function()
	if L.MasterEnabled ~= lastState then
		lastState = L.MasterEnabled
		Apply()
	end
end)
				local Window = Library:CreateWindow({
					Title = "                                          $$ roxy.win $$",
					Center = true,
					AutoShow = true,
					MenuFadeTime = 0.1,
					Resizable = true,
					ShowCustomCursor = false,
					NotifySide = "Left",
					Size = UDim2.new(0, 800, 0, 600)
				})
				local Tabs = {
					A = Window:AddTab("Legitbot"),
			        B2 = Window:AddTab("Ragebot"),
					B = Window:AddTab("Visuals"),
					["UI Settings"] = Window:AddTab("UI Settings")
				}
				local Aimbot = Tabs.A:AddLeftGroupbox("Aimbot")
				local Silent = Tabs.A:AddRightGroupbox("Silent")
				local LOCALP = Tabs.A:AddRightGroupbox("Local")
				local Triggerbot = Tabs.A:AddLeftGroupbox("Triggerbot")
				local ESP1 = Tabs.B:AddLeftGroupbox("Enemy")
				local ESP2 = Tabs.B:AddRightTabbox()
				local ESP3 = Tabs.B:AddLeftGroupbox("World")
                local ESP4 = Tabs.B:AddLeftGroupbox("Crosshair")
				local AimbotToggle = Aimbot:AddToggle("ToggleAimbot", {
					Text = "Toggle Aimbot",
					Default = false,
					Callback = function(v)
						L.AimbotEnabled = v
					end
				})
				AimbotToggle:AddKeyPicker("AimbotToggleKeybind", {
					Default = "MB2",
					Mode = "Hold",
					SyncToggleState = false,
					Text = "Aimbot",
					Callback = function() end,
					ChangedCallback = function(New)
						L.AimKey = New
					end
				})
				Aimbot:AddToggle("AimbotStickyAimToggle", {
					Text = "Sticky Aim",
					Default = false,
					Callback = function(v)
						L.StickyAim = v
					end
				})
				Aimbot:AddToggle("WallCheckToggle", {
					Text = "Wall Check",
					Default = false,
					Callback = function(v)
						L.WallCheck = v
					end
				})
Aimbot:AddSlider("SmoothnessSlider", {
	Text = "Smoothness",
	Default = 1.2,
	Min = 0.3,
	Max = 5,
	Rounding = 1,
	Compact = true,
	Callback = function(v)
		L.AimVelocity = v * 1000
	end
})
				Aimbot:AddSlider("MaxDistanceB", {
					Text = "Max Distance",
					Default = 500,
					Min = 1,
					Max = 1000,
					Rounding = 0,
					Compact = true,
					Suffix = "stds",
					Callback = function(v)
						L.MaxAimDistance = v
					end
				})
				Aimbot:AddDropdown('AimbotPartSelection', {
					Values = { 'Head', 'Torso' },
					Default = 1,
					Multi = false,
					Text = 'Aimbot Bone',
					Callback = function(Value)
						L.SelectedAimPart = Value
						L.TARGET_MESH_ID = L.MESH_IDS[Value]
					end
				})
				Aimbot:AddDropdown('AimbotTypeDropdown', {
					Values = { 'Closest To Mouse', 'Closest To You' },
					Default = 1,
					Multi = false,
					Text = 'Target Priority',
					Callback = function(Value)
						L.AimbotType = Value
					end
				})

				Aimbot:AddDivider()
				local SnapLine1 = Aimbot:AddToggle("SnapLineToggle", {
					Text = "Snap Line",
					Default = false,
					Callback = function(v)
						L.SnapEnabled = v
						if not v then
							SnapLine.Visible = false
							SnapOutline.Visible = false
						end
					end
				})
				SnapLine1:AddColorPicker("SnapLineColor", {
					Default = Color3.fromRGB(255, 255, 255),
					Title = "Line Color",
					Callback = function(v)
						SnapLine.Color = v
					end
				})
				local FOVToggle = Aimbot:AddToggle("ToggleFOV", {
					Text = "Show FOV",
					Default = false,
					Callback = function(v)
						L.ShowFOV = v
					end
				})
				Aimbot:AddToggle("DynamicFOVToggle", {
					Text = "Dynamic FOV",
					Default = false,
					Callback = function(v)
						L.DynamicFOVEnabled = v
					end
				})
				Aimbot:AddToggle("FOVLockOnTarget", {
					Text = "Lock On Target",
					Tooltip = "Locks FOV on aimbot target",
					Default = false,
					Callback = function(v)
						L.FOVLockOnTarget = v
					end
				})
				FOVToggle:AddColorPicker("L.FOVColor", {
					Default = Color3.fromRGB(255, 255, 255),
					Title = "FOV Color",
					Callback = function(v)
						L.FOVColor = v
					end
				})
				Aimbot:AddSlider("FOVSize1", {
					Text = "Size",
					Default = 120,
					Min = 0,
					Max = 500,
					Rounding = 0,
					Suffix = "px",
					Compact = true,
					Callback = function(v)
						L.FOVRadius = v
					end
				})
	Aimbot:AddDropdown('SnapLineMethod', {
	Values = { 'Gun Barrel', 'Mouse' },
	Default = 1,
	Multi = false,
	Text = 'Snap From',
	Callback = function(v)
		L.SnapLineMethod = v
	end
})
Aimbot:AddDropdown('FovPositionMethod', {
	Values = { 'Gun Barrel', 'Mouse' },
	Default = 2,
	Multi = false,
	Text = 'Fov Position',
	Callback = function(v)
		L.FovPositionMethod = v
	end
})

				local walkspeedtoggle = LOCALP:AddToggle("WALKSPEEDLOCK", {
					Text = "Walkspeed Modifier",
					Default = false,
					Compact = true,
					Callback = function(value)
						L.WalkSpeedEnabled = value
						if value then
							startWalkSpeedLock()
						else
							stopWalkSpeedLock()
						end
					end
				})
				LOCALP:AddToggle("WALKSPEEDLOCK", {
					Text = "No Jump Cooldown",
					Default = false,
					Callback = function(value)
						L.NoJumpCooldownEnabled = value
						if not value then
							local humanoid = findHumanoid()
							if humanoid then
								humanoid.Jump = false
							end
						end
					end
				})
				LOCALP:AddSlider("WALKSPEEDSLIDER", {
					Text = "WalkSpeed",
					Default = 24,
					Min = 5,
					Max = 36,
					Rounding = 0,
					Compact = false,
					Callback = function(Value)
						L.TARGET_WALKSPEED = Value
						if L.WalkSpeedEnabled and L.CurrentHumanoid then
							L.CurrentHumanoid.WalkSpeed = L.TARGET_WALKSPEED
						end
					end
				})
				local ESP2TAB = ESP2:AddTab('Arm')
				ESP2TAB:AddToggle('ArmVisualsToggle', {
					Text = 'Toggle Arm Visuals',
					Default = false,
					Tooltip = nil,
					Callback = function(Value)
						L.MasterEnabled = Value
						if Value then
							warn("nigers")
						else
							ClearAll()
							restoreArmMaterial()
						end
					end
				})
				local ArmsHighlight = ESP2TAB:AddToggle('ArmHighlighToggle', {
					Text = 'Arm Highlight',
					Default = false,
					Tooltip = nil,
					Callback = function(Value)
						L.HighlightEnabled = Value
						if not Value then
							ClearAll()
						end
					end
				})
				ArmsHighlight:AddColorPicker("ArmFillCP", {
					Default = Color3.fromRGB(131,147,255),
					Title = "Fill Color",
					Transparency = nil,
					Callback = function(value)
						L.FillColor = value
						for _, h in pairs(L.ArmHighlights) do
							h.FillColor = value
						end
					end
				})
				ArmsHighlight:AddColorPicker("ArmHighlightCP", {
					Default = Color3.fromRGB(255, 255, 255),
					Title = "Highlight Color",
					Transparency = nil,
					Callback = function(value)
						L.OutlineColor = value
						for _, h in pairs(L.ArmHighlights) do
							h.OutlineColor = value
						end
					end
				})
				ESP2TAB:AddSlider('HighlightTransparency', {
					Text = 'Transparency',
					Default = L.HighlightFillTransparency,
					Min = 0,
					Max = 1,
					Rounding = 1,
					Compact = true,
					Callback = function(Value)
						L.HighlightFillTransparency = Value
						for _, h in pairs(L.ArmHighlights) do
							h.FillTransparency = Value
						end
					end
				})
				local ArmsMaterial = ESP2TAB:AddToggle('ArmsMaterialToggle', {
					Text = 'Arm Material',
					Default = false,
					Callback = function(Value)
						L.ArmsMaterialEnabled = Value
						if not Value then
							restoreArmMaterial()
						end
					end
				})
				ArmsMaterial:AddColorPicker("ArmMaterialCP", {
					Default = Color3.fromRGB(131,147,255),
					Title = "Material Color",
					Callback = function(value)
						L.ArmsMaterialColor = value
					end
				})
				ESP2TAB:AddToggle('HideArmsToggle', {
					Text = 'Hide Arms',
					Default = false,
					Callback = function(Value)
						L.HideArmsEnabled = Value
						if not Value then
							restoreHideArms()
						end
					end
				})
				ESP2TAB:AddToggle('HideSleevesToggle', {
	Text = 'Hide Sleeves',
	Default = false,
	Callback = function(Value)
		L.HideSleevesEnabled = Value

		if Value then
			SetSleeveSlotsTransparency(1)
		else
			SetSleeveSlotsTransparency(0)
		end
	end
})
				ESP2TAB:AddDropdown('ArmMaterialDropdown', {
					Values = { 'ForceField', 'Neon', 'SmoothPlastic', 'Glass', 'Metal' },
					Default = 1,
					Multi = false,
					Text = 'Material Selection',
					Callback = function(Value)
						L.ArmsMaterialEnum = L.MaterialMap[Value] or Enum.Material.ForceField
					end
				})
ESP2TAB:AddDropdown('SleeveTextureDropdown', {
	Values = {'Default','Beach','Camo'},
	Default = 1,
	Multi = false,
	Text = 'Sleeves Texture',
	Callback = function(Value)
		L.SelectedSleeveTexture = Value
		Apply()
	end
})
ESP2TAB:AddLabel('Sleeves Color'):AddColorPicker('SleeveColorP', {
	Default = Color3.new(1, 1, 1),
	Title = 'Sleeve Color',
	Transparency = nil,
	Callback = function(Value)
		L.SleeveColor = Value
		if L.MasterEnabled then
			Apply()
		end
	end
})
local ESP2TAB1 = ESP2:AddTab('Weapon')
				ESP2TAB1:AddToggle('WeaponVisualsToggle', {
					Text = 'Toggle Weapon Visuals',
					Default = false,
					Tooltip = nil,
					Callback = function(Value)
						L.WeaponMasterEnabled = Value
						if not Value then
							clearWeaponHighlights()
							restoreWeaponMaterial()
						end
					end
				})
				local WeaponHighlightT = ESP2TAB1:AddToggle('WeaponHighlightToggle', {
					Text = 'Weapon Highlight',
					Default = false,
					Tooltip = nil,
					Callback = function(Value)
						L.WeaponHighlightEnabled = Value
						if not Value then
							clearWeaponHighlights()
						end
					end
				})
				WeaponHighlightT:AddColorPicker("WeaponFillCP", {
					Default = L.WeaponFillColor,
					Title = "Fill Color",
					Transparency = nil,
					Callback = function(value)
						L.WeaponFillColor = value
						for _, h in pairs(L.WeaponHighlights) do
							h.FillColor = value
						end
					end
				})
				WeaponHighlightT:AddColorPicker("WeaponHighlightCP", {
					Default = L.WeaponOutlineColor,
					Title = "Highlight Color",
					Transparency = nil,
					Callback = function(value)
						L.WeaponOutlineColor = value
						for _, h in pairs(L.WeaponHighlights) do
							h.OutlineColor = value
						end
					end
				})
				ESP2TAB1:AddSlider('WeaponHighlightTransparency', {
					Text = 'Transparency',
					Default = L.WeaponFillTransparency,
					Min = 0,
					Max = 1,
					Rounding = 1,
					Compact = true,
					Callback = function(Value)
						L.WeaponFillTransparency = Value
						for _, h in pairs(L.WeaponHighlights) do
							h.FillTransparency = Value
						end
					end
				})
				local WeaponMaterial = ESP2TAB1:AddToggle('WeaponMaterialToggle', {
					Text = 'Weapon Material',
					Default = false,
					Callback = function(Value)
						L.WeaponMaterialEnabled = Value 
						if not Value or not L.WeaponMasterEnabled then
							restoreWeaponMaterial()
						end
					end
				})
				WeaponMaterial:AddColorPicker("WeaponMaterialCP", {
					Default = Color3.fromRGB(131,147,255),
					Title = "Material Color",
					Callback = function(value)
						L.WeaponMaterialColor = value
					end
				})
				ESP2TAB1:AddToggle('HideGunToggle', {
					Text = 'Hide Gun',
					Default = false,
					Callback = function(Value)
						L.HideGunEnabled = Value 
						if not Value or not L.WeaponMasterEnabled then
							if type(restoreHideGun) == "function" then
								restoreHideGun()
							end
						end
					end
				})
				ESP2TAB1:AddDropdown('WeaponMaterialDropdown', {
					Values = { 'ForceField', 'Neon', 'SmoothPlastic', 'Glass', 'Metal' },
					Default = 1,
					Multi = false,
					Text = 'Material Selection',
					Callback = function(Value)
						L.WeaponMaterialEnum = L.WeaponMaterialMap[Value] or Enum.Material.ForceField
					end
				})
				local CAmbientToggle = ESP3:AddToggle('CustomAmbienToggle', {
					Text = 'Custom Ambient',
					Default = false,
					Callback = function(enabled)
						if enabled then
							task.spawn(function()
								while enabled and not Library.Unloaded do
									Lighting.Ambient = L.CAmbientColor
									task.wait()
								end
							end)
						else
							Lighting.Ambient = L.OriginalValues.Ambient
						end
					end
				})

				CAmbientToggle:AddColorPicker('CAmbientCP1', {
					Default = L.CAmbientColor,
					Title = 'Ambient Color',
					Callback = function(color)
						L.CAmbientColor = color
						if CAmbientToggle.Value then
							Lighting.Ambient = L.CAmbientColor
						end
					end
				})
				ESP3:AddToggle('CustomSkyboxToggle', {
					Text = 'Custom Skybox',
					Default = false,
					Tooltip = "If skyboxes arent showing toggle custom clocktime",
					Callback = function(enabled)
						L.SkyboxEnabled = enabled
						if L.SkyboxEnabled then
							ApplySky(L.SelectedSky)
						else
							RestoreSky()
						end
					end
				})
				ESP3:AddToggle('CustomClockTimeToggle', {
					Text = 'Custom ClockTime',
					Default = false,
					Callback = function(enabled)
						L.CustomClockTimeEnabled = enabled
						if enabled then
							L.OriginalClockTime = Lighting.ClockTime
							Lighting.ClockTime = L.CustomClockTimeValue
						else
							Lighting.ClockTime = L.OriginalClockTime
						end
					end
				})
				ESP3:AddSlider("CustomClockTimeSlider", {
					Text = "ClockTime",
					Default = 12,
					Min = 0,
					Max = 24,
					Rounding = 0,
					Compact = true,
					Callback = function(v)
						L.CustomClockTimeValue = v
						if L.CustomClockTimeEnabled then
							Lighting.ClockTime = v
						end
					end
				})
ESP3:AddDropdown('SkyboxSelectionDropdown', {
    Values = (function()
        local skyKeys = {}
        for k, _ in pairs(L.Skyboxes) do
            table.insert(skyKeys, k)
        end
        table.sort(skyKeys)
        return skyKeys
    end)(),
    Default = 3,
    Multi = false,
    Text = 'Skybox Selection',
    Callback = function(value)
        L.SelectedSky = value
        if L.SkyboxEnabled then
            ApplySky(L.SelectedSky)
        end
    end
})
				local CHAMSESP1 = ESP1:AddToggle('ChamsESP', {
					Text = 'Player Chams',
					Default = false,
					Callback = function(v)
						L.ChamsEnabled = v
						if L.ChamsEnabled then
							for _, folder in ipairs(PlayersFolder:GetChildren()) do
								if folder:IsA("Folder") then
									for _, model in ipairs(folder:GetChildren()) do
										processChams(model)
										for _, child in ipairs(model:GetChildren()) do
											if isValidModel(child) then
												processChams(child)
											end
										end
									end
								end
							end
						else
							for model in pairs(L.ActiveChams) do
								clearChams(model)
							end
						end
					end
				})
				CHAMSESP1:AddColorPicker("ChamsESPCP", {
					Default = Color3.fromRGB(131,146,255),
					Title = "Chams Color",
					Callback = function(v)
						L.ChamsColor = v
					end
				})
				local NAMEVISUALS = ESP1:AddToggle('ShowPlayerTags', {
					Text = 'Player Name',
					Default = false,
					Callback = function(state)
						L.NameESPEnabled = state
					end
				})
				NAMEVISUALS:AddColorPicker('NameTagColor', {
					Default = Color3.fromRGB(200, 200, 255),
					Title = 'Name Text Color',
					Transparency = 0,
					Callback = function(color)
						L.NameTextColor = color
						for _, text in pairs(L.NameDrawings) do
							text.Color = color
						end
					end
				})
				local BOXVISUALS = ESP1:AddToggle("BoxESP", {
					Text = "Player Box",
					Default = false,
					Callback = function(state)
						L.BoxESPEnabled = state
					end
				})
				BOXVISUALS:AddColorPicker("BoxESPColor", {
					Default = Color3.fromRGB(255, 255, 255),
					Title = "Box Color",
					Transparency = 0,
					Callback = function(color)
						L.BoxColor = color
						for _, box in pairs(L.BoxDrawings) do
							box.Color = color
						end
					end
				})
				local HEALTHVISUALS = ESP1:AddToggle("HealthESP", {
					Text = "Player Health",
					Default = false,
					Callback = function(state)
						L.HealthESPEnabled = state
					end
				})

				HEALTHVISUALS:AddColorPicker("HealthESPHigh", {
					Default = Color3.fromRGB(0, 255, 0),
					Title = "Health Color ( High )",
					Transparency = nil,
					Callback = function(color)
						L.HealthHighColor = color
					end
				})

				HEALTHVISUALS:AddColorPicker("HealthESPLow", {
					Default = Color3.fromRGB(255, 0, 0),
					Title = "Health Color ( Low )",
					Transparency = nil,
					Callback = function(color)
						L.HealthLowColor = color
					end
				})

				local CHAMSESP2 = ESP1:AddToggle('DistanceESP', {
					Text = 'Player Distance',
					Default = false,
					Callback = function(v)
						L.DistanceESPEnabled = v
					end
				})
				CHAMSESP2:AddColorPicker("DistanceESPCP", {
					Default = Color3.fromRGB(255, 255, 255),
					Title = "Text Color",
					Callback = function(v)
					L.DistanceTextColor = v
				end
				})
				ESP1:AddSlider("ChamsTransparencySlider", {
					Text = "Chams Transparency",
					Default = L.ChamsTransparency or 0.5,
					Min = 0,
					Max = 1,
					Rounding = 2,
					Compact = true,
					Callback = function(v)
						L.ChamsTransparency = v
						for _, boxes in pairs(L.ActiveChams) do
							for _, b in ipairs(boxes) do
								if b then
									b.Transparency = v
								end
							end
						end
					end
				})
				ESP1:AddDropdown('ChamsTypeDropdown', {
					Values = { 'AlwaysOnTop', 'Occluded' },
					Default = 1,
					Multi = false,
					Text = 'Chams Type',
					Callback = function(Value)
						L.ChamsType = Value
						for model in pairs(L.ActiveChams) do
							clearChams(model)
						end
						if L.ChamsEnabled then
							refreshAllChams()
						end
					end
				})
				ESP1:AddDropdown('BoxTypeDropdown', {
					Values = { 'Full', 'Corner' },
					Default = 1,
					Multi = false,
					Text = 'Box Type',
					Callback = function(Value)
						L.BoxType = Value
					end
				})
ESP1:AddDropdown('FontTypeDropdown', {
    Values = {
        'UI',
        'System',
        'Plex',
        'Monospace'
    },
    Default = 3,
    Multi = false,
    Text = 'Text Font',
    Callback = function(Value)
        local fontId = FontMap[Value]
        if fontId ~= nil then
            updateAllFonts(fontId)
        end
    end
})

local TabBox = Tabs.B:AddRightTabbox()
local ExtraTab = TabBox:AddTab('Extra')
				local extracount = ExtraTab:AddToggle('AmmoCountToggle', {
					Text = 'Ammo Count',
					Default = false,
					Callback = function(v)
						AmmoLabel.Visible = v
					end
				})

				extracount:AddColorPicker("AmmoCountTextColor", {
					Default = Color3.fromRGB(255, 255, 255),
					Title = "Text Color",
					Callback = function(v)
						AmmoLabel.TextColor3 = v
					end
				})

				ExtraTab:AddSlider("AmmoCountPosY", {
					Text = "Vertical Position",
					Default = -350,
					Min = -500,
					Max = 500,
					Rounding = 0,
					Compact = true,
					Callback = function(v)
						AmmoLabel.Position = UDim2.new(0.5, AmmoLabel.Position.X.Offset, 0.95, v)
					end
				})

				ExtraTab:AddSlider("AmmoCountSize", {
					Text = "Text Size",
					Default = 15,
					Min = 10,
					Max = 50,
					Rounding = 1,
					Compact = true,
					Callback = function(v)
						AmmoLabel.TextScaled = false
						AmmoLabel.TextSize = v
					end
				})

				local BulletTab = TabBox:AddTab('Bullets')
				local SoundTab = TabBox:AddTab('Sound')

				SoundTab:AddToggle('GunShotSound', {
					Text = 'Gunshot Sound Override',
					Default = false,
					Callback = function(v)
						L.GunshotOverride = v
					end
				})
				SoundTab:AddDropdown('GunShotSoundIds', {
	Values = {
		'Minecraft experience',
		'Neverlose',
		'Gamesense',
		'One',
		'Bell',
		'Rust',
		'TF2',
		'Slime',
		'Among Us',
		'Minecraft',
		'CS:GO',
		'Saber',
		'Baimware',
		'Osu',
		'TF2 Critical',
		'Bat',
		'Call of Duty',
		'Bubble',
		'Pick',
		'Pop',
		'Bruh',
		'[Bamboo]',
		'Crowbar',
		'Weeb',
		'Beep',
		'Bambi',
		'Stone',
		'Old Fatality',
		'Click',
		'Ding',
		'Snow',
		'Laser',
		'Mario',
		'Steve',
		'Snowdrake',
		'Default'
	},
	Default = "",
	Multi = false,
	Text = 'Sound Selection',
	Callback = function(v)
		L.SelectedSound = v
	end
})
				SoundTab:AddSlider("SoundVolumeSlider", {
					Text = "Volume",
					Default = 1,
					Min = 0,
					Max = 10,
					Rounding = 1,
					Compact = true,
					Callback = function(v)
						L.SoundVolume = v
					end
				})

SoundTab:AddToggle('HitSoundShot', {
	Text = 'Hit Sound Override',
	Default = false,
	Callback = function(v)
		L.HitSoundOverride = v
		local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
		for _, root in ipairs(playerGui:GetChildren()) do
			for _, s in ipairs(root:GetDescendants()) do
				if s:IsA("Sound") and s.Name=="hitmarker" then
					if v then
						applyHitSound(s)
					else
						restoreHitSound(s)
					end
				end
			end
		end
	end
})

SoundTab:AddDropdown('HitSoundShotDropdown', {
	Values = { "Minecraft experience","Neverlose","Gamesense","One","Bell","Rust","TF2","Slime","Among Us","Minecraft","CS:GO","Saber","Baimware","Osu","TF2 Critical","Bat","Call of Duty","Bubble","Pick","Pop","Bruh","[Bamboo]","Crowbar","Weeb","Beep","Bambi","Stone","Old Fatality","Click","Ding","Snow","Laser","Mario","Steve","Snowdrake","Default" },
	Default = L.HitSoundSelected,
	Multi = false,
	Text = 'Sound Selection',
	Callback = function(v)
		L.HitSoundSelected = v
		if L.HitSoundOverride then
			local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
			for _, root in ipairs(playerGui:GetChildren()) do
				for _, s in ipairs(root:GetDescendants()) do
					if s:IsA("Sound") and s.Name=="hitmarker" then
						applyHitSound(s)
					end
				end
			end
		end
	end
})

SoundTab:AddSlider("HitSoundVolumeSlider", {
	Text = "Volume",
	Default = 1,
	Min = 0,
	Max = 10,
	Rounding = 1,
	Compact = true,
	Callback = function(v)
		L.HitSoundVolume = v
		if L.HitSoundOverride then
			local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
			for _, root in ipairs(playerGui:GetChildren()) do
				for _, s in ipairs(root:GetDescendants()) do
					if s:IsA("Sound") and s.Name=="hitmarker" then
						applyHitSound(s)
					end
				end
			end
		end
	end
})

SoundTab:AddToggle('KillSoundShot', {
	Text = 'Kill Sound Override',
	Default = false,
	Callback = function(v)
		L.KillSoundOverride = v
		local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
		for _, root in ipairs(playerGui:GetChildren()) do
			for _, s in ipairs(root:GetDescendants()) do
				if s:IsA("Sound") and (s.Name=="killshot" or s.Name=="headshotkill") then
					if v then
						applyKillSound(s)
					else
						restoreKillSound(s)
					end
				end
			end
		end
	end
})

SoundTab:AddDropdown('KillSoundShotDropdown', {
	Values = { "Minecraft experience","Neverlose","Gamesense","One","Bell","Rust","TF2","Slime","Among Us","Minecraft","CS:GO","Saber","Baimware","Osu","TF2 Critical","Bat","Call of Duty","Bubble","Pick","Pop","Bruh","[Bamboo]","Crowbar","Weeb","Beep","Bambi","Stone","Old Fatality","Click","Ding","Snow","Laser","Mario","Steve","Snowdrake","Default" },
	Default = L.KillSoundSelected or "Default",
	Multi = false,
	Text = 'Sound Selection',
	Callback = function(v)
		L.KillSoundSelected = v
		if L.KillSoundOverride then
			local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
			for _, root in ipairs(playerGui:GetChildren()) do
				for _, s in ipairs(root:GetDescendants()) do
					if s:IsA("Sound") and (s.Name=="killshot" or s.Name=="headshotkill") then
						applyKillSound(s)
					end
				end
			end
		end
	end
})

SoundTab:AddSlider("KillSoundVolumeSlider", {
	Text = "Volume",
	Default = 1,
	Min = 0,
	Max = 10,
	Rounding = 1,
	Compact = true,
	Callback = function(v)
		L.KillSoundVolume = v
		if L.KillSoundOverride then
			local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
			for _, root in ipairs(playerGui:GetChildren()) do
				for _, s in ipairs(root:GetDescendants()) do
					if s:IsA("Sound") and (s.Name=="killshot" or s.Name=="headshotkill") then
						applyKillSound(s)
					end
				end
			end
		end
	end
})

L.CrosshairLockOnTarget = false
L.CrosshairEnabled = false
L.CrosshairColor = Color3.fromRGB(255,255,255)
L.CrosshairSpin = false
L.CrosshairSize = 20
L.CrosshairSpinSpeed = 150
L.CrosshairThickness = 1
L.CrosshairGap = 2
L.CrosshairSides = {Top=true,Bottom=true,Left=true,Right=true}
L.CrosshairPositionMode = "Center Of Screen"

ESP4:AddToggle('CrosshairToggle1',{
	Text='Toggle Crosshair',
	Default=L.CrosshairEnabled,
	Callback=function(v)
		L.CrosshairEnabled=v
	end
}):AddColorPicker("CrosshairMainColor",{
	Default=L.CrosshairColor,
	Title="Crosshair Color",
	Callback=function(v)
		L.CrosshairColor=v
	end
})

ESP4:AddToggle('CrosshairSpinToggle',{
	Text='Spin',
	Default=L.CrosshairSpin,
	Callback=function(v)
		L.CrosshairSpin=v
	end
})

ESP4:AddToggle('CrosshairLockOnTarget',{
	Text='Lock On Target',
	Tooltip="Locks Crosshair On Aimbot Target",
	Default=false,
	Callback=function(v)
		L.CrosshairLockOnTarget = v
	end
})

ESP4:AddToggle('CrosshairRemoveIGCH',{
	Text='No Crosshair',
	Tooltip="Hides in-game crosshair",
	Default=false,
	Callback=function(v)
		local crosshairs = player.PlayerGui.HudScreenGui.Main.DisplayCrosshairs
		local parts = {
			crosshairs.Up,
			crosshairs.Center,
			crosshairs.Down,
			crosshairs.Left,
			crosshairs.Right,
		}
		for _, part in ipairs(parts) do
			if part then
				part.Visible = not v
			end
		end
	end
})

ESP4:AddSlider("CrossHairSizeSlider",{
	Text="Crosshair Size",
	Default=L.CrosshairSize,
	Min=2,
	Max=100,
	Rounding=0,
	Compact=true,
	Callback=function(v)
		L.CrosshairSize=v
	end
})

ESP4:AddSlider("CrosshairSpinSpeed",{
	Text="Spin Speed",
	Default=L.CrosshairSpinSpeed,
	Min=1,
	Max=200,
	Rounding=0,
	Compact=true,
	Callback=function(v)
		L.CrosshairSpinSpeed=v
	end
})

ESP4:AddSlider("CrosshairThickness",{
	Text="Crosshair Thickness",
	Default=L.CrosshairThickness,
	Min=1,
	Max=10,
	Rounding=0,
	Compact=true,
	Callback=function(v)
		L.CrosshairThickness=v
	end
})

ESP4:AddSlider("CrosshairGap",{
	Text="Crosshair Gap",
	Default=L.CrosshairGap,
	Min=0,
	Max=50,
	Rounding=0,
	Compact=true,
	Callback=function(v)
		L.CrosshairGap=v
	end
})

ESP4:AddDropdown('CrosshairStyles',{
	Values={'1','2','3','4','5'},
	Default='1',
	Multi=false,
	Text='Crosshair Style',
	Callback=function(v)
		L.CrosshairStyle=v
	end
})

ESP4:AddDropdown('CrosshairScreenPosition',{
	Values={'Center Of Screen','Gun Barrel'},
	Default="Center Of Screen",
	Multi=false,
	Text='Crosshair Position',
	Callback=function(v)
		L.CrosshairPositionMode=v
	end
})

local SilentToggle = Silent:AddToggle("ToggleSilent",{
	Text="Toggle Silent", -- fix nigger
	Default=false,
	Risky = true,
	Tooltip = "not working as of 2/23/26",
	Callback=function(v)
		L.SilentEnabled=v
		if not v then
			L.SilentHolding=false
			L:StopSilentAim()
		end
	end
})

SilentToggle:AddKeyPicker("AimbotToggleKeybind",{
	Default="MB2",
	Mode="Hold",
	SyncToggleState=false,
	Text="Silent Aim",
	Callback=function()
		L.SilentHolding=true
		if L.SilentEnabled then
			L:StartSilentAim()
		end
	end,
	ChangedCallback=function()
		L.SilentHolding=false
		L:StopSilentAim()
	end
})

Silent:AddToggle("SilentStickyAimToggle",{
	Text="Sticky Aim",
	Default=false,
	Callback=function(v)
		L.SilentSticky=v
	end
})

Silent:AddToggle("SilentWallCheckToggle",{
	Text="Wall Check",
	Default=false,
	Callback=function(v)
		L.SilentWallCheck=v
	end
})

Silent:AddSlider("SilentRedirectChanceSlider",{
	Text="Hit Chance",
	Default=50,
	Min=1,
	Max=100,
	Rounding=0,
	Compact=true,
	Suffix="%",
	Callback=function(v)
		L.SilentHitChance=v
	end
})

Silent:AddSlider("SilentMaxDistanceB",{
	Text="Max Distance",
	Default=500,
	Min=1,
	Max=1000,
	Rounding=0,
	Compact=true,
	Suffix="stds",
	Callback=function(v)
		L.SilentMaxDistance=v
	end
})

Silent:AddDropdown("SilentAimPartSelection",{
	Values={"Head","Torso"},
	Default=1,
	Multi=false,
	Text="Aimbot Bone",
	Callback=function(v)
		L.SilentAimPart=v
		L.SILENT_TARGET_MESH=L.SILENT_MESH_IDS[v]
	end
})

Silent:AddDropdown("SilentTypeDropdown",{
	Values={"Closest To Mouse","Closest To You"},
	Default=1,
	Multi=false,
	Text="Target Priority",
	Callback=function(v)
		L.SilentPriority=v
	end
})

Silent:AddDivider()

local SnapLine2 = Silent:AddToggle("SilentSnapLineToggle",{
	Text="Snap Line",
	Default=false,
	Callback=function(v)
		L.SilentSnapEnabled=v
	end
})

SnapLine2:AddColorPicker("SilentSnapLineColor",{
	Default=Color3.fromRGB(255,255,255),
	Title="Line Color",
	Callback=function(v)
		L.SilentSnapColor=v
	end
})

local SilentFovToggle = Silent:AddToggle("SilentToggleFOV",{
	Text="Show FOV",
	Default=false,
	Callback=function(v)
		L.SilentShowFOV=v
	end
})

Silent:AddToggle("SilentDynamicFOVToggle",{
	Text="Dynamic FOV",
	Default=false,
	Callback=function(v)
		L.SilentDynamicFOV=v
	end
})

SilentFovToggle:AddColorPicker("SilentL.FOVColor",{
	Default=Color3.fromRGB(255,255,255),
	Title="FOV Color",
	Callback=function(v)
		L.SilentFOVColor=v
	end
})

Silent:AddSlider("SilentFOVSize1",{
	Text="Size",
	Default=120,
	Min=0,
	Max=500,
	Rounding=0,
	Suffix="px",
	Compact=true,
	Callback=function(v)
		L.SilentFOVRadius=v
	end
})

Silent:AddDropdown("SilentSnapLineMethod",{
	Values={"Gun Barrel","Mouse"},
	Default=1,
	Multi=false,
	Text="Snap From",
	Callback=function(v)
		L.SilentSnapOriginMethod=v
	end
})

Silent:AddDropdown("SilentFovPositionMethod",{
	Values={"Gun Barrel","Mouse"},
	Default=1,
	Multi=false,
	Text="Fov Position",
	Callback=function(v)
		L.SilentFOVOriginMethod=v
	end
})





game:GetService("Players").LocalPlayer.PlayerGui.DescendantAdded:Connect(function(c)
	if c:IsA("Sound") then
		if c.Name=="hitmarker" and L.HitSoundOverride then
			applyHitSound(c)
		elseif (c.Name=="killshot" or c.Name=="headshotkill") and L.KillSoundOverride then
			applyKillSound(c)
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if not extracount.Value then
		AmmoLabel.Visible=false
		return
	end
	local currentAmmo=tonumber(Hud.TextMagCount.Text) or 0
	local spareAmmo=tonumber(Hud.TextSpareCount.Text) or 0
	AmmoLabel.Text=currentAmmo.."/"..spareAmmo
	AmmoLabel.Visible=(currentAmmo~=0 or spareAmmo~=0)
end)

pcall(function()
	workspace.StreamingEnabled=false
end)

Library:SetWatermarkVisibility(true)

local FrameTimer=tick()
local FrameCounter=0
local FPS=60
local GetPing=(function()
	return math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
end)
local CanDoPing=pcall(function()
	return GetPing()
end)

local WatermarkConnection=RunService.RenderStepped:Connect(function()
	FrameCounter+=1
	if (tick()-FrameTimer)>=1 then
		FPS=FrameCounter
		FrameTimer=tick()
		FrameCounter=0
	end
	if CanDoPing then
		Library:SetWatermark(('roxy.win / dev | %d fps | %d ms'):format(math.floor(FPS),GetPing()))
	else
		Library:SetWatermark(('roxy.win | %d fps'):format(math.floor(FPS)))
	end
end)

Library:OnUnload(function()
	L.AimbotEnabled = false
	L.ShowFOV = false
	L.ChamsEnabled = false
	L.BoxESPEnabled = false
	L.CrosshairEnabled = false
	L.GunshotOverride = false
	L.KillSoundOverride = false
	L.HitSoundOverride = false
	L.SkyboxEnabled = false
	L.NameESPEnabled = false
	L.DistanceESPEnabled = false
	L.ViewModelEnabled = false
	L.WeaponMasterEnabled = false
	L.HealthESPEnabled = false
	L.SnapEnabled = false
	L.KillNotifyEnabled = false
	L.WalkSpeedEnabled = false
	L.MasterEnabled = false
	L.HighlightEnabled = false
	L.SilentEnabled = false
	Lighting.Ambient = L.OriginalValues.Ambient
	if L.OriginalClockTime then Lighting.ClockTime = L.OriginalClockTime end
	local sky = Lighting:FindFirstChildOfClass("Sky")
	if sky then sky:Destroy() end
	local origSky = Lighting:FindFirstChild("OriginalSkyBackup")
	if origSky then origSky:Clone().Parent = Lighting end

	local hum = findHumanoid()
	if hum then hum.WalkSpeed = 16 end
	restoreHideArms()
	restoreArmMaterial()
	restoreWeaponMaterial()
	SetSleeveSlotsTransparency(0)
	for s, old in pairs(L.HitSoundBackup) do
		if s and s:IsDescendantOf(game) then s.SoundId = old.Id s.Volume = old.Volume end
	end
	for s, old in pairs(L.KillSoundBackup) do
		if s and s:IsDescendantOf(game) then s.SoundId = old.Id s.Volume = old.Volume end
	end
	for s, old in pairs(L.SoundBackup) do
		if s and s:IsDescendantOf(game) then s.SoundId = old.Id s.Volume = old.Volume end
	end
	if AmmoLabel then AmmoLabel:Destroy() end
	for _,h in pairs(L.ArmHighlights) do pcall(function() h:Destroy() end) end
	for _,h in pairs(L.WeaponHighlights) do pcall(function() h:Destroy() end) end
	for m,_ in pairs(L.ActiveChams) do clearChams(m) end
	pcall(function()
		for _,v in pairs(L.DistanceDrawings) do v:Remove() end
		for _,v in pairs(L.NameDrawings) do v:Remove() end
		for _, boxes in pairs(L.BoxDrawings) do
			for _, l in ipairs(boxes) do l:Remove() end
		end
		for _, outlines in pairs(L.BoxOutlineDrawings) do
			for _, l in ipairs(outlines) do l:Remove() end
		end
		for _,v in pairs(L.HealthDrawings) do v:Remove() end
		for _,v in pairs(L.HealthOutlineDrawings) do v:Remove() end
		for i=1,4 do 
            lines[i]:Remove() 
            outlines[i]:Remove() 
            flapLines[i]:Remove()
            flapOutlines[i]:Remove()
        end
		if dot then dot:Remove() end
		if dotOutline then dotOutline:Remove() end
		if SnapLine then SnapLine:Remove() end
		if SnapOutline then SnapOutline:Remove() end
		if FOVCircle then FOVCircle:Remove() end
		if FOVOutline then FOVOutline:Remove() end
		if SilentSnapLine then SilentSnapLine:Remove() end
		if SilentSnapOutline then SilentSnapOutline:Remove() end
		if SilentFOVCircle then SilentFOVCircle:Remove() end
		if SilentFOVOutline then SilentFOVOutline:Remove() end
	end)
	WatermarkConnection:Disconnect()
	Library.Unloaded = true
end)

local MenuGroup=Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddToggle("KeybindMenuOpen",{
	Default=Library.KeybindFrame.Visible,
	Text="Open Keybind Menu",
	Callback=function(v)
		Library.KeybindFrame.Visible=v
	end
})

MenuGroup:AddToggle("ShowCustomCursor",{
	Text="Custom Cursor",
	Default=false,
	Callback=function(v)
		Library.ShowCustomCursor=v
	end
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind",{Default="RightShift",NoUI=true,Text="Menu keybind"})
MenuGroup:AddButton("Unload",function()
	Library:Unload()
end)

local text="you're a developer.."
local color="rgb(162,174,255)"
local label=MenuGroup:AddLabel("")
label.RichText=true

task.spawn(function()
	while true do
		for i=1,#text do
			label:SetText('<font color="'..color..'">'..text:sub(1,i)..'</font>')
			task.wait(0.05)
		end
		task.wait(0.3)
		for i=#text-1,0,-1 do
			label:SetText('<font color="'..color..'">'..text:sub(1,i)..'</font>')
			task.wait(0.05)
		end
		task.wait(0.1)
	end
end)

local baseTitle = "                                                                                        "
local current = "$$ roxy.win $$"
local flickerChar = "$$"

task.spawn(function()
	local visible = true
	while true do
		local left = visible and flickerChar or "  "
		local right = visible and flickerChar or "  "
		local middle = current:sub(3, #current-2)
		Window:SetWindowTitle(baseTitle .. left .. middle .. right)
		visible = not visible
		task.wait(0.5)
	end
end)

Library.ToggleKeybind=Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('Roxx')
SaveManager:SetFolder('Roxx/Phantom-Forces')
SaveManager:SetSubFolder('specific-place')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
