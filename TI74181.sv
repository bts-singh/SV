// TI74181 4-bit Arithmetic Logic Unit (ALU)
// M=1: Logic operations, M=0: Arithmetic operations
// S[3:0]: Operation selector
// Cn: Carry input (for arithmetic operations)
// A, B: 4-bit operands
// F: 4-bit function output
// P: Carry propagate (for carry lookahead)
// G: Carry generate (for carry lookahead)
// Cn1: Carry output (for arithmetic operations)

module TI74181(
    input logic [3:0] A,B,S,
    input logic M,Cn,
    output logic P,G,Cn1,
    output logic [3:0] F
    );

    logic [3:0] p, g;  // propagate and generate for each bit
    logic [4:0] C;     // carry bits [0]=Cn, [4]=Cn1
    logic [3:0] F_logic, F_arith;
    
    // Carry chain for Cn and intermediate carries
    assign C[0] = Cn;
    
    // Generate P and G for each bit (for ALU operations)
    assign p[0] = A[0] ^ B[0];
    assign p[1] = A[1] ^ B[1];
    assign p[2] = A[2] ^ B[2];
    assign p[3] = A[3] ^ B[3];
    
    assign g[0] = A[0] & B[0];
    assign g[1] = A[1] & B[1];
    assign g[2] = A[2] & B[2];
    assign g[3] = A[3] & B[3];
    
    // Carry propagate and generate output
    assign P = p[0] & p[1] & p[2] & p[3];
    assign G = (g[3] | (p[3] & g[2])) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    
    // Carry lookahead logic
    assign C[1] = g[0] | (p[0] & C[0]);
    assign C[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & C[0]);
    assign C[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & C[0]);
    assign C[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & C[0]);
    
    assign Cn1 = C[4];
    
    // Logic operations (when M=1)
    always_comb begin
        case(S)
            4'b1111: F_logic = 4'b1111;  // Set all
            4'b1110: F_logic = A | B;    // OR
            4'b1101: F_logic = ~(A & B); // NAND
            4'b1100: F_logic = ~B;       // Complement B
            4'b1011: F_logic = ~(A | B); // NOR
            4'b1010: F_logic = A ^ B;    // XOR
            4'b1001: F_logic = ~(A ^ B); // XNOR
            4'b1000: F_logic = A & B;    // AND
            4'b0111: F_logic = ~A;       // Complement A
            4'b0110: F_logic = B;        // Pass B
            4'b0101: F_logic = A;        // Pass A
            4'b0100: F_logic = 4'b0000;  // Clear all
            default: F_logic = 4'b0000;
        endcase
    end
    
    // Arithmetic operations (when M=0)
    always_comb begin
        case(S)
            // Addition and subtraction operations
            4'b0000: F_arith = A + Cn;                    // A + Cin
            4'b0001: F_arith = (A | B) + Cn;             // (A|B) + Cin
            4'b0010: F_arith = (A | ~B) + Cn;            // (A|~B) + Cin
            4'b0011: F_arith = 4'hF + Cn;                // all 1s + Cin
            4'b0100: F_arith = (A & B) + Cn;             // (A&B) + Cin
            4'b0101: F_arith = (A ^ B) + Cn;             // (A^B) + Cin
            4'b0110: F_arith = A - B + Cn;               // A - B + Cin
            4'b0111: F_arith = (A & ~B) + Cn;            // (A&~B) + Cin
            4'b1000: F_arith = (A ^ ~B) + Cn;            // (A^~B) + Cin
            4'b1001: F_arith = A + B + Cn;               // A + B + Cin
            4'b1010: F_arith = (A | ~B) + Cn;            // (A|~B) + Cin
            4'b1011: F_arith = (A & B) + Cn;             // (A&B) + Cin
            4'b1100: F_arith = A + A + Cn;               // 2A + Cin
            4'b1101: F_arith = (A | B) + A + Cn;         // (A|B) + A + Cin
            4'b1110: F_arith = (A | ~B) + A + Cn;       // (A|~B) + A + Cin
            4'b1111: F_arith = A - 1 + Cn;               // A - 1 + Cin
            default: F_arith = 4'b0000;
        endcase
    end
    
    // Select logic or arithmetic operation based on M
    assign F = M ? F_logic : F_arith;
    
endmodule
