module mult_ctl(
  input reset_n,
  input start,
  input prod_reg_LSB,
  input clk,
  output logic prod_reg_high_ld,
  output logic prod_reg_shift,
  output logic done);

 
  enum reg [1:0]{
    WAIT  = 2'b00,
    READ  = 2'b01,
    SHIFT = 2'b11,
    LOAD  = 2'b10
    }mult_ctl_ns, mult_ctl_ps;

  up_counter up_counter_0(
    .reset_n          ( start           ),
    .enable           ( prod_reg_shift  ),
    .clk              ( clk             ),
    .done             ( done            ));
    
  always_ff @(posedge clk, negedge reset_n)
    if (!reset_n) mult_ctl_ps <= WAIT;
    else mult_ctl_ps <= mult_ctl_ns;

  always_comb begin
    mult_ctl_ns = WAIT;
    unique case (mult_ctl_ps)
      WAIT :begin 
                                prod_reg_high_ld = 1'b0;
                                prod_reg_shift = 1'b0;
            if (start) begin 
                                prod_reg_high_ld = 1'b1;
                                mult_ctl_ns = READ;
             end                    
             else               mult_ctl_ns = WAIT;
      end
      READ : begin              
                                prod_reg_high_ld = 1'b0;
             if (prod_reg_LSB)  mult_ctl_ns = LOAD;
             else               mult_ctl_ns = SHIFT;
      end       
      SHIFT : begin             
                                prod_reg_high_ld = 1'b0;
                                prod_reg_shift = 1'b1; 
              if (done)         mult_ctl_ns = WAIT;
              else if (prod_reg_LSB) mult_ctl_ns = LOAD;
              else              mult_ctl_ns = SHIFT;
      end           
      LOAD :  begin             
                                prod_reg_high_ld = 1'b1;
                                prod_reg_shift = 1'b0;
                                mult_ctl_ns = SHIFT;       
      end
    endcase
  end
endmodule  