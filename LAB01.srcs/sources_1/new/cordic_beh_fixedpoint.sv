`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Luki-ENGINEER 
// 
// Create Date: 06.03.2023 20:03:32
// Design Name: 
// Module Name: cordic_beh_fixedpoint
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


module cordic_beh_fixedpoint();
parameter integer FXP_SCALE = 1024;
reg signed [11:0] t_angle = 1 * FXP_SCALE; //Input angle
reg signed [23:0] cos = 1.0 * FXP_SCALE; //Initial condition
reg signed [23:0] sin = 0.0;
reg signed [11:0] angle = 0.0; //Running angle
reg signed [11:0] atan[0:10] = { 0.785398163 * FXP_SCALE, 0.463647609* FXP_SCALE, 0.244978663* FXP_SCALE, 0.124354995* FXP_SCALE,
 0.06241881* FXP_SCALE, 0.031239833* FXP_SCALE, 0.015623729* FXP_SCALE, 0.007812341* FXP_SCALE,
  0.00390623* FXP_SCALE, 0.001953123* FXP_SCALE, 0.000976562* FXP_SCALE };
reg signed [11:0] Kn = 0.607253 * FXP_SCALE;

integer i, d;
real tmp;
initial //Execute only once
begin
 for ( i = 0; i < 11; i = i + 1) //Ten algorithm iterations
     begin
        if( t_angle > angle )
         begin
            angle = angle + atan[i];
            tmp = cos - ( sin >>> i );
            sin = ( cos  >>>i ) + sin;
            cos = tmp;
        end
        else
         begin
            angle = angle - atan[i];
            tmp = cos + ( sin >>>i );
            sin = - ( cos >>>i) + sin;
            cos = tmp;
        end //if
 end //for
 //Scale sin/cos values
 sin = Kn * sin;
 cos = Kn * cos;
 $display("sin=%f, cos=%f", sin, cos);
end
endmodule;
