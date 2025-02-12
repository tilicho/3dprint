include <BOSL2/std.scad>
include <BOSL2/screws.scad>

H = 14; // Fixed height of all boxes
H_USB_C = 5;
H_HDMI = 7;
H_JACK = 6;
H_SD = -3.5;

BOARD_X = 85;
BOARD_Y = 56;
BOARD_Z = 1.7;

H_DX = 3;
H_DY = 3;
H_DD = 3;

R_BASE = 0;

$fn = 50;

function get_BOARD_X() = BOARD_X;
function get_BOARD_Y() = BOARD_Y;
function get_BOARD_Z() = BOARD_Z;
function get_H_DX() = H_DX;
function get_H_DY() = H_DY;
function get_H_DD() = H_DD;

function shift_port(x, shift, max_x, w) = 
    (x == 0) ? 
    -1 * shift 
    : 
    (x + w >= max_x ? x + shift : x);

module draw_box(x, y, dx, dy, h, 
    shift_ports,
    scale_d) 
{
    calc_x = shift_port(
        x < 0 ? (BOARD_X + x) : x,
        shift_ports,
        BOARD_X,
        dx);
        
    calc_y = shift_port(
        y < 0 ? (BOARD_Y + y) : y,
        shift_ports,
        BOARD_Y,
        dy);
        
    calc_z = (h < 0 ? (-BOARD_Z+h) : 0);
    
    calc_h = abs(h) + (h < 0 ? BOARD_Z : 0);
    

    translate([calc_x-scale_d, calc_y-scale_d, calc_z-scale_d])
        cube([dx+2*scale_d, dy+2*scale_d, calc_h + 2*scale_d]);
}

module draw_cyl(x,y,z,d,h)
{
    translate([x,y,z])
    zcyl(d=d, h = h, anchor=BOTTOM);

}

module orange_pi_plate_holes(h = H, d = H_DD)
{
    translate([H_DX, H_DY, 0])
    zcyl(d = d, h = h);
    
    translate([H_DX, BOARD_Y - H_DY, 0])
    zcyl(d = d, h = h);
    
    translate([BOARD_X - H_DX, BOARD_Y - H_DY, 0])
    zcyl(d = d, h = h);
    
    translate([BOARD_X - H_DX, H_DY, 0])
    zcyl(d = d, h = h);
}

module orange_pi_base()
{
difference()
{
translate([0,0,-BOARD_Z])
cuboid([BOARD_X, BOARD_Y, BOARD_Z], rounding=R_BASE, edges="Z",
    anchor=LEFT+FRONT+BOTTOM);

//draw_box(0,0,BOARD_X,BOARD_Y,BOARD_Z, 0);

orange_pi_plate_holes();
}
}

//function get_scale_f(scale_d) =  max(
//    (BOARD_X + scale_d * 2) / BOARD_X,
//   (BOARD_Y + scale_d * 2) / BOARD_Y);


module orange_pi_3_zero_model(
    show_base = true,
    scale_d = 0,
    h = H,
    shift_ports = 0,
)
{

//scale_f = get_scale_f(scale_d);


boxes = [
    [0, 6+1, 10, 8-1, H],
    [0, 14, 18, 16+6, H],
    [0, 35, 14, 13, H+2],
    [17, 0, 7, 7, 9],
    [44,1,33,5,h],
    [59,-4,8,3,h],
    
    [-7,12-0.5,7,8+1,H_USB_C],
    [-7,43,7,5,H_HDMI],
    [41,-10,15,10,H_HDMI],
    [18,-12,7,12,H_JACK],
    
    [-14,24,14,15,H_SD],
];

COOLER_W = 30;
COOLER_DW = 3;
cooler_shift = COOLER_W/2 - COOLER_DW;
COOLER_D = 3;

cyls = [
    [BOARD_X/2, BOARD_Y/2, 0, 28, h],
    [BOARD_X/2+cooler_shift, BOARD_Y/2+cooler_shift, 0, COOLER_D, h],
    [BOARD_X/2+cooler_shift, BOARD_Y/2-cooler_shift, 0, COOLER_D, h],
    [BOARD_X/2-cooler_shift, BOARD_Y/2+cooler_shift, 0, COOLER_D, h],
    [BOARD_X/2-cooler_shift, BOARD_Y/2-cooler_shift, 0, COOLER_D, h],
];
    
//scale([scale_f, scale_f, 1])
//{

for (box = boxes) {
    draw_box(
        box[0], box[1], box[2], box[3], box[4],
        shift_ports,
        scale_d);
}

for (cy = cyls) {
    draw_cyl(
        cy[0], cy[1], cy[2],
        cy[3], cy[4]);
}

if (show_base)
    orange_pi_base();
    
//}

}

module shift_model_center(scale_d = 0)
{

//scale_f = get_scale_f(scale_d);
scale_f = 1;

translate([-get_BOARD_X()*scale_f/2.0, -get_BOARD_Y()*scale_f/2.0, 0])
children();
}

orange_pi_3_zero_model(shift_ports=0);

//t = shift_port(0, -2, 20);