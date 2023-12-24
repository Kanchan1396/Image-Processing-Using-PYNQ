module box_blur_conv(
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
    kernel[0] = 1;
    kernel[1] = 1;
    kernel[2] = 1;
    kernel[3] = 1;
    kernel[4] = 1;
    kernel[5] = 1;
    kernel[6] = 1;
    kernel[7] = 1;
    kernel[8] = 1;
end    

always @(posedge i_clk)
begin
    for(i=0; i<9; i=i+1)
        multData[i] <= kernel[i] * i_pixel_data[i*8 +: 8];
    multDataValid <= i_pixel_data_valid;
end

always @(*)
begin
    sumDataInt = 0;
    for(i=0; i<9; i=i+1)
        sumDataInt = sumDataInt + multData[i];
end

always @(posedge i_clk)
begin
    sumData <= sumDataInt;
    sumDataValid <= multDataValid;
end

always @(posedge i_clk)
begin
    o_convolved_data <= sumData/9; // Divide by 16 (sum of the Gaussian kernel values)
    o_convolved_data_valid <= sumDataValid;
end

endmodule
