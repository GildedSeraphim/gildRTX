const std = @import("std");
const Progress = std.Progress;

const height = 256;
const width = 256;

pub fn main() !void {
    const out = std.io.getStdOut().writer();

    var pbuf: [1024]u8 = undefined;
    const pr = Progress.start(.{
        .draw_buffer = &pbuf,
        .estimated_total_items = height * width,
        .root_name = "raytracer",
    });
    defer pr.end();

    try out.print("P3\n {d} {d} \n255\n", .{ width, height });

    for (0..height) |h| {
        for (0..width) |w| {
            const fh: f32 = @floatFromInt(h);
            const fw: f32 = @floatFromInt(w);

            const r: u8 = @intFromFloat(255.99 * (fh / (height - 1.0)));
            const g: u8 = @intFromFloat(255.99 * (fw / (width - 1.0)));
            const b: u8 = 0;

            try out.print("{d} {d: >3} {d}\n", .{ r, g, b });
        }
    }
}
