include <BOSL2/std.scad>
include <BOSL2/screws.scad>
use <jetson_nano.scad>

$fn = 50;

CASE_DX = 2.7;

BOARD_X = get_BOARD_X() + CASE_DX;
BOARD_Y = get_BOARD_Y() + CASE_DX;

BOARD_Z = get_BOARD_Z();


R_BASE = 2;

DI = 3.5;
DO = 7;
WALL = 1.2;
E = 0.01;
E2 = 0.2;

H_TOP = 25;

H_BOTTOM = 7; // TODO - need screw size!

SCALE_D = 0.4;

SHOW_BOARD = false;

SHOW_TOP = true;
SHOW_BOTTOM = false;
SHOW_HATS = true;

TOP_HEAD_SHIFT = 2;


BOLT_LEN = 20;
BOLT_CUP_LEN = 3;
BOLT_CUP_D = 6;
//BOLT_UP_D = 5;

HOLE_UP_PLAV = 5;
HOLE_UP_PLAV_H = 6;

bolt_up_len = BOLT_LEN-H_BOTTOM-WALL-BOARD_Z;



module top_walls()
{
    difference()
    {

    cuboid([BOARD_X+WALL*2, BOARD_Y+WALL*2, H_TOP], anchor=BOTTOM, rounding=R_BASE, edges="Z");

    cuboid([BOARD_X, BOARD_Y, H_TOP+E], anchor=BOTTOM, rounding=R_BASE, edges="Z");

    }


    translate([0,0,H_TOP/2])
    {
    difference()
    {
        union()
        {
            shift_model_center()
            {
                orange_pi_plate_holes(d = DO, h=H_TOP);
                additional_plate_holes(h=H_TOP,dx=CASE_DX-E2);
            }
        }
        
        
        shift_model_center()
        orange_pi_plate_holes(d = DI, h=H_TOP+E);
        
        shift_model_center()
        translate([0,0,(-H_TOP/2+HOLE_UP_PLAV_H/2)])
        orange_pi_plate_holes(d = HOLE_UP_PLAV, h=HOLE_UP_PLAV_H);
        
        //shift_model_center()
        //translate([0,0,(H_TOP-bolt_up_len)/2])
        //orange_pi_plate_holes(d = BOLT_UP_D, h=bolt_up_len);
        
    }
    }
}

module top_head()
{

    cuboid([BOARD_X + WALL*2 + TOP_HEAD_SHIFT*2,
        BOARD_Y + WALL*2 + TOP_HEAD_SHIFT*2,
        WALL],
        rounding = R_BASE,
        edges = "Z");

}

module top()
{
    difference()
    {
        top_walls();

        shift_model_center()
        {
        orange_pi_3_zero_model(
            shift_ports=5,
            scale_d=SCALE_D);
        
        //orange_pi_3_zero_model(
        //    shift_ports=0,
        //    scale_d=-0.4);
        }
    }

    if (SHOW_HATS)
    difference()
    {
        translate([0,0,H_TOP+WALL/2])
        difference()
        {
            top_head();
            shift_model_center()
            orange_pi_plate_holes(d = DI, h=H_TOP+E);
        
        }
        
        
        shift_model_center()
        {
        orange_pi_3_zero_model(
                shift_ports=5,
                scale_d=SCALE_D,
                h = H_TOP+2*WALL);
        //orange_pi_3_zero_model(
        //    shift_ports=0,
        //    scale_d=-0.4);
        }
    }

}

module bottom_walls()
{
    bottom_hat_z = BOLT_CUP_LEN;

    translate([0,0,-H_BOTTOM-BOARD_Z])
    difference()
    {

    cuboid([BOARD_X+WALL*2, BOARD_Y+WALL*2, H_BOTTOM+BOARD_Z], anchor=BOTTOM, rounding=R_BASE, edges="Z");

    cuboid([BOARD_X, BOARD_Y, H_BOTTOM+E+BOARD_Z], anchor=BOTTOM, rounding=R_BASE, edges="Z");

    }


    translate([0,0,-H_BOTTOM/2-BOARD_Z])
    {
    difference()
    {
        union()
        {
        shift_model_center()  
        {
        orange_pi_plate_holes(d = DO, h=H_BOTTOM);
        
        additional_plate_holes(h=H_BOTTOM,dx=CASE_DX-E2);
        }
        }


        shift_model_center()
        orange_pi_plate_holes(d = DI, h=H_BOTTOM+E);
    
        
        translate([0,0,-H_BOTTOM/2+bottom_hat_z/2])
        shift_model_center()
        orange_pi_plate_holes(d = BOLT_CUP_D, h=bottom_hat_z);
    
    
    }
    }
}

module bottom()
{
    difference()
    {
        bottom_walls();

        shift_model_center()
        orange_pi_3_zero_model(shift_ports=5,
            scale_d=SCALE_D);

    }
    
    if (SHOW_HATS)
    translate([0,0,-H_BOTTOM-WALL/2-BOARD_Z])
    difference()
    {
    top_head();
    shift_model_center()
    orange_pi_plate_holes(d = BOLT_CUP_D, h=H_BOTTOM+E);
    }
}

module board()
{
    shift_model_center()
    orange_pi_3_zero_model(shift_ports=0);
}

if (SHOW_TOP)
    top();

if (SHOW_BOARD)
   #board();

if (SHOW_BOTTOM)
bottom();