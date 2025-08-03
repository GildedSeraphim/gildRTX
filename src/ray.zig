const std = @import("std");
const vec = @import("vec3.zig");
const Vec3 = vec.Vec3;

const Ray = @This();

origin: Vec3,
dir: Vec3,

pub fn init(origin: Vec3, dir: Vec3) Ray {
    return .{
        .origin = origin,
        .dir = dir,
    };
}

pub fn at(r: Ray, t: f64) Vec3 {
    return @mulAdd(Vec3, r.origin, r.dir, @splat(t));
}
