local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Util = require(script.Parent.Parent.Util)
local clr = Util.clr

local Slider = {}

function Slider.new(section, config)
	local label = config.Label    or "Slider"
	local min   = config.Min      or 0
	local max   = config.Max      or 100
	local def   = config.Default  or 50
	local step  = config.Step     or 1
	local cb    = config.Callback or function() end

	section._ic = section._ic + 1
	local order = section._base + section._ic

	local f = Util.row(section._holder, order, label)

	local vLbl = Instance.new("TextLabel")
	vLbl.Name = "ValueLabel"
	vLbl.FontFace = Util.font
	vLbl.TextSize = 12
	vLbl.Size = UDim2.new(0, 30, 0, 19)
	vLbl.Position = UDim2.new(0.44, 0, 0.20, 0)
	vLbl.TextColor3 = clr.TextSecondary
	vLbl.BackgroundTransparency = 1
	vLbl.Text = tostring(def)
	vLbl.Parent = f

	local track = Instance.new("Frame")
	track.Name = "SliderTrack"
	track.Size = UDim2.new(0, 136, 0, 5)
	track.Position = UDim2.new(0.57, 0, 0.41, 0)
	track.BorderSizePixel = 0
	track.BackgroundColor3 = clr.SliderTrack
	track.Parent = f
	Util.corner(track, 1.0)

	local fill = Instance.new("Frame")
	fill.Name = "SliderFill"
	fill.Size = UDim2.new(0, 0, 0, 5)
	fill.BorderSizePixel = 0
	fill.BackgroundColor3 = clr.SliderFill
	fill.Parent = track
	Util.corner(fill, 1.0)

	local kFrame = Instance.new("Frame")
	kFrame.Name = "SliderKnob"
	kFrame.Size = UDim2.new(0, 13, 0, 13)
	kFrame.BorderSizePixel = 0
	kFrame.BackgroundColor3 = clr.SliderFill
	kFrame.Parent = track
	local kc = Instance.new("UICorner")
	kc.CornerRadius = UDim.new(0.4, 0)
	kc.Parent = kFrame

	local cur = def
	local dragging = false

	local function upd(v)
		v = math.clamp(v, min, max)
		if step > 0 then
			v = math.round((v - min) / step) * step + min
		end
		cur = v
		local pct = (v - min) / (max - min)
		local tw = track.AbsoluteSize.X
		fill.Size = UDim2.new(0, tw * pct, 0, 5)
		kFrame.Position = UDim2.new(0, tw * pct - 6, -0.87, 0)
		vLbl.Text = tostring(v)
	end

	task.defer(function() upd(def) end)

	local function onInput(input)
		local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		upd(min + pct * (max - min))
		cb(cur)
	end

	local clickR = Instance.new("TextButton")
	clickR.Size = UDim2.new(1, 0, 3, 0)
	clickR.Position = UDim2.new(0, 0, -1, 0)
	clickR.BackgroundTransparency = 1
	clickR.Text = ""
	clickR.Parent = track

	clickR.MouseButton1Down:Connect(function(x, y)
		dragging = true
		onInput({ Position = Vector3.new(x, y, 0) })
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			onInput(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	return {
		SetValue = function(_, v) upd(v) end,
		GetValue = function(_) return cur end,
	}
end

return Slider
