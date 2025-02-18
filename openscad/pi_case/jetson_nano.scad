include <BOSL2/std.scad>
include <BOSL2/screws.scad>

H = 14; // Fixed height of all boxes
H2=17;
H3=19;
Hpow=10;

H_USB_C = 5;
H_HDMI = 7;
H_JACK = 6;
H_SD = -3.5;

Hmicro=3;

BOARD_X = 79;
BOARD_Y = 100;
BOARD_Z = 2.1;

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
        cube([
            dx+2*scale_d, 
            dy+2*scale_d, 
            calc_h + 2*scale_d]);
}

module draw_cyl(x,y,z,d,h,anchor=BOTTOM)
{
    calc_x = x < 0 ? BOARD_X + x : x;
    calc_y = y < 0 ? BOARD_Y + y : y;
    calc_z = z;// < 0 ? -BOARD_Z + h : h;
    
    translate([calc_x,calc_y,calc_z])
    zcyl(d=d, h = h, anchor=anchor);

}

module additional_plate_holes(h=H,dx=0)
{

    boxes = [
        [-6-2, -6-3, 6+2+dx, 6+3+dx, h],
        [14-0,-7-2,8+1,7+2+dx,h],
        [-7,7,7+dx,7+3,h],
     ];

     translate([0,0,-h/2])
     for (box = boxes) {
        draw_box(
            box[0], box[1], box[2], box[3], box[4],
            0,
            0);
    }
}


module orange_pi_plate_holes(h = H, d = H_DD)
{
    cyls = [
        //[17,11,0,d,h],
        [17,-4,0,d,h],
        [-4,-4,0,d,h],
        [-4,11,0,d,h],
    ];

    for (cy = cyls) {
        draw_cyl(
            cy[0], cy[1], cy[2],
            cy[3], cy[4],
            anchor=CENTER);
    }

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
    [0, 4, 6, 8+3, Hmicro],
    [0, 15, 21, 16+3, H],
    [0, 34, 17, 13+3, H2],
    [0, 50, 17, 13+5, H2],
    [0,-32,17,17,H3],
    [0,-10-5,14,9+5,Hpow],
    
    [21,8,50,6,h],
    //[-7,2,5,5,h],
    [25,-6,47-1,4,h],
    [40-2,23-2,40+4,59+4,27],
];

COOLER_W = 30;
COOLER_DW = 3;
cooler_shift = COOLER_W/2 - COOLER_DW;
COOLER_D = 3;

cyls = [
    
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

#additional_plate_holes();

//t = shift_port(0, -2, 20);