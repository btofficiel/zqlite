const std = @import("std");

const compiler = struct {
    usingnamespace @import("../compiler/parser.zig");
};

test "parsing" {
    const source = "SELECT * FROM table";
    const result = compiler.parse(source);
    std.testing.expect(result.len, 4);
}
