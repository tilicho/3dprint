include <BOSL2/std.scad>

module round_corner2(dz, r, e=E)
{
    dx = 3 * r;
    
    translate([0, 0, -dz/2])
    difference()
    {
        cuboid([dx-r*2, dx-r*2, dz], p1 = [0,0,0] 
                );
        
        translate([r, -e, 0])
        cuboid([dx-r*2, dx-r*2, dz], p1 = [0,0,0]);
    
        translate([-e, r, 0])
        cuboid([dx-r*2, dx-r*2, dz], p1 = [0,0,0]);
    
        //translate([0, e, 0])
        //cuboid([dx-r*2, dy-r*2, dz], p1 = [0,0,0]);
    
        translate([0, 0, -e])
        cuboid([dx, dx, dz+2*e], rounding = r, edges = ["Z"],
                p1 = [0,0,0]);

        /*translate([0, 0, -e-R*3-dz/2])
        cuboid([dx, dx, dz+2*e], rounding = r, edges = ["X"],
                p1 = [0,0,0]);

        translate([0, 0, e+R*3+dz/2])
        cuboid([dx, dx, dz+2*e], rounding = r, edges = ["X"],
                p1 = [0,0,0]);
*/
    };
}
R = 10;
$fn = 50;
E = 0.001;

path = [ [0, 0, 0], [33, 33, 33], [66, 33, 40]];
//, [66, 33, 40], [100, 0, 0], [150,0,0] ];

module round_corner2d(r = R, e = 0.001)
{
    translate([-r, -r, 0])
    difference()
    {
    rect(r, anchor = BOTTOM + LEFT);
    arc(r = r + e, angle = 90, wedge = true);
    };
}


//round_corner2d();


color("blue") path_extrude(path) round_corner2d(10);

path_extrude(path) mask2d_roundover(r=10);


//path_extrude(path) circle(r=10);

//circle(r=10);