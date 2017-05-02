// multi.sv

module mult (
  input [31:0]      a_in,b_in,
  input             reset,
  input             clk,
  input             start,
  output      logic done,
  output      logic [63:0] product );

  //wires
  wire       [31:0] reg_a;            //reg a output 
  logic      [31:0] addout;           //addr output
  logic      [31:0] prod_reg_high_in; //reg high input
  logic      [31:0] prod_reg_high;    //high 32 of out reg
  wire       [31:0] prod_reg_low;     //low 32 of out reg
  wire       [31:0] reg_a_out;        //output of in_a reg
  wire              prod_reg_high_ld; //high 32 load enable
  wire              prod_reg_shift;   //output reg shift en

  //register
  
  mult_reg #(. width (32)) mult_reg_a (
    . reset_n    ( reset ),
    . clk        ( clk   ),
    . enable     ( start ),
    . din        ( a_in  ),
    . dout       ( reg_a ));
  
  
  mult_shift_reg #(. width (32)) mult_reg_low (
    . reset_n    ( reset            ),
    . clk        ( clk              ),
    . enable     ( start            ),
    .shift       ( prod_reg_shift   ),
    .shift_in    ( prod_reg_high[0] ),
    . din        ( b_in             ),
    . dout       ( prod_reg_low     ));  
  
  
   mult_shift_reg #(. width (32)) mult_reg_high (
    . reset_n    ( reset            ),
    . clk        ( clk              ),
    . enable     ( prod_reg_high_ld ),
    .shift       ( prod_reg_shift   ),
    .shift_in    ( 0                ),
    . din        ( prod_reg_high_in ),
    . dout       ( prod_reg_high    ));  
  

    
  always_comb begin
    assign addout = reg_a + prod_reg_high;
    if (start) prod_reg_high_in = 32'b0;
    else prod_reg_high_in = addout;
  end
  
  always_ff @(posedge clk) begin
    product[63:32] <= prod_reg_high;
    product[31:0]  <= prod_reg_low;
  end
  
  
mult_ctl mutl_ctl_0(
  .reset_n          (reset            ),
  .clk              (clk              ),
  .start            (start            ),
  .prod_reg_LSB     (prod_reg_low[0]  ),
  .prod_reg_high_ld (prod_reg_high_ld ),
  .prod_reg_shift   (prod_reg_shift   ),
  .done             (done             ));
  
endmodule