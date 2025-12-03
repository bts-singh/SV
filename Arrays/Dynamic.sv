module arr();
bit dyna[];
initial begin
    dyna=new[4];
    $display(dyna.size);
    dyna[1]=9;
    dyna[3]=100;
    dyna=new[8](dyna); 
    $display(dyna.size);    
    dyna.delete;
    $display(dyna.size);    
end
endmodule
