const rl = @import("raylib");
const std = @import("std");

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
