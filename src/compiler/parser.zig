const std = @import("std");
const token = @import("./token.zig");

pub fn tokenize(input: []const u8) ![]token.Token {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    var tokens = try allocator.alloc(token.Token, 1024);

    var token_count: usize = 0;
    var current_read_word = try allocator.alloc(u8, 1024);
    defer allocator.free(current_read_word);

    var word_index: usize = 0;

    for (input) |char| {
        std.debug.print("reading {any}\n", .{char});
        if (char == ' ' or char == '\n') {
            if (word_index > 0) {
                std.debug.print("encountered end\n", .{});
                const string_to_enum = std.meta.stringToEnum(token.Token, current_read_word[0..word_index]) orelse token.Token.UNKNOWN;
                tokens[token_count] = string_to_enum;
                token_count += 1;
                word_index = 0; // Reset the word index for the next word
            }
        } else {
            current_read_word[word_index] = char;
            word_index += 1;
        }
    }

    // Handle the last word if there is no trailing space or newline
    if (word_index > 0) {
        const string_to_enum = std.meta.stringToEnum(token.Token, current_read_word[0..word_index]) orelse token.Token.UNKNOWN;
        tokens[token_count] = string_to_enum;
        token_count += 1;
    }

    std.debug.print("current read word: {s}\n", .{current_read_word[0..word_index]});

    return tokens[0..token_count];
}
