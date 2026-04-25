local Util = {}

Util.font = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
Util.fontReg = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

Util.clr = {
	Background    = Color3.new(0.12, 0.12, 0.12),
	RowBackground = Color3.new(0.14, 0.14, 0.14),
	Stroke        = Color3.new(0.24, 0.24, 0.24),
	TextPrimary   = Color3.new(0.96, 0.96, 0.96),
	TextSecondary = Color3.new(0.39, 0.39, 0.39),
	SwitchOff     = Color3.new(0.20, 0.20, 0.20),
	SwitchOn      = Color3.new(1.00, 1.00, 1.00),
	SliderTrack   = Color3.new(0.20, 0.20, 0.20),
	SliderFill    = Color3.new(1.00, 1.00, 1.00),
	InputBg       = Color3.new(0.16, 0.16, 0.16),
	InputText     = Color3.new(0.86, 0.86, 0.86),
}

function Util.corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(r or 0.2, 0)
	c.Parent = p
	return c
end

function Util.stroke(p, color, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Util.clr.Stroke
	s.Transparency = transparency or 0
	s.Parent = p
	return s
end

function Util.row(parent, order, lbl)
	local f = Instance.new("Frame")
	f.LayoutOrder = order
	f.Size = UDim2.new(1, 0, 0, 34)
	f.BorderSizePixel = 0
	f.BackgroundColor3 = Util.clr.RowBackground
	f.Parent = parent
	Util.corner(f, 0.20)
	Util.stroke(f, Util.clr.Stroke)

	local label = Instance.new("TextLabel")
	label.Name = "RowLabel"
	label.FontFace = Util.font
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextSize = 14
	label.Size = UDim2.new(0, 200, 0, 19)
	label.Text = lbl or ""
	label.TextColor3 = Util.clr.TextPrimary
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0.02, 0, 0.20, 0)
	label.Parent = f

	return f
end

return Util
