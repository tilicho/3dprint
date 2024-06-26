include <BOSL2/std.scad>

DX = 7.8;//10.6;
LEN = 25;
R = 0.9;

W = 1.2;
$fn = 50;

CUT = false;
E = 0.1;

CUT_THROUGH = false;
CUT_THROUGH_MODE = 0;

//FILLETS = false;


THIN_WALLS = true;

CORNER = true;
CORNER_MODE = "3d"; //["3d", "2d", "4d", "3ds"]


FULL_CROSS = (CORNER_MODE == "4d") || (CORNER_MODE == "3ds");
TWO_D_CROSS = CORNER_MODE == "2d";
THRE_D_CROSS = CORNER_MODE == "3d";

CUTTED_THREE_D = CORNER_MODE == "3ds";

L = FULL_CROSS ? LEN * 4/3 : LEN;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module sq_base(cut = false, l = L, dx=DX)
{
translate([0,0,-dx/2])

if (!cut)
{
    difference()
    {
        cuboid([dx+2*E, dx+2*E, l+2*E], 
        //rounding=R,
        //edges = ["Z",],
        chamfer = R,
        anchor=BOTTOM);

        if (THIN_WALLS)
        {
            translate([0,0,dx+W])
            cuboid([dx-2*W+2*E, dx-2*W+2*E, L-dx+2*E], 
                anchor=BOTTOM);
        }
    }
}
else
{
    cuboid([dx, dx, L], 
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
        sq_base(false);

        rotate([90,0,0])
        sq_base(false);
        
        if (!TWO_D_CROSS)
        {
        
            rotate([0,90,0])
            {
                sq_base(false, 
                    dx=CUTTED_THREE_D ? DX+W*4 : DX);
            }
            
            if (FULL_CROSS && !CUTTED_THREE_D) 
            {
                rotate([0,180,0])
                    sq_base(false);
                
            }
            
            
         }
         
         if (THRE_D_CROSS)
            cuboid(DX+2*W, chamfer=W, 
                edges=[[0, -1, 1], 
                    [1, 0, 1],
                    [1,-1,0]]); 
         else
            cuboid(
                CUTTED_THREE_D ? DX+4*W : DX+2*W, chamfer=R, edges="X"); 
    };
    
    cut_through_mode();
    
    if (CUTTED_THREE_D)
    {
        rotate([0,90,0])
        sq_base(true, dx = DX+2*W+0.6);
    }
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
            translate([0,0,(DX+W)*sin(45)])
            cuboid([DX*3, DX*3, DX*2], rounding=R,
                edges = "Z",
                anchor=TOP);
                
            
        }
        else
        {
            dz = sqrt(sqr(DX+W*4)*2) * sin(45);
            dz2 = (L+DX+2*W)*sin(45)-dz;
            #translate([0,0,dz2])
            cuboid([L*2, L*2, DX*2], rounding=R,
                edges = "Z",
                anchor=BOTTOM);
                
                
            dz3 = CUTTED_THREE_D ? DX/2+L*sin(45)/2+W*2: (L+W*2)*sin(45)+DX/2;
            
            #translate([0,0,-dz3])
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