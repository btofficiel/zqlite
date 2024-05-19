const std = @import("std");

pub const Token = enum {
    @".exit",
    SELECT,
    INSERT,
    UNKNOWN,
};
