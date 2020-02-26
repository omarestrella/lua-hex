local Hex = import('catan-generator/Hex')

HexTile = class()

function HexTile:init(q, r, _color)
    self.color = _color
    
    self.hex = Hex(q, r)
end

function HexTile:draw()
    local Size = Size or 40
    
    pushStyle()
    pushMatrix()
    
    self.hex:update_size(vec2(Size, Size))
    self.hex:change_orientation(Pointed)
    
    local corners = self.hex:corners()
    
    _mesh = mesh()
    _mesh.vertices = triangulate(corners)
    _mesh:setColors(self.color)
    _mesh:draw()
    
    stroke(0, 0, 0)
    strokeWidth(2)
    for idx, corner in ipairs(corners) do
        if idx ~= #corners then
            local next_corner = corners[idx + 1]        
            line(corner.x, corner.y, next_corner.x, next_corner.y)
        elseif idx == #corners then
            local first_corner = corners[1]
            line(corner.x, corner.y, first_corner.x, first_corner.y)
        end
    end
    
    popMatrix()
    popStyle()
end

function HexTile:reposition()
    --self.hex:update_origin(vec2(0, 0))
    self.hex:update_origin(vec2(WIDTH / 2, HEIGHT / 2 + 150))
end

function HexTile:is_touching(touch)
    local layout = self.hex.layout
    local touched_hex = self.hex.from_point(layout, touch)
    return self.hex.q == touched_hex.q and self.hex.r == touched_hex.r and self.hex.s == touched_hex.s
end

function HexTile:touched(touch)
    -- Codea does not automatically call this method
end

return HexTile
