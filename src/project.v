`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Entradas dedicadas
    output wire [7:0] uo_out,   // Salidas dedicadas
    input  wire [7:0] uio_in,   // Pines bidireccionales (entrada)
    output wire [7:0] uio_out,  // Pines bidireccionales (salida)
    input  wire [7:0] uio_oe,   // Pines bidireccionales (habilitación de salida)
    input  wire       ena,      // Activo en alto (mantener en 1 para habilitar el diseño)
    input  wire       clk,      // Reloj global del sistema
    input  wire       rst_n     // Reset global ACTIVO EN BAJO (¡Ojo con esto!)
);

    // ----------------------------------------------------
    // Conexión de tus señales con los pines físicos del chip
    // ----------------------------------------------------
    wire sequence_in;
    wire match_sequence;
    wire rst;

    // Asignamos la entrada serial al pin de entrada 0
    assign sequence_in = ui_in[0];

    // Asignamos la salida del detector al pin de salida 0
    assign uo_out[0] = match_sequence;

    // Tiny Tapeout usa reset activo en bajo (rst_n). 
    // Como tu FSM usa reset activo en alto (rst), lo invertimos:
    assign rst = ~rst_n;

    // Ponemos el resto de pines de salida no usados en 0 por seguridad
    assign uo_out[7:1] = 7'b0000000;
    assign uio_out     = 8'b00000000;
    assign uio_oe      = 8'b00000000;

    // ----------------------------------------------------
    // AQUÍ VA TU MÁQUINA DE ESTADOS COMPLETA (FSM)
    // ----------------------------------------------------
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100,
              S5 = 3'b101;[cite: 1]

    reg [2:0] current_state, next_state;[cite: 1]

    // Registro de estado[cite: 1]
    always @(posedge clk or posedge rst)[cite: 1]
    begin
        if (rst)[cite: 1]
            current_state <= S0;[cite: 1]
        else[cite: 1]
            current_state <= next_state;[cite: 1]
    end

    // Lógica de transición[cite: 1]
    always @(*)[cite: 1]
    begin
        case(current_state)[cite: 1]
            S0:[cite: 1]
                if(sequence_in)[cite: 1]
                    next_state = S1;[cite: 1]
                else[cite: 1]
                    next_state = S0;[cite: 1]
            S1:[cite: 1]
                if(sequence_in)[cite: 1]
                    next_state = S2;[cite: 1]
                else[cite: 1]
                    next_state = S0;[cite: 1]
            S2:[cite: 1]
                if(sequence_in)[cite: 1]
                    next_state = S2;[cite: 1]
                else[cite: 1]
                    next_state = S3;[cite: 1]
            S3:[cite: 1]
                if(sequence_in)[cite: 1]
                    next_state = S4;[cite: 1]
                else[cite: 1]
                    next_state = S0;[cite: 1]
            S4:[cite: 1]
                if(sequence_in)[cite: 1]
                    next_state = S2;[cite: 1]
                else[cite: 1]
                    next_state = S5;[cite: 1]
            S5:[cite: 1]
                if(sequence_in)[cite: 1]
                    next_state = S4;[cite: 1]
                else[cite: 1]
                    next_state = S0;[cite: 1]
            default:[cite: 1]
                next_state = S0;[cite: 1]
        endcase[cite: 1]
    end

    // Lógica de salida (Moore)[cite: 1]
    always @(*)[cite: 1]
    begin
        case(current_state)[cite: 1]
            S5: match_sequence = 1'b1;[cite: 1]
            default: match_sequence = 1'b0;[cite: 1]
        endcase[cite: 1]
    end

endmodule
