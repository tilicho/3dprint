include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

DX = 52.8;
DY = 20;
DZ = 6;
E = 0.1;
D = 3.2;
D2 = 7.2;

$fn = 30;
R = 2;
CORNER = true;



module wall(x = DX, y = DY, z = DZ, edg = "Z")
{
    shift_hole = CORNER ? 0 : z/2;
    diff()
    cuboid([x, y, z], p1 = [0,0,0], rounding=R, edges=edg)
    {
        tag("remove") 
        attach(TOP) 
        translate([z/2, shift_hole, -z - E]) 
        cylinder(z + 2 * E, d2 = D2, d1 = D, center = false); 
    }

}

module round_corner()
{
    difference()
    {
        translate([DZ, DZ, 0]) 
        cuboid([DZ-R*2, DZ-R*2, DX], p1 = [0,0,0]);
    
        translate([DZ, DZ, -E])
            cuboid([DZ, DZ, DX+2*E], rounding = R, edges = "Z",
                p1 = [0,0,0]);
    };
    
}

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


wall(DY, DY, DZ);


mirror([1, 0, 0])
rotate([0, -90, 0])
wall(DX, DY, DZ, "X");

if (!CORNER)
{

    rotate([0, 0, -90])
    rotate([0, -90, 0])
    wall(DX, DY, DZ, "X");

    round_corner();
    
    path = [
        [R, DY - R],
        [DZ, DY-R],
        [DZ, DZ],
        [DY-R, DZ],
        [DY-R, R]
        ];
    path_smooth = round_corners(path, radius=R, closed = false);

    translate([0,0,DZ])
    path_extrude(path_smooth) 
    rotate([0, 180, 0]) 
    mask2d_roundover(r=R);


}
else
{
    
    /*translate([DZ, DY/2, DZ]) 
    rotate([90, 0, 0])
    round_corner2(DY-2*R, R*2);*/

    path = [[R,R], [DZ,R], [DZ, DY-R], [R, DY-R]];
    path_smooth = round_corners(path, radius=R, closed = false);

    translate([0,0,DZ])
    path_extrude(path_smooth) 
    rotate([180, 180, 0]) 
    mask2d_roundover(r=R);


}