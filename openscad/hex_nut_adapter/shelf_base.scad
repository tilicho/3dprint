include <BOSL2/std.scad>

DX = 10.4;//20.2;//10.4;//10.6;
LEN = 30;//55;//30;
R = 1.8;

W = 1.2;
$fn = 50;

CUT = false;
E = 0.1;

CUT_THROUGH = false;
CUT_THROUGH_MODE = 0;

FILLETS = false;




CORNER = true;
CORNER_MODE = "2d"; //["3d", "4d", "2d"]


FULL_CROSS = CORNER_MODE == "4d";
TWO_D_CROSS = CORNER_MODE == "2d";


L = FULL_CROSS ? LEN * 4/3 : LEN;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module sq_base(cut = false, l = L)
{
translate([0,0,-DX/2])

if (!cut)
{
    difference()
    {
        cuboid([DX+2*W, DX+2*W, l], 
        rounding=R,
        //edges = ["Z",],
        //chamfer = R,
        anchor=BOTTOM);


        translate([0,0,DX+W])
        cuboid([DX, DX, L-DX], 
            anchor=BOTTOM);
    }
}
else
{
    cuboid([DX, DX, L], 
        anchor=CENTER);
    
}

}

module cut_through_mode()
{
    if (CUT_THROUGH)
    {    
        if (FULL_CROSS)
        {
            if (CUT_THROUGH_MODE == 0)
            {
                rotate([90,0,0])
                    sq_base(true);
                
            }
            else
            {
                sq_base(true);
            }
        }
        else
        {
            sq_base(true);
        }
    }
}

module cross()
{

difference()
{
    union()
    {
        lk = FULL_CROSS ? 1.5 : 1.0;
        
        sq_base(false);

        rotate([90,0,0])
        sq_base(false);
        
        if (!TWO_D_CROSS)
        {
        
            rotate([0,90,0])
            sq_base(false);
            
            if (FULL_CROSS) 
            {
                rotate([0,180,0])
                    sq_base(false);
                
            }
            
            if (FILLETS)
            {
                translate([DX/2+W, -DX/2-W, 0])
                fillet(l = DX, r = 5, spin=270);
                
                translate([0, -DX/2-W, DX/2+W])
                fillet(l = DX, r = 5, spin=180, orient=RIGHT);
                
                translate([DX/2+W, 0, DX/2+W])
                fillet(l = DX, r = 5, spin=0, orient=FRONT);
                
                if (FULL_CROSS)
                {
                translate([DX/2+W, 0, -DX/2-W])
                fillet(l = DX, r = 5, spin=0, orient=BACK);
                
                translate([0, -DX/2-W, -DX/2-W])
                fillet(l = DX, r = 5, spin=180, orient=LEFT);
                }
            }
         }
    };
    
    cut_through_mode();
}

}

module turn_full_cross()
{
    if (FULL_CROSS) 
        rotate([180,0,0]) children();
    else
        children();
}

module print_cross()
{
    turn_full_cross()
    difference()
    {
        if (!TWO_D_CROSS)
        {
            rotate([-45,-atan(cos(45)),0])
            translate([DX/2, -DX/2, DX/2])
            cross();
        }
        else
        {
            rotate([-45,0,0])
            translate([0, -DX/2, DX/2])
            cross();
        }

        if (!FULL_CROSS)
        {
            #
            translate([0,0,-DX/2])
            cuboid([DX*2, DX*2, DX], rounding=R,
                edges = "Z",
                anchor=BOTTOM);
                
            
        }
        else
        {
            dz = sqrt(sqr(DX+W*4)*2) * sin(45);
            dz2 = (L+DX+2*W)*sin(45)-dz;
            #translate([0,0,dz2])
            cuboid([L*2, L*2, DX*2], rounding=R,
                edges = "Z",
                anchor=BOTTOM);
                
            #translate([0,0,-(L+W*2)*sin(45)+DX/2])
            cuboid([L*2, L*2, DX*2], rounding=R,
                edges = "Z",
                anchor=BOTTOM);
        }
    }
}


perform_cut()
{
print_cross();
//sq_base();

//cross();
}