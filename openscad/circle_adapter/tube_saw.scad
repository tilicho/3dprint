include <BOSL2/std.scad>


module tube_saw()
{
    H = 15;
    DEXT = 17.9;
    DIN = 13.2;
    WALL = 2.66;
    $fn = 50;


    pts = [
        [0, 0],
        [-8.21, 0],
        [-8.21, 5],
        [-7.29, 6.7],
        [-7.29, 9],
        [-3.13, 9],
        [-3.13, 5.11],
        [-3.72, 3.8],
        [0, 3.8]];

    module cut_hole()
    { 
        rotate([0, 0, 20])
        translate([0, -3.4, H + 0.01])
        rotate([0, -90, 0])
        linear_extrude(40)    
        polygon(pts);

    }


    difference()
    {
        tube(h=H, od=DEXT, id = 12.8, anchor=BOTTOM);
        cut_hole();
        yflip()
        mirror([-1, 0, 0])
        cut_hole();
    };
}

tube_saw();