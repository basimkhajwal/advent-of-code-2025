const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input/input01.txt", .{});
    defer file.close();

    const content = try file.readToEndAlloc(allocator, 1e5);
    defer allocator.free(content);

    var lines = std.mem.splitScalar(u8, content, '\n');
    var loc: i32 = 50;
    var part1: i32 = 0;
    var part2: i32 = 0;
    while (lines.next()) |line| {
        const dir: i32 = if (line[0] == 'L') -1 else 1;
        const amt = try std.fmt.parseInt(i32, line[1..], 10);
        if (dir > 0) {
            part2 += @divFloor(amt + loc, 100);
        } else {
            part2 += @divFloor(amt + @mod(100 - loc, 100), 100);
        }
        loc = @mod(100 + @mod(loc + dir * amt, 100), 100);
        if (loc == 0) {
            part1 += 1;
        }
    }
    std.debug.print("Part 1: {d}\n", .{part1});
    std.debug.print("Part 2: {d}\n", .{part2});
}
