-- src/init.lua
local Window = _G.import("src/Window")

local Zinterrium = {}

function Zinterrium.CreateWindow(config)
    return Window.new(config)
end

return Zinterrium