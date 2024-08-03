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
    damping: f32,
    lasers: [100]Laser,
    laser_count: usize,

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
            .acceleration = 300,
            .rotation_speed = 100,
            .rotation = 0,
            .damping = 0.98,
            .lasers = undefined,
            .laser_count = 0,
        };
    }

    pub fn shoot(self: *Ship) void {
        if (self.laser_count > self.lasers.len) return;
        const radians_rotation = self.rotation * std.math.pi / 180;

        const laser_velocity = rl.Vector2{
            .x = @sin(radians_rotation) * 500,
            .y = @cos(radians_rotation) * 500,
        };

        self.lasers[self.laser_count] = Laser.init(self.position, laser_velocity);
        self.laser_count += 1;
    }

    pub fn update(self: *Ship) void {
        const delta_time = rl.getFrameTime();
        const radians_rotation = self.rotation * std.math.pi / 180;

        // Rotate counter-clockwise
        if (rl.isKeyDown(.key_a)) {
            self.rotation -= self.rotation_speed * delta_time;
        }

        // Rotate clockwise
        if (rl.isKeyDown(.key_d)) {
            self.rotation += self.rotation_speed * delta_time;
        }

        // Speed up
        if (rl.isKeyDown(.key_w)) {
            const thrust_x = @sin(radians_rotation) * self.acceleration * delta_time;
            const thrust_y = -@cos(radians_rotation) * self.acceleration * delta_time;
            self.velocity.x += thrust_x;
            self.velocity.y += thrust_y;
        }

        // Slow Down
        if (rl.isKeyDown(.key_s)) {
            const thrust_x = @sin(radians_rotation) * self.acceleration * delta_time;
            const thrust_y = -@cos(radians_rotation) * self.acceleration * delta_time;
            self.velocity.x -= thrust_x;
            self.velocity.y -= thrust_y;
        }

        self.velocity.x *= self.damping;
        self.velocity.y *= self.damping;

        self.position.x += self.velocity.x * delta_time;
        self.position.y += self.velocity.y * delta_time;

        // Laser Shooting
        if (rl.isKeyDown(.key_space)) {
            self.shoot;
        }

        var i = 0;
        while (i < self.laser_count) : (i += 1) {
            if (self.lasers[i].active) {
                self.lasers[i].update();
            } else {
                self.lasers[i] = self.lasers[self.laser_count - 1];
                self.laser_count -= 1;
                i -= 1;
            }
        }
    }

    pub fn draw(self: Ship) void {
        const cos_rotation = @cos(self.rotation * std.math.pi / 180);
        const sin_rotation = @sin(self.rotation * std.math.pi / 180);

        const p1 = rl.Vector2{
            .x = self.position.x + (self.vertices[0].x - 400.0) * cos_rotation - (self.vertices[0].y - 300.0) * sin_rotation,
            .y = self.position.y + (self.vertices[0].x - 400.0) * sin_rotation + (self.vertices[0].y - 300.0) * cos_rotation,
        };
        const p2 = rl.Vector2{
            .x = self.position.x + (self.vertices[1].x - 400.0) * cos_rotation - (self.vertices[1].y - 300.0) * sin_rotation,
            .y = self.position.y + (self.vertices[1].x - 400.0) * sin_rotation + (self.vertices[1].y - 300.0) * cos_rotation,
        };
        const p3 = rl.Vector2{
            .x = self.position.x + (self.vertices[2].x - 400.0) * cos_rotation - (self.vertices[2].y - 300.0) * sin_rotation,
            .y = self.position.y + (self.vertices[2].x - 400.0) * sin_rotation + (self.vertices[2].y - 300.0) * cos_rotation,
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

        for (i = 0; i < self.laser_count; i += 1) {
            self.lasers[i].draw();
        }
    }
};

pub const Laser = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    active: bool,
    color: rl.Color,

    pub fn init(position: rl.Vector2, velocity: rl.Vector2) Laser {
        return Laser{
            .position = position,
            .velocity = velocity,
            .active = true,
            .color = rl.Color.white,
        };
    }

    pub fn update(self: *Laser) void {
        self.position.x += self.velocity.x;
        self.position.y += self.velocity.y;

        if (self.position.x < 0 or self.position.x > 800 or self.position.y < 0 or self.position.y > 600) {
            self.active = false;
        }
    }

    pub fn draw(self: *Laser) void {
        if (self.active) {
            rl.drawPixel(self.position.x, self.position.y, self.color);
        }
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

// TODO: ADD SHOOTING FROM SHIP

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
