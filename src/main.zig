const std = @import("std");
const Writer = std.io.Writer;
const Progress = std.Progress;

const vec = @import("vec3.zig");
const Vec3 = vec.Vec3;
const Ray = @import("ray.zig");

const aspect_ratio = 16.0 / 9.0;
const width = 400;
const height = blk: {
    const h: comptime_int = @intFromFloat((width - 0.0) / aspect_ratio);

    if (h < 1) break :blk 1;
    break :blk h;
};

const focal_length = 1.0;
const viewport_height = 2.0;
const viewport_width = viewport_height * (width + 0.0) / (height - 0.0);
const camera_center: Vec3 = vec.zero;

const viewport_u: Vec3 = .{ viewport_width, 0, 0 };
const viewport_v: Vec3 = .{ 0, -viewport_height, 0 };

const pixel_delta_u = viewport_u / vec.splat(width);
const pixel_delta_v = viewport_v / vec.splat(height);

const viewport_upper_left: Vec3 = blk: {
    const vu_half = viewport_u / vec.splat(2);
    const vv_half = viewport_v / vec.splat(2);
    const foc_len: Vec3 = .{ 0, 0, focal_length };
    break :blk camera_center - foc_len - vu_half - vv_half;
};
const pixel00_loc = viewport_upper_left + vec.splat(0.5) * (pixel_delta_u + pixel_delta_v);

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
            const pixel_center = pixel00_loc + (vec.splat(w) * pixel_delta_u) + (vec.splat(h) * pixel_delta_v);

            const ray_direction = pixel_center - camera_center;
            const r: Ray = .init(camera_center, ray_direction);

            const pixel: Vec3 = ray_color(r);

            try out.print("{f}", .{vec.color{ .data = pixel }});
        }
    }
    try out.flush();
}

fn hit_sphere(center: Vec3, radius: f64, r: Ray) bool {
    const oc: Vec3 = center - r.origin;
    const a = vec.dot(r.dir, r.dir);
    const b = -2.0 * vec.dot(r.dir, oc);
    const c = vec.dot(oc, oc) - radius * radius;
    const discriminant = b * b - 4 * a * c;
    return discriminant >= 0;
}

fn ray_color(r: Ray) Vec3 {
    if (hit_sphere(.{ 0, 0, -1 }, 0.5, r)) {
        return .{ 1, 0, 0 };
    }

    const dir = vec.unit_vector(r.dir);
    const a = 0.5 * (vec.y(dir) + 1.0);
    const wat: Vec3 = .{ 0.5, 0.7, 1.0 };
    return vec.splat(1.0 - a) * vec.one + vec.splat(a) * wat;
}

// Timestamp : 2.28.46
