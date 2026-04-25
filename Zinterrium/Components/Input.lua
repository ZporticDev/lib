local TweenService = game:GetService("TweenService")
local Util = require(script.Parent.Parent.Util)
local clr = Util.clr

local Input = {}

function Input.new(section, config)
	local label = config.Label       or "Input"
	local ph    = config.Placeholder or "..."
	local def   = config.Default     or ""
	local cb    = config.Callback    or function() end

	section._ic = section._ic + 1
	local order = section._base + section._ic

	local f = Util.row(section._holder, order, label)

	local tb = Instance.new("TextBox")
	tb.BorderSizePixel = 0
	tb.BackgroundColor3 = clr.InputBg
	tb.FontFace = Util.fontReg
	tb.TextSize = 13
	tb.Size = UDim2.new(0, 141, 0, 21)
	tb.TextColor3 = clr.InputText
	tb.Text = def
	tb.PlaceholderText = ph
	tb.PlaceholderColor3 = clr.TextSecondary
	tb.TextXAlignment = Enum.TextXAlignment.Left
	tb.ClearTextOnFocus = false
	tb.Position = UDim2.new(0.58, 0, 0.20, 0)
	tb.Parent = f
	Util.corner(tb, 0.20)

	local s = Instance.new("UIStroke")
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Color = Color3.new(0.27, 0.27, 0.27)
	s.Transparency = 0.5
	s.Parent = tb

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 7)
	pad.Parent = tb

	tb.Focused:Connect(function()
		TweenService:Create(tb, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.new(0.20, 0.20, 0.20)
		}):Play()
	end)
	tb.FocusLost:Connect(function(enter)
		TweenService:Create(tb, TweenInfo.new(0.15), {
			BackgroundColor3 = clr.InputBg
		}):Play()
		cb(tb.Text, enter)
	end)

	return {
		SetValue = function(_, v) tb.Text = v end,
		GetValue = function(_) return tb.Text end,
	}
end

return Input
