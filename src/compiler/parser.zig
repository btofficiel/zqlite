const std = @import("std");
const Allocator = std.mem.Allocator;
const token = @import("./token.zig");
const InputBuffer = @import("../utils/repl.zig").InputBuffer;

pub const ParserAtom = struct {
    token: token.Token,
    value: ?[]const u8,
};

pub fn tokenize(allocator: *Allocator, input: []const u8) ![]ParserAtom {
    var tokens = try allocator.alloc(ParserAtom, 1024);
    var token_count: usize = 0;
    var current_read_word = try allocator.alloc(u8, 1024);
    defer allocator.free(current_read_word);

    var word_index: usize = 0;

    for (input) |char| {
        if (char == ' ' or char == '\n') {
            if (word_index > 0) {
                const string_to_enum = std.meta.stringToEnum(token.Token, current_read_word[0..word_index]) orelse token.Token.IDENTIFIER; // TODO: everthing else is not an identifier learn rules of identifier and accordingly implement.
                if (string_to_enum == token.Token.IDENTIFIER) {
                    const token_value = try allocator.alloc(u8, word_index);
                    std.mem.copyForwards(u8, token_value, current_read_word[0..word_index]);
                    tokens[token_count] = ParserAtom{ .token = string_to_enum, .value = token_value };
                } else {
                    tokens[token_count] = ParserAtom{ .token = string_to_enum, .value = null };
                }
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
        const string_to_enum = std.meta.stringToEnum(token.Token, current_read_word[0..word_index]) orelse token.Token.IDENTIFIER; // TODO: everthing else is not an identifier learn rules of identifier and accordingly implement.
        if (string_to_enum == token.Token.IDENTIFIER) {
            const token_value = try allocator.alloc(u8, word_index);
            std.mem.copyForwards(u8, token_value, current_read_word[0..word_index]);
            tokens[token_count] = ParserAtom{ .token = string_to_enum, .value = token_value };
        } else {
            tokens[token_count] = ParserAtom{ .token = string_to_enum, .value = null };
        }
        token_count += 1;
    }

    std.debug.print("current read word: {s}\n", .{current_read_word[0..word_index]});
    return tokens[0..token_count];
}
