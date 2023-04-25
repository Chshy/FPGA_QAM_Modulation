module IQ_mod (
    input  [31:0] carrier_i,
    input  [31:0] carrier_q,
    input  [34:0] baseband_i,
    input  [34:0] baseband_q,
    output [68:0] mod_iq
);

assign mod_iq = $signed(carrier_i) * $signed(baseband_i) + $signed(carrier_q) * $signed(baseband_q);

endmodule