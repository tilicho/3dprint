include <BOSL2/std.scad>


TABLE_WALL_WIDTH = 2.6;
TABLE_WALL_WIDTH_BOTTOM = 5.6;


TABLE_WIDTH = 17.4;
TABLE_WALL_LEN = 17;
TABLE_WALL_LEN_BOTTOM = 27;

H = 10;

WIDTH_INNER = 6.4;
WIDTH_OUTER = 9;
OUTER_LEN = 12;

D = 3.6;
E = 0.1;
R = 1;
N = 1;

FN_HOLE = 6;

BOTTOM_HOLE = true;
HOLE_BOTTOM_D = 4;

PIN_X = 3;
PIN_Y = 7;
PIN_Z = 5;


function get_hex_cyl_d(dint, fn) = 
    let (a = 360 / fn)
    let (bat_d = dint / cos(a/2))
    bat_d;

    
module cable_module(cable_d=D, bottom_hole=BOTTOM_HOLE, rounding=R, except="NONE", attach_pin=false)
{

diff()
{

translate([(TABLE_WALL_LEN_BOTTOM-TABLE_WALL_LEN)/2,0,0])
cuboid([TABLE_WALL_LEN_BOTTOM, TABLE_WALL_WIDTH_BOTTOM, H], rounding=rounding, edges="X", except=except)
{
    align(BACK+LEFT)
    translate([0,-TABLE_WALL_WIDTH_BOTTOM,0])
    cuboid([WIDTH_INNER, TABLE_WIDTH+TABLE_WALL_WIDTH_BOTTOM+TABLE_WALL_WIDTH, H],
        rounding=rounding, edges="X", except=except)
    {
    if (attach_pin)
    {
        align(BOTTOM+LEFT)
        cuboid([PIN_X, PIN_Y, PIN_Z], rounding=rounding, edges="X", except=TOP);
    }
    };
        
        
    if (bottom_hole)
    {
    hole_d = get_hex_cyl_d(HOLE_BOTTOM_D, 6);
    align(FRONT)
    tag("remove")
    translate([0,TABLE_WALL_WIDTH_BOTTOM+E,0])
    ycyl(d = hole_d, l = TABLE_WALL_WIDTH_BOTTOM+2*E);
    }
    
    
};

translate([0, 
    TABLE_WIDTH+TABLE_WALL_WIDTH_BOTTOM/2+TABLE_WALL_WIDTH/2,
    0])
cuboid([TABLE_WALL_LEN, TABLE_WALL_WIDTH, H],
    rounding=rounding, edges="X", except=except) //
{
    dy = TABLE_WALL_WIDTH/2;
    
    align(BACK+LEFT)
    translate([WIDTH_OUTER-WIDTH_INNER,-dy,0])
    cuboid([WIDTH_OUTER, OUTER_LEN+dy, H],rounding=rounding, edges="X", except=except)
    {
        cyl_l = TABLE_WIDTH+3*TABLE_WALL_WIDTH_BOTTOM+OUTER_LEN;
        cyl_d = get_hex_cyl_d(cable_d, FN_HOLE);
        
        align(LEFT+BACK)
        tag("remove")
        translate([0,-cyl_l+E,0])
        {
            translate([cyl_d,0,0])
            ycyl(d= cyl_d, l = cyl_l, $fn=FN_HOLE);
        
            translate([cyl_d/2,0,0])
            ycyl(d= cyl_d, l = cyl_l, $fn=FN_HOLE);
        }
    }
}

};

}

if (N >=2)
{

zcopies(H-TABLE_WALL_WIDTH/2, n=N-2, sp=[0,0,0])
cable_module(bottom_hole=BOTTOM_HOLE, rounding=0);

translate([0,0,-H+TABLE_WALL_WIDTH/2])
cable_module(bottom_hole=BOTTOM_HOLE, rounding=R, except=TOP, attach_pin=true);


translate([0,0,(H-TABLE_WALL_WIDTH/2)*(N-2)])
mirror([0,0,1])
cable_module(bottom_hole=BOTTOM_HOLE, rounding=R, except=TOP, attach_pin=true);
}
else
{
cable_module(bottom_hole=BOTTOM_HOLE, rounding=R, except=TOP, attach_pin=true);

translate([50,0,0])
mirror([0,0,1])
cable_module(bottom_hole=BOTTOM_HOLE, rounding=R, except=TOP, attach_pin=true);

}