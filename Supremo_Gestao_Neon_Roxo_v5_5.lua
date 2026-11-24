-- BY Supremo Gestao v5.5 - interface neon roxo (Zero Delay + Fisica Fluida) (Canais Laterais + Config Supremo + Zero Delay Pulo/Dash/Soco + X e -)
-- Live hierarchy of the target experience was not inspected directly; uses standard Roblox instances and heuristics.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = pcall(function() return game:GetService("VirtualInputManager") end) and game:GetService("VirtualInputManager") or nil

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

for _, name in ipairs({"SUPREMO_PANEL_GUI", "DARK_LAG_HUB", "DARK_LAG_FPS"}) do
	local old = playerGui:FindFirstChild(name)
	if old then
		pcall(function() old:Destroy() end)
	end
end

local LINE_COLOR_PRESETS = {
	["Azul"] = {
		primary = Color3.fromRGB(115, 70, 255),
		accent = Color3.fromRGB(70, 175, 255),
		alpha = 0.05
	},
	["Roxo"] = {
		primary = Color3.fromRGB(175, 55, 255),
		accent = Color3.fromRGB(95, 110, 255),
		alpha = 0.05
	},
	["Ciano"] = {
		primary = Color3.fromRGB(90, 140, 255),
		accent = Color3.fromRGB(170, 75, 255),
		alpha = 0.05
	},
	["Branco"] = {
		primary = Color3.fromRGB(165, 85, 255),
		accent = Color3.fromRGB(80, 165, 255),
		alpha = 0.05
	}
}

local LINE_COLOR_ORDER = {"Azul", "Roxo", "Ciano", "Branco"}

local config = {
	hubActive = true,
	panelOpen = true,
	minimizedToSquare = false,
	aimAssistEnabled = true,
	punchAssistRange = 60,
	punchAssistStrength = 0.65,
	ignoreTeam = false,

	fovEnabled = false,
	fovValue = 60,
	fovRadius = 120,
	fovOpacity = 0.40,
	showFovCircle = true,
	fovFilled = false,

	espEnabled = false,
	espBox = false,
	espName = false,
	espDistance = false,
	espHealth = false,
	espLines = false,
	espStyle = "Cantos",
	espMaxDistance = 500,

	mapVisualsEnabled = true,
	mapTheme = "Azul + Roxo",
	lineColorPreset = "Roxo",
	lagOptEnabled = true,
	spiderVisualEnabled = true,
	dashImpulse = 64,
	dashNoclipEnabled = false,
	dashNoclipHoldKey = Enum.KeyCode.ButtonL2,
	doubleTapAEnabled = true,
	doubleTapAWindow = 0.28,
	activeTab = "Principal",
	activeChannel = "Aimbot"
}

local function snapshotConfig()
	return table.clone(config)
end

local defaultSnapshot = snapshotConfig()
local savedProfiles = {
	["Padrao"] = snapshotConfig()
}
local selectedProfileName = "Padrao"
local pendingConfirmProfile = nil

local MAP_THEMES = {
	["Azul + Roxo"] = {
		floorColor = Color3.fromRGB(24, 28, 72),
		floorMaterial = Enum.Material.SmoothPlastic,
		floorReflectance = 0.02,
		gridColor = Color3.fromRGB(165, 75, 255),
		gridAccentColor = Color3.fromRGB(65, 165, 255),
		gridTransparency = 0.05,
		showFloorGrid = true,
		railColor = Color3.fromRGB(155, 65, 255),
		blockNormal = Color3.fromRGB(52, 88, 225),
		blockBreaking = Color3.fromRGB(168, 55, 255),
		blockCoreColor = Color3.fromRGB(120, 195, 255),
		backdropColor = Color3.fromRGB(22, 14, 58),
		ambientColor = Color3.fromRGB(115, 105, 205),
		fogColor = Color3.fromRGB(24, 16, 64)
	},
	["Roxo e Preto"] = {
		floorColor = Color3.fromRGB(18, 16, 28),
		floorMaterial = Enum.Material.SmoothPlastic,
		floorReflectance = 0.02,
		gridColor = Color3.fromRGB(175, 55, 255),
		gridAccentColor = Color3.fromRGB(95, 110, 255),
		gridTransparency = 0.05,
		showFloorGrid = true,
		railColor = Color3.fromRGB(175, 55, 235),
		blockNormal = Color3.fromRGB(98, 32, 215),
		blockBreaking = Color3.fromRGB(165, 75, 255),
		blockCoreColor = Color3.fromRGB(215, 155, 255),
		backdropColor = Color3.fromRGB(26, 8, 42),
		ambientColor = Color3.fromRGB(130, 90, 175),
		fogColor = Color3.fromRGB(22, 8, 38)
	},
	["Amarelona"] = {
		floorColor = Color3.fromRGB(242, 182, 18),
		floorMaterial = Enum.Material.SmoothPlastic,
		floorReflectance = 0.02,
		gridColor = Color3.fromRGB(165, 75, 255),
		gridAccentColor = Color3.fromRGB(65, 165, 255),
		gridTransparency = 0.05,
		showFloorGrid = true,
		railColor = Color3.fromRGB(85, 225, 75),
		blockNormal = Color3.fromRGB(115, 225, 105),
		blockBreaking = Color3.fromRGB(28, 92, 36),
		blockCoreColor = Color3.fromRGB(185, 255, 175),
		backdropColor = Color3.fromRGB(185, 98, 10),
		ambientColor = Color3.fromRGB(195, 165, 95),
		fogColor = Color3.fromRGB(175, 92, 12)
	},
	["Branco e Azul"] = {
		floorColor = Color3.fromRGB(238, 242, 248),
		floorMaterial = Enum.Material.SmoothPlastic,
		floorReflectance = 0.02,
		gridColor = Color3.fromRGB(165, 75, 255),
		gridAccentColor = Color3.fromRGB(65, 165, 255),
		gridTransparency = 0.05,
		showFloorGrid = true,
		railColor = Color3.fromRGB(24, 115, 235),
		blockNormal = Color3.fromRGB(36, 132, 255),
		blockBreaking = Color3.fromRGB(16, 48, 110),
		blockCoreColor = Color3.fromRGB(165, 215, 255),
		backdropColor = Color3.fromRGB(210, 224, 245),
		ambientColor = Color3.fromRGB(175, 190, 215),
		fogColor = Color3.fromRGB(215, 228, 248)
	},
	["Azul + Rosa"] = {
		floorColor = Color3.fromRGB(28, 105, 215),
		floorMaterial = Enum.Material.SmoothPlastic,
		floorReflectance = 0.02,
		gridColor = Color3.fromRGB(165, 75, 255),
		gridAccentColor = Color3.fromRGB(65, 165, 255),
		gridTransparency = 0.05,
		showFloorGrid = true,
		railColor = Color3.fromRGB(245, 55, 155),
		blockNormal = Color3.fromRGB(85, 22, 68),
		blockBreaking = Color3.fromRGB(255, 125, 195),
		blockCoreColor = Color3.fromRGB(245, 95, 180),
		backdropColor = Color3.fromRGB(58, 14, 38),
		ambientColor = Color3.fromRGB(155, 115, 155),
		fogColor = Color3.fromRGB(52, 12, 34)
	}
}

local SPIDER_RED = Color3.fromRGB(225, 25, 35)
local SPIDER_BLUE = Color3.fromRGB(22, 65, 195)
local SPIDER_WHITE = Color3.fromRGB(248, 248, 255)

local ESP_ENEMY_COLOR = Color3.fromRGB(220, 255, 40)
local ESP_FILL_TRANSPARENCY = 0.55
local ESP_OUTLINE_TRANSPARENCY = 0

local BASE_WALK_SPEED = 16
local BASE_JUMP_POWER = 50

local DASH_NOCLIP_MAX_DIST = 42

local lagOriginals = {}
local lagLightingOriginals = {}
local mapOriginals = {}
local mapLightingOriginals = {}
local mapAddedInstances = {}
local spiderOriginals = {}
local spiderAddedInstances = {}
local terrainOriginals = {}
local trackedBlocks = {}
local trackedFloors = {}
local blockConnections = {}

local espHighlights = {}
local espDrawingBoxes = {}
local espDrawingLines = {}
local espBillboards = {}
local espConnections = {}

local originalFov = nil
local fovCircleDrawing = nil
local lastPunchAssistAt = 0
local lastDashAt = 0
local lastAPressAt = 0

local dashNoclipLtHeld = false
local dashNoclipSavedCollide = {}
local dashNoclipStepConn = nil
local dashNoclipChangedConn = nil

local floorReferencePart
local floorReferenceY
local floorReferencePosition
local isRebuildingEnvironment = false

local function getActiveTheme()
	return MAP_THEMES[config.mapTheme] or MAP_THEMES["Azul + Roxo"]
end

local function getLineColors(theme)
	local preset = LINE_COLOR_PRESETS[config.lineColorPreset]
	if preset then
		return preset.primary, preset.accent, preset.alpha
	end
	return Color3.fromRGB(165, 75, 255), Color3.fromRGB(65, 165, 255), theme.gridTransparency or 0.05
end

local function hasDrawingApi()
	return type(Drawing) == "table" and type(Drawing.new) == "function"
end

local function isCharacter(obj)
	local current = obj
	while current and current ~= Workspace do
		if current:IsA("Model") and current:FindFirstChildOfClass("Humanoid") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function isOwnCharacterDescendant(obj)
	local char = player.Character
	if not char or not obj then return false end
	return obj == char or obj:IsDescendantOf(char)
end

local function containsName(obj, words)
	local name = string.lower(obj.Name)
	for _, word in ipairs(words) do
		if string.find(name, word, 1, true) then
			return true
		end
	end
	return false
end

local function change(store, obj, property, value)
	if not obj or not obj.Parent then return end
	local ok, oldValue = pcall(function()
		return obj[property]
	end)
	if not ok then return end

	store[obj] = store[obj] or {}
	if store[obj][property] == nil then
		store[obj][property] = oldValue
	end

	pcall(function()
		obj[property] = value
	end)
end

local function restore(store)
	if type(store) ~= "table" then return end
	for obj, properties in pairs(store) do
		if obj and obj.Parent then
			for property, value in pairs(properties) do
				pcall(function()
					obj[property] = value
				end)
			end
		end
	end
	table.clear(store)
end

local function cleanupInstanceEntry(obj)
	lagOriginals[obj] = nil
	mapOriginals[obj] = nil
	spiderOriginals[obj] = nil
	trackedBlocks[obj] = nil
	trackedFloors[obj] = nil
	dashNoclipSavedCollide[obj] = nil

	local conns = blockConnections[obj]
	if conns then
		for _, conn in ipairs(conns) do
			pcall(function() conn:Disconnect() end)
		end
		blockConnections[obj] = nil
	end
end

local function isEnemyPlayer(targetPlayer)
	if not targetPlayer or targetPlayer == player then
		return false
	end
	if config.ignoreTeam then
		return true
	end

	local okLocal, localTeam = pcall(function() return player.Team end)
	local okTarget, targetTeam = pcall(function() return targetPlayer.Team end)

	if okLocal and okTarget and localTeam ~= nil and targetTeam ~= nil then
		return localTeam ~= targetTeam
	end

	return true
end

local function getCharacterRoot(char)
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
end

-- NOCLIP SEGURANDO BUTTONL2 (LT) QUANDO ATIVADO NO PAINEL
local function restoreDashNoclipCollisions()
	for part, prevCollide in pairs(dashNoclipSavedCollide) do
		if part and part.Parent and part:IsA("BasePart") then
			pcall(function()
				part.CanCollide = prevCollide
			end)
		end
	end
	table.clear(dashNoclipSavedCollide)
end

local function applyDashNoclipStep()
	if not config.hubActive or not config.dashNoclipEnabled or not dashNoclipLtHeld then
		restoreDashNoclipCollisions()
		return
	end

	local char = player.Character
	local root = getCharacterRoot(char)
	if not char or not char.Parent or not root then
		restoreDashNoclipCollisions()
		return
	end

	local rootPos = root.Position
	local activeParts = {}

	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj:IsA("Terrain") and not isOwnCharacterDescendant(obj) and not isCharacter(obj) then
			local okPos, pos = pcall(function() return obj.Position end)
			if okPos and typeof(pos) == "Vector3" and (pos - rootPos).Magnitude <= DASH_NOCLIP_MAX_DIST then
				local okCol, canCollide = pcall(function() return obj.CanCollide end)
				if okCol and (canCollide or dashNoclipSavedCollide[obj] ~= nil) then
					activeParts[obj] = true
					if dashNoclipSavedCollide[obj] == nil then
						dashNoclipSavedCollide[obj] = canCollide
					end
					if canCollide then
						pcall(function()
							obj.CanCollide = false
						end)
					end
				end
			end
		end
	end

	for part, prevCollide in pairs(dashNoclipSavedCollide) do
		if not activeParts[part] then
			if part and part.Parent and part:IsA("BasePart") then
				pcall(function()
					part.CanCollide = prevCollide
				end)
			end
			dashNoclipSavedCollide[part] = nil
		end
	end
end

local function setDashNoclipLtHeld(held)
	local nextHeld = (held == true) and config.hubActive and config.dashNoclipEnabled
	if dashNoclipLtHeld == nextHeld then
		if not nextHeld then
			restoreDashNoclipCollisions()
		end
		return
	end

	dashNoclipLtHeld = nextHeld
	if dashNoclipLtHeld then
		applyDashNoclipStep()
		if not dashNoclipStepConn then
			dashNoclipStepConn = RunService.Stepped:Connect(function()
				applyDashNoclipStep()
			end)
		end
	else
		if dashNoclipStepConn then
			dashNoclipStepConn:Disconnect()
			dashNoclipStepConn = nil
		end
		restoreDashNoclipCollisions()
	end
end

local function setDashNoclipEnabled(enabled)
	config.dashNoclipEnabled = (enabled == true)
	if not config.dashNoclipEnabled then
		setDashNoclipLtHeld(false)
	end
end

local function cleanupDashNoclipOnHubDisable()
	setDashNoclipLtHeld(false)
	restoreDashNoclipCollisions()
end

if not dashNoclipChangedConn then
	dashNoclipChangedConn = UIS.InputChanged:Connect(function(input)
		local targetKey = config.dashNoclipHoldKey or Enum.KeyCode.ButtonL2
		if input.KeyCode == targetKey then
			local triggerDepth = input.Position.Z > 0.20
			setDashNoclipLtHeld(triggerDepth)
		end
	end)
end

-- FOV DA CAMERA
local function restoreCameraFov()
	local cam = Workspace.CurrentCamera
	if cam and type(originalFov) == "number" then
		pcall(function()
			cam.FieldOfView = originalFov
		end)
	end
	originalFov = nil
end

local function applyCameraFov()
	local cam = Workspace.CurrentCamera
	if not cam then return end

	if not config.hubActive or not config.fovEnabled then
		restoreCameraFov()
		return
	end

	if originalFov == nil then
		local ok, cur = pcall(function() return cam.FieldOfView end)
		if ok and type(cur) == "number" then
			originalFov = cur
		end
	end

	pcall(function()
		if math.abs(cam.FieldOfView - config.fovValue) > 0.05 then
			cam.FieldOfView = config.fovValue
		end
	end)
end

-- CIRCULO DE RAIO NA TELA
local function ensureFovCircle()
	if not hasDrawingApi() then return nil end
	if not fovCircleDrawing then
		local ok, circle = pcall(function()
			local d = Drawing.new("Circle")
			d.Visible = false
			d.NumSides = 64
			d.Thickness = 1.5
			return d
		end)
		if ok and circle then
			fovCircleDrawing = circle
		end
	end
	return fovCircleDrawing
end

local function updateFovCircle()
	local circle = ensureFovCircle()
	if not circle then return end

	local cam = Workspace.CurrentCamera
	if not config.hubActive or not config.fovEnabled or not config.showFovCircle or not cam then
		circle.Visible = false
		return
	end

	local vp = cam.ViewportSize
	circle.Position = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
	circle.Radius = config.fovRadius
	circle.Color = Color3.fromRGB(175, 85, 255)
	circle.Transparency = math.clamp(1 - config.fovOpacity, 0.05, 1)
	circle.Filled = config.fovFilled
	circle.Visible = true
end

-- ESP INIMIGO
local function clearPlayerEsp(targetPlayer)
	local conns = espConnections[targetPlayer]
	if conns then
		for _, c in ipairs(conns) do
			pcall(function() c:Disconnect() end)
		end
		espConnections[targetPlayer] = nil
	end

	local hl = espHighlights[targetPlayer]
	if hl then
		pcall(function()
			hl.Enabled = false
			hl:Destroy()
		end)
		espHighlights[targetPlayer] = nil
	end

	local bb = espBillboards[targetPlayer]
	if bb then
		pcall(function() bb:Destroy() end)
		espBillboards[targetPlayer] = nil
	end

	local box = espDrawingBoxes[targetPlayer]
	if box then
		pcall(function()
			box.Visible = false
			if box.Remove then box:Remove() end
		end)
		espDrawingBoxes[targetPlayer] = nil
	end

	local line = espDrawingLines[targetPlayer]
	if line then
		pcall(function()
			line.Visible = false
			if line.Remove then line:Remove() end
		end)
		espDrawingLines[targetPlayer] = nil
	end
end

local function ensureBillboard(targetPlayer, char)
	local head = char:FindFirstChild("Head") or getCharacterRoot(char)
	if not head then return nil end

	local bb = espBillboards[targetPlayer]
	if not bb or not bb.Parent or bb.Adornee ~= head then
		if bb then pcall(function() bb:Destroy() end) end
		bb = Instance.new("BillboardGui")
		bb.Name = "SUPREMO_ESP_INFO"
		bb.Adornee = head
		bb.Size = UDim2.fromOffset(180, 44)
		bb.StudsOffset = Vector3.new(0, 2.6, 0)
		bb.AlwaysOnTop = true
		bb.Parent = playerGui

		local lbl = Instance.new("TextLabel")
		lbl.Name = "InfoLabel"
		lbl.Size = UDim2.fromScale(1, 1)
		lbl.BackgroundTransparency = 1
		lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 12
		lbl.TextColor3 = ESP_ENEMY_COLOR
		lbl.TextStrokeTransparency = 0.25
		lbl.Parent = bb

		espBillboards[targetPlayer] = bb
	end
	return bb
end

local function updateEsp()
	if not config.hubActive or not config.espEnabled then
		for _, hl in pairs(espHighlights) do
			if hl then hl.Enabled = false end
		end
		for _, bb in pairs(espBillboards) do
			if bb then bb.Enabled = false end
		end
		for _, d in pairs(espDrawingBoxes) do
			pcall(function() d.Visible = false end)
		end
		for _, d in pairs(espDrawingLines) do
			pcall(function() d.Visible = false end)
		end
		return
	end

	local cam = Workspace.CurrentCamera
	local myChar = player.Character
	local myRoot = getCharacterRoot(myChar)

	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= player then
			local char = targetPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = getCharacterRoot(char)
			local validEnemy = isEnemyPlayer(targetPlayer) and char and char.Parent and hum and hum.Health > 0 and root

			local distStuds = 0
			if validEnemy and myRoot then
				distStuds = (root.Position - myRoot.Position).Magnitude
			end

			if not validEnemy or distStuds > config.espMaxDistance then
				if espHighlights[targetPlayer] then espHighlights[targetPlayer].Enabled = false end
				if espBillboards[targetPlayer] then espBillboards[targetPlayer].Enabled = false end
				if espDrawingBoxes[targetPlayer] then pcall(function() espDrawingBoxes[targetPlayer].Visible = false end) end
				if espDrawingLines[targetPlayer] then pcall(function() espDrawingLines[targetPlayer].Visible = false end) end
			else
				local hl = espHighlights[targetPlayer]
				if not hl or not hl.Parent then
					hl = Instance.new("Highlight")
					hl.Name = "SUPREMO_ESP_HIGHLIGHT"
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Parent = playerGui
					espHighlights[targetPlayer] = hl
				end
				hl.Adornee = char
				hl.FillColor = ESP_ENEMY_COLOR
				hl.FillTransparency = (config.espStyle == "Cheia") and 0.35 or ESP_FILL_TRANSPARENCY
				hl.OutlineColor = ESP_ENEMY_COLOR
				hl.OutlineTransparency = ESP_OUTLINE_TRANSPARENCY
				hl.Enabled = true

				local showInfo = config.espName or config.espDistance or config.espHealth
				local bb = ensureBillboard(targetPlayer, char)
				if bb then
					bb.Enabled = showInfo
					local lbl = bb:FindFirstChild("InfoLabel")
					if lbl then
						local parts = {}
						if config.espName then
							table.insert(parts, targetPlayer.DisplayName)
						end
						if config.espHealth then
							table.insert(parts, string.format("%d HP", math.round(hum.Health)))
						end
						if config.espDistance and myRoot then
							table.insert(parts, string.format("%d m", math.round(distStuds)))
						end
						lbl.Text = table.concat(parts, " • ")
					end
				end

				if cam and hasDrawingApi() then
					local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
					if onScreen and screenPos.Z > 0 then
						local box = espDrawingBoxes[targetPlayer]
						if not box then
							local ok, d = pcall(function()
								local sq = Drawing.new("Square")
								sq.Thickness = 1.5
								return sq
							end)
							if ok and d then
								box = d
								espDrawingBoxes[targetPlayer] = box
							end
						end
						if box then
							if config.espBox then
								local scaleH = math.clamp(2200 / screenPos.Z, 24, 340)
								local scaleW = scaleH * 0.62
								box.Size = Vector2.new(scaleW, scaleH)
								box.Position = Vector2.new(screenPos.X - scaleW * 0.5, screenPos.Y - scaleH * 0.5)
								box.Filled = (config.espStyle == "Cheia")
								box.Color = ESP_ENEMY_COLOR
								box.Visible = true
							else
								box.Visible = false
							end
						end

						local line = espDrawingLines[targetPlayer]
						if not line then
							local ok, d = pcall(function()
								local ln = Drawing.new("Line")
								ln.Thickness = 1.2
								return ln
							end)
							if ok and d then
								line = d
								espDrawingLines[targetPlayer] = line
							end
						end
						if line then
							if config.espLines then
								local vp = cam.ViewportSize
								line.From = Vector2.new(vp.X * 0.5, vp.Y)
								line.To = Vector2.new(screenPos.X, screenPos.Y)
								line.Color = ESP_ENEMY_COLOR
								line.Visible = true
							else
								line.Visible = false
							end
						end
					else
						if espDrawingBoxes[targetPlayer] then pcall(function() espDrawingBoxes[targetPlayer].Visible = false end) end
						if espDrawingLines[targetPlayer] then pcall(function() espDrawingLines[targetPlayer].Visible = false end) end
					end
				end
			end
		end
	end
end

-- VISUAL HOMEM-ARANHA NO SEU PERSONAGEM
local function getSpiderPartColor(part)
	local n = string.lower(part.Name)
	if string.find(n, "head", 1, true) then
		return SPIDER_RED
	elseif string.find(n, "torso", 1, true) or string.find(n, "upper", 1, true) then
		return SPIDER_RED
	elseif string.find(n, "lower", 1, true) or string.find(n, "leg", 1, true) or string.find(n, "foot", 1, true) then
		return SPIDER_BLUE
	elseif string.find(n, "arm", 1, true) or string.find(n, "hand", 1, true) then
		return SPIDER_RED
	end
	return SPIDER_WHITE
end

local function clearSpiderExtras()
	for _, inst in ipairs(spiderAddedInstances) do
		pcall(function()
			if inst and inst.Parent then
				inst:Destroy()
			end
		end)
	end
	table.clear(spiderAddedInstances)
end

local function addSpiderChestEmblem(char)
	local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not torso or not torso:IsA("BasePart") then return end
	if torso:FindFirstChild("SPIDER_CHEST_EMBLEM") then return end

	local gui = Instance.new("SurfaceGui")
	gui.Name = "SPIDER_CHEST_EMBLEM"
	gui.Face = Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 32
	gui.Adornee = torso
	gui.Parent = torso

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(22, 22)
	dot.Position = UDim2.new(0.5, -11, 0.45, -11)
	dot.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	dot.BorderSizePixel = 0
	dot.Parent = gui
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	table.insert(spiderAddedInstances, gui)
end

local function applySpiderVisualToOwnCharacter()
	if not config.hubActive or not config.spiderVisualEnabled then return end
	local char = player.Character
	if not char then return end

	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
			change(spiderOriginals, obj, "Color", getSpiderPartColor(obj))
			change(spiderOriginals, obj, "Material", Enum.Material.SmoothPlastic)
			change(spiderOriginals, obj, "Reflectance", 0.08)
		elseif obj:IsA("Shirt") or obj:IsA("Pants") then
			change(spiderOriginals, obj, "Color3", SPIDER_RED)
		elseif obj:IsA("ShirtGraphic") then
			change(spiderOriginals, obj, "Color3", SPIDER_WHITE)
		elseif obj:IsA("Decal") and string.lower(obj.Name) == "face" then
			change(spiderOriginals, obj, "Transparency", 0.65)
		end
	end

	addSpiderChestEmblem(char)
end

local function restoreSpiderVisual()
	clearSpiderExtras()
	restore(spiderOriginals)
end

-- DETECCAO DE CHAO, BLOCOS, LASERS/BORDAS E FUNDO
local function findFloorReference()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {character}
	params.IgnoreWater = false

	local result = Workspace:Raycast(
		root.Position + Vector3.new(0, 2, 0),
		Vector3.new(0, -500, 0),
		params
	)

	if result then
		if floorReferenceY == nil then
			floorReferenceY = result.Position.Y
			floorReferencePosition = result.Position
		end
		if result.Instance and result.Instance:IsA("BasePart") and floorReferencePart == nil then
			floorReferencePart = result.Instance
		end
	end
end

local function isRailOrLaser(obj)
	if not obj:IsA("BasePart") or isCharacter(obj) then return false end
	if containsName(obj, {"laser", "beam", "raio", "sweeper", "rail", "border", "borda"}) then
		return true
	end
	local s = obj.Size
	local longest = math.max(s.X, s.Y, s.Z)
	local shortest = math.min(s.X, s.Y, s.Z)
	return longest >= 8 and longest >= shortest * 5
end

local function isBreakableBlock(obj)
	if not obj:IsA("BasePart") or isCharacter(obj) or isRailOrLaser(obj) then
		return false
	end
	if containsName(obj, {"block", "bloco", "break", "quebra", "crumble", "box", "cube"}) then
		return true
	end
	if floorReferenceY and obj.Position.Y > floorReferenceY + 0.5 and obj.Position.Y < floorReferenceY + 35 then
		local maxDim = math.max(obj.Size.X, obj.Size.Y, obj.Size.Z)
		if maxDim >= 2 and maxDim <= 40 then
			return true
		end
	end
	return false
end

local function isFloor(obj)
	if not obj:IsA("BasePart") then return false end
	if isCharacter(obj) or isRailOrLaser(obj) or isBreakableBlock(obj) then return false end

	if trackedFloors[obj] then
		return true
	end

	if floorReferencePart and obj == floorReferencePart then
		return true
	end

	if containsName(obj, {
		"floor", "ground", "chao", "piso",
		"platform", "plataforma", "baseplate",
		"mapfloor", "terrain", "walkable", "arena", "tile", "grid"
	}) then
		return true
	end

	if obj.CFrame.UpVector.Y < 0.85 then
		return false
	end

	local flatSpan = math.max(obj.Size.X, obj.Size.Z)
	if flatSpan < 16 then
		return false
	end

	if floorReferenceY then
		local topY = (obj.CFrame * Vector3.new(0, obj.Size.Y / 2, 0)).Y
		if math.abs(topY - floorReferenceY) <= 14 then
			return true
		end
	end

	return obj.Size.Y <= 12 and flatSpan >= 32
end

local function isBackdrop(obj)
	if not obj:IsA("BasePart") then return false end
	if isCharacter(obj) or isFloor(obj) or isRailOrLaser(obj) or isBreakableBlock(obj) then return false end
	if containsName(obj, {"sky", "fundo", "bg", "backdrop", "void", "space", "ceu", "horizon", "wall", "parede"}) then
		return true
	end
	local maxDim = math.max(obj.Size.X, obj.Size.Y, obj.Size.Z)
	return maxDim >= 120
end

local function isBlockBreaking(part)
	if part.Transparency > 0.08 then
		return true
	end

	if containsName(part, {"break", "quebra", "crack", "racha", "danger", "crit", "fragile"}) then
		return true
	end

	for _, attrName in ipairs({"Health", "Hp", "Durability", "BreakProgress", "Stage", "Hits", "Breaking"}) do
		local val = part:GetAttribute(attrName)
		if type(val) == "boolean" and val then
			return true
		elseif type(val) == "number" and val <= 0.75 then
			return true
		end
	end

	return false
end

local function clearMapExtras()
	for _, inst in ipairs(mapAddedInstances) do
		pcall(function()
			if inst and inst.Parent then
				inst:Destroy()
			end
		end)
	end
	table.clear(mapAddedInstances)
	table.clear(trackedFloors)
end

-- BORDA AZUL E ROXO CONTORNANDO O FIM DO MAPA
local function buildUniformGrid(container, part, theme)
	for _, child in ipairs(container:GetChildren()) do
		child:Destroy()
	end

	local primaryCol, accentCol, alpha = getLineColors(theme)
	local thicknessPx = 3

	local topEdge = Instance.new("Frame")
	topEdge.Name = "TopBorderLine"
	topEdge.Size = UDim2.new(1, 0, 0, thicknessPx)
	topEdge.Position = UDim2.new(0, 0, 0, 0)
	topEdge.BackgroundColor3 = primaryCol
	topEdge.BackgroundTransparency = alpha
	topEdge.BorderSizePixel = 0
	topEdge.Parent = container

	local bottomEdge = Instance.new("Frame")
	bottomEdge.Name = "BottomBorderLine"
	bottomEdge.Size = UDim2.new(1, 0, 0, thicknessPx)
	bottomEdge.Position = UDim2.new(0, 0, 1, -thicknessPx)
	bottomEdge.BackgroundColor3 = accentCol
	bottomEdge.BackgroundTransparency = alpha
	bottomEdge.BorderSizePixel = 0
	bottomEdge.Parent = container

	local leftEdge = Instance.new("Frame")
	leftEdge.Name = "LeftBorderLine"
	leftEdge.Size = UDim2.new(0, thicknessPx, 1, 0)
	leftEdge.Position = UDim2.new(0, 0, 0, 0)
	leftEdge.BackgroundColor3 = accentCol
	leftEdge.BackgroundTransparency = alpha
	leftEdge.BorderSizePixel = 0
	leftEdge.Parent = container

	local rightEdge = Instance.new("Frame")
	rightEdge.Name = "RightBorderLine"
	rightEdge.Size = UDim2.new(0, thicknessPx, 1, 0)
	rightEdge.Position = UDim2.new(1, -thicknessPx, 0, 0)
	rightEdge.BackgroundColor3 = primaryCol
	rightEdge.BackgroundTransparency = alpha
	rightEdge.BorderSizePixel = 0
	rightEdge.Parent = container
end

local function applyFloorDetails(part, theme)
	if not part or not part.Parent then return end
	trackedFloors[part] = true

	local gui = part:FindFirstChild("SUPREMO_FLOOR_DETAIL")
	if not config.hubActive or not config.mapVisualsEnabled or not theme.showFloorGrid then
		if gui then gui.Enabled = false end
		return
	end

	if not gui then
		gui = Instance.new("SurfaceGui")
		gui.Name = "SUPREMO_FLOOR_DETAIL"
		gui.Face = Enum.NormalId.Top
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 16
		gui.AlwaysOnTop = false
		gui.Adornee = part
		gui.Parent = part
		table.insert(mapAddedInstances, gui)
	end

	gui.Enabled = true
	gui.Adornee = part

	local container = gui:FindFirstChild("UniformGridContainer")
	if not container then
		container = Instance.new("Frame")
		container.Name = "UniformGridContainer"
		container.Size = UDim2.fromScale(1, 1)
		container.BackgroundTransparency = 1
		container.Parent = gui
	end

	buildUniformGrid(container, part, theme)
end

local function applyBlockCenterDetail(part, breaking, theme)
	local gui = part:FindFirstChild("SUPREMO_BLOCK_CENTER")
	if not gui then
		gui = Instance.new("SurfaceGui")
		gui.Name = "SUPREMO_BLOCK_CENTER"
		gui.Face = Enum.NormalId.Front
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 20
		gui.Adornee = part
		gui.Parent = part
		table.insert(mapAddedInstances, gui)
	end

	local core = gui:FindFirstChild("CoreFrame")
	if not core then
		core = Instance.new("Frame")
		core.Name = "CoreFrame"
		core.Size = UDim2.fromScale(0.46, 0.46)
		core.Position = UDim2.fromScale(0.27, 0.27)
		core.BorderSizePixel = 0
		core.Parent = gui
		Instance.new("UICorner", core).CornerRadius = UDim.new(0, 4)
	end

	core.BackgroundColor3 = theme.blockCoreColor
	core.BackgroundTransparency = breaking and 0.45 or 0.25
end

local function updateBlockVisual(part)
	if not config.hubActive or not config.mapVisualsEnabled or not part or not part.Parent then return end
	local theme = getActiveTheme()
	local breaking = isBlockBreaking(part)
	local targetColor = breaking and theme.blockBreaking or theme.blockNormal
	change(mapOriginals, part, "Color", targetColor)
	change(mapOriginals, part, "Material", Enum.Material.SmoothPlastic)
	change(mapOriginals, part, "Reflectance", 0.04)
	applyBlockCenterDetail(part, breaking, theme)
end

local function trackBreakableBlock(part)
	if trackedBlocks[part] then return end
	trackedBlocks[part] = true

	local conns = {}
	table.insert(conns, part:GetPropertyChangedSignal("Transparency"):Connect(function()
		if config.hubActive and config.mapVisualsEnabled then
			updateBlockVisual(part)
		end
	end))

	table.insert(conns, part:GetPropertyChangedSignal("Size"):Connect(function()
		if config.hubActive and config.mapVisualsEnabled then
			updateBlockVisual(part)
		end
	end))

	table.insert(conns, part.AttributeChanged:Connect(function()
		if config.hubActive and config.mapVisualsEnabled then
			updateBlockVisual(part)
		end
	end))

	table.insert(conns, part.Destroying:Connect(function()
		cleanupInstanceEntry(part)
	end))

	blockConnections[part] = conns
end

local function applyThemeLighting(theme)
	pcall(function()
		if mapLightingOriginals.Ambient == nil then
			mapLightingOriginals.Ambient = Lighting.Ambient
			mapLightingOriginals.OutdoorAmbient = Lighting.OutdoorAmbient
			mapLightingOriginals.FogColor = Lighting.FogColor
			mapLightingOriginals.FogEnd = Lighting.FogEnd
			mapLightingOriginals.Brightness = Lighting.Brightness
		end
		Lighting.Ambient = theme.ambientColor
		Lighting.OutdoorAmbient = theme.ambientColor
		Lighting.FogColor = theme.fogColor
		Lighting.FogEnd = 420
		Lighting.Brightness = 1.4
	end)

	for _, child in ipairs(Lighting:GetChildren()) do
		if child:IsA("Sky") then
			change(mapOriginals, child, "SkyboxBk", "")
			change(mapOriginals, child, "SkyboxDn", "")
			change(mapOriginals, child, "SkyboxFt", "")
			change(mapOriginals, child, "SkyboxLf", "")
			change(mapOriginals, child, "SkyboxRt", "")
			change(mapOriginals, child, "SkyboxUp", "")
		elseif child:IsA("Atmosphere") then
			change(mapOriginals, child, "Color", theme.backdropColor)
			change(mapOriginals, child, "Decay", theme.backdropColor)
		end
	end
end

local function restoreThemeLighting()
	for prop, value in pairs(mapLightingOriginals) do
		pcall(function()
			Lighting[prop] = value
		end)
	end
	table.clear(mapLightingOriginals)
end

local function applyThemeTerrain(theme)
	local terrain = Workspace:FindFirstChildOfClass("Terrain")
	if not terrain then return end

	for _, mat in ipairs(Enum.Material:GetEnumItems()) do
		if terrainOriginals[mat] == nil then
			local ok, orig = pcall(function()
				return terrain:GetMaterialColor(mat)
			end)
			if ok then
				terrainOriginals[mat] = orig
			end
		end
		pcall(function()
			terrain:SetMaterialColor(mat, theme.floorColor)
		end)
	end
end

local function restoreThemeTerrain()
	local terrain = Workspace:FindFirstChildOfClass("Terrain")
	if not terrain then
		table.clear(terrainOriginals)
		return
	end

	for mat, orig in pairs(terrainOriginals) do
		pcall(function()
			terrain:SetMaterialColor(mat, orig)
		end)
	end
	table.clear(terrainOriginals)
end

local function processMapObj(obj)
	if not config.hubActive or not config.mapVisualsEnabled or isCharacter(obj) then return end
	local theme = getActiveTheme()

	if obj:IsA("BasePart") then
		if isFloor(obj) then
			change(mapOriginals, obj, "Color", theme.floorColor)
			change(mapOriginals, obj, "Material", theme.floorMaterial)
			change(mapOriginals, obj, "Reflectance", theme.floorReflectance)
			applyFloorDetails(obj, theme)
		elseif isRailOrLaser(obj) then
			change(mapOriginals, obj, "Color", theme.railColor)
			change(mapOriginals, obj, "Material", Enum.Material.SmoothPlastic)
			change(mapOriginals, obj, "Reflectance", 0)
		elseif isBreakableBlock(obj) then
			trackBreakableBlock(obj)
			updateBlockVisual(obj)
		elseif isBackdrop(obj) then
			change(mapOriginals, obj, "Color", theme.backdropColor)
			change(mapOriginals, obj, "Material", Enum.Material.SmoothPlastic)
			change(mapOriginals, obj, "Reflectance", 0)
		end
	end
end

local function processLagObject(obj)
	if not config.hubActive or not config.lagOptEnabled then return end

	if obj:IsA("PostEffect") then
		change(lagOriginals, obj, "Enabled", false)
	elseif not isCharacter(obj) then
		if obj:IsA("BasePart") then
			change(lagOriginals, obj, "CastShadow", false)
			if obj:IsA("MeshPart") then
				change(lagOriginals, obj, "RenderFidelity", Enum.RenderFidelity.Performance)
				change(lagOriginals, obj, "TextureID", "")
			end
		elseif obj:IsA("SpecialMesh") then
			change(lagOriginals, obj, "TextureId", "")
		elseif obj:IsA("SurfaceAppearance") then
			change(lagOriginals, obj, "ColorMap", "")
			change(lagOriginals, obj, "MetalnessMap", "")
			change(lagOriginals, obj, "NormalMap", "")
			change(lagOriginals, obj, "RoughnessMap", "")
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Trail") or obj:IsA("Beam") then
			change(lagOriginals, obj, "Enabled", false)
			pcall(function() if obj.Clear then obj:Clear() end end)
		elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
			change(lagOriginals, obj, "Enabled", false)
			change(lagOriginals, obj, "Shadows", false)
		elseif (obj:IsA("Decal") or obj:IsA("Texture")) and not isBreakableBlock(obj.Parent) then
			change(lagOriginals, obj, "Transparency", 1)
		elseif obj:IsA("Terrain") then
			change(lagOriginals, obj, "Decoration", false)
		end
	end
end

local function applyEnvironmentAndVisuals()
	if not config.hubActive or isRebuildingEnvironment then return end
	isRebuildingEnvironment = true

	pcall(function()
		findFloorReference()
		local theme = getActiveTheme()

		if config.mapVisualsEnabled then
			applyThemeLighting(theme)
			applyThemeTerrain(theme)
		end

		if config.lagOptEnabled then
			pcall(function()
				if lagLightingOriginals.GlobalShadows == nil then
					lagLightingOriginals.GlobalShadows = Lighting.GlobalShadows
					lagLightingOriginals.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
					lagLightingOriginals.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
				end
				Lighting.GlobalShadows = false
				Lighting.EnvironmentSpecularScale = 0
				Lighting.EnvironmentDiffuseScale = 0
			end)

			for _, eff in ipairs(Lighting:GetChildren()) do
				processLagObject(eff)
			end

			local terrain = Workspace:FindFirstChildOfClass("Terrain")
			if terrain then
				processLagObject(terrain)
			end
		end

		for _, obj in ipairs(Workspace:GetDescendants()) do
			if config.lagOptEnabled then
				processLagObject(obj)
			end
			if config.mapVisualsEnabled then
				processMapObj(obj)
			end
		end

		if config.spiderVisualEnabled then
			applySpiderVisualToOwnCharacter()
		end
	end)

	isRebuildingEnvironment = false
end

local function ensureFloorGridAlwaysAlive()
	if not config.hubActive or not config.mapVisualsEnabled then return end
	local theme = getActiveTheme()
	for fl in pairs(trackedFloors) do
		if fl and fl.Parent then
			local gui = fl:FindFirstChild("SUPREMO_FLOOR_DETAIL")
			if not gui or not gui.Enabled then
				applyFloorDetails(fl, theme)
			end
		else
			trackedFloors[fl] = nil
		end
	end
end

local function restoreEnvironmentAndVisuals()
	for obj, conns in pairs(blockConnections) do
		for _, conn in ipairs(conns) do
			pcall(function() conn:Disconnect() end)
		end
		blockConnections[obj] = nil
	end
	table.clear(trackedBlocks)

	clearMapExtras()
	restoreSpiderVisual()
	restore(mapOriginals)
	restore(lagOriginals)
	restoreThemeLighting()
	restoreThemeTerrain()

	for prop, value in pairs(lagLightingOriginals) do
		pcall(function()
			Lighting[prop] = value
		end)
	end
	table.clear(lagLightingOriginals)
end

local function rebuildThemeNow()
	restoreEnvironmentAndVisuals()
	if config.hubActive then
		applyEnvironmentAndVisuals()
	end
end

local function setHubActive(active)
	config.hubActive = (active == true)
	if not config.hubActive then
		cleanupDashNoclipOnHubDisable()
		restoreCameraFov()
		updateFovCircle()
		updateEsp()
		restoreEnvironmentAndVisuals()
	else
		applyCameraFov()
		applyEnvironmentAndVisuals()
		updateEsp()
	end
end

-- ZERO DELAY NO PULO, DASH E SOCO + ASSISTENCIA SEM PUXAR CAMERA
local function syncCharacterStats()
	if not config.hubActive then return end
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum or not hum.Parent then return end

	pcall(function()
		if not hum.AutoRotate then
			hum.AutoRotate = true
		end
		if hum.WalkSpeed <= 0 then
			hum.WalkSpeed = BASE_WALK_SPEED
		end
		if hum.UseJumpPower and hum.JumpPower <= 0 then
			hum.JumpPower = BASE_JUMP_POWER
		end
	end)
end

local function findClosestEnemyInRange(maxRange)
	local myChar = player.Character
	local myRoot = getCharacterRoot(myChar)
	if not myRoot then return nil, nil end

	local bestRoot = nil
	local bestDist = maxRange

	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if isEnemyPlayer(targetPlayer) then
			local char = targetPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = getCharacterRoot(char)
			if char and hum and hum.Health > 0 and root then
				local dist = (root.Position - myRoot.Position).Magnitude
				if dist <= bestDist then
					bestDist = dist
					bestRoot = root
				end
			end
		end
	end

	return bestRoot, bestDist
end

local function triggerPunchAndDashAssist()
	if not config.hubActive then return end
	lastPunchAssistAt = os.clock()

	local myChar = player.Character
	local myRoot = getCharacterRoot(myChar)
	if not myChar or not myRoot then return end

	syncCharacterStats()

	for _, item in ipairs(myChar:GetChildren()) do
		if item:IsA("Tool") then
			pcall(function() item:Activate() end)
		end
	end

	if VirtualInputManager then
		local cam = Workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(640, 360)
		pcall(function()
			VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, true, game, 1)
			VirtualInputManager:SendMouseButtonEvent(vp.X * 0.5, vp.Y * 0.5, 0, false, game, 1)
		end)
	end

	if not config.aimAssistEnabled then return end

	local targetRoot, dist = findClosestEnemyInRange(config.punchAssistRange)
	if not targetRoot or not dist then return end

	local flatDelta = Vector3.new(targetRoot.Position.X - myRoot.Position.X, 0, targetRoot.Position.Z - myRoot.Position.Z)
	if flatDelta.Magnitude > 0.01 then
		local dir = flatDelta.Unit

		pcall(function()
			local boostSpeed = math.clamp(dist * 2.2 * config.punchAssistStrength, 14, 56)
			myRoot.AssemblyLinearVelocity = Vector3.new(
				dir.X * boostSpeed,
				myRoot.AssemblyLinearVelocity.Y,
				dir.Z * boostSpeed
			)
		end)
	end
end

local function fireDashInstant()
	if not config.hubActive then return end
	lastDashAt = os.clock()

	local myChar = player.Character
	local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
	local myRoot = getCharacterRoot(myChar)
	if not myChar or not myHum or not myRoot then return end

	syncCharacterStats()

	local moveDir = myHum.MoveDirection
	if moveDir.Magnitude < 0.05 then
		local cam = Workspace.CurrentCamera
		if cam then
			local look = cam.CFrame.LookVector
			moveDir = Vector3.new(look.X, 0, look.Z)
		end
	end

	if moveDir.Magnitude > 0.05 then
		local dir = moveDir.Unit
		pcall(function()
			myRoot.AssemblyLinearVelocity = Vector3.new(
				dir.X * config.dashImpulse,
				myRoot.AssemblyLinearVelocity.Y,
				dir.Z * config.dashImpulse
			)
		end)
	end

	if config.dashNoclipEnabled and dashNoclipLtHeld then
		applyDashNoclipStep()
	end
end

local function fireZeroDelayJump()
	if not config.hubActive then return end
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = getCharacterRoot(char)
	if not hum or not hum.Parent then return end

	pcall(function()
		hum.Jump = true
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
		if root then
			local jumpVel = hum.UseJumpPower and hum.JumpPower or BASE_JUMP_POWER
			if root.AssemblyLinearVelocity.Y < jumpVel * 0.75 then
				root.AssemblyLinearVelocity = Vector3.new(
					root.AssemblyLinearVelocity.X,
					math.max(root.AssemblyLinearVelocity.Y, jumpVel),
					root.AssemblyLinearVelocity.Z
				)
			end
		end
	end)
end

local function triggerDoubleTapAAction()
	if not config.hubActive or not config.doubleTapAEnabled then return end
	fireDashInstant()
	triggerPunchAndDashAssist()
end

UIS.JumpRequest:Connect(function()
	fireZeroDelayJump()
end)

RunService.Heartbeat:Connect(function()
	if not config.hubActive then return end
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum and UIS:IsKeyDown(Enum.KeyCode.Space) then
		fireZeroDelayJump()
	end
end)

-- INTERFACE ESTILO PAINEL SUPREMO COM CANAIS LATERAIS E X / -
local gui = Instance.new("ScreenGui")
gui.Name = "SUPREMO_PANEL_GUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "SupremoMain"
mainFrame.Size = UDim2.fromOffset(960, 600)
mainFrame.Position = UDim2.new(0.5, -480, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 2
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 11, 42)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 7, 20)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 18, 48))
})
mainGradient.Rotation = 18
mainGradient.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(170, 55, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.05
mainStroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 54)
topBar.BackgroundColor3 = Color3.fromRGB(15, 9, 26)
topBar.BorderSizePixel = 0
topBar.ZIndex = 3
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

local logoBadge = Instance.new("Frame")
logoBadge.Size = UDim2.fromOffset(30, 30)
logoBadge.Position = UDim2.fromOffset(18, 12)
logoBadge.BackgroundColor3 = Color3.fromRGB(160, 65, 255)
logoBadge.BorderSizePixel = 0
logoBadge.ZIndex = 4
logoBadge.Parent = topBar
Instance.new("UICorner", logoBadge).CornerRadius = UDim.new(0, 7)

local logoDot = Instance.new("Frame")
logoDot.Size = UDim2.fromOffset(10, 10)
logoDot.Position = UDim2.new(0.5, -5, 0.5, -5)
logoDot.BackgroundColor3 = Color3.fromRGB(15, 9, 26)
logoDot.BorderSizePixel = 0
logoDot.ZIndex = 5
logoDot.Parent = logoBadge
Instance.new("UICorner", logoDot).CornerRadius = UDim.new(1, 0)

local brandTitle = Instance.new("TextLabel")
brandTitle.Size = UDim2.fromOffset(220, 28)
brandTitle.Position = UDim2.fromOffset(56, 13)
brandTitle.BackgroundTransparency = 1
brandTitle.Text = "Supremo Gestão"
brandTitle.TextColor3 = Color3.fromRGB(250, 250, 252)
brandTitle.Font = Enum.Font.GothamBold
brandTitle.TextSize = 14
brandTitle.TextXAlignment = Enum.TextXAlignment.Left
brandTitle.ZIndex = 4
brandTitle.Parent = topBar

local verPill = Instance.new("TextLabel")
verPill.Size = UDim2.fromOffset(44, 22)
verPill.Position = UDim2.fromOffset(278, 16)
verPill.BackgroundColor3 = Color3.fromRGB(30, 18, 48)
verPill.Text = "v5.5"
verPill.TextColor3 = Color3.fromRGB(205, 175, 255)
verPill.Font = Enum.Font.GothamMedium
verPill.TextSize = 11
verPill.ZIndex = 4
verPill.Parent = topBar
Instance.new("UICorner", verPill).CornerRadius = UDim.new(0, 6)

local tabs = {"Principal", "Perfis"}
local tabButtons = {}
local tabUnderlines = {}

for i, tabName in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromOffset(88, 34)
	btn.Position = UDim2.new(0.5, -45 + (i - 1) * 92, 0, 10)
	btn.BackgroundTransparency = 1
	btn.Text = tabName
	btn.TextColor3 = (tabName == config.activeTab) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(185, 160, 220)
	btn.Font = (tabName == config.activeTab) and Enum.Font.GothamBold or Enum.Font.GothamMedium
	btn.TextSize = 12
	btn.ZIndex = 4
	btn.Parent = topBar

	local line = Instance.new("Frame")
	line.Size = UDim2.fromOffset(68, 2)
	line.Position = UDim2.new(0.5, -35 + (i - 1) * 92, 1, -2)
	line.BackgroundColor3 = Color3.fromRGB(175, 75, 255)
	line.Visible = (tabName == config.activeTab)
	line.BorderSizePixel = 0
	line.ZIndex = 4
	line.Parent = topBar

	tabButtons[tabName] = btn
	tabUnderlines[tabName] = line
end

local statusTop = Instance.new("TextLabel")
statusTop.Size = UDim2.fromOffset(125, 24)
statusTop.Position = UDim2.new(1, -214, 0, 15)
statusTop.BackgroundTransparency = 1
statusTop.Text = "● Ativo · 0ms Delay"
statusTop.TextColor3 = Color3.fromRGB(220, 220, 228)
statusTop.Font = Enum.Font.GothamMedium
statusTop.TextSize = 11
statusTop.TextXAlignment = Enum.TextXAlignment.Right
statusTop.ZIndex = 4
statusTop.Parent = topBar

-- BOTAO MENOS (-) E FECHAR (X)
local minSquareBtn = Instance.new("TextButton")
minSquareBtn.Name = "MinimizarMenosBtn"
minSquareBtn.Size = UDim2.fromOffset(30, 30)
minSquareBtn.Position = UDim2.new(1, -80, 0, 12)
minSquareBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 48)
minSquareBtn.Text = "-"
minSquareBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
minSquareBtn.Font = Enum.Font.GothamBold
minSquareBtn.TextSize = 16
minSquareBtn.ZIndex = 4
minSquareBtn.Parent = topBar
Instance.new("UICorner", minSquareBtn).CornerRadius = UDim.new(0, 7)
local minSquareStroke = Instance.new("UIStroke")
minSquareStroke.Color = Color3.fromRGB(120, 65, 195)
minSquareStroke.Parent = minSquareBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "FecharPainelBtn"
closeBtn.Size = UDim2.fromOffset(30, 30)
closeBtn.Position = UDim2.new(1, -44, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 18, 36)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 145, 175)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.ZIndex = 4
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)

-- QUADRINHO PEQUENO NO CANTO INFERIOR ESQUERDO ESCRITO "SP"
local miniCornerSquare = Instance.new("TextButton")
miniCornerSquare.Name = "SUPREMO_SP_CORNER_SQUARE"
miniCornerSquare.Size = UDim2.fromOffset(44, 44)
miniCornerSquare.Position = UDim2.new(0, 18, 1, -64)
miniCornerSquare.BackgroundColor3 = Color3.fromRGB(150, 55, 255)
miniCornerSquare.Text = "SP"
miniCornerSquare.TextColor3 = Color3.fromRGB(255, 255, 255)
miniCornerSquare.Font = Enum.Font.GothamBold
miniCornerSquare.TextSize = 14
miniCornerSquare.Visible = true
miniCornerSquare.ZIndex = 999
miniCornerSquare.Parent = gui
Instance.new("UICorner", miniCornerSquare).CornerRadius = UDim.new(0, 8)
local miniSquareStroke = Instance.new("UIStroke")
miniSquareStroke.Color = Color3.fromRGB(85, 165, 255)
miniSquareStroke.Thickness = 1.4
miniSquareStroke.Parent = miniCornerSquare

-- BANNER DE CONFIRMACAO AO ABRIR O PAINEL
local confirmOpenBar = Instance.new("Frame")
confirmOpenBar.Name = "ConfirmProfileOpenBar"
confirmOpenBar.Size = UDim2.new(1, -36, 0, 42)
confirmOpenBar.Position = UDim2.fromOffset(18, 58)
confirmOpenBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
confirmOpenBar.BorderSizePixel = 0
confirmOpenBar.Visible = false
confirmOpenBar.ZIndex = 12
confirmOpenBar.Parent = mainFrame
Instance.new("UICorner", confirmOpenBar).CornerRadius = UDim.new(0, 10)
local confirmStroke = Instance.new("UIStroke")
confirmStroke.Color = Color3.fromRGB(120, 65, 195)
confirmStroke.Parent = confirmOpenBar

local confirmOpenLbl = Instance.new("TextLabel")
confirmOpenLbl.Size = UDim2.new(1, -210, 1, 0)
confirmOpenLbl.Position = UDim2.fromOffset(14, 0)
confirmOpenLbl.BackgroundTransparency = 1
confirmOpenLbl.Text = "Aplicar perfil salvo ao abrir?"
confirmOpenLbl.TextColor3 = Color3.fromRGB(245, 245, 252)
confirmOpenLbl.Font = Enum.Font.GothamBold
confirmOpenLbl.TextSize = 11
confirmOpenLbl.TextXAlignment = Enum.TextXAlignment.Left
confirmOpenLbl.ZIndex = 13
confirmOpenLbl.Parent = confirmOpenBar

local confirmApplyBtn = Instance.new("TextButton")
confirmApplyBtn.Size = UDim2.fromOffset(92, 28)
confirmApplyBtn.Position = UDim2.new(1, -192, 0.5, -14)
confirmApplyBtn.BackgroundColor3 = Color3.fromRGB(150, 55, 255)
confirmApplyBtn.Text = "Confirmar"
confirmApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmApplyBtn.Font = Enum.Font.GothamBold
confirmApplyBtn.TextSize = 11
confirmApplyBtn.ZIndex = 13
confirmApplyBtn.Parent = confirmOpenBar
Instance.new("UICorner", confirmApplyBtn).CornerRadius = UDim.new(0, 7)

local confirmDismissBtn = Instance.new("TextButton")
confirmDismissBtn.Size = UDim2.fromOffset(82, 28)
confirmDismissBtn.Position = UDim2.new(1, -94, 0.5, -14)
confirmDismissBtn.BackgroundColor3 = Color3.fromRGB(42, 23, 68)
confirmDismissBtn.Text = "Ignorar"
confirmDismissBtn.TextColor3 = Color3.fromRGB(215, 215, 225)
confirmDismissBtn.Font = Enum.Font.GothamBold
confirmDismissBtn.TextSize = 11
confirmDismissBtn.ZIndex = 13
confirmDismissBtn.Parent = confirmOpenBar
Instance.new("UICorner", confirmDismissBtn).CornerRadius = UDim.new(0, 7)

local function syncLayoutForConfirmBanner()
	local showBar = config.panelOpen and (not config.minimizedToSquare) and (pendingConfirmProfile ~= nil) and savedProfiles[pendingConfirmProfile] ~= nil
	confirmOpenBar.Visible = showBar
	if showBar then
		confirmOpenLbl.Text = "Perfil salvo: '" .. pendingConfirmProfile .. "' — confirmar aplicacao?"
	end
end

local function restoreFullPanelFromSquare()
	config.minimizedToSquare = false
	config.panelOpen = true
	mainFrame.Visible = true
	miniCornerSquare.Visible = true
	if savedProfiles[selectedProfileName] then
		pendingConfirmProfile = selectedProfileName
	end
	syncLayoutForConfirmBanner()
end

local function minimizeToCornerSquare()
	config.minimizedToSquare = true
	config.panelOpen = false
	mainFrame.Visible = false
	miniCornerSquare.Visible = true
	syncLayoutForConfirmBanner()
end

local function closePanelCompletely()
	config.minimizedToSquare = false
	config.panelOpen = false
	mainFrame.Visible = false
	miniCornerSquare.Visible = true
	syncLayoutForConfirmBanner()
end

minSquareBtn.Activated:Connect(minimizeToCornerSquare)
closeBtn.Activated:Connect(closePanelCompletely)
miniCornerSquare.Activated:Connect(function()
	if config.panelOpen and not config.minimizedToSquare then
		minimizeToCornerSquare()
	else
		restoreFullPanelFromSquare()
	end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		if config.minimizedToSquare or not config.panelOpen then
			restoreFullPanelFromSquare()
		else
			minimizeToCornerSquare()
		end
		return
	end
	if not config.hubActive then return end
	if input.KeyCode == Enum.KeyCode.Space then
		fireZeroDelayJump()
	elseif input.KeyCode == Enum.KeyCode.A then
		local now = os.clock()
		if (now - lastAPressAt) <= (config.doubleTapAWindow or 0.28) then
			lastAPressAt = 0
			triggerDoubleTapAAction()
		else
			lastAPressAt = now
		end
	elseif input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.LeftShift then
		fireDashInstant()
	elseif input.KeyCode == Enum.KeyCode.F or input.KeyCode == Enum.KeyCode.E or input.UserInputType == Enum.UserInputType.MouseButton1 then
		triggerPunchAndDashAssist()
	end
end)

local dragging = false
local dragTarget = nil
local dragStart = nil
local startPos = nil

local function bindDrag(handle, target)
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragTarget = target
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End and dragTarget == target then
					dragging = false
					dragTarget = nil
				end
			end)
		end
	end)
end

bindDrag(topBar, mainFrame)
bindDrag(miniCornerSquare, miniCornerSquare)

UIS.InputChanged:Connect(function(input)
	if dragging and dragTarget and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		dragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- COLUNA ESQUERDA: PRÉ-VISUALIZAÇÃO
local leftColumn = Instance.new("Frame")
leftColumn.Size = UDim2.fromOffset(252, 504)
leftColumn.Position = UDim2.fromOffset(16, 62)
leftColumn.BackgroundTransparency = 1
leftColumn.ZIndex = 3
leftColumn.Parent = mainFrame

local previewTitle = Instance.new("TextLabel")
previewTitle.Size = UDim2.new(0.65, 0, 0, 18)
previewTitle.BackgroundTransparency = 1
previewTitle.Text = "PRÉ-VISUALIZAÇÃO"
previewTitle.TextColor3 = Color3.fromRGB(195, 175, 225)
previewTitle.Font = Enum.Font.GothamBold
previewTitle.TextSize = 10
previewTitle.TextXAlignment = Enum.TextXAlignment.Left
previewTitle.ZIndex = 4
previewTitle.Parent = leftColumn

local liveLabel = Instance.new("TextLabel")
liveLabel.Size = UDim2.new(0.35, 0, 0, 18)
liveLabel.Position = UDim2.new(0.65, 0, 0, 0)
liveLabel.BackgroundTransparency = 1
liveLabel.Text = "Ao vivo"
liveLabel.TextColor3 = Color3.fromRGB(185, 160, 220)
liveLabel.Font = Enum.Font.GothamMedium
liveLabel.TextSize = 10
liveLabel.TextXAlignment = Enum.TextXAlignment.Right
liveLabel.ZIndex = 4
liveLabel.Parent = leftColumn

local previewBox = Instance.new("Frame")
previewBox.Size = UDim2.new(1, 0, 0, 444)
previewBox.Position = UDim2.fromOffset(0, 22)
previewBox.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
previewBox.BorderSizePixel = 0
previewBox.ZIndex = 4
previewBox.Parent = leftColumn
Instance.new("UICorner", previewBox).CornerRadius = UDim.new(0, 12)
local previewStroke = Instance.new("UIStroke")
previewStroke.Color = Color3.fromRGB(95, 45, 165)
previewStroke.Parent = previewBox

local fovHudTop = Instance.new("TextLabel")
fovHudTop.Size = UDim2.fromOffset(80, 18)
fovHudTop.Position = UDim2.fromOffset(12, 10)
fovHudTop.BackgroundTransparency = 1
fovHudTop.Text = "FOV " .. tostring(config.fovValue)
fovHudTop.TextColor3 = Color3.fromRGB(190, 170, 225)
fovHudTop.Font = Enum.Font.GothamMedium
fovHudTop.TextSize = 10
fovHudTop.TextXAlignment = Enum.TextXAlignment.Left
fovHudTop.ZIndex = 5
fovHudTop.Parent = previewBox

local rangeHudTop = Instance.new("TextLabel")
rangeHudTop.Size = UDim2.fromOffset(90, 18)
rangeHudTop.Position = UDim2.new(1, -102, 0, 10)
rangeHudTop.BackgroundTransparency = 1
rangeHudTop.Text = "Alcance " .. tostring(config.espMaxDistance) .. " m"
rangeHudTop.TextColor3 = Color3.fromRGB(190, 170, 225)
rangeHudTop.Font = Enum.Font.GothamMedium
rangeHudTop.TextSize = 10
rangeHudTop.TextXAlignment = Enum.TextXAlignment.Right
rangeHudTop.ZIndex = 5
rangeHudTop.Parent = previewBox

local previewRing = Instance.new("Frame")
previewRing.Size = UDim2.fromOffset(170, 170)
previewRing.Position = UDim2.new(0.5, -85, 0.5, -116)
previewRing.BackgroundColor3 = Color3.fromRGB(150, 65, 255)
previewRing.BackgroundTransparency = 1 - config.fovOpacity
previewRing.BorderSizePixel = 0
previewRing.ZIndex = 5
previewRing.Parent = previewBox
Instance.new("UICorner", previewRing).CornerRadius = UDim.new(1, 0)
local ringStroke = Instance.new("UIStroke")
ringStroke.Color = Color3.fromRGB(105, 175, 255)
ringStroke.Thickness = 1.6
ringStroke.Parent = previewRing

local dummyLabel = Instance.new("TextLabel")
dummyLabel.Size = UDim2.new(1, 0, 0, 16)
dummyLabel.Position = UDim2.fromOffset(0, 14)
dummyLabel.BackgroundTransparency = 1
dummyLabel.Text = "Jogador_01"
dummyLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
dummyLabel.Font = Enum.Font.GothamBold
dummyLabel.TextSize = 10
dummyLabel.ZIndex = 6
dummyLabel.Parent = previewRing

local dummyBody = Instance.new("Frame")
dummyBody.Size = UDim2.fromOffset(48, 72)
dummyBody.Position = UDim2.new(0.5, -24, 0.5, -24)
dummyBody.BackgroundColor3 = Color3.fromRGB(165, 85, 255)
dummyBody.BorderSizePixel = 0
dummyBody.ZIndex = 6
dummyBody.Parent = previewRing
Instance.new("UICorner", dummyBody).CornerRadius = UDim.new(0, 6)

local dummyHp = Instance.new("TextLabel")
dummyHp.Size = UDim2.fromScale(1, 1)
dummyHp.BackgroundTransparency = 1
dummyHp.Text = "10"
dummyHp.TextColor3 = Color3.fromRGB(255, 255, 255)
dummyHp.Font = Enum.Font.GothamBold
dummyHp.TextSize = 12
dummyHp.ZIndex = 7
dummyHp.Parent = dummyBody

local dummyDist = Instance.new("TextLabel")
dummyDist.Size = UDim2.new(1, 0, 0, 16)
dummyDist.Position = UDim2.new(0, 0, 1, -24)
dummyDist.BackgroundTransparency = 1
dummyDist.Text = "128 m"
dummyDist.TextColor3 = Color3.fromRGB(170, 170, 180)
dummyDist.Font = Enum.Font.GothamMedium
dummyDist.TextSize = 10
dummyDist.ZIndex = 6
dummyDist.Parent = previewRing

local miniStatsRow = Instance.new("Frame")
miniStatsRow.Size = UDim2.new(1, -16, 0, 44)
miniStatsRow.Position = UDim2.fromOffset(8, 388)
miniStatsRow.BackgroundTransparency = 1
miniStatsRow.ZIndex = 5
miniStatsRow.Parent = previewBox

local function makeStatBox(xPos, w, titleText, valueText)
	local box = Instance.new("Frame")
	box.Size = UDim2.fromOffset(w, 44)
	box.Position = UDim2.fromOffset(xPos, 0)
	box.BackgroundColor3 = Color3.fromRGB(32, 18, 52)
	box.BorderSizePixel = 0
	box.ZIndex = 6
	box.Parent = miniStatsRow
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 0, 16)
	t.Position = UDim2.fromOffset(0, 4)
	t.BackgroundTransparency = 1
	t.Text = titleText
	t.TextColor3 = Color3.fromRGB(155, 130, 190)
	t.Font = Enum.Font.GothamBold
	t.TextSize = 8.5
	t.ZIndex = 7
	t.Parent = box

	local v = Instance.new("TextLabel")
	v.Size = UDim2.new(1, 0, 0, 18)
	v.Position = UDim2.fromOffset(0, 20)
	v.BackgroundTransparency = 1
	v.Text = valueText
	v.TextColor3 = Color3.fromRGB(240, 240, 245)
	v.Font = Enum.Font.GothamBold
	v.TextSize = 10.5
	v.ZIndex = 7
	v.Parent = box

	return v
end

local statTargetVal = makeStatBox(0, 84, "ALVO", "Jogador_01")
local statDistVal = makeStatBox(88, 74, "DISTÂNCIA", "128 m")
local statHpVal = makeStatBox(166, 70, "VIDA", "68%")

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.fromOffset(122, 34)
resetBtn.Position = UDim2.fromOffset(0, 472)
resetBtn.BackgroundColor3 = Color3.fromRGB(24, 13, 38)
resetBtn.Text = "Redefinir"
resetBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 11.5
resetBtn.ZIndex = 4
resetBtn.Parent = leftColumn
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 9)
local resetStroke = Instance.new("UIStroke")
resetStroke.Color = Color3.fromRGB(95, 45, 150)
resetStroke.Parent = resetBtn

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.fromOffset(124, 34)
saveBtn.Position = UDim2.fromOffset(128, 472)
saveBtn.BackgroundColor3 = Color3.fromRGB(150, 55, 255)
saveBtn.Text = "Salvar perfil"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 11.5
saveBtn.ZIndex = 4
saveBtn.Parent = leftColumn
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 9)

-- COLUNA DE CANAIS LATERAIS (AIMBOT, FOV, ESP, TEXTURA + CONFIG SUPREMO)
local channelColumn = Instance.new("Frame")
channelColumn.Name = "ChannelsSidebar"
channelColumn.Size = UDim2.fromOffset(196, 504)
channelColumn.Position = UDim2.fromOffset(278, 62)
channelColumn.BackgroundColor3 = Color3.fromRGB(13, 10, 24)
channelColumn.BorderSizePixel = 0
channelColumn.ZIndex = 3
channelColumn.Parent = mainFrame
Instance.new("UICorner", channelColumn).CornerRadius = UDim.new(0, 12)
local channelStroke = Instance.new("UIStroke")
channelStroke.Color = Color3.fromRGB(115, 55, 195)
channelStroke.Thickness = 1.2
channelStroke.Parent = channelColumn

local channelsTitle = Instance.new("TextLabel")
channelsTitle.Size = UDim2.new(1, -20, 0, 22)
channelsTitle.Position = UDim2.fromOffset(12, 10)
channelsTitle.BackgroundTransparency = 1
channelsTitle.Text = "CANAIS"
channelsTitle.TextColor3 = Color3.fromRGB(185, 150, 245)
channelsTitle.Font = Enum.Font.GothamBold
channelsTitle.TextSize = 10.5
channelsTitle.TextXAlignment = Enum.TextXAlignment.Left
channelsTitle.ZIndex = 4
channelsTitle.Parent = channelColumn

-- BOTAO CONFIG SUPREMO (ATIVA TUDO CONFORME PEDIDO + ZERO DELAY)
local configSupremoBtn = Instance.new("TextButton")
configSupremoBtn.Name = "ConfigSupremoBtn"
configSupremoBtn.Size = UDim2.new(1, -20, 0, 38)
configSupremoBtn.Position = UDim2.fromOffset(10, 38)
configSupremoBtn.BackgroundColor3 = Color3.fromRGB(135, 45, 255)
configSupremoBtn.Text = "Config Supremo"
configSupremoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
configSupremoBtn.Font = Enum.Font.GothamBold
configSupremoBtn.TextSize = 12
configSupremoBtn.ZIndex = 5
configSupremoBtn.Parent = channelColumn
Instance.new("UICorner", configSupremoBtn).CornerRadius = UDim.new(0, 8)
local configSupremoStroke = Instance.new("UIStroke")
configSupremoStroke.Color = Color3.fromRGB(85, 175, 255)
configSupremoStroke.Thickness = 1.4
configSupremoStroke.Parent = configSupremoBtn

local channelDefs = {
	{id = "Aimbot", label = "Canal Aimbot", sub = "Mira e alcance"},
	{id = "FOV", label = "Canal FOV", sub = "Campo de visão"},
	{id = "ESP", label = "Canal ESP", sub = "Visual de alvos"},
	{id = "Textura", label = "Canal Textura", sub = "Azul e Roxo"}
}

local channelButtons = {}

for i, ch in ipairs(channelDefs) do
	local btn = Instance.new("TextButton")
	btn.Name = "Channel_" .. ch.id
	btn.Size = UDim2.new(1, -20, 0, 48)
	btn.Position = UDim2.fromOffset(10, 88 + (i - 1) * 56)
	btn.BorderSizePixel = 0
	btn.ZIndex = 5
	btn.Text = ""
	btn.Parent = channelColumn
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

	local bStroke = Instance.new("UIStroke")
	bStroke.Thickness = 1
	bStroke.Parent = btn

	local mainLbl = Instance.new("TextLabel")
	mainLbl.Size = UDim2.new(1, -16, 0, 20)
	mainLbl.Position = UDim2.fromOffset(10, 5)
	mainLbl.BackgroundTransparency = 1
	mainLbl.Text = ch.label
	mainLbl.Font = Enum.Font.GothamBold
	mainLbl.TextSize = 11.5
	mainLbl.TextXAlignment = Enum.TextXAlignment.Left
	mainLbl.ZIndex = 6
	mainLbl.Parent = btn

	local subLbl = Instance.new("TextLabel")
	subLbl.Size = UDim2.new(1, -16, 0, 16)
	subLbl.Position = UDim2.fromOffset(10, 24)
	subLbl.BackgroundTransparency = 1
	subLbl.Text = ch.sub
	subLbl.Font = Enum.Font.GothamMedium
	subLbl.TextSize = 10
	subLbl.TextXAlignment = Enum.TextXAlignment.Left
	subLbl.ZIndex = 6
	subLbl.Parent = btn

	channelButtons[ch.id] = {
		button = btn,
		stroke = bStroke,
		mainLabel = mainLbl,
		subLabel = subLbl
	}
end

local zeroDelayBadge = Instance.new("Frame")
zeroDelayBadge.Size = UDim2.new(1, -20, 0, 58)
zeroDelayBadge.Position = UDim2.fromOffset(10, 434)
zeroDelayBadge.BackgroundColor3 = Color3.fromRGB(22, 16, 42)
zeroDelayBadge.BorderSizePixel = 0
zeroDelayBadge.ZIndex = 4
zeroDelayBadge.Parent = channelColumn
Instance.new("UICorner", zeroDelayBadge).CornerRadius = UDim.new(0, 8)
local zdStroke = Instance.new("UIStroke")
zdStroke.Color = Color3.fromRGB(70, 145, 255)
zdStroke.Parent = zeroDelayBadge

local zdTitle = Instance.new("TextLabel")
zdTitle.Size = UDim2.new(1, -12, 0, 20)
zdTitle.Position = UDim2.fromOffset(8, 6)
zdTitle.BackgroundTransparency = 1
zdTitle.Text = "ZERO DELAY ATIVO"
zdTitle.TextColor3 = Color3.fromRGB(145, 210, 255)
zdTitle.Font = Enum.Font.GothamBold
zdTitle.TextSize = 10.5
zdTitle.TextXAlignment = Enum.TextXAlignment.Left
zdTitle.ZIndex = 5
zdTitle.Parent = zeroDelayBadge

local zdDesc = Instance.new("TextLabel")
zdDesc.Size = UDim2.new(1, -12, 0, 24)
zdDesc.Position = UDim2.fromOffset(8, 25)
zdDesc.BackgroundTransparency = 1
zdDesc.Text = "Pulo · Dash · Soco sem delay"
zdDesc.TextColor3 = Color3.fromRGB(195, 180, 235)
zdDesc.Font = Enum.Font.GothamMedium
zdDesc.TextSize = 10
zdDesc.TextXAlignment = Enum.TextXAlignment.Left
zdDesc.ZIndex = 5
zdDesc.Parent = zeroDelayBadge

-- COLUNA DIREITA: CONTEUDO DO CANAL SELECIONADO
local rightColumn = Instance.new("Frame")
rightColumn.Size = UDim2.fromOffset(462, 504)
rightColumn.Position = UDim2.fromOffset(484, 62)
rightColumn.BackgroundTransparency = 1
rightColumn.ZIndex = 3
rightColumn.Parent = mainFrame

local function makeCard(name, yPos, height)
	local card = Instance.new("Frame")
	card.Name = name
	card.Size = UDim2.new(1, 0, 0, height)
	card.Position = UDim2.fromOffset(0, yPos)
	card.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
	card.BorderSizePixel = 0
	card.ZIndex = 4
	card.Parent = rightColumn
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
	local st = Instance.new("UIStroke")
	st.Color = Color3.fromRGB(115, 55, 195)
	st.Thickness = 1.2
	st.Parent = card
	return card
end

local function createToggle(parent, xOff, yOff, initialState, onToggle)
	local track = Instance.new("TextButton")
	track.Size = UDim2.fromOffset(42, 22)
	track.Position = UDim2.new(1, xOff, 0, yOff)
	track.Text = ""
	track.BorderSizePixel = 0
	track.ZIndex = 5
	track.Parent = parent
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	knob.BorderSizePixel = 0
	knob.ZIndex = 6
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local function paint(state)
		local active = (state == true)
		track.BackgroundColor3 = active and Color3.fromRGB(155, 65, 255) or Color3.fromRGB(55, 32, 85)
		knob.Position = active and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)
	end

	paint(initialState)
	track.Activated:Connect(function()
		local nextState = onToggle()
		paint(nextState)
	end)

	return track, paint
end

-- CANAL 1: AIMBOT
local aimCard = makeCard("AimbotCard", 0, 128)

local aimTitle = Instance.new("TextLabel")
aimTitle.Size = UDim2.fromOffset(75, 24)
aimTitle.Position = UDim2.fromOffset(18, 12)
aimTitle.BackgroundTransparency = 1
aimTitle.Text = "AIMBOT"
aimTitle.TextColor3 = Color3.fromRGB(250, 250, 252)
aimTitle.Font = Enum.Font.GothamBold
aimTitle.TextSize = 13
aimTitle.TextXAlignment = Enum.TextXAlignment.Left
aimTitle.ZIndex = 5
aimTitle.Parent = aimCard

local aimSub = Instance.new("TextLabel")
aimSub.Size = UDim2.fromOffset(220, 24)
aimSub.Position = UDim2.fromOffset(82, 12)
aimSub.BackgroundTransparency = 1
aimSub.Text = "Ajustes do assistente de mira"
aimSub.TextColor3 = Color3.fromRGB(155, 130, 190)
aimSub.Font = Enum.Font.GothamMedium
aimSub.TextSize = 11
aimSub.TextXAlignment = Enum.TextXAlignment.Left
aimSub.ZIndex = 5
aimSub.Parent = aimCard

local _, paintAimToggle = createToggle(aimCard, -60, 13, config.aimAssistEnabled, function()
	config.aimAssistEnabled = not config.aimAssistEnabled
	return config.aimAssistEnabled
end)

local reachLabel = Instance.new("TextLabel")
reachLabel.Size = UDim2.fromOffset(105, 24)
reachLabel.Position = UDim2.fromOffset(18, 50)
reachLabel.BackgroundTransparency = 1
reachLabel.Text = "Alcance extra"
reachLabel.TextColor3 = Color3.fromRGB(205, 190, 230)
reachLabel.Font = Enum.Font.GothamMedium
reachLabel.TextSize = 12
reachLabel.TextXAlignment = Enum.TextXAlignment.Left
reachLabel.ZIndex = 5
reachLabel.Parent = aimCard

local reachMinusBtn = Instance.new("TextButton")
reachMinusBtn.Size = UDim2.fromOffset(26, 26)
reachMinusBtn.Position = UDim2.fromOffset(122, 49)
reachMinusBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 48)
reachMinusBtn.Text = "-"
reachMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
reachMinusBtn.Font = Enum.Font.GothamBold
reachMinusBtn.TextSize = 14
reachMinusBtn.ZIndex = 5
reachMinusBtn.Parent = aimCard
Instance.new("UICorner", reachMinusBtn).CornerRadius = UDim.new(0, 6)

local reachValueLbl = Instance.new("TextLabel")
reachValueLbl.Size = UDim2.fromOffset(52, 26)
reachValueLbl.Position = UDim2.fromOffset(152, 49)
reachValueLbl.BackgroundColor3 = Color3.fromRGB(32, 18, 52)
reachValueLbl.Text = tostring(config.punchAssistRange) .. " st"
reachValueLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
reachValueLbl.Font = Enum.Font.GothamBold
reachValueLbl.TextSize = 11
reachValueLbl.ZIndex = 5
reachValueLbl.Parent = aimCard
Instance.new("UICorner", reachValueLbl).CornerRadius = UDim.new(0, 6)

local reachPlusBtn = Instance.new("TextButton")
reachPlusBtn.Size = UDim2.fromOffset(26, 26)
reachPlusBtn.Position = UDim2.fromOffset(208, 49)
reachPlusBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 48)
reachPlusBtn.Text = "+"
reachPlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
reachPlusBtn.Font = Enum.Font.GothamBold
reachPlusBtn.TextSize = 14
reachPlusBtn.ZIndex = 5
reachPlusBtn.Parent = aimCard
Instance.new("UICorner", reachPlusBtn).CornerRadius = UDim.new(0, 6)

reachMinusBtn.Activated:Connect(function()
	config.punchAssistRange = math.clamp(config.punchAssistRange - 4, 8, 60)
	reachValueLbl.Text = tostring(config.punchAssistRange) .. " st"
end)

reachPlusBtn.Activated:Connect(function()
	config.punchAssistRange = math.clamp(config.punchAssistRange + 4, 8, 60)
	reachValueLbl.Text = tostring(config.punchAssistRange) .. " st"
end)

local teamIgnoreLabel = Instance.new("TextLabel")
teamIgnoreLabel.Size = UDim2.fromOffset(88, 24)
teamIgnoreLabel.Position = UDim2.fromOffset(312, 50)
teamIgnoreLabel.BackgroundTransparency = 1
teamIgnoreLabel.Text = "Ignorar time"
teamIgnoreLabel.TextColor3 = Color3.fromRGB(205, 190, 230)
teamIgnoreLabel.Font = Enum.Font.GothamMedium
teamIgnoreLabel.TextSize = 12
teamIgnoreLabel.TextXAlignment = Enum.TextXAlignment.Left
teamIgnoreLabel.ZIndex = 5
teamIgnoreLabel.Parent = aimCard

local _, paintIgnoreToggle = createToggle(aimCard, -18, 51, config.ignoreTeam, function()
	config.ignoreTeam = not config.ignoreTeam
	return config.ignoreTeam
end)

local aimInfoLbl = Instance.new("TextLabel")
aimInfoLbl.Size = UDim2.new(1, -36, 0, 22)
aimInfoLbl.Position = UDim2.fromOffset(18, 90)
aimInfoLbl.BackgroundTransparency = 1
aimInfoLbl.Text = "Soco e dash configurados sem delay (0ms)."
aimInfoLbl.TextColor3 = Color3.fromRGB(130, 185, 255)
aimInfoLbl.Font = Enum.Font.GothamMedium
aimInfoLbl.TextSize = 11
aimInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
aimInfoLbl.ZIndex = 5
aimInfoLbl.Parent = aimCard

-- CANAL 2: FOV
local fovCard = makeCard("FovCard", 0, 146)

local fovTitle = Instance.new("TextLabel")
fovTitle.Size = UDim2.fromOffset(55, 24)
fovTitle.Position = UDim2.fromOffset(18, 12)
fovTitle.BackgroundTransparency = 1
fovTitle.Text = "FOV"
fovTitle.TextColor3 = Color3.fromRGB(250, 250, 252)
fovTitle.Font = Enum.Font.GothamBold
fovTitle.TextSize = 13
fovTitle.TextXAlignment = Enum.TextXAlignment.Left
fovTitle.ZIndex = 5
fovTitle.Parent = fovCard

local fovSub = Instance.new("TextLabel")
fovSub.Size = UDim2.fromOffset(220, 24)
fovSub.Position = UDim2.fromOffset(56, 12)
fovSub.BackgroundTransparency = 1
fovSub.Text = "Campo de visão da câmera"
fovSub.TextColor3 = Color3.fromRGB(155, 130, 190)
fovSub.Font = Enum.Font.GothamMedium
fovSub.TextSize = 11
fovSub.TextXAlignment = Enum.TextXAlignment.Left
fovSub.ZIndex = 5
fovSub.Parent = fovCard

local _, paintFovToggle = createToggle(fovCard, -60, 13, config.fovEnabled, function()
	config.fovEnabled = not config.fovEnabled
	applyCameraFov()
	return config.fovEnabled
end)

local fovValLabel = Instance.new("TextLabel")
fovValLabel.Size = UDim2.fromOffset(115, 24)
fovValLabel.Position = UDim2.fromOffset(18, 52)
fovValLabel.BackgroundTransparency = 1
fovValLabel.Text = "FOV: " .. tostring(config.fovValue)
fovValLabel.TextColor3 = Color3.fromRGB(235, 235, 242)
fovValLabel.Font = Enum.Font.GothamBold
fovValLabel.TextSize = 12
fovValLabel.TextXAlignment = Enum.TextXAlignment.Left
fovValLabel.ZIndex = 5
fovValLabel.Parent = fovCard

local fovMinusBtn = Instance.new("TextButton")
fovMinusBtn.Size = UDim2.fromOffset(28, 26)
fovMinusBtn.Position = UDim2.fromOffset(132, 51)
fovMinusBtn.BackgroundColor3 = Color3.fromRGB(38, 20, 62)
fovMinusBtn.Text = "-"
fovMinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fovMinusBtn.Font = Enum.Font.GothamBold
fovMinusBtn.TextSize = 14
fovMinusBtn.ZIndex = 5
fovMinusBtn.Parent = fovCard
Instance.new("UICorner", fovMinusBtn).CornerRadius = UDim.new(0, 6)

local fovPlusBtn = Instance.new("TextButton")
fovPlusBtn.Size = UDim2.fromOffset(28, 26)
fovPlusBtn.Position = UDim2.fromOffset(166, 51)
fovPlusBtn.BackgroundColor3 = Color3.fromRGB(38, 20, 62)
fovPlusBtn.Text = "+"
fovPlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fovPlusBtn.Font = Enum.Font.GothamBold
fovPlusBtn.TextSize = 14
fovPlusBtn.ZIndex = 5
fovPlusBtn.Parent = fovCard
Instance.new("UICorner", fovPlusBtn).CornerRadius = UDim.new(0, 6)

local function refreshFovHud()
	config.fovValue = math.clamp(config.fovValue, 40, 120)
	fovValLabel.Text = "FOV: " .. tostring(config.fovValue)
	fovHudTop.Text = "FOV " .. tostring(config.fovValue)
	applyCameraFov()
	updateFovCircle()
end

fovMinusBtn.Activated:Connect(function()
	config.fovValue -= 5
	refreshFovHud()
end)

fovPlusBtn.Activated:Connect(function()
	config.fovValue += 5
	refreshFovHud()
end)

local showCircleLbl = Instance.new("TextLabel")
showCircleLbl.Size = UDim2.fromOffset(105, 24)
showCircleLbl.Position = UDim2.fromOffset(18, 98)
showCircleLbl.BackgroundTransparency = 1
showCircleLbl.Text = "Mostrar círculo"
showCircleLbl.TextColor3 = Color3.fromRGB(205, 190, 230)
showCircleLbl.Font = Enum.Font.GothamMedium
showCircleLbl.TextSize = 12
showCircleLbl.TextXAlignment = Enum.TextXAlignment.Left
showCircleLbl.ZIndex = 5
showCircleLbl.Parent = fovCard

local _, paintCircleToggle = createToggle(fovCard, -312, 99, config.showFovCircle, function()
	config.showFovCircle = not config.showFovCircle
	updateFovCircle()
	return config.showFovCircle
end)

local filledLbl = Instance.new("TextLabel")
filledLbl.Size = UDim2.fromOffset(80, 24)
filledLbl.Position = UDim2.fromOffset(265, 98)
filledLbl.BackgroundTransparency = 1
filledLbl.Text = "Preenchido"
filledLbl.TextColor3 = Color3.fromRGB(205, 190, 230)
filledLbl.Font = Enum.Font.GothamMedium
filledLbl.TextSize = 12
filledLbl.TextXAlignment = Enum.TextXAlignment.Left
filledLbl.ZIndex = 5
filledLbl.Parent = fovCard

local _, paintFilledToggle = createToggle(fovCard, -18, 99, config.fovFilled, function()
	config.fovFilled = not config.fovFilled
	updateFovCircle()
	return config.fovFilled
end)

-- CANAL 3: ESP
local espCard = makeCard("EspCard", 0, 212)

local espTitle = Instance.new("TextLabel")
espTitle.Size = UDim2.fromOffset(45, 24)
espTitle.Position = UDim2.fromOffset(18, 12)
espTitle.BackgroundTransparency = 1
espTitle.Text = "ESP"
espTitle.TextColor3 = Color3.fromRGB(250, 250, 252)
espTitle.Font = Enum.Font.GothamBold
espTitle.TextSize = 13
espTitle.TextXAlignment = Enum.TextXAlignment.Left
espTitle.ZIndex = 5
espTitle.Parent = espCard

local espSub = Instance.new("TextLabel")
espSub.Size = UDim2.fromOffset(220, 24)
espSub.Position = UDim2.fromOffset(54, 12)
espSub.BackgroundTransparency = 1
espSub.Text = "Marcação de jogadores"
espSub.TextColor3 = Color3.fromRGB(155, 130, 190)
espSub.Font = Enum.Font.GothamMedium
espSub.TextSize = 11
espSub.TextXAlignment = Enum.TextXAlignment.Left
espSub.ZIndex = 5
espSub.Parent = espCard

local _, paintEspToggle = createToggle(espCard, -60, 13, config.espEnabled, function()
	config.espEnabled = not config.espEnabled
	updateEsp()
	return config.espEnabled
end)

local pillOptions = {
	{key = "espBox", label = "Caixa"},
	{key = "espName", label = "Nome"},
	{key = "espDistance", label = "Distância"},
	{key = "espHealth", label = "Vida"},
	{key = "espLines", label = "Linhas"}
}

local pillRefreshers = {}

for i, opt in ipairs(pillOptions) do
	local pill = Instance.new("TextButton")
	pill.Size = UDim2.fromOffset(80, 28)
	local col = (i - 1) % 3
	local row = math.floor((i - 1) / 3)
	pill.Position = UDim2.fromOffset(18 + col * 86, 48 + row * 34)
	pill.Font = Enum.Font.GothamBold
	pill.TextSize = 11
	pill.Text = opt.label
	pill.ZIndex = 5
	pill.Parent = espCard
	Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

	local function refreshPill()
		local active = config[opt.key]
		pill.BackgroundColor3 = active and Color3.fromRGB(150, 55, 255) or Color3.fromRGB(25, 14, 40)
		pill.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(185, 185, 195)
	end

	pillRefreshers[opt.key] = refreshPill
	refreshPill()
	pill.Activated:Connect(function()
		config[opt.key] = not config[opt.key]
		refreshPill()
		updateEsp()
	end)
end

local cantosBtn = Instance.new("TextButton")
cantosBtn.Size = UDim2.fromOffset(80, 28)
cantosBtn.Position = UDim2.fromOffset(18 + 2 * 86, 48 + 34)
cantosBtn.BackgroundColor3 = Color3.fromRGB(150, 55, 255)
cantosBtn.Text = "Cantos"
cantosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
cantosBtn.Font = Enum.Font.GothamBold
cantosBtn.TextSize = 10.5
cantosBtn.ZIndex = 5
cantosBtn.Parent = espCard
Instance.new("UICorner", cantosBtn).CornerRadius = UDim.new(0, 6)

local cheiaBtn = Instance.new("TextButton")
cheiaBtn.Size = UDim2.fromOffset(80, 28)
cheiaBtn.Position = UDim2.fromOffset(18, 48 + 2 * 34)
cheiaBtn.BackgroundColor3 = Color3.fromRGB(25, 14, 40)
cheiaBtn.Text = "Cheia"
cheiaBtn.TextColor3 = Color3.fromRGB(185, 185, 195)
cheiaBtn.Font = Enum.Font.GothamBold
cheiaBtn.TextSize = 10.5
cheiaBtn.ZIndex = 5
cheiaBtn.Parent = espCard
Instance.new("UICorner", cheiaBtn).CornerRadius = UDim.new(0, 6)

local function syncEspStyleButtons()
	local isCantos = (config.espStyle == "Cantos")
	cantosBtn.BackgroundColor3 = isCantos and Color3.fromRGB(150, 55, 255) or Color3.fromRGB(25, 14, 40)
	cantosBtn.TextColor3 = isCantos and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(185, 185, 195)
	cheiaBtn.BackgroundColor3 = (not isCantos) and Color3.fromRGB(150, 55, 255) or Color3.fromRGB(25, 14, 40)
	cheiaBtn.TextColor3 = (not isCantos) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(185, 185, 195)
	updateEsp()
end

cantosBtn.Activated:Connect(function()
	config.espStyle = "Cantos"
	syncEspStyleButtons()
end)

cheiaBtn.Activated:Connect(function()
	config.espStyle = "Cheia"
	syncEspStyleButtons()
end)

local maxDistLbl = Instance.new("TextLabel")
maxDistLbl.Size = UDim2.fromOffset(115, 22)
maxDistLbl.Position = UDim2.fromOffset(112, 120)
maxDistLbl.BackgroundTransparency = 1
maxDistLbl.Text = "Alcance máximo"
maxDistLbl.TextColor3 = Color3.fromRGB(205, 190, 230)
maxDistLbl.Font = Enum.Font.GothamMedium
maxDistLbl.TextSize = 12
maxDistLbl.TextXAlignment = Enum.TextXAlignment.Left
maxDistLbl.ZIndex = 5
maxDistLbl.Parent = espCard

local maxDistValLbl = Instance.new("TextLabel")
maxDistValLbl.Size = UDim2.fromOffset(65, 22)
maxDistValLbl.Position = UDim2.new(1, -83, 0, 120)
maxDistValLbl.BackgroundTransparency = 1
maxDistValLbl.Text = tostring(config.espMaxDistance) .. " m"
maxDistValLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
maxDistValLbl.Font = Enum.Font.GothamBold
maxDistValLbl.TextSize = 12
maxDistValLbl.TextXAlignment = Enum.TextXAlignment.Right
maxDistValLbl.ZIndex = 5
maxDistValLbl.Parent = espCard

local distSteps = {150, 300, 500, 1000}
local distCycleBtn = Instance.new("TextButton")
distCycleBtn.Size = UDim2.new(1, -36, 0, 28)
distCycleBtn.Position = UDim2.fromOffset(18, 166)
distCycleBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 48)
distCycleBtn.Text = "Alternar alcance (" .. tostring(config.espMaxDistance) .. " m)"
distCycleBtn.TextColor3 = Color3.fromRGB(215, 215, 225)
distCycleBtn.Font = Enum.Font.GothamBold
distCycleBtn.TextSize = 11
distCycleBtn.ZIndex = 5
distCycleBtn.Parent = espCard
Instance.new("UICorner", distCycleBtn).CornerRadius = UDim.new(0, 7)

distCycleBtn.Activated:Connect(function()
	local idx = table.find(distSteps, config.espMaxDistance) or 3
	config.espMaxDistance = distSteps[(idx % #distSteps) + 1]
	maxDistValLbl.Text = tostring(config.espMaxDistance) .. " m"
	rangeHudTop.Text = "Alcance " .. tostring(config.espMaxDistance) .. " m"
	distCycleBtn.Text = "Alternar alcance (" .. tostring(config.espMaxDistance) .. " m)"
	updateEsp()
end)

-- CANAL 4: TEXTURA (AZUL E ROXO)
local texturesCard = makeCard("TexturesCard", 0, 126)

local texturesTitle = Instance.new("TextLabel")
texturesTitle.Size = UDim2.fromOffset(90, 24)
texturesTitle.Position = UDim2.fromOffset(18, 12)
texturesTitle.BackgroundTransparency = 1
texturesTitle.Text = "TEXTURA"
texturesTitle.TextColor3 = Color3.fromRGB(250, 250, 252)
texturesTitle.Font = Enum.Font.GothamBold
texturesTitle.TextSize = 13
texturesTitle.TextXAlignment = Enum.TextXAlignment.Left
texturesTitle.ZIndex = 5
texturesTitle.Parent = texturesCard

local texturesSub = Instance.new("TextLabel")
texturesSub.Size = UDim2.fromOffset(220, 24)
texturesSub.Position = UDim2.fromOffset(88, 12)
texturesSub.BackgroundTransparency = 1
texturesSub.Text = "Tema Azul e Roxo no mapa"
texturesSub.TextColor3 = Color3.fromRGB(155, 130, 190)
texturesSub.Font = Enum.Font.GothamMedium
texturesSub.TextSize = 11
texturesSub.TextXAlignment = Enum.TextXAlignment.Left
texturesSub.ZIndex = 5
texturesSub.Parent = texturesCard

local _, paintMapVisualsToggle = createToggle(texturesCard, -60, 13, config.mapVisualsEnabled, function()
	config.mapVisualsEnabled = not config.mapVisualsEnabled
	rebuildThemeNow()
	return config.mapVisualsEnabled
end)

local themeOrder = {"Azul + Roxo", "Roxo e Preto", "Amarelona", "Branco e Azul", "Azul + Rosa"}
local themeCycleBtn = Instance.new("TextButton")
themeCycleBtn.Size = UDim2.new(1, -36, 0, 28)
themeCycleBtn.Position = UDim2.fromOffset(18, 48)
themeCycleBtn.BackgroundColor3 = Color3.fromRGB(125, 45, 255)
themeCycleBtn.Text = "Textura: " .. config.mapTheme
themeCycleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeCycleBtn.Font = Enum.Font.GothamBold
themeCycleBtn.TextSize = 11
themeCycleBtn.ZIndex = 5
themeCycleBtn.Parent = texturesCard
Instance.new("UICorner", themeCycleBtn).CornerRadius = UDim.new(0, 7)

local lineColorBtn = Instance.new("TextButton")
lineColorBtn.Size = UDim2.new(1, -36, 0, 28)
lineColorBtn.Position = UDim2.fromOffset(18, 84)
lineColorBtn.BackgroundColor3 = Color3.fromRGB(36, 58, 165)
lineColorBtn.Text = "Borda: Azul e Roxo"
lineColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lineColorBtn.Font = Enum.Font.GothamBold
lineColorBtn.TextSize = 11
lineColorBtn.ZIndex = 5
lineColorBtn.Parent = texturesCard
Instance.new("UICorner", lineColorBtn).CornerRadius = UDim.new(0, 7)

-- ABA PERFIS
local profilesCard = makeCard("ProfilesCard", 0, 276)
profilesCard.Visible = false

local profilesTitle = Instance.new("TextLabel")
profilesTitle.Size = UDim2.new(1, -36, 0, 24)
profilesTitle.Position = UDim2.fromOffset(18, 14)
profilesTitle.BackgroundTransparency = 1
profilesTitle.Text = "PERFIS SALVOS (NOME + CONFIRMAR AO ABRIR)"
profilesTitle.TextColor3 = Color3.fromRGB(250, 250, 252)
profilesTitle.Font = Enum.Font.GothamBold
profilesTitle.TextSize = 12.5
profilesTitle.TextXAlignment = Enum.TextXAlignment.Left
profilesTitle.ZIndex = 5
profilesTitle.Parent = profilesCard

local profileNameInput = Instance.new("TextBox")
profileNameInput.Size = UDim2.fromOffset(210, 32)
profileNameInput.Position = UDim2.fromOffset(18, 48)
profileNameInput.BackgroundColor3 = Color3.fromRGB(25, 14, 40)
profileNameInput.Text = selectedProfileName
profileNameInput.PlaceholderText = "Digite o nome do perfil..."
profileNameInput.TextColor3 = Color3.fromRGB(250, 250, 255)
profileNameInput.PlaceholderColor3 = Color3.fromRGB(145, 115, 180)
profileNameInput.Font = Enum.Font.GothamMedium
profileNameInput.TextSize = 12
profileNameInput.ClearTextOnFocus = false
profileNameInput.ZIndex = 5
profileNameInput.Parent = profilesCard
Instance.new("UICorner", profileNameInput).CornerRadius = UDim.new(0, 7)

local createProfileBtn = Instance.new("TextButton")
createProfileBtn.Size = UDim2.fromOffset(104, 32)
createProfileBtn.Position = UDim2.fromOffset(236, 48)
createProfileBtn.BackgroundColor3 = Color3.fromRGB(145, 55, 255)
createProfileBtn.Text = "Salvar nome"
createProfileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createProfileBtn.Font = Enum.Font.GothamBold
createProfileBtn.TextSize = 11
createProfileBtn.ZIndex = 5
createProfileBtn.Parent = profilesCard
Instance.new("UICorner", createProfileBtn).CornerRadius = UDim.new(0, 7)

local confirmProfileBtn = Instance.new("TextButton")
confirmProfileBtn.Size = UDim2.fromOffset(96, 32)
confirmProfileBtn.Position = UDim2.fromOffset(348, 48)
confirmProfileBtn.BackgroundColor3 = Color3.fromRGB(36, 98, 225)
confirmProfileBtn.Text = "Confirmar"
confirmProfileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmProfileBtn.Font = Enum.Font.GothamBold
confirmProfileBtn.TextSize = 11
confirmProfileBtn.ZIndex = 5
confirmProfileBtn.Parent = profilesCard
Instance.new("UICorner", confirmProfileBtn).CornerRadius = UDim.new(0, 7)

local profileListFrame = Instance.new("ScrollingFrame")
profileListFrame.Size = UDim2.new(1, -36, 0, 140)
profileListFrame.Position = UDim2.fromOffset(18, 92)
profileListFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
profileListFrame.BorderSizePixel = 0
profileListFrame.ScrollBarThickness = 4
profileListFrame.ZIndex = 5
profileListFrame.Parent = profilesCard
Instance.new("UICorner", profileListFrame).CornerRadius = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = profileListFrame

local activeProfileStatusLbl = Instance.new("TextLabel")
activeProfileStatusLbl.Size = UDim2.new(1, -36, 0, 22)
activeProfileStatusLbl.Position = UDim2.fromOffset(18, 240)
activeProfileStatusLbl.BackgroundTransparency = 1
activeProfileStatusLbl.Text = "Selecionado: " .. selectedProfileName
activeProfileStatusLbl.TextColor3 = Color3.fromRGB(175, 185, 205)
activeProfileStatusLbl.Font = Enum.Font.GothamMedium
activeProfileStatusLbl.TextSize = 11
activeProfileStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
activeProfileStatusLbl.ZIndex = 5
activeProfileStatusLbl.Parent = profilesCard

-- RODAPE INFERIOR
local footerBar = Instance.new("Frame")
footerBar.Size = UDim2.new(1, -36, 0, 20)
footerBar.Position = UDim2.fromOffset(18, 574)
footerBar.BackgroundTransparency = 1
footerBar.ZIndex = 4
footerBar.Parent = mainFrame

local footerLeft = Instance.new("TextLabel")
footerLeft.Size = UDim2.new(0.7, 0, 1, 0)
footerLeft.BackgroundTransparency = 1
footerLeft.Text = "Abrir ou fechar: RightShift · - Minimiza para SP · X Fecha"
footerLeft.TextColor3 = Color3.fromRGB(130, 125, 155)
footerLeft.Font = Enum.Font.GothamMedium
footerLeft.TextSize = 10
footerLeft.TextXAlignment = Enum.TextXAlignment.Left
footerLeft.ZIndex = 5
footerLeft.Parent = footerBar

local footerRight = Instance.new("TextLabel")
footerRight.Size = UDim2.new(0.3, 0, 1, 0)
footerRight.Position = UDim2.new(0.7, 0, 0, 0)
footerRight.BackgroundTransparency = 1
footerRight.Text = "Perfil: " .. selectedProfileName
footerRight.TextColor3 = Color3.fromRGB(185, 160, 220)
footerRight.Font = Enum.Font.GothamMedium
footerRight.TextSize = 10
footerRight.TextXAlignment = Enum.TextXAlignment.Right
footerRight.ZIndex = 5
footerRight.Parent = footerBar

local function refreshLineColorButton()
	lineColorBtn.Text = "Borda: Azul e Roxo"
	lineColorBtn.BackgroundColor3 = Color3.fromRGB(36, 58, 165)
	lineColorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

local function refreshChannelSelection()
	local isMainTab = (config.activeTab == "Principal")
	aimCard.Visible = isMainTab and (config.activeChannel == "Aimbot")
	fovCard.Visible = isMainTab and (config.activeChannel == "FOV")
	espCard.Visible = isMainTab and (config.activeChannel == "ESP")
	texturesCard.Visible = isMainTab and (config.activeChannel == "Textura")
	profilesCard.Visible = (config.activeTab == "Perfis")

	for chId, item in pairs(channelButtons) do
		local selected = isMainTab and (config.activeChannel == chId)
		item.button.BackgroundColor3 = selected and Color3.fromRGB(52, 22, 102) or Color3.fromRGB(21, 14, 38)
		item.stroke.Color = selected and Color3.fromRGB(175, 85, 255) or Color3.fromRGB(70, 38, 125)
		item.mainLabel.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(205, 185, 235)
		item.subLabel.TextColor3 = selected and Color3.fromRGB(145, 205, 255) or Color3.fromRGB(135, 115, 175)
	end
end

for _, ch in ipairs(channelDefs) do
	channelButtons[ch.id].button.Activated:Connect(function()
		config.activeChannel = ch.id
		if config.activeTab ~= "Principal" then
			config.activeTab = "Principal"
			for name, btn in pairs(tabButtons) do
				local sel = (name == "Principal")
				btn.TextColor3 = sel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(185, 160, 220)
				btn.Font = sel and Enum.Font.GothamBold or Enum.Font.GothamMedium
				tabUnderlines[name].Visible = sel
			end
		end
		refreshChannelSelection()
	end)
end

local function syncAllUiFromConfig()
	themeCycleBtn.Text = "Textura: " .. config.mapTheme
	refreshLineColorButton()
	refreshFovHud()
	reachValueLbl.Text = tostring(config.punchAssistRange) .. " st"
	maxDistValLbl.Text = tostring(config.espMaxDistance) .. " m"
	rangeHudTop.Text = "Alcance " .. tostring(config.espMaxDistance) .. " m"
	distCycleBtn.Text = "Alternar alcance (" .. tostring(config.espMaxDistance) .. " m)"
	for _, fn in pairs(pillRefreshers) do
		fn()
	end
	syncEspStyleButtons()
	paintAimToggle(config.aimAssistEnabled)
	paintIgnoreToggle(config.ignoreTeam)
	paintFovToggle(config.fovEnabled)
	paintCircleToggle(config.showFovCircle)
	paintFilledToggle(config.fovFilled)
	paintEspToggle(config.espEnabled)
	paintMapVisualsToggle(config.mapVisualsEnabled)
	refreshChannelSelection()
end

local function applyConfigSupremoPreset()
	config.aimAssistEnabled = true
	config.ignoreTeam = true
	config.punchAssistRange = 60

	config.fovEnabled = true
	config.fovValue = 65
	config.showFovCircle = false
	config.fovFilled = false

	config.espEnabled = true
	config.espBox = false
	config.espName = false
	config.espDistance = false
	config.espHealth = false
	config.espLines = false
	config.espStyle = "Cheia"
	config.espMaxDistance = 1000

	config.mapVisualsEnabled = true
	config.mapTheme = "Azul + Roxo"
	config.lineColorPreset = "Roxo"

	syncAllUiFromConfig()
	rebuildThemeNow()
	updateEsp()

	configSupremoBtn.Text = "Config Supremo ✓"
	activeProfileStatusLbl.Text = "Config Supremo aplicado (Aimbot+Time+Max, FOV 65 sem círculo/preenchido, ESP Cheia + 1000m, Azul e Roxo)."
	-- Atualizacao instantanea sem atraso de task.delay
end

configSupremoBtn.Activated:Connect(applyConfigSupremoPreset)

local function applySavedProfileNow(profileName)
	local snap = savedProfiles[profileName]
	if not snap then return end
	local keepTab = config.activeTab
	local keepChannel = config.activeChannel
	local keepMin = config.minimizedToSquare
	local keepOpen = config.panelOpen
	for k, v in pairs(snap) do
		config[k] = v
	end
	config.activeTab = keepTab
	config.activeChannel = keepChannel
	config.minimizedToSquare = keepMin
	config.panelOpen = keepOpen
	selectedProfileName = profileName
	profileNameInput.Text = profileName
	pendingConfirmProfile = nil
	syncLayoutForConfirmBanner()
	syncAllUiFromConfig()
	rebuildThemeNow()
	updateEsp()
	footerRight.Text = "Perfil: " .. profileName
	activeProfileStatusLbl.Text = "Confirmado e aplicado: " .. profileName
end

local function rebuildProfileRows()
	for _, child in ipairs(profileListFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for name in pairs(savedProfiles) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -12, 0, 34)
		row.BackgroundColor3 = (name == selectedProfileName) and Color3.fromRGB(36, 20, 66) or Color3.fromRGB(24, 13, 38)
		row.BorderSizePixel = 0
		row.ZIndex = 6
		row.Parent = profileListFrame
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

		local pLbl = Instance.new("TextLabel")
		pLbl.Size = UDim2.new(1, -210, 1, 0)
		pLbl.Position = UDim2.fromOffset(10, 0)
		pLbl.BackgroundTransparency = 1
		pLbl.Text = name
		pLbl.TextColor3 = Color3.fromRGB(245, 245, 250)
		pLbl.Font = Enum.Font.GothamBold
		pLbl.TextSize = 11
		pLbl.TextXAlignment = Enum.TextXAlignment.Left
		pLbl.ZIndex = 7
		pLbl.Parent = row

		local pickBtn = Instance.new("TextButton")
		pickBtn.Size = UDim2.fromOffset(88, 24)
		pickBtn.Position = UDim2.new(1, -192, 0.5, -12)
		pickBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 54)
		pickBtn.Text = "Selecionar"
		pickBtn.TextColor3 = Color3.fromRGB(235, 235, 245)
		pickBtn.Font = Enum.Font.GothamBold
		pickBtn.TextSize = 10
		pickBtn.ZIndex = 7
		pickBtn.Parent = row
		Instance.new("UICorner", pickBtn).CornerRadius = UDim.new(0, 6)

		local applyRowBtn = Instance.new("TextButton")
		applyRowBtn.Size = UDim2.fromOffset(92, 24)
		applyRowBtn.Position = UDim2.new(1, -98, 0.5, -12)
		applyRowBtn.BackgroundColor3 = Color3.fromRGB(150, 55, 255)
		applyRowBtn.Text = "Confirmar"
		applyRowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		applyRowBtn.Font = Enum.Font.GothamBold
		applyRowBtn.TextSize = 10
		applyRowBtn.ZIndex = 7
		applyRowBtn.Parent = row
		Instance.new("UICorner", applyRowBtn).CornerRadius = UDim.new(0, 6)

		pickBtn.Activated:Connect(function()
			selectedProfileName = name
			profileNameInput.Text = name
			activeProfileStatusLbl.Text = "Selecionado: " .. name .. " (clique Confirmar)"
			rebuildProfileRows()
		end)

		applyRowBtn.Activated:Connect(function()
			applySavedProfileNow(name)
			rebuildProfileRows()
		end)
	end

	profileListFrame.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y + 8)
end

themeCycleBtn.Activated:Connect(function()
	local idx = table.find(themeOrder, config.mapTheme) or 1
	config.mapTheme = themeOrder[(idx % #themeOrder) + 1]
	themeCycleBtn.Text = "Textura: " .. config.mapTheme
	rebuildThemeNow()
end)

lineColorBtn.Activated:Connect(function()
	config.lineColorPreset = "Roxo"
	refreshLineColorButton()
	rebuildThemeNow()
end)

createProfileBtn.Activated:Connect(function()
	local raw = string.gsub(profileNameInput.Text or "", "^%s*(.-)%s*$", "%1")
	local name = (raw ~= "") and raw or ("Perfil_" .. tostring(#savedProfiles + 1))
	savedProfiles[name] = snapshotConfig()
	selectedProfileName = name
	profileNameInput.Text = name
	createProfileBtn.Text = "Salvo!"
	footerRight.Text = "Perfil: " .. name
	activeProfileStatusLbl.Text = "Perfil '" .. name .. "' salvo! Clique Confirmar para aplicar."
	rebuildProfileRows()
	-- Atualizacao instantanea sem atraso de task.delay
end)

confirmProfileBtn.Activated:Connect(function()
	local raw = string.gsub(profileNameInput.Text or "", "^%s*(.-)%s*$", "%1")
	local targetName = (raw ~= "" and savedProfiles[raw]) and raw or selectedProfileName
	if savedProfiles[targetName] then
		applySavedProfileNow(targetName)
		rebuildProfileRows()
	end
end)

confirmApplyBtn.Activated:Connect(function()
	if pendingConfirmProfile and savedProfiles[pendingConfirmProfile] then
		applySavedProfileNow(pendingConfirmProfile)
		rebuildProfileRows()
	end
end)

confirmDismissBtn.Activated:Connect(function()
	pendingConfirmProfile = nil
	syncLayoutForConfirmBanner()
end)

resetBtn.Activated:Connect(function()
	for k, v in pairs(defaultSnapshot) do
		config[k] = v
	end
	syncAllUiFromConfig()
	rebuildThemeNow()
	updateEsp()
	activeProfileStatusLbl.Text = "Configuracoes redefinidas para o padrao."
end)

saveBtn.Activated:Connect(function()
	local raw = string.gsub(profileNameInput.Text or "", "^%s*(.-)%s*$", "%1")
	local name = (raw ~= "") and raw or selectedProfileName
	savedProfiles[name] = snapshotConfig()
	selectedProfileName = name
	profileNameInput.Text = name
	saveBtn.Text = "Salvo!"
	footerRight.Text = "Perfil: " .. name
	activeProfileStatusLbl.Text = "Salvo em '" .. name .. "'."
	rebuildProfileRows()
	-- Atualizacao instantanea sem atraso de task.delay
end)

for _, tabName in ipairs(tabs) do
	tabButtons[tabName].Activated:Connect(function()
		config.activeTab = tabName
		for name, btn in pairs(tabButtons) do
			local selected = (name == tabName)
			btn.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(185, 160, 220)
			btn.Font = selected and Enum.Font.GothamBold or Enum.Font.GothamMedium
			tabUnderlines[name].Visible = selected
		end
		refreshChannelSelection()
		if tabName == "Perfis" then
			rebuildProfileRows()
		end
	end)
end

rebuildProfileRows()
refreshChannelSelection()

Players.PlayerRemoving:Connect(function(leavingPlayer)
	clearPlayerEsp(leavingPlayer)
end)

Workspace.DescendantAdded:Connect(function(obj)
	if not config.hubActive or isRebuildingEnvironment then return end
	if isOwnCharacterDescendant(obj) then
		if config.spiderVisualEnabled then
			applySpiderVisualToOwnCharacter()
		end
		return
	end
	if config.lagOptEnabled then
		processLagObject(obj)
	end
	if config.mapVisualsEnabled then
		processMapObj(obj)
	end
end)

Workspace.DescendantRemoving:Connect(function(obj)
	cleanupInstanceEntry(obj)
end)

player.CharacterAdded:Connect(function()
	cleanupDashNoclipOnHubDisable()
	restoreSpiderVisual()
	if config.hubActive then
		syncCharacterStats()
		applyEnvironmentAndVisuals()
	end
end)

-- LOOP PRINCIPAL
applyCameraFov()
applyEnvironmentAndVisuals()
updateEsp()

RunService.RenderStepped:Connect(function(dt)
	pcall(function()
		syncCharacterStats()
		applyCameraFov()
		updateFovCircle()
		updateEsp()
		ensureFloorGridAlwaysAlive()

		local closestRoot, closestDist = findClosestEnemyInRange(config.espMaxDistance)
		if closestRoot and closestDist then
			local enemyModel = closestRoot.Parent
			local enemyPlayer = enemyModel and Players:GetPlayerFromCharacter(enemyModel)
			local enemyHum = enemyModel and enemyModel:FindFirstChildOfClass("Humanoid")
			statTargetVal.Text = enemyPlayer and enemyPlayer.DisplayName or "Alvo"
			statDistVal.Text = tostring(math.round(closestDist)) .. " m"
			if enemyHum and enemyHum.MaxHealth > 0 then
				statHpVal.Text = tostring(math.clamp(math.round((enemyHum.Health / enemyHum.MaxHealth) * 100), 0, 100)) .. "%"
			end
		else
			statTargetVal.Text = "Jogador_01"
			statDistVal.Text = "128 m"
			statHpVal.Text = "68%"
		end

		if config.hubActive then
			if UIS:IsKeyDown(Enum.KeyCode.Space) then
				fireZeroDelayJump()
			end
			if config.aimAssistEnabled and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				local myChar = player.Character
				local myRoot = getCharacterRoot(myChar)
				local targetRoot, _ = findClosestEnemyInRange(config.punchAssistRange)
				if myRoot and targetRoot then
					local flatDelta = Vector3.new(targetRoot.Position.X - myRoot.Position.X, 0, targetRoot.Position.Z - myRoot.Position.Z)
					if flatDelta.Magnitude > 0.01 then
						local dir = flatDelta.Unit
						local pos = myRoot.Position
						myRoot.CFrame = CFrame.lookAt(pos, pos + dir)
					end
				end
			end
		end

		statusTop.Text = "● Ativo · 0ms Delay"
	end)
end)
