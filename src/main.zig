// raylib-zig (c) Nikolas Wipper 2023

const rl = @import("raylib");

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 600;
    rl.initWindow(screenWidth, screenHeight, "Zig Asteroids");
    defer rl.closeWindow(); // Close window and OpenGL context called when main ends.
    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);

        const v1 = rl.Vector2{ .x = 400.0, .y = 200.0 };
        const v2 = rl.Vector2{ .x = 385.0, .y = 225.0 };
        const v3 = rl.Vector2{ .x = 415.0, .y = 225.0 };

        rl.drawTriangle(v1, v2, v3, rl.Color.black);
    }
}
