const std = @import("std");
const heap = std.heap;
const mem = std.mem;
const fs = std.fs;
const io = std.Io;

fn checkSum2020(a: i32, b: i32) bool {
    return a + b == 2020;
}

fn readInput(allocator: mem.Allocator) ![]i32 {

    // open/ close file so we can read the content
    const file = try fs.cwd().openFile("input.txt", .{});
    defer file.close();

    // getting the exact size of the file
    const file_size = try file.getEndPos();
    const content = try allocator.alloc(u8, file_size);
    defer allocator.free(content);

    // has to be var because the reader changes state (see reader.read())
    var reader = file.reader(&.{});
    _ = try reader.read(content);

    var records = std.array_list.Aligned(i32, null).empty;
    var lines = std.mem.splitScalar(u8, content, '\n');

    while (lines.next()) |line| {
        try records.append(allocator, try std.fmt.parseInt(i32, line, 10));
    }

    return try records.toOwnedSlice(allocator);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const entries = try readInput(allocator);
    defer allocator.free(entries);

    for (entries, 0..) |first, i| {
        for (entries, i + 1..) |second, j| {
            for (entries, j + 1..) |third, k| {
                if (checkSum2020(first, second + third)) {
                    std.debug.print("Found entries at {d}, {d} and {d}: {d} + {d} + {d} = 2020\n", .{ i, j, k, first, second, third });
                    std.debug.print("The product is: {d}\n", .{first * second * third});
                }
            }
        }
    }
}
