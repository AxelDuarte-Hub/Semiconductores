// Detector de secuencia 11010 en Verilog (RTL)
// Integrantes: José Abdiel Lopez y Axel Duarte
//module sequence_detector_11010 (
module tt_um_example (
    input clk,
    input rst,
    input sequence_in,
    output reg match_sequence
);

// Codificación de estados
parameter S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100,
          S5 = 3'b101;

reg [2:0] current_state, next_state;

// Registro de estado
always @(posedge clk or posedge rst)
begin
    if (rst)
        current_state <= S0;
    else
        current_state <= next_state;
end

// Lógica de transición
always @(*)
begin
    case(current_state)
        S0:
            if(sequence_in)
                next_state = S1;
            else
                next_state = S0;
        S1:
            if(sequence_in)
                next_state = S2;
            else
                next_state = S0;
        S2:
            if(sequence_in)
                next_state = S2;
            else
                next_state = S3;
        S3:
            if(sequence_in)
                next_state = S4;
            else
                next_state = S0;
        S4:
            if(sequence_in)
                next_state = S2;
            else
                next_state = S5;
        S5:
            if(sequence_in)
                next_state = S4;
            else
                next_state = S0;
        default:
            next_state = S0;
    endcase
end

// Lógica de salida (Moore)
always @(*)
begin
    case(current_state)
        S5: match_sequence = 1'b1;
        default: match_sequence = 1'b0;
    endcase
end
endmodule
