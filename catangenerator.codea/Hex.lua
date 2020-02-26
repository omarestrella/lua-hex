Hex = class()

local Orientation = class()
local Layout = class()

-- Metadata classes

function Orientation:init(is_flat)
    local sqrt = math.sqrt
    if is_flat then
        self.start_angle = 0.0
        self.forward_matrix = vec4(3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0))
        self.inverse_matrix = vec4(2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0)
    else
        self.start_angle = 0.5
        self.forward_matrix = vec4(sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0)
        self.inverse_matrix = vec4(sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0)
    end
end

function Layout:init(orientation, size, origin)
    self.orientation = orientation
    self.size = size
    self.origin = origin
end

function Layout:corner_offset(corner)
    local angle = 2.0 * math.pi *
        (self.orientation.start_angle + corner) / 6
    return vec2(self.size.x * math.cos(angle), self.size.y * math.sin(angle))
end

-- End metadata classes

local POINTY_ORIENTATION = Orientation(false)
local FLAT_ORIENTATION = Orientation(true)
local LAYOUT = Layout(POINTY_ORIENTATION, vec2(Size, Size),
    vec2(WIDTH / 2, HEIGHT / 2))


-- Hex and static helpers

function Hex:init(q, r)
    assert(q ~= nil and r ~= nil, 'Q and R should be valid numbers')
    
    local s = -q - r
    
    self.q = q
    self.r = r
    self.s = s
    
    self.layout = LAYOUT
end

function Hex:corners()
    local corners = {}
    local center = self:to_point()
    for i = 1, 6 do
        local offset = self.layout:corner_offset(i)
        table.insert(corners, vec2(center.x + offset.x, center.y + offset.y))
    end
    return corners
end

function Hex:to_point()
    local o = self.layout.orientation or POINTY_ORIENTATION
    local x = (o.forward_matrix.x * self.q + o.forward_matrix.y * self.r) * self.layout.size.x
    local y = (o.forward_matrix.z * self.q + o.forward_matrix.w * self.r) * self.layout.size.y
    return vec2(x + self.layout.origin.x, y + self.layout.origin.y)
end

function Hex:update_size(size)
    self.layout.size = size
end

function Hex:update_origin(origin)
    self.layout.origin = origin
end

function Hex:change_orientation(pointed)
    if pointed then
        self.layout.orientation = POINTY_ORIENTATION
    else
        self.layout.orientation = FLAT_ORIENTATION
    end
end

function Hex.from_point(layout, pt)
    local mat = layout.orientation.inverse_matrix
    local x = (pt.x - layout.origin.x) / layout.size.x
    local y = (pt.y - layout.origin.y) / layout.size.y
    local fractional_q = mat.x * x + mat.y * y
    local fractional_r = mat.z * x + mat.w * y
    
    q, r = Hex.round_to_nearest(fractional_q, fractional_r)
    
    return Hex(q, r)
end

function Hex.round_to_nearest(frac_q, frac_r)
    local round = function (num)
        return math.floor(num + 0.5)
    end
    
    frac_s = -frac_q - frac_r
    
    q = round(frac_q)
    r = round(frac_r)
    s = round(frac_s)
    
    q_diff = math.abs(q - frac_q)
    r_diff = math.abs(r - frac_r)
    s_diff = math.abs(r - frac_s)
    
    if q_diff > r_diff and q_diff > s_diff then
        q = -r - s
    elseif r_diff > s_diff then
        r = -q - s
    else
        s = -q - r
    end
    
    return q, r
end

function Hex.equal(a, b)
    return a.q == b.q and a.r == b.r and a.s == b.s
end

function Hex.add(a, b)
    return Hex(a.q + b.q, a.r + b.r, a.s + b.s)
end

function Hex.sub(a, b)
    return Hex(a.q - b.q, a.r - b.r, a.s - b.s)
end

function Hex.mul(hex, k)
    return Hex(hex.q * k, hex.r * k, hex.s * k)
end

function Hex.length(hex)
    local abs = math.abs
    return (abs(hex.q) + abs(hex.r) + abs(hex.s)) / 2
end

function Hex.distance(a, b)
    return Hex.length(Hex.sub(a, b))
end

-- End Hex and static helpers

return Hex

