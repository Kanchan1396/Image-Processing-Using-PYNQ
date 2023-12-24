module sharpen_conv(
    input         i_clk,
    input [71:0]  i_pixel_data,
    input         i_pixel_data_valid,
    output reg [7:0] o_convolved_data,
    output reg   o_convolved_data_valid
);

integer i; 
reg [7:0] kernel [8:0];
reg [15:0] multData[8:0];
reg [15:0] sumDataInt;
reg [15:0] sumData;
reg multDataValid;
reg sumDataValid;
reg convolved_data_valid;

initial
begin
    // 3x3 Gaussian filter kernel
    kernel[0] = 0;
    kernel[1] = -1;
    kernel[2] = 0;
    kernel[3] = -1;
    kernel[4] = 5;
    kernel[5] = -1;
    kernel[6] = 0;
    kernel[7] = -1;
    kernel[8] = 0;
end    

always @(posedge i_clk)
begin
    for(i=0; i<9; i=i+1)
    multData[i] <= $signed(kernel[i])*$signed({1'b0,i_pixel_data[i*8+:8]});
    multDataValid <= i_pixel_data_valid;
end

always @(*)
begin
    sumDataInt = 0;
    for(i=0; i<9; i=i+1)
        sumDataInt = $signed(sumDataInt) + $signed(multData[i]);
end

always @(posedge i_clk)
begin
    sumData <= sumDataInt;
    sumDataValid <= multDataValid;
end

always @(posedge i_clk)
begin
    o_convolved_data <= sumData; // Divide by 16 (sum of the Gaussian kernel values)
    o_convolved_data_valid <= sumDataValid;
end

endmodule
