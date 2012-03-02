Vector = Class()

function Vector:init(x, y)
	self.x = x
	self.y = y
end

function Vector:__add(b)
  if type(b) == "number" then
    return Vector(self.x + b, self.y + b)
  else
    return Vector(self.x + b.x, self.y + b.y)
  end
end

function Vector:__sub(b)
  if type(b) == "number" then
    return Vector(self.x - b, self.y - b)
  else
    return Vector(self.x - b.x, self.y - b.y)
  end
end

function Vector:__mul(b)
  if type(b) == "number" then
    return Vector(self.x * b, self.y * b)
  else
    return Vector(self.x * b.x, self.y * b.y)
  end
end

function Vector:__div(b)
  if type(b) == "number" then
    return Vector(self.x / b, self.y / b)
  else
    return Vector(self.x / b.x, self.y / b.y)
  end
end

function Vector:__eq(b)
  return self.x == b.x and self.y == b.y
end

function Vector:__lt(b)
  return self.x < b.x or (self.x == b.x and self.y < b.y)
end

function Vector:__le(b)
  return self.x <= b.x and self.y <= b.y
end

function Vector:__tostring()
  return "(" .. self.x .. ", " .. self.y .. ")"
end

function Vector:distance(b)
  return (b - self):len()
end

function Vector:clone()
  return Vector(self.x, self.y)
end

function Vector:unpack()
  return self.x, self.y
end

function Vector:len()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:lenSq()
  return self.x * self.x + self.y * self.y
end

function Vector:normalize()
  local len = self:len()
  self.x = self.x / len
  self.y = self.y / len
  return self
end

function Vector:normalized()
  return self / self:len()
end

function Vector:rotate(phi)
  local c = math.cos(phi)
  local s = math.sin(phi)
  self.x = c * self.x - s * self.y
  self.y = s * self.x + c * self.y
  return self
end

function Vector:rotated(phi)
  return self:clone():rotate(phi)
end

function Vector:perpendicular()
  return Vector(-self.y, self.x)
end

function Vector:projectOn(other)
  return (self * other) * other / other:lenSq()
end

function Vector:cross(other)
  return self.x * other.y - self.y * other.x
end