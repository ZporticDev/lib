local _cache = {}
local _repo  = "https://raw.githubusercontent.com/ZporticDev/lib/main/"

function _G.import(path)
    if _cache[path] then return _cache[path] end

    local ok, src = pcall(game.HttpGet, game, _repo .. path .. ".lua")
    assert(ok and src, "[import] Failed to fetch: " .. path)

    local fn, parseErr = loadstring(src)
    assert(fn, "[import] Failed to parse: " .. path .. "\n" .. tostring(parseErr))

    local runOk, result = pcall(fn)
    assert(runOk, "[import] Runtime error in: " .. path .. "\n" .. tostring(result))

    _cache[path] = result
    return result
end