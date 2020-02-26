local HexTile = import('catan-generator/HexTile')

CatanTile = class(HexTile)

function CatanTile:init(number, q, r, _color, _type)
    HexTile.init(self, q, r, _color)
    
    self.number = number
    self.type = _type
end

function CatanTile:draw()
    HexTile.draw(self)
    
    pushStyle()
    
    self:draw_number()
    
    popStyle()
end

function CatanTile:draw_number()
    local center = self.hex:to_point()
    
    local Size = Size or 40

    if self.number then    
        strokeWidth(2)
        stroke(0, 0, 0)
        
        ellipseMode(CENTER)
        fill(255, 255, 255)
        ellipse(center.x, center.y, Size / 1.2)
    
        textMode(CENTER)
        fontSize(Size / 2.3)
        fill(0, 0, 0)
        text(self.number, center.x, center.y)
    end
end

return CatanTile
