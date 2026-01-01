const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var part1: usize = 0;
    var part2: usize = 0;

    const file = try std.fs.cwd().openFile("input/input03.txt", .{});
    const content = try file.readToEndAlloc(allocator, 1e5);

    var linesIter = std.mem.splitScalar(u8, content, '\n');
    while (linesIter.next()) |line| {
        const n = line.len;
        const digits = blk: {
            var digits = try std.ArrayList(usize).initCapacity(allocator, n);
            try digits.resize(allocator, n);
            for (0..n) |i| digits.items[i] = line[i] - '0';
            break :blk digits.items;
        };

        const m = 13;

        // dp[i][k] = biggest num from [i..n] using k digits
        var dp = blk: {
            var dp = try std.ArrayList([]usize).initCapacity(allocator, n + 1);
            try dp.resize(allocator, n + 1);
            for (0..n + 1) |i| {
                var row = try std.ArrayList(usize).initCapacity(allocator, m);
                try row.resize(allocator, m);
                for (0..m) |k| row.items[k] = 0;
                dp.items[i] = row.items;
            }
            break :blk dp.items;
        };

        var i = n;
        while (i > 0) {
            i -= 1;
            for (1..@min(m, n - i + 1)) |k| {
                const x = digits[i] * try std.math.powi(usize, 10, k - 1);
                dp[i][k] = @max(dp[i + 1][k], x + dp[i + 1][k - 1]);
            }
        }

        part1 += dp[0][2];
        part2 += dp[0][12];
    }

    std.debug.print("Part 1: {}\n", .{part1});
    std.debug.print("Part 2: {}\n", .{part2});
}
