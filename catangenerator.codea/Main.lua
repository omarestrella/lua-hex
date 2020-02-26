local show_menu = false
local show_graph = false

function button_touched(button)
    if button.name == 'New Game' then
        show_menu = false
    end
end

function update_board(board)
    return function ()
        board:update()
    end
end

local CatanBoard = import('catan-generator/CatanBoard')
local Menu = import('catan-generator/Menu')

-- Use this function to perform your initial setup
function setup()
    -- displayMode(OVERLAY)
    
    graph = Graph()
    board = CatanBoard()
    menu = Menu()
    menu.handler = button_touched
    
    parameter.integer('Size', 20, 200, 48)
    parameter.boolean('Pointed', true)
    parameter.action('Update Board', update_board(board))
end

-- This function gets called once every frame
function draw()
    background(222, 222, 222)
    
    translate(-WIDTH/10, -HEIGHT/10)
    
    board:draw()
end

function touched(touch)
    board:touched(touch)
    if show_menu then
        menu:touched(touch)
    end
end

function orientationChanged()
    if board then board:reposition() end
end
