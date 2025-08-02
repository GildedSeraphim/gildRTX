const std = @import("std");

pub const Vec3 = @Vector(3, f64);

pub const zero: Vec3 = .{ 0, 0, 0 };

pub fn x(v: Vec3) f64 {
    return v[0];
}
pub fn y(v: Vec3) f64 {
    return v[1];
}
pub fn z(v: Vec3) f64 {
    return v[2];
}

pub fn magnitude(v: Vec3) f64 {
    return @sqrt(@reduce(.Add, v * v));
}

pub const fmt = std.fmt.Alt(Vec3, format);
pub fn format(w: *Writer, v: Vec3) void {
    w.print("{d} {d} {d}", .{ v[0], v[1], v[2] });
}

pub fn dot(lhs: Vec3, rhs: Vec3) f64 {
    return @reduce(.Add, lhs * rhs);
}

pub fn cross(lhs: Vec3, rhs: Vec3) Vec3 {
    return .{
        lhs[1] * rhs[2] - lhs[2] * rhs[1],
        lhs[2] * rhs[0] - lhs[0] * rhs[2],
        lhs[0] * rhs[1] - lhs[1] * rhs[0],
    };
}

pub fn unit_vector(v: Vec3) Vec3 {
    const mag: Vec3 = @splat(magnitude(v));
    if (mag == zero) {
        return zero;
    }
    return v / mag;
}
