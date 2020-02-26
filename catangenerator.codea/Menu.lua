Menu = class()

function Menu:init()
    self.origin = vec2(WIDTH / 2, HEIGHT / 2)
    self.buttons = {
        { name = 'New Game', tint = nil },
        { name = 'Settings', tint = nil }
    }
    
    self:calculate_positions()
end

function Menu:calculate_positions()
    local button_height = 50
    local origin = #self.buttons * button_height / 2 + self.origin.y
    
    for idx, button in ipairs(self.buttons) do
        button.x = self.origin.x
        button.y = origin - (idx * button_height)
    end
end

function Menu:draw()
    self:draw_buttons()
end

function Menu:draw_buttons()
    spriteMode(CENTER)
    
    
    for idx, button in ipairs(self.buttons) do
        if button.tint ~= nil then
            tint(button.tint)
        else
            tint(255, 255, 255, 255)
        end
        sprite("Cargo Bot:Dialogue Button", button.x, button.y)
    end
end

function Menu:touched(touch)
    for idx, button in ipairs(self.buttons) do
        local lower_x, upper_x = button.x - 50, button.x + 50
        local lower_y, upper_y = button.y - 25 , button.y + 25
        
        if lower_x < touch.x and touch.x < upper_x
            and touch.y > lower_y and touch.y < upper_y then
            button.tint = color(40)
            self.handler(button)
        else
            button.tint = nil
        end
    end
end

return Menu
