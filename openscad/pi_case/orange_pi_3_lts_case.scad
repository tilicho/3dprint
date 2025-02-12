include <BOSL2/std.scad>
include <BOSL2/screws.scad>
use <orange_pi_3_lts.scad>

$fn = 50;

CASE_DX = 2.7;

BOARD_X = get_BOARD_X() + CASE_DX;
BOARD_Y = get_BOARD_Y() + CASE_DX;

BOARD_Z = get_BOARD_Z();


R_BASE = 2;

DI = 3.2;
DO = 5.5;
WALL = 1.2;
E = 0.01;

H_TOP = 25;

H_BOTTOM = 10; // TODO - need screw size!

SCALE_D = 0.4;

SHOW_BOARD = false;

SHOW_TOP = false;

TOP_HEAD_SHIFT = 2;

module top_walls()
{
    difference()
    {

    cuboid([BOARD_X+WALL*2, BOARD_Y+WALL*2, H_TOP], anchor=BOTTOM, rounding=R_BASE, edges="Z");

    cuboid([BOARD_X, BOARD_Y, H_TOP+E], anchor=BOTTOM, rounding=R_BASE, edges="Z");

    }


    translate([0,0,H_TOP/2])
    shift_model_center()
    {
    difference()
    {
    orange_pi_plate_holes(d = DO, h=H_TOP);

    orange_pi_plate_holes(d = DI, h=H_TOP+E);
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
        orange_pi_3_zero_model(shift_ports=5,
            scale_d=SCALE_D);

    }

    translate([0,0,H_TOP])
    difference()
    {
    top_head();
    shift_model_center()
    orange_pi_plate_holes(d = DI, h=H_TOP+E);
    }

}

module bottom_walls()
{
    translate([0,0,-H_BOTTOM])
    difference()
    {

    cuboid([BOARD_X+WALL*2, BOARD_Y+WALL*2, H_BOTTOM], anchor=BOTTOM, rounding=R_BASE, edges="Z");

    cuboid([BOARD_X, BOARD_Y, H_BOTTOM+E], anchor=BOTTOM, rounding=R_BASE, edges="Z");

    }


    translate([0,0,-H_BOTTOM/2])
    shift_model_center()
    {
    difference()
    {
    orange_pi_plate_holes(d = DO, h=H_BOTTOM);

    orange_pi_plate_holes(d = DI, h=H_BOTTOM+E);
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
    
    translate([0,0,-H_BOTTOM])
    difference()
    {
    top_head();
    shift_model_center()
    orange_pi_plate_holes(d = DI, h=H_BOTTOM+E);
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

bottom();