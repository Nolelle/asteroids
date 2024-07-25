const rl = @import("raylib");

pub const Ship = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    scale: f32,
    rotation: f32,
    color: rl.Color,
    vertices: [3]rl.Vector2,
    acceleration: f32,
    rotation_speed: f32,

    pub fn init() Ship {
        return .{
            .position = rl.Vector2.init(300.0, 200.0),
            .velocity = rl.Vector2.init(0.0, 0.0),
            .scale = 1.0,
            .color = rl.Color.black,
            .vertices = [3]rl.Vector2{
                rl.Vector2{ .x = 400.0, .y = 200.0 },
                rl.Vector2{ .x = 385.0, .y = 225.0 },
                rl.Vector2{ .x = 415.0, .y = 225.0 },
            },
        };
    }
    // ToDO
    pub fn update() void {}
};

pub const Asteroid = struct {
    vertices: [3]rl.Vector2,
    position: rl.Vector2,
    velocity: rl.Vector2,
    rotation: f32,
    scale: f32,
    color: rl.Color,
};

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 600;
    rl.initWindow(screenWidth, screenHeight, "Zig Asteroids");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var ship = Ship{};

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);

        rl.drawTriangle(ship.vertices[0], ship.vertices[1], ship.vertices[2], ship.color);
    }
}
