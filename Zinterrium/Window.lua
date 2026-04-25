local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Util = require(script.Parent.Util)
local clr = Util.clr
local font = Util.font

local Button = require(script.Parent.Components.Button)
local Switch = require(script.Parent.Components.Switch)
local Slider = require(script.Parent.Components.Slider)
local Input  = require(script.Parent.Components.Input)

local Window = {}

local function makeSection(holder, base, ic)
	local sec = {
		_holder = holder,
		_base   = base,
		_ic     = ic,
	}
	return setmetatable(sec, {
		__index = {
			CreateButton = function(self, cfg) return Button.new(self, cfg) end,
			CreateSwitch = function(self, cfg) return Switch.new(self, cfg) end,
			CreateSlider = function(self, cfg) return Slider.new(self, cfg) end,
			CreateInput  = function(self, cfg) return Input.new(self, cfg) end,
		}
	})
end

local function makeTab(wObj, name)
	wObj._tc = wObj._tc + 1

	local tf = Instance.new("Frame")
	tf.Name = "Tab_" .. name
	tf.LayoutOrder = wObj._tc
	tf.Size = UDim2.new(0, 121, 0, 21)
	tf.BorderSizePixel = 0
	tf.BackgroundTransparency = 1
	tf.Parent = wObj._tabsF

	local bar = Instance.new("Frame")
	bar.Name = "AccentBar"
	bar.Size = UDim2.new(0, 3, 0, 21)
	bar.BorderSizePixel = 0
	bar.BackgroundColor3 = clr.SwitchOn
	bar.BackgroundTransparency = 1
	bar.Parent = tf

	local tLbl = Instance.new("TextLabel")
	tLbl.Name = "Label"
	tLbl.FontFace = font
	tLbl.TextXAlignment = Enum.TextXAlignment.Left
	tLbl.TextSize = 14
	tLbl.Size = UDim2.new(0, 100, 0, 19)
	tLbl.Text = name
	tLbl.TextColor3 = clr.TextSecondary
	tLbl.BackgroundTransparency = 1
	tLbl.Position = UDim2.new(0.03, 0, 0, 0)
	tLbl.Parent = tf

	local lPad = Instance.new("UIPadding")
	lPad.PaddingLeft = UDim.new(0, 10)
	lPad.Parent = tLbl

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = tf

	local holder = Instance.new("Frame")
	holder.Name = "Holder_" .. name
	holder.Size = UDim2.new(1, 0, 0, 0)
	holder.AutomaticSize = Enum.AutomaticSize.Y
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.Visible = false
	holder.Parent = wObj._scroll

	local hLayout = Instance.new("UIListLayout")
	hLayout.SortOrder = Enum.SortOrder.LayoutOrder
	hLayout.Padding = UDim.new(0, 8)
	hLayout.Parent = holder

	local tObj = {
		_bar    = bar,
		_lbl    = tLbl,
		_holder = holder,
		_sc     = 0,
	}

	local function sel()
		for _, t in ipairs(wObj._tabs) do
			TweenService:Create(t._bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				BackgroundTransparency = 1,
			}):Play()
			TweenService:Create(t._lbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				TextColor3 = clr.TextSecondary,
			}):Play()
			t._holder.Visible = false
		end
		TweenService:Create(bar, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			BackgroundTransparency = 0,
		}):Play()
		TweenService:Create(tLbl, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			TextColor3 = clr.TextPrimary,
		}):Play()
		holder.Visible = true
		wObj._active = tObj
	end

	btn.MouseButton1Click:Connect(sel)
	table.insert(wObj._tabs, tObj)

	if #wObj._tabs == 1 then sel() end

	return setmetatable(tObj, {
		__index = {
			CreateSection = function(self, cfg)
				cfg = cfg or {}
				local sName = cfg.Name or ""
				self._sc = self._sc + 1

				local titleLbl = Instance.new("TextLabel")
				titleLbl.LayoutOrder = self._sc * 100
				titleLbl.FontFace = font
				titleLbl.TextXAlignment = Enum.TextXAlignment.Left
				titleLbl.TextSize = 14
				titleLbl.Size = UDim2.new(1, 0, 0, 19)
				titleLbl.Text = sName
				titleLbl.TextColor3 = clr.TextPrimary
				titleLbl.BackgroundTransparency = 1
				titleLbl.Parent = self._holder

				return makeSection(self._holder, self._sc * 100, 0)
			end,
		}
	})
end

function Window.new(config)
	config = config or {}
	local title    = config.Title    or "Zinterrium"
	local subtitle = config.Subtitle or ""
	local size     = config.Size     or Vector2.new(476, 303)
	local position = config.Position or UDim2.new(0.32, 0, 0.09, 0)

	local sg = Instance.new("ScreenGui")
	sg.Name = title .. "_Zinterrium"
	sg.Enabled = true
	sg.IgnoreGuiInset = true
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	sg.ResetOnSpawn = false

	local function getGui()
		if game:GetService("RunService"):IsStudio() then
			sg.DisplayOrder = 9999
			return Players.LocalPlayer:WaitForChild("PlayerGui")
		else
			local ok, cg = pcall(function() return game:GetService("CoreGui") end)
			if ok and cg then return cg end
			sg.DisplayOrder = 9999
			return Players.LocalPlayer:WaitForChild("PlayerGui")
		end
	end
	sg.Parent = getGui()

	local win = Instance.new("CanvasGroup")
	win.Name = "Window"
	win.Size = UDim2.new(0, size.X, 0, size.Y)
	win.Position = position
	win.BorderSizePixel = 0
	win.BackgroundColor3 = clr.Background
	win.GroupTransparency = 1
	win.Parent = sg
	Util.corner(win, 0.01)

	local hTitle = Instance.new("TextLabel")
	hTitle.FontFace = font
	hTitle.TextXAlignment = Enum.TextXAlignment.Left
	hTitle.TextSize = 14
	hTitle.Size = UDim2.new(0, 200, 0, 19)
	hTitle.Text = title
	hTitle.TextColor3 = clr.TextPrimary
	hTitle.BackgroundTransparency = 1
	hTitle.Position = UDim2.new(0.02, 0, 0.03, 0)
	hTitle.Parent = win

	local hSub = Instance.new("TextLabel")
	hSub.TextYAlignment = Enum.TextYAlignment.Top
	hSub.FontFace = font
	hSub.TextXAlignment = Enum.TextXAlignment.Left
	hSub.TextSize = 12
	hSub.Size = UDim2.new(0, 200, 0, 19)
	hSub.Text = subtitle
	hSub.TextColor3 = clr.TextSecondary
	hSub.BackgroundTransparency = 1
	hSub.Position = UDim2.new(0.02, 0, 0.08, 0)
	hSub.Parent = win

	local tabsF = Instance.new("Frame")
	tabsF.Name = "Tabs"
	tabsF.Size = UDim2.new(0, 115, 0, size.Y - 50)
	tabsF.Position = UDim2.new(0, 0, 0.16, 0)
	tabsF.BorderSizePixel = 0
	tabsF.BackgroundTransparency = 1
	tabsF.Parent = win
	local tabsL = Instance.new("UIListLayout")
	tabsL.SortOrder = Enum.SortOrder.LayoutOrder
	tabsL.Parent = tabsF

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "ContentScroll"
	scroll.Active = true
	scroll.BorderSizePixel = 0
	scroll.BackgroundTransparency = 1
	scroll.Size = UDim2.new(0, size.X - 110, 0, size.Y - 50)
	scroll.Position = UDim2.new(0.23, 0, 0.17, 0)
	scroll.ScrollBarThickness = 5
	scroll.ScrollBarImageTransparency = 0.71
	scroll.Parent = win
	local scrollL = Instance.new("UIListLayout")
	scrollL.SortOrder = Enum.SortOrder.LayoutOrder
	scrollL.Padding = UDim.new(0, 8)
	scrollL.Parent = scroll
	scrollL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.new(0, 0, 0, scrollL.AbsoluteContentSize.Y + 20)
	end)
	local scrollPad = Instance.new("UIPadding")
	scrollPad.PaddingTop    = UDim.new(0, 10)
	scrollPad.PaddingBottom = UDim.new(0, 10)
	scrollPad.PaddingLeft   = UDim.new(0, 10)
	scrollPad.PaddingRight  = UDim.new(0, 10)
	scrollPad.Parent = scroll

	local topbar = Instance.new("TextButton")
	topbar.Name = "Topbar"
	topbar.Size = UDim2.new(1, 0, 0.16, 0)
	topbar.Position = UDim2.new(0, 0, 0, 0)
	topbar.BackgroundTransparency = 1
	topbar.Text = ""
	topbar.ZIndex = 10
	topbar.Parent = win

	local drag, dStart, sPos
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			dStart = input.Position
			sPos = win.Position
		end
	end)
	topbar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - dStart
			win.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
		end
	end)

	TweenService:Create(win, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		GroupTransparency = 0,
	}):Play()

	local isOpen = true
	local function tog()
		if isOpen then
			local t = TweenService:Create(win, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				GroupTransparency = 1,
			})
			t:Play()
			t.Completed:Connect(function() win.Visible = false end)
		else
			win.Visible = true
			TweenService:Create(win, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				GroupTransparency = 0,
			}):Play()
		end
		isOpen = not isOpen
	end

	local wObj = {
		_sg     = sg,
		_win    = win,
		_tabsF  = tabsF,
		_scroll = scroll,
		_tabs   = {},
		_tc     = 0,
		_active = nil,
		_tog    = tog,
	}

	return setmetatable(wObj, {
		__index = {
			CreateTab = function(self, cfg)
				cfg = cfg or {}
				return makeTab(self, cfg.Name or ("Tab " .. (self._tc + 1)))
			end,
			Toggle  = function(self) self._tog() end,
			Destroy = function(self) self._sg:Destroy() end,
		}
	})
end

return Window
