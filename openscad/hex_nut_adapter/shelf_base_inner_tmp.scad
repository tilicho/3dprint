include <BOSL2/std.scad>

DX = 7.9;//7.8;//10.6;
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
CORNER_MODE = "3d"; //["3d", "2d", "4d", "2ds"]


FULL_CROSS = CORNER_MODE == "4d";
TWO_D_CROSS = (CORNER_MODE == "2d") || (CORNER_MODE == "2ds");
THRE_D_CROSS = CORNER_MODE == "3d";

ROTATED_TWO_D_CROSS = (CORNER_MODE == "2ds");

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
        cuboid([dx, dx, l], 
        //rounding=R,
        //edges = ["Z",],
        chamfer = R,
        anchor=BOTTOM);

        if (THIN_WALLS)
        {
            translate([0,0,dx+W])
            cuboid([dx-2*W, dx-2*W, L-dx], 
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
            
            
         }
         
         if (THRE_D_CROSS)
            cuboid(DX+2*W, chamfer=W, 
                edges=[[0, -1, 1], 
                    [1, 0, 1],
                    [1,-1,0]]); 
         else
         {
            if (ROTATED_TWO_D_CROSS)
            {
                dx = DX + 4*W + 4*E;
                dx2 = W*2;
                
                translate([0, dx2, -dx2])
                cuboid([dx-4*W-4*E,dx,dx]
                    , chamfer=W, 
                    edges=["X"]
                    //,except=[[1,-1,1]]
                    );
                //translate([0, -dx/2, dx/2])
                //cuboid([dx+E, dx/2, dx/2]);
                //}
            }
            else
            {
                cuboid(DX+2*W, chamfer=W, edges="X"); 
            }
        }
    };
    
    cut_through_mode();
    
    if (ROTATED_TWO_D_CROSS)
    {
    dx =  DX + 2*W + 4*E;
    dx2 = W*3/2;
    translate([0, dx2, -dx2])
    cuboid([dx,dx,dx]); 
    }
}

}

module turn_full_cross()
{
    if (FULL_CROSS || ROTATED_TWO_D_CROSS) 
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
            if (ROTATED_TWO_D_CROSS)
            {
                dz = (W*2+L) * cos(45) - (DX*sin(45))/2;
                translate([0,0,dz])
                cuboid([L*2, L*2, DX*2], rounding=R,
                    edges = "Z",
                    anchor=BOTTOM);
            }
            else
            {
                translate([0,0,(DX+W)*sin(45)])
                cuboid([DX*3, DX*3, DX*2], rounding=R,
                edges = "Z",
                anchor=TOP);
            }
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
    
    if (ROTATED_TWO_D_CROSS)
    {
    #translate([0,0,-(2*DX+1*W)*cos(45)+E*4])
        cuboid([DX, L-W*8, W-E*2], anchor=BOTTOM);
    }
}


perform_cut()
{
print_cross();
//sq_base();

//cross();
}