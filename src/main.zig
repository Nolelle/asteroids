const rl = @import("raylib");
const std = @import("std");

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
        const center_x = 400.0;
        const center_y = 300.0;
        const size = 15.0;

        return .{
            .position = rl.Vector2.init(400.0, 300.0),
            .velocity = rl.Vector2.init(0.0, 0.0),
            .scale = 1.0,
            .color = rl.Color.white,
            .vertices = [3]rl.Vector2{
                rl.Vector2{ .x = center_x, .y = center_y - size },
                rl.Vector2{ .x = center_x - size * 0.866, .y = center_y + size * 0.5 },
                rl.Vector2{ .x = center_x + size * 0.866, .y = center_y + size * 0.5 },
            },
            .acceleration = 200,
            .rotation_speed = 10,
            .rotation = 0,
        };
    }

    pub fn update(self: *Ship) void {
        const delta_time = rl.getFrameTime();

        // Rotate left
        if (rl.isKeyDown(.key_a)) {
            self.rotation -= self.rotation_speed * delta_time;
        }

        // Rotate right
        if (rl.isKeyDown(.key_d)) {
            self.rotation += self.rotation_speed * delta_time;
        }

        // Speed up
        if (rl.isKeyDown(.key_w)) {
            const thrust_x = @cos(self.rotation) * self.acceleration * delta_time;
            const thrust_y = @sin(self.rotation) * self.acceleration * delta_time;
            self.velocity.x += thrust_x;
            self.velocity.y += thrust_y;
        }

        // Slow Down
        if (rl.isKeyDown(.key_d)) {
            const thrust_x = @cos(self.rotation) * self.acceleration * delta_time;
            const thrust_y = @sin(self.rotation) * self.acceleration * delta_time;
            self.velocity.x -= thrust_x;
            self.velocity.y -= thrust_y;
        }

        self.position.x += self.velocity.x * delta_time;
        self.position.y += self.velocity.y * delta_time;
    }

    pub fn draw(self: Ship) void {
        const cos_rot = @cos(self.rotation * std.math.pi / 180);
        const sin_rot = @sin(self.rotation * std.math.pi / 180);

        const p1 = rl.Vector2{
            .x = self.position.x + (self.vertices[0].x - 400.0) * cos_rot - (self.vertices[0].y - 300.0) * sin_rot,
            .y = self.position.y + (self.vertices[0].x - 400.0) * sin_rot + (self.vertices[0].y - 300.0) * cos_rot,
        };
        const p2 = rl.Vector2{
            .x = self.position.x + (self.vertices[1].x - 400.0) * cos_rot - (self.vertices[1].y - 300.0) * sin_rot,
            .y = self.position.y + (self.vertices[1].x - 400.0) * sin_rot + (self.vertices[1].y - 300.0) * cos_rot,
        };
        const p3 = rl.Vector2{
            .x = self.position.x + (self.vertices[2].x - 400.0) * cos_rot - (self.vertices[2].y - 300.0) * sin_rot,
            .y = self.position.y + (self.vertices[2].x - 400.0) * sin_rot + (self.vertices[2].y - 300.0) * cos_rot,
        };

        const extension_length = 10.0;
        const p2_extension = rl.Vector2{
            .x = p1.x + (p2.x - p1.x) * (1 + extension_length / std.math.sqrt((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y))),
            .y = p1.y + (p2.y - p1.y) * (1 + extension_length / std.math.sqrt((p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y))),
        };
        const p3_extension = rl.Vector2{
            .x = p1.x + (p3.x - p1.x) * (1 + extension_length / std.math.sqrt((p3.x - p1.x) * (p3.x - p1.x) + (p3.y - p1.y) * (p3.y - p1.y))),
            .y = p1.y + (p3.y - p1.y) * (1 + extension_length / std.math.sqrt((p3.x - p1.x) * (p3.x - p1.x) + (p3.y - p1.y) * (p3.y - p1.y))),
        };

        // Draw the outline of the triangle with extended lines
        rl.drawLineV(p1, p2_extension, self.color);
        rl.drawLineV(p2, p3, self.color);
        rl.drawLineV(p3, p1, self.color);
        rl.drawLineV(p1, p3_extension, self.color);
    }
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

    var ship: Ship = Ship.init();

    while (!rl.windowShouldClose()) {
        ship.update();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        ship.draw();
    }
}
