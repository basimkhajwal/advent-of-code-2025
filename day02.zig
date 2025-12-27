const std = @import("std");

const int_set = std.AutoHashMap(i64, void);

fn doubles_in_range(set: *int_set, start: i64, end: i64) !void {
    var base: u32 = 1;
    while (true) {
        const num_digits = std.math.log10_int(base) + 1;
        const pow = try std.math.powi(i64, 10, num_digits);
        const n = pow * base + base;
        if (n > end) break;
        if (n >= start) try set.put(n, {});
        base += 1;
    }
}

fn repeats_in_range(set: *int_set, start: i64, end: i64) !void {
    var base: u32 = 1;

    while (true) {
        const num_digits = std.math.log10_int(base) + 1;
        const pow = try std.math.powi(i64, 10, num_digits);

        var n = pow * base + base;
        if (n > end) break;

        while (n <= end) {
            if (n >= start) try set.put(n, {});
            n = n * pow + base;
        }
        base += 1;
    }
}

fn sum_set(set: int_set) !i64 {
    var total: i64 = 0;
    var iter = set.iterator();
    while (iter.next()) |entry| total += entry.key_ptr.*;
    return total;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input/input02.txt", .{});

    const content = try file.readToEndAlloc(allocator, 1e5);

    var part1_set = int_set.init(allocator);
    var part2_set = int_set.init(allocator);

    var ranges = std.mem.splitScalar(u8, content, ',');
    while (ranges.next()) |range| {
        var bounds = std.mem.splitScalar(u8, range, '-');
        const start = bounds.next() orelse continue;
        const end = bounds.next() orelse continue;
        const start_num = try std.fmt.parseInt(i64, start, 10);
        const end_num = try std.fmt.parseInt(i64, end, 10);
        try doubles_in_range(&part1_set, start_num, end_num);
        try repeats_in_range(&part2_set, start_num, end_num);
    }

    const part1 = try sum_set(part1_set);
    const part2 = try sum_set(part2_set);

    std.debug.print("Part 1: {d}\n", .{part1});
    std.debug.print("Part 2: {d}\n", .{part2});
}
