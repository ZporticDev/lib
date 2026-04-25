local TweenService = game:GetService("TweenService")
local Util = require(script.Parent.Parent.Util)
local clr = Util.clr

local Button = {}

function Button.new(section, config)
	local label = config.Label or "Button"
	local cb    = config.Callback or function() end

	section._ic = section._ic + 1
	local order = section._base + section._ic

	local f = Util.row(section._holder, order, label)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = f

	btn.MouseEnter:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.15), {
			BackgroundColor3 = clr.RowBackground
		}):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		TweenService:Create(f, TweenInfo.new(0.08), {
			BackgroundColor3 = Color3.new(0.22, 0.22, 0.22)
		}):Play()
		task.delay(0.12, function()
			TweenService:Create(f, TweenInfo.new(0.15), {
				BackgroundColor3 = clr.RowBackground
			}):Play()
		end)
		cb()
	end)

	return {
		SetLabel = function(_, text)
			f:FindFirstChild("RowLabel").Text = text
		end,
	}
end

return Button
