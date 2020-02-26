local CatanTile = import('catan-generator/CatanTile')

CatanBoard = class()

local COLORS = {
    brick=color(147, 63, 27),
    stone=color(127, 127, 127),
    wool=color(187, 225, 119),
    wood=color(37, 86, 30),
    wheat=color(238, 213, 53),
    desert=color(223, 215, 168)
}

function shuffle(t)
    math.randomseed(os.time())
    for i = #t, 2, -1 do
        j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function hex_map(radius)
    local min, max = math.min, math.max
    local collection = {}
    for q = -radius, radius, 1 do
        local r1 = max(-radius, -q - radius)
        local r2 = min(radius, -q + radius)
        for r = r1, r2, 1 do
            table.insert(collection, vec2(q, r))
        end
    end
    return collection
end

function tile_numbers()
    local number_count = { 1, 2, 2, 2, 2, 0, 2, 2, 2, 2, 1 }
    local numbers = {}
    for idx, total_amount in ipairs(number_count) do
        if total_amount ~= 0 then
            local num = idx + 1
            for i = 1, total_amount do
                table.insert(numbers, num)
            end
        end
    end
    return numbers
end

function tile_colors()
    local tile_count = {
        brick=3,
        stone=3,
        wool=4,
        wood=4,
        wheat=4
    }
    local colors = {}
    for name, num in pairs(tile_count) do
        for i = 1, num do
            table.insert(colors, { type=name, color=COLORS[name] })
        end
    end
    return colors
end

function tile_data()
    local numbers = tile_numbers()
    local tile_colors = tile_colors()
    local data = {}
    for idx, color in ipairs(tile_colors) do
        table.insert(data, {
            type=color.type,
            color=color.color,
            number=numbers[idx]
        })
    end
    table.insert(data, {
        type='desert',
        color=COLORS.desert,
        number=nil
    })
    shuffle(shuffle(data))
    return data
end

function CatanBoard:init()    
    local board_map = hex_map(2)
    local tile_data = tile_data()

    self.tiles = {}
    for idx, point in ipairs(board_map) do        
        local data = tile_data[idx]
        local tile = CatanTile(data.number, point.x, point.y,
            data.color, data.type)
        
        table.insert(self.tiles, tile)
    end
    
end

function CatanBoard:draw()
    for idx, hex in ipairs(self.tiles) do
        hex:draw()
    end
end

function CatanBoard:reposition()
    for idx, hex in ipairs(self.tiles) do
        hex:reposition()
        hex:draw()
    end
end

function CatanBoard:update()
    local tile_data = tile_data()
    for idx, tile in ipairs(self.tiles) do
        tile.color = tile_data[idx].color
        tile.number = tile_data[idx].number
    end
end

function CatanBoard:touched(touch)
end

return CatanBoard
