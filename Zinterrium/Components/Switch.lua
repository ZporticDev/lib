local TweenService = game:GetService("TweenService")
local Util = require(script.Parent.Parent.Util)
local clr = Util.clr

local Switch = {}

function Switch.new(section, config)
	local label = config.Label   or "Toggle Switch"
	local def   = config.Default ~= nil and config.Default or false
	local cb    = config.Callback or function() end

	section._ic = section._ic + 1
	local order = section._base + section._ic

	local f = Util.row(section._holder, order, label)

	local sw = Instance.new("Frame")
	sw.Name = "Switch"
	sw.Size = UDim2.new(0, 42, 0, 25)
	sw.Position = UDim2.new(0.88, 0, 0.18, 0)
	sw.BorderSizePixel = 0
	sw.BackgroundColor3 = def and clr.SwitchOn or clr.SwitchOff
	sw.Parent = f
	Util.corner(sw, 1.0)
	Util.stroke(sw, clr.Stroke)

	local uiScale = Instance.new("UIScale")
	uiScale.Scale = 0.8
	uiScale.Parent = sw

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = def and UDim2.new(0, 20, 0.14, 0) or UDim2.new(0, 5, 0.14, 0)
	knob.BorderSizePixel = 0
	knob.BackgroundColor3 = def and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	knob.Parent = sw
	Util.corner(knob, 1.0)

	local tog = def

	local function setTog(state, animate)
		tog = state
		local info = TweenInfo.new(animate and 0.2 or 0, Enum.EasingStyle.Quad)
		TweenService:Create(sw, info, {
			BackgroundColor3 = state and clr.SwitchOn or clr.SwitchOff
		}):Play()
		TweenService:Create(knob, info, {
			Position = state and UDim2.new(0, 20, 0.14, 0) or UDim2.new(0, 5, 0.14, 0),
			BackgroundColor3 = state and Color3.new(0, 0, 0) or Color3.new(1, 1, 1),
		}):Play()
	end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = sw
	btn.MouseButton1Click:Connect(function()
		setTog(not tog, true)
		cb(tog)
	end)

	return {
		SetValue = function(_, v) setTog(v, true) end,
		GetValue = function(_) return tog end,
	}
end

return Switch
