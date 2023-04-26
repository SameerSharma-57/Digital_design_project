`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT Jodhpur
// Engineer: Sameer Sharma
// 
// Create Date: 04/04/2023 02:39:37 PM
// Design Name: Digital Safe
// Module Name: main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer (
    input clk,  // clock input
    input button,  // button input
    output reg debounced_button  // debounced button output
);

    reg counter;
    
    
    always @(posedge clk) begin
        if (button != 1) begin
            counter <= 0;
        end
         if (button==1 && counter==0) begin
            counter <= 1;
            debounced_button <=1;
        end else begin
            debounced_button <= 0;
        end
        
    end

endmodule



module frequency_divider(clk,div_clock);
    input clk;
    output reg div_clock;
    reg [16:0]count;
    
    always@(posedge clk)
    begin
        count=count+1;
        div_clock=count[16];
    end
endmodule

module displaylogic(In,out);
    input [3:0]In;
    output [6:0] out;
    assign out[0]=~(In[0]|In[2]|(In[1]&In[3])|(~In[1]&~In[3]));
    assign out[1]=~(~In[1]|(~In[2]&~In[3])|(In[2]&In[3]));
    assign out[2]=~(In[1]|~In[2]|In[3]);
    assign out[3]=~(In[0]|(In[2]&~In[3])|(~In[1]&~In[3])|(~In[1]&In[2])|((In[1]&~In[2])&In[3]));
    assign out[4]=~((In[2]|~In[1])&~In[3]);
    assign out[5]=~(In[0]|(~In[2]&~In[3])|(In[1]&~In[2])|(In[1]&~In[3]));
    assign out[6]=~(In[0]|(In[1]&~In[2])|(In[2]&~In[3])|(~In[1]&In[2]));
endmodule

module decoder_2x4(
    input [2:0] A,
    output wire [3:0] Y
);

assign Y[0] = ~(~(A[0] & A[1]));
assign Y[1] = ~(~(A[0] & ~A[1]));
assign Y[2] = ~(~(~A[0] & A[1]));
assign Y[3] = ~(~(~A[0] & ~A[1]));

endmodule


module main(
    input wire [9:0]buttons,
    input reset,clk,load,
    input wire backspace,
    output reg green_led,red_led,
    output div_clk,
    output reg password_loaded,
    output reg [2:0] out_count=3'b0
//    output reg [6:0]seven_seg_out,
//    output reg [3:0] enable
//    output debounced_buttons [9:0]
    );
//    reg debounced_buttons [9:0];
    reg [3:0] password [0:3];
    reg [2:0]count=2'b0;
    reg [3:0]pass_input [0:3];
    reg [3:0]loaded_password [0:3];
    reg [2:0] load_count=3'b0;
    integer j;
    reg is_pressed;
    reg is_equal;
    reg temp;
    wire [9:0]debounced_buttons ;
    wire debounced_backspace;
    reg [2:0]wrong_count=3'b0;
    reg [1:0] res=2'b00; 
    wire [3:0]ou1,ou2,ou3,ou4;
//    assign enable=4'b1110;
    
    

    frequency_divider f1(clk,div_clk);
     
    initial begin
        is_equal=1;
        green_led=0;
        red_led=0;
        password_loaded=0;
        wrong_count=0;
        
        
        password[0]=4'b0;
        password[1]=4'b0;
        password[2]=4'b0;
        password[3]=4'b0;
    
    
    end

    debouncer d1(.clk(div_clk),.button(buttons[0]),.debounced_button(debounced_buttons[0]));
    debouncer d2(.clk(div_clk),.button(buttons[1]),.debounced_button(debounced_buttons[1]));
    debouncer d3(.clk(div_clk),.button(buttons[2]),.debounced_button(debounced_buttons[2]));
    debouncer d4(.clk(div_clk),.button(buttons[3]),.debounced_button(debounced_buttons[3]));
    debouncer d5(.clk(div_clk),.button(buttons[4]),.debounced_button(debounced_buttons[4]));
    debouncer d6(.clk(div_clk),.button(buttons[5]),.debounced_button(debounced_buttons[5]));
    debouncer d7(.clk(div_clk),.button(buttons[6]),.debounced_button(debounced_buttons[6]));
    debouncer d8(.clk(div_clk),.button(buttons[7]),.debounced_button(debounced_buttons[7]));
    debouncer d9(.clk(div_clk),.button(buttons[8]),.debounced_button(debounced_buttons[8]));
    debouncer d10(.clk(div_clk),.button(buttons[9]),.debounced_button(debounced_buttons[9]));
    debouncer d11(.clk(div_clk), .button(backspace), .debounced_button(debounced_backspace));
    displaylogic dl1(pass_input[0],ou1);
    displaylogic dl2(pass_input[1],ou2);
    displaylogic dl3(pass_input[2],ou3);
    displaylogic dl4(pass_input[3],ou4);


//    always @(count)begin
//        if(count<4)begin
//        case(pass_input[count])
//            4'b0000: seven_seg_out <= 7'b1000000; // 0
//            4'b0001: seven_seg_out <= 7'b1111001; // 1
//            4'b0010: seven_seg_out <= 7'b0100100; // 2
//            4'b0011: seven_seg_out <= 7'b0110000; // 3
//            4'b0100: seven_seg_out <= 7'b0011001; // 4
//            4'b0101: seven_seg_out <= 7'b0010010; // 5
//            4'b0110: seven_seg_out <= 7'b0000010; // 6
//            4'b0111: seven_seg_out <= 7'b1111000; // 7
//            4'b1000: seven_seg_out <= 7'b0000000; // 8
//            4'b1001: seven_seg_out <= 7'b0010000; // 9
//            default: seven_seg_out <= 7'b1111111; 
//        endcase
        
//        enable<=4'b1110;
//        end
        
            
        
//    end
    
    
//    always@(posedge div_clk)
//    begin
//    if (res == 2'b00)
//    begin
//        enable = 4'b0111;
//        seven_seg_out <= ou1;
//        res <= 2'b01;
//    end
//    else if(res==2'b01)
//    begin
//        enable = 4'b1011;
//        seven_seg_out <= ou2;
//        res <= 2'b10;
//    end
    
//    else if(res==2'b10)
//    begin
//        enable = 4'b1101;
//        seven_seg_out <= ou3;
//        res <= 2'b11;
//    end
    
//    else
//    begin
//        enable = 4'b1110;
//        seven_seg_out <= ou4;
//        res <= 2'b11;
//    end
//end
    always@(posedge div_clk)
    begin
        out_count=load?load_count:count;
        
        if (reset==1)begin
            count=0;
            green_led=0;
            red_led=0;
            is_equal=1;
            password_loaded=0;
            load_count=3'b0;
           
        end
        
        else if(wrong_count>2)begin
            red_led=1;
        end
        
        else if(debounced_backspace)begin
            if(!load)begin
                count=count>0?count-1:0;
            end
            else load_count=load_count>0?load_count-1:0;
        end        

        
        else if (load==1)begin
            if(load_count==4 && !password_loaded)begin
                for(j=0;j<4;j=j+1)begin
                    password[j]=loaded_password[j];
                end
                
                password_loaded=1;
                load_count=3'b0;

            end
            else if (!password_loaded) begin
                for(j=0;j<10;j=j+1)begin
                    if(debounced_buttons[j])begin
                        loaded_password[load_count] = j;
                        load_count=load_count+1;
                    end
                end
            end
        end
        
        
        
        else begin
            if (count>=4) begin
                count = 0;
                is_equal=1;
                for(j=0;j<4;j=j+1)begin
                    if(password[j]!=pass_input[j])begin
                     is_equal=0;
                    
                     end
                end
              
                if (is_equal)begin green_led=1;wrong_count=0;end
               
                else begin wrong_count=wrong_count+1;red_led=1;end
            end
            
            else begin
                for(j=0;j<10;j=j+1)begin
                    if(debounced_buttons[j])begin
                        pass_input[count] = j;
                        count=count+1;
                        
                    end
                end
            end
        end
    end
    
    
    
    
endmodule
