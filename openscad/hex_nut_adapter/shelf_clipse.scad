include <BOSL2/std.scad>

DX = 10.4;//10.6;
DDX = 0.6;
L = 10;
R = 1.5;

W = 1.2;
$fn = 50;

CUT = false;
E = 0.1;

DX2 = 3.1;
L2 = 15;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module sq_base(l = L)
{
    translate([-(DX+2*W)/2-(L2)/2,0,0])
    
    difference()
    {
        cuboid([L2, DX2+2*W, L], 
            rounding=R,
            edges = LEFT,
            //chamfer = R,
            anchor=CENTER);


        //translate([0,0,DX+W])
        cuboid([L2+E, DX2, L+E], 
            anchor=CENTER);
    }
    
    //translate([0,0,-DX/2])
    
    difference()
    {
        cuboid([DX+2*W+DDX, DX+2*W, l], 
            rounding=R,
            edges = ["Z",],
            //chamfer = R,
            anchor=CENTER);


        //translate([0,0,DX+W])
        cuboid([DX+DDX, DX, l+E], 
            anchor=CENTER);
            
        translate([W*2,0,0])
        cuboid([DX+W, DX-W*2, l+E], 
            anchor=CENTER);
    }
    
    

}

sq_base();