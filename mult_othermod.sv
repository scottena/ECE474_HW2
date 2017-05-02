module mult_reg #(parameter width=8)(
   input             reset_n,
   input             clk,
   input             enable,
   input             [width-1:0] din,
   output      logic [width-1:0] dout );
   
   reg               [width-1:0] dreg;
   
   always @(posedge clk or negedge reset_n)
     if (!reset_n)       dout <= 0;
     else if (enable)    dout <= din;        
endmodule 

module mult_shift_reg #(parameter width=8)(

   input             reset_n,
   input             clk,
   input             enable,
   input             shift,
   input             shift_in,
   input             [width-1:0] din,
   output      logic [width-1:0] dout );
   
   reg               [width-1:0] dreg;
   
   always @(posedge clk or negedge reset_n)
     if (!reset_n)       dout <= 0;
     else if (enable)    dout <= din; 
     else if (shift)     begin
        dout = dout >> 1;
        dout[width-1] = shift_in;
     end   
endmodule  

module up_counter (
  input              reset_n,
  input              enable,
  input              clk,
  output       logic done);
  
  logic     [7:0]cntInc;
  
  always @(posedge clk)
    if (reset_n) cntInc = 8'b0;
    else if (enable) cntInc = cntInc + 1;
  
  always_comb begin 
     if (cntInc === 32) done = 1'b1;
     else done = 1'b0;     
  end
endmodule    