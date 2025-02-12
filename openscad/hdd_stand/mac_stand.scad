include <BOSL2/std.scad>

W = 19.2;
L = 25;//[0:1:100]

BASE = 20;
H2 = 0; //9
H = 2.4 + H2 + BASE;//[0:1:100]

WS = 1.2 * 7;
HS = 35 + BASE + H2;//[0:1:100]

WB = 35;//[0:1:100]
R = 1;

$fn=50;

HALF_SUPPORT = true;

E = 0.1;

module round_corner(dz, r, e=E)
{
    dx = 4 * r;
    
    translate([0, 0, -dz/2])
    difference()
    {
        cuboid([dx-r*2, dx-r*2, dz], p1 = [0,0,0]);
        
        translate([r, -e, 0])
        cuboid([dx-r*2, dx-r*2, dz], p1 = [0,0,0]);
    
        translate([-e, r, 0])
        cuboid([dx-r*2, dx-r*2, dz], p1 = [0,0,0]);
    
        //translate([0, e, 0])
        //cuboid([dx-r*2, dy-r*2, dz], p1 = [0,0,0]);
    
        translate([0, 0, -e])
        cuboid([dx, dx, dz+2*e], rounding = r, edges = "Z",
                p1 = [0,0,0]);
    };
}

module stand()
{
    cuboid([W, L, H ]);

    translate([W/2+WS/2, 0, HS/2 - H/2])
    cuboid([WS, L, HS],
        rounding=R, 
        edges="Y", except=BOTTOM
        );

    translate([-W/2-WS/2, 0, HS/2 - H/2])
    cuboid([WS, L, HS],
        rounding=R, 
        edges="Y", except=BOTTOM
        );

    translate([-W/2-WS/2-WB/2, 0, -H/2+WS/2])
    cuboid([WB, L, WS],
        rounding=R, 
        edges="Y", except=RIGHT
    );

    if (!HALF_SUPPORT)
    {
        translate([W/2+WS/2+WB/2, 0, -H/2+WS/2])
        cuboid([WB, L, WS], 
            rounding=R, 
            edges="Y", except=LEFT
            );
            
        translate([W/2+WS, 0, -H/2+WS])
        rotate([90, 0, 0])
        round_corner(L, R);
    }
    

    mirror([1, 0, 0])
    translate([W/2+WS, 0, -H/2+WS])
    rotate([90, 0, 0])
    round_corner(L, R);

    translate([W/2, 0, H/2])
    mirror([1, 0, 0])
    rotate([90, 0, 0])
    round_corner(L, R);

    mirror([1,0,0])
    translate([W/2, 0, H/2])
    mirror([1, 0, 0])
    rotate([90, 0, 0])
    round_corner(L, R);
}

rotate([90, 0, 0])
stand();
