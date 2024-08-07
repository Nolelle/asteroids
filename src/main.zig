const rl = @import("raylib");
const std = @import("std");

const Ship = @import("ship.zig");

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 600;
    rl.initWindow(screenWidth, screenHeight, "Zig Asteroids");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var ship = Ship.init();

    while (!rl.windowShouldClose()) {
        Ship.update(&ship);

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        Ship.draw(&ship);
    }
}
