const rl = @import("raylib");
const std = @import("std");

const Ship = @import("ship.zig");
const Asteroid = @import("asteroid.zig");

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 600;
    rl.initWindow(screenWidth, screenHeight, "Zig Asteroids");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    var ship = Ship.init();
    const asteroids = [_]Asteroid{ Asteroid.spawnAsteroid(), Asteroid.spawnAsteroid(), Asteroid.spawnAsteroid() };

    while (!rl.windowShouldClose()) {
        Ship.update(&ship);

        for (asteroids) |*asteroid| {
            if (asteroid.active) {
                asteroid.update();
            }
        }

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);
        Ship.draw(&ship);

        for (asteroids) |*asteroid| {
            if (asteroid.active) {
                asteroid.draw();
            }
        }
    }
}
