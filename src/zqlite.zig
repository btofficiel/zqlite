const std = @import("std");
const utils = struct {
    usingnamespace @import("utils/repl.zig");
};
const compiler = struct {
    usingnamespace @import("compiler/parser.zig");
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    defer (std.debug.print("Memory leak", .{}));
    const inputBuffer = try utils.newInputBuffer(&allocator);
    const declaration = "ZQLite - A minimal SQLite implentation in Zig\n";
    try utils.printOutput(declaration);
    while (true) {
        const prompt = "db > ";
        try utils.printOutput(prompt);
        try utils.readInput(inputBuffer);
        if (inputBuffer.input) |input| {
            const tokens = try compiler.tokenize(&allocator, input);
            std.debug.print("tokens {any}", .{tokens});
            if (std.mem.eql(u8, input[0..inputBuffer.input_length], ".exit")) {
                std.process.exit(0);
            } else {
                std.debug.print("Unrecognised command \n", .{});
            }
        }
    }
}
