// TI74181 Testbench for verification
`timescale 1ns/1ps

module TI74181_TB;
    
    // Test signals
    logic [3:0] A_tb, B_tb, S_tb;
    logic M_tb, Cn_tb;
    logic P_tb, G_tb, Cn1_tb;
    logic [3:0] F_tb;
    
    // Instantiate DUT (Design Under Test)
    TI74181 dut(
        .A(A_tb),
        .B(B_tb),
        .S(S_tb),
        .M(M_tb),
        .Cn(Cn_tb),
        .P(P_tb),
        .G(G_tb),
        .Cn1(Cn1_tb),
        .F(F_tb)
    );
    
    // Test counter
    integer test_num = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // Task to display test results
    task display_test(string operation_name);
        test_num++;
        $display("Test %0d: A=%h, B=%h, S=%h, M=%b, Cn=%b | F=%h, P=%b, G=%b, Cn1=%b | %s", 
                 test_num, A_tb, B_tb, S_tb, M_tb, Cn_tb, F_tb, P_tb, G_tb, Cn1_tb, operation_name);
    endtask
    
    // Task for assertion checks
    task check_result(logic [3:0] expected_F, string test_case);
        if(F_tb == expected_F) begin
            pass_count++;
            $display("  ✓ PASS: %s", test_case);
        end else begin
            fail_count++;
            $display("  ✗ FAIL: %s | Expected: %h, Got: %h", test_case, expected_F, F_tb);
        end
    endtask
    
    initial begin
        $display("========================================");
        $display("  TI74181 ALU Verification Testbench");
        $display("========================================\n");
        
        // ===== LOGIC OPERATIONS (M=1) =====
        $display("--- LOGIC OPERATIONS (M=1) ---\n");
        
        // Test 1: AND operation
        M_tb = 1'b1; S_tb = 4'b1000; A_tb = 4'hA; B_tb = 4'h3; Cn_tb = 1'b0;
        #10;
        display_test("AND: A=1010, B=0011");
        check_result(4'h2, "AND(0xA, 0x3) = 0x2");
        #10;
        
        // Test 2: OR operation
        M_tb = 1'b1; S_tb = 4'b1110; A_tb = 4'hA; B_tb = 4'h3; Cn_tb = 1'b0;
        #10;
        display_test("OR: A=1010, B=0011");
        check_result(4'hB, "OR(0xA, 0x3) = 0xB");
        #10;
        
        // Test 3: XOR operation
        M_tb = 1'b1; S_tb = 4'b1010; A_tb = 4'hA; B_tb = 4'h3; Cn_tb = 1'b0;
        #10;
        display_test("XOR: A=1010, B=0011");
        check_result(4'h9, "XOR(0xA, 0x3) = 0x9");
        #10;
        
        // Test 4: NAND operation
        M_tb = 1'b1; S_tb = 4'b1101; A_tb = 4'hF; B_tb = 4'hF; Cn_tb = 1'b0;
        #10;
        display_test("NAND: A=1111, B=1111");
        check_result(4'h0, "NAND(0xF, 0xF) = 0x0");
        #10;
        
        // Test 5: NOR operation
        M_tb = 1'b1; S_tb = 4'b1011; A_tb = 4'h0; B_tb = 4'h0; Cn_tb = 1'b0;
        #10;
        display_test("NOR: A=0000, B=0000");
        check_result(4'hF, "NOR(0x0, 0x0) = 0xF");
        #10;
        
        // Test 6: Pass A
        M_tb = 1'b1; S_tb = 4'b0101; A_tb = 4'h7; B_tb = 4'h0; Cn_tb = 1'b0;
        #10;
        display_test("Pass A");
        check_result(4'h7, "Pass(0x7) = 0x7");
        #10;
        
        // Test 7: Pass B
        M_tb = 1'b1; S_tb = 4'b0110; A_tb = 4'h0; B_tb = 4'h5; Cn_tb = 1'b0;
        #10;
        display_test("Pass B");
        check_result(4'h5, "Pass(0x5) = 0x5");
        #10;
        
        // Test 8: Complement A
        M_tb = 1'b1; S_tb = 4'b0111; A_tb = 4'h0; B_tb = 4'h0; Cn_tb = 1'b0;
        #10;
        display_test("Complement A");
        check_result(4'hF, "~A(0x0) = 0xF");
        #10;
        
        // Test 9: Complement B
        M_tb = 1'b1; S_tb = 4'b1100; A_tb = 4'h0; B_tb = 4'h5; Cn_tb = 1'b0;
        #10;
        display_test("Complement B");
        check_result(4'hA, "~B(0x5) = 0xA");
        #10;
        
        // Test 10: All 1's
        M_tb = 1'b1; S_tb = 4'b1111; A_tb = 4'h0; B_tb = 4'h0; Cn_tb = 1'b0;
        #10;
        display_test("Set all ones");
        check_result(4'hF, "All 1s = 0xF");
        #10;
        
        $display("\n--- ARITHMETIC OPERATIONS (M=0) ---\n");
        
        // Test 11: A + B (Cn=0)
        M_tb = 1'b0; S_tb = 4'b1001; A_tb = 4'h3; B_tb = 4'h2; Cn_tb = 1'b0;
        #10;
        display_test("A + B: 0x3 + 0x2");
        check_result(4'h5, "0x3 + 0x2 = 0x5");
        #10;
        
        // Test 12: A + B (Cn=1)
        M_tb = 1'b0; S_tb = 4'b1001; A_tb = 4'h3; B_tb = 4'h2; Cn_tb = 1'b1;
        #10;
        display_test("A + B + Cin: 0x3 + 0x2 + 1");
        check_result(4'h6, "0x3 + 0x2 + 1 = 0x6");
        #10;
        
        // Test 13: A + B with carry generation
        M_tb = 1'b0; S_tb = 4'b1001; A_tb = 4'hF; B_tb = 4'hF; Cn_tb = 1'b0;
        #10;
        display_test("A + B: 0xF + 0xF (overflow)");
        $display("  Carry out (Cn1) = %b (should be 1)", Cn1_tb);
        #10;
        
        // Test 14: A - B (Cn=1)
        M_tb = 1'b0; S_tb = 4'b0110; A_tb = 4'h5; B_tb = 4'h3; Cn_tb = 1'b1;
        #10;
        display_test("A - B + Cin: 0x5 - 0x3 + 1");
        $display("  Result = %h (0x5 - 0x3 + 1 = 0x3)", F_tb);
        #10;
        
        // Test 15: 2A + Cin
        M_tb = 1'b0; S_tb = 4'b1100; A_tb = 4'h3; B_tb = 4'h0; Cn_tb = 1'b0;
        #10;
        display_test("2A + Cin: 2*0x3");
        check_result(4'h6, "2*0x3 = 0x6");
        #10;
        
        // Test 16: A + Cin
        M_tb = 1'b0; S_tb = 4'b0000; A_tb = 4'h7; B_tb = 4'h0; Cn_tb = 1'b1;
        #10;
        display_test("A + Cin: 0x7 + 1");
        check_result(4'h8, "0x7 + 1 = 0x8");
        #10;
        
        // Test 17: A - 1 + Cin
        M_tb = 1'b0; S_tb = 4'b1111; A_tb = 4'h5; B_tb = 4'h0; Cn_tb = 1'b1;
        #10;
        display_test("A - 1 + Cin: 0x5 - 1 + 1");
        check_result(4'h5, "0x5 - 1 + 1 = 0x5");
        #10;
        
        // Test 18: Clear result
        M_tb = 1'b0; S_tb = 4'b0000; A_tb = 4'hF; B_tb = 4'hF; Cn_tb = 1'b0;
        #10;
        display_test("Clear (F + 0)");
        check_result(4'h0, "Clear = 0x0");
        #10;
        
        $display("\n--- CARRY PROPAGATE AND GENERATE TESTS ---\n");
        
        // Test 19: P and G calculation
        M_tb = 1'b0; S_tb = 4'b1001; A_tb = 4'hF; B_tb = 4'h1; Cn_tb = 1'b0;
        #10;
        display_test("A=0xF, B=0x1 (carry propagate check)");
        #10;
        
        // Test 20: Random test
        M_tb = 1'b0; S_tb = 4'b1001; A_tb = 4'h7; B_tb = 4'h8; Cn_tb = 1'b0;
        #10;
        display_test("A + B: 0x7 + 0x8");
        check_result(4'hF, "0x7 + 0x8 = 0xF");
        #10;
        
        // Print summary
        $display("\n========================================");
        $display("  TEST SUMMARY");
        $display("========================================");
        $display("Total Tests: %0d", test_num);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        $display("Pass Rate: %0.1f%%", (pass_count*100.0)/test_num);
        $display("========================================\n");
        
        $finish;
    end
    
endmodule


