const std = @import("std");

pub fn main() anyerror!void {
    while (true) {
        std.debug.print("Enter an expression: ", .{});
        var input = std.io.getStdIn().reader();
        var buffer: [1024]u8 = undefined;
        _ = input.readUntilDelimiterOrEof(&buffer, '\n') catch |err| {
            std.debug.print("Error reading input: {}\n", .{err});
            continue;
        };
        var expression = buffer[0 .. buffer.len - 1];

        var num1: f64 = undefined;
        var op: u8 = undefined;
        var num2: f64 = undefined;
        var found_op = false;
        var i: usize = 0;

        while (i < expression.len) : (i += 1) {
            if (expression[i] >= '0' and expression[i] <= '9') {
                if (found_op) {
                    var j: usize = i;
                    while (j < expression.len and expression[j] >= '0' and expression[j] <= '9') : (j += 1) {}
                    num2 = std.fmt.parseFloat(f64, expression[i..j]) catch unreachable;
                    i = j - 1;
                } else {
                    var j: usize = i;
                    while (j < expression.len and expression[j] >= '0' and expression[j] <= '9') : (j += 1) {}
                    num1 = std.fmt.parseFloat(f64, expression[i..j]) catch unreachable;
                    i = j - 1;
                }
            } else if (expression[i] == '+' or expression[i] == '-' or expression[i] == '*' or expression[i] == '/') {
                op = expression[i];
                found_op = true;
            }
        }

        var result: f64 = undefined;
        switch (op) {
            '+' => result = num1 + num2,
            '-' => result = num1 - num2,
            '*' => result = num1 * num2,
            '/' => {
                if (num2 == 0) {
                    std.debug.print("Error: Division by zero\n", .{});
                    continue;
                }
                result = num1 / num2;
            },
            else => {
                std.debug.print("Error: Invalid operator\n", .{});
                continue;
            },
        }

        std.debug.print("Result: {}\n", .{result});
    }
}
