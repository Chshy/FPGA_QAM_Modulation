// -------------------------------------------------------------
//
// Module: CIC_Interpolator8
// Generated by MATLAB(R) 9.12 and Filter Design HDL Coder 3.1.11.
// Generated on: 2023-04-25 10:28:32
// -------------------------------------------------------------

// -------------------------------------------------------------
// HDL Code Generation Options:
//
// TargetDirectory: CIC_Interpolator8
// Name: CIC_Interpolator8
// InputDataType: numerictype(1,32,31)
// TargetLanguage: Verilog
// TestBenchName: CIC_Interpolator8_tb

// -------------------------------------------------------------
// HDL Implementation    : Fully parallel
// -------------------------------------------------------------




`timescale 1 ns / 1 ns

module CIC_Interpolator8
               (
                clk,
                clk_enable,
                reset,
                filter_in,
                filter_out,
                ce_out
                );

  input   clk; 
  input   clk_enable; 
  input   reset; 
  input   signed [31:0] filter_in; //sfix32_En31
  output  signed [34:0] filter_out; //sfix35_En31
  output  ce_out; 

////////////////////////////////////////////////////////////////
//Module Architecture: CIC_Interpolator8
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  parameter signed [32:0] zeroconst = 33'h000000000; //sfix33_En31
  // Signals
  reg  [2:0] cur_count; // ufix3
  wire phase_0; // boolean
  //   
  reg  signed [31:0] input_register; // sfix32_En31
  //   -- Section 1 Signals 
  wire signed [31:0] section_in1; // sfix32_En31
  wire signed [32:0] section_cast1; // sfix33_En31
  reg  signed [32:0] diff1; // sfix33_En31
  wire signed [32:0] section_out1; // sfix33_En31
  wire signed [32:0] sub_cast; // sfix33_En31
  wire signed [32:0] sub_cast_1; // sfix33_En31
  wire signed [33:0] sub_temp; // sfix34_En31
  //   -- Section 2 Signals 
  wire signed [32:0] section_in2; // sfix33_En31
  reg  signed [32:0] diff2; // sfix33_En31
  wire signed [32:0] section_out2; // sfix33_En31
  wire signed [32:0] sub_cast_2; // sfix33_En31
  wire signed [32:0] sub_cast_3; // sfix33_En31
  wire signed [33:0] sub_temp_1; // sfix34_En31
  wire signed [32:0] upsampling; // sfix33_En31
  //   -- Section 3 Signals 
  wire signed [32:0] section_in3; // sfix33_En31
  wire signed [32:0] sum1; // sfix33_En31
  reg  signed [32:0] section_out3; // sfix33_En31
  wire signed [32:0] add_cast; // sfix33_En31
  wire signed [32:0] add_cast_1; // sfix33_En31
  wire signed [33:0] add_temp; // sfix34_En31
  //   -- Section 4 Signals 
  wire signed [32:0] section_in4; // sfix33_En31
  wire signed [34:0] section_cast4; // sfix35_En31
  wire signed [34:0] sum2; // sfix35_En31
  reg  signed [34:0] section_out4; // sfix35_En31
  wire signed [34:0] add_cast_2; // sfix35_En31
  wire signed [34:0] add_cast_3; // sfix35_En31
  wire signed [35:0] add_temp_1; // sfix36_En31
  wire signed [34:0] output_typeconvert; // sfix35_En31
  //   
  reg  signed [34:0] output_register; // sfix35_En31

  // Block Statements
  //   ------------------ CE Output Generation ------------------

  always @ (posedge clk or posedge reset)
    begin: ce_output
      if (reset == 1'b1) begin
        cur_count <= 3'b000;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (cur_count >= 3'b111) begin
            cur_count <= 3'b000;
          end
          else begin
            cur_count <= cur_count + 3'b001;
          end
        end
      end
    end // ce_output

  assign  phase_0 = (cur_count == 3'b000 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

  //   ------------------ Input Register ------------------

  always @ (posedge clk or posedge reset)
    begin: input_reg_process
      if (reset == 1'b1) begin
        input_register <= 0;
      end
      else begin
        if (phase_0 == 1'b1) begin
          input_register <= filter_in;
        end
      end
    end // input_reg_process

  //   ------------------ Section # 1 : Comb ------------------

  assign section_in1 = input_register;

  assign section_cast1 = $signed({{1{section_in1[31]}}, section_in1});

  assign sub_cast = section_cast1;
  assign sub_cast_1 = diff1;
  assign sub_temp = sub_cast - sub_cast_1;
  assign section_out1 = sub_temp[32:0];

  always @ (posedge clk or posedge reset)
    begin: comb_delay_section1
      if (reset == 1'b1) begin
        diff1 <= 0;
      end
      else begin
        if (phase_0 == 1'b1) begin
          diff1 <= section_cast1;
        end
      end
    end // comb_delay_section1

  //   ------------------ Section # 2 : Comb ------------------

  assign section_in2 = section_out1;

  assign sub_cast_2 = section_in2;
  assign sub_cast_3 = diff2;
  assign sub_temp_1 = sub_cast_2 - sub_cast_3;
  assign section_out2 = sub_temp_1[32:0];

  always @ (posedge clk or posedge reset)
    begin: comb_delay_section2
      if (reset == 1'b1) begin
        diff2 <= 0;
      end
      else begin
        if (phase_0 == 1'b1) begin
          diff2 <= section_in2;
        end
      end
    end // comb_delay_section2

  assign upsampling = (phase_0 == 1'b1) ? section_out2 :
                zeroconst;
  //   ------------------ Section # 3 : Integrator ------------------

  assign section_in3 = upsampling;

  assign add_cast = section_in3;
  assign add_cast_1 = section_out3;
  assign add_temp = add_cast + add_cast_1;
  assign sum1 = add_temp[32:0];

  always @ (posedge clk or posedge reset)
    begin: integrator_delay_section3
      if (reset == 1'b1) begin
        section_out3 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          section_out3 <= sum1;
        end
      end
    end // integrator_delay_section3

  //   ------------------ Section # 4 : Integrator ------------------

  assign section_in4 = section_out3;

  assign section_cast4 = $signed({{2{section_in4[32]}}, section_in4});

  assign add_cast_2 = section_cast4;
  assign add_cast_3 = section_out4;
  assign add_temp_1 = add_cast_2 + add_cast_3;
  assign sum2 = add_temp_1[34:0];

  always @ (posedge clk or posedge reset)
    begin: integrator_delay_section4
      if (reset == 1'b1) begin
        section_out4 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          section_out4 <= sum2;
        end
      end
    end // integrator_delay_section4

  assign output_typeconvert = section_out4;

  //   ------------------ Output Register ------------------

  always @ (posedge clk or posedge reset)
    begin: output_reg_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          output_register <= output_typeconvert;
        end
      end
    end // output_reg_process

  // Assignment Statements
  assign ce_out = phase_0;
  assign filter_out = output_register;
endmodule  // CIC_Interpolator8
