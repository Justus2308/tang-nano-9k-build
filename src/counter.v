module top
    (
        input clk,
        output [5:0] led
    );

    localparam WAIT_TIME = 13500000;
    logic [5:0] led_counter = 0;
    logic [23:0] clock_counter = 0;

    always @(posedge clk) begin
        clock_counter <= clock_counter + 1;
        if (clock_counter == WAIT_TIME) begin
            clock_counter <= 0;
            led_counter <= led_counter + 1;
        end
    end

    assign led = ~led_counter;
endmodule
