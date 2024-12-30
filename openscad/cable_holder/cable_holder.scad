include <BOSL2/std.scad>


TABLE_WALL_WIDTH = 4;
TABLE_WALL_WIDTH_BOTTOM = 4;


TABLE_WIDTH = 16.6;//6.4; //16.8 bab
TABLE_WALL_LEN = 16.8;
TABLE_WALL_LEN_BOTTOM = 16.8;

H = 14;

WIDTH_INNER = 13.4;
WIDTH_OUTER = 13;//9;
OUTER_LEN = 12;

D = 6;//3.6;
E = 0.1;
R = 1;
N = 4;

FN_HOLE = 6;

BOTTOM_HOLE = true;
HOLE_BOTTOM_D = 4;

PIN_X = 3;
PIN_Y = 7;
PIN_Z = 5;

PINS = false;


function get_hex_cyl_d(dint, fn) = 
    let (a = 360 / fn)
    let (bat_d = dint / cos(a/2))
    bat_d;

module hole_wire(cable_d=D,cyl_l=TABLE_WIDTH+3*TABLE_WALL_WIDTH_BOTTOM+OUTER_LEN)
{

//cyl_l = TABLE_WIDTH+3*TABLE_WALL_WIDTH_BOTTOM+OUTER_LEN;
        cyl_d = get_hex_cyl_d(cable_d, FN_HOLE);
union()
{        
//#rotate([0,180/6,0])
//ycyl(d= cyl_d, l = cyl_l, $fn=FN_HOLE);

cuboid([cable_d, cyl_l, cable_d])
align(TOP)
//translate([0,0,cyl_d/4])
prismoid([cable_d, cyl_l], [cable_d/3, cyl_l], h = cable_d);

}
}
    
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
        
        //align(LEFT+BACK)
        tag("remove")
        translate([0,TABLE_WIDTH*2,0])//-WIDTH_OUTER,0])//-cyl_l+E,0])
        //{
            translate([0,0,0])
            rotate([0,-90,0])
            hole_wire(cable_d, TABLE_WIDTH*10);
            //translate([cyl_d,0,0])
            //#ycyl(d= cyl_d, l = cyl_l, $fn=FN_HOLE);
        
            //#translate([cyl_d/2,0,0])
            //cuboid([cable_d, cyl_l, cable_d]);
            //ycyl(d= cyl_d, l = cyl_l, $fn=FN_HOLE);
        
            
            //translate([0,0,cable_d/4])
            //rotate([0,20,0])
            
            //prismoid([cable_d, cyl_l], [cable_d/2, cyl_l], h = cable_d);
        
        //}
    }
}

};

}

//!hole_wire();

if (N >=2)
{

zcopies(H-TABLE_WALL_WIDTH/2, n=N-2, sp=[0,0,0])
cable_module(bottom_hole=false, rounding=0);

translate([0,0,-H+TABLE_WALL_WIDTH/2])
cable_module(bottom_hole=BOTTOM_HOLE, rounding=R, except=TOP, attach_pin=PINS);


translate([0,0,(H-TABLE_WALL_WIDTH/2)*(N-2)])
mirror([0,0,1])
cable_module(bottom_hole=BOTTOM_HOLE, rounding=R, except=TOP, attach_pin=PINS);
}
else
{
cable_module(bottom_hole=BOTTOM_HOLE, rounding=R, except=TOP, attach_pin=PINS);

translate([50,0,0])
mirror([0,0,1])
cable_module(bottom_hole=BOTTOM_HOLE, rounding=R, except=TOP, attach_pin=PINS);

}