include <BOSL2/std.scad>

DX = 10.3;// 10.4;//10.6;
DDX = 0.6;
L = 10;
R = 1.5;

W = 1.2;
$fn = 50;

CUT = false;
E = 0.1;

DX2 = 3.1;
L2 = 15;

MODE = "B"; //["A", "B"]



module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module prism()
{
    dxp = DX2;//+2*W;
    dxp2 = DX;
    
    #diff()
    {
    prismoid(
        [dxp2, L],[dxp, L], h=L2, shift=[-(dxp2-dxp)/2,0])
    {
       edge_profile(
              "Y",
              except=BOTTOM,
                        //[TOP+RIGHT, BOT+FRONT], 
              excess=2, convexity=4) 
        {
            mask2d_roundover(h=R/4,       mask_angle=$edge_angle);
        }
    }
    }
}

module sq_base(l = L)
{
    
        
    if (MODE=="A")
    translate([-(DX+2*W)/2-(L2)/2,0,0])
        difference()
        {
            cuboid([L2, DX2+2*W, L], 
                rounding=R,
                edges = LEFT,
                //chamfer = R,
                anchor=CENTER);


            cuboid([L2+E, DX2, L+E], 
                anchor=CENTER);
        }
    //else
    //translate([-(DX+2*W)/2-(L2)/2,
    //            (DX2)/2+W,0])
    //translate([-(DX+2*W)/2-(L2)/2,
    //            -(DX2-DX+2*W)/2,0])
    /*
    {
        
        
        translate([-(DX+2*W)/2-(L2)/2+W/2,
            (dxp+W/2)-E-W,0])
        rotate([0,90,0])
        {
            diff()
            {
                prismoid(
                    [L, dxp],[L, dxp2], h=L2, anchor=CENTER, shift=[0,-(dxp2-dxp)/2])
                {
                    edge_profile(
                        "X",
                        except=TOP,
                        //[TOP+RIGHT, BOT+FRONT], 
                        excess=2, convexity=4) 
                     {
                       mask2d_roundover(h=R/2,       mask_angle=$edge_angle);
                     }
                }
            }
        } */  
            /*
        cuboid([L2, DX2+2*W, L], 
                rounding=R,
                edges = LEFT,
                except=[TOP, BOTTOM],
                //chamfer = R,
                anchor=CENTER);
            */
    //}
    
    //translate([0,0,-DX/2])
    
    difference()
    {
        cuboid([DX+2*W+DDX, DX+2*W, l], 
            rounding=R,
            edges = ["Z",],
            //chamfer = R,
            anchor=CENTER)
         attach(LEFT)
         {
            if (MODE == "B")
                prism();
         }

        //translate([0,0,DX+W])
        cuboid([DX+DDX, DX, l+E], 
            anchor=CENTER);
        
        if (MODE == "A")
            translate([W*2,0,0])
                cuboid([DX+W, DX-W*2, l+E], 
                anchor=CENTER);
    }
    
    

}

sq_base();