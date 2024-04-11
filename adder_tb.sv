module adder_tb;
reg clk,reset;
logic [3:0]A,B;
logic [4:0]C;
localparam maxpos = 7 , maxneg= -8 , zero=0;

integer error_count , correct_count;

adder a1(
    .clk(clk),
    .reset(reset),
    .A(A),.B(B),
    .C(C)
);

initial begin
 clk = 0 ;
    forever 
        #1 clk= ~clk;
end

initial begin
    error_count =0;
    correct_count = 0;
    A=0;
    B=0;
    checkreset;

    A=B=maxneg; checkresult(-16);
    A=maxneg; B=zero; checkreset(-8);
    A=maxneg; B=maxpos; checkreset(-1);

    A=B=maxpos; checkresult(14);
    A=maxpos; B=zero; checkreset(7);
    A=maxpos; B=maxneg; checkreset(-1); 

    A=B=zero; checkresult(14);
    A=zero; B=maxpos; checkreset(7);
    A=zero; B=maxneg; checkreset(-1);    

end


task checkreset;
reset=1;
    @(negedge clk);
    if(C !== 0)begin
        error_count = error_count +1;
        $dispaly("%t: Reset vlaue is asserted and output value is not tied low",$time);
    end
    else 
        correct_count = correct_count +1;
        reset = 0;
endtask


task checkresult;
    input signed [4:0] expected_result;
    @(negedge clk);
    if (expected_result !== C) begin
        error_count = error_count + 1;
        $dispaly("%t: Error: for A=0d%0d , and B=0d%0d C should equal 0d%0d but is 0d%0d ",$time,A,B,expected_result,C);
    end
    else correct_count = correct_count +1;
endtask