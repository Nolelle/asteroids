const rl = @import("raylib");
const std = @import("std");

pub const Asteroid = struct {
    vertices: [3]rl.Vector2,
    position: rl.Vector2,
    velocity: rl.Vector2,
    rotation: f32,
    scale: f32,
    color: rl.Color,
    active: bool,
};

pub fn init(x: f32, y: f32) Asteroid {
    return Asteroid{
        .vertices = [_]rl.Vector2{
            rl.Vector2{ .x = 0, .y = -10 },
            rl.Vector2{ .x = -10, .y = 10 },
            rl.Vector2{ .x = 10, .y = 10 },
        },
        .position = rl.Vector2{ .x = x, .y = y },
        .velocity = rl.Vector2{ .x = std.rand.float(f32), .y = std.rand.float(f32) },
        .rotation = 0,
        .scale = 1,
        .color = rl.Color.white,
        .active = true,
    };
}

pub fn update(self: *Asteroid) void {
    self.position.x += self.velocity.x;
    self.position.y += self.velocity.y;

    if (self.position.x > 800) self.position.x = 0;
    if (self.position.x < 0) self.position.x = 800;
    if (self.position.y > 600) self.position.y = 0;
    if (self.position.y < 0) self.position.y = 600;
}

pub fn draw(self: *Asteroid) void {
    const p1 = rl.Vector2{
        .x = self.position.x + (self.vertices[0].x - 400) * std.math.cos(self.rotation) - (self.vertices[0].y - 300) * std.math.sin(self.rotation),
        .y = self.position.y + (self.vertices[0].x - 400) * std.math.sin(self.rotation) + (self.vertices[0].y - 300) * std.math.cos(self.rotation),
    };
    const p2 = rl.Vector2{
        .x = self.position.x + (self.vertices[1].x - 400) * std.math.cos(self.rotation) - (self.vertices[1].y - 300) * std.math.sin(self.rotation),
        .y = self.position.y + (self.vertices[1].x - 400) * std.math.sin(self.rotation) + (self.vertices[1].y - 300) * std.math.cos(self.rotation),
    };
    const p3 = rl.Vector2{
        .x = self.position.x + (self.vertices[2].x - 400) * std.math.cos(self.rotation) - (self.vertices[2].y - 300) * std.math.sin(self.rotation),
        .y = self.position.y + (self.vertices[2].x - 400) * std.math.sin(self.rotation) + (self.vertices[2].y - 300) * std.math.cos(self.rotation),
    };

    rl.drawLine(p1, p2, self.color);
    rl.drawLine(p2, p3, self.color);
    rl.drawLine(p3, p1, self.color);
}

pub fn spawnAsteroid() Asteroid {
    const x = std.randfloat(f32) * 800;
    const y = std.randfloat(f32) * 600;

    return init(x, y);
}

// TOdo with Lasers
pub fn checkCollision() bool {}
