const std = @import("std");
const lib = @import("dice_roller_lib");

//const dice_to_roll: [6]i32 = .{20,12,10,8,6,4};

pub fn main() !void {
    // set up gpa allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // getting the args
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // setting up random
    var prng = std.Random.DefaultPrng.init(random_seed: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :random_seed seed;
    });
    const rand = prng.random();

    var total: i32 = 0;
    // loop over all the dice and add the value to the total
    for (args) |arg| {
        const type_of_dice = std.fmt.parseInt(i32, arg, 10) catch 0;
        if (type_of_dice != 0) {
            const value = rand.intRangeAtMost(i32, 1, type_of_dice);
            std.debug.print("d{d}: {d}\n", .{type_of_dice, value});
            total += value;
        }
    }
    std.debug.print("total: {d}\n", .{total});
}
