const std = @import("std");
const Allocator = std.mem.Allocator;

pub const InputBuffer = struct { input: ?[]u8 = null, input_length: usize = 0, buffer_length: usize = 1024 };

pub fn newInputBuffer(allocator: *Allocator) !*InputBuffer {
    const instance = try allocator.create(InputBuffer);
    instance.* = InputBuffer{};
    instance.input = try allocator.alloc(u8, 100);
    return instance;
}

pub fn printOutput(output: []const u8) !void {
    const out = std.io.getStdOut().writer();
    var buf = std.io.bufferedWriter(out);
    var writer = buf.writer();
    try writer.print("{s}", .{output});
    try buf.flush();
}

pub fn readInput(inputBuffer: *InputBuffer) !void {
    const in = std.io.getStdIn().reader();
    var buf_reader = std.io.bufferedReader(in);
    var reader = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    const input = try reader.readUntilDelimiterOrEof(&buf, '\n');
    if (input) |line| {
        std.mem.copyForwards(u8, inputBuffer.input.?, line);
        inputBuffer.input_length = line.len;
    } else {
        std.debug.print("Error occured while taking input", .{});
        std.process.exit(1);
    }
}
