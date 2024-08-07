const rl = @import("raylib");
const std = @import("std");

pub const Laser = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    active: bool,
    color: rl.Color,
    length: rl.Vector2,

    pub fn init(position: rl.Vector2, velocity: rl.Vector2) Laser {
        const speed = @sqrt(velocity.x * velocity.x + velocity.y * velocity.y);
        const length = rl.Vector2{
            .x = velocity.x / speed * 20, // Adjust 20 to change laser length
            .y = velocity.y / speed * 20,
        };
        return Laser{
            .position = position,
            .velocity = velocity,
            .length = length,
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

    pub fn draw(self: *const Laser) void {
        if (self.active) {
            const end_position = rl.Vector2{
                .x = self.position.x + self.length.x,
                .y = self.position.y + self.length.y,
            };
            rl.drawLineV(self.position, end_position, self.color);
        }
    }
};
