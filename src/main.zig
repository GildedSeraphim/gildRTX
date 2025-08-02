const std = @import("std");
const Progress = std.Progress;

const width = 256;
const height = 256;

pub fn main() !void {
    var wbuf: [4096]u8 = undefined;
    var file_writer = std.fs.File.stdout().writer(&wbuf);
    const out = &file_writer.interface;

    var pbuf: [1024]u8 = undefined;
    const pr = Progress.start(.{
        .draw_buffer = &pbuf,
        .estimated_total_items = width * height,
        .root_name = "raytracing",
    });
    defer pr.end();

    try out.print("P3\n{d} {d}\n255\n", .{ width, height });

    for (0..height) |h| {
        for (0..width) |w| {
            const fh: f32 = @floatFromInt(h);
            const fw: f32 = @floatFromInt(w);

            const r: u8 = @intFromFloat(255.99 * (fh / (height - 1.0)));
            const g: u8 = @intFromFloat(255.99 * (fw / (width - 1.0)));
            const b: u8 = 0;

            try out.print("{d} {d} {d}\n", .{ r, g, b });
        }
    }
    try out.flush();
}
