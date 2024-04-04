include <BOSL2/std.scad>
include <BOSL2/screws.scad>

M=38;
M_STEP = 2;
D=35;
WALL=3;
WALL_C=1.8;
L=25;
TL=12;
TL2=10;
$fn=60;
FN_OUTER=15;
CUT=true;
JOIN_L = 0.5;

DRAW_UP=true;
DRAW_DOWN=true;
Chamfer = 2;

MS = str_join(["M", str(M), str("x",M_STEP)]);

module chamfer_cyl(d1, d2)
{
    e = 0.01;
    cha = (d2 - d1) / 2.0;
    diff()
    cyl(d = d2, h = cha)
    tag("remove") cyl(d = d2, h = cha+e, chamfer1 = cha);
}

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module up_screw()
{
    din = D+WALL * 1.8;
    
    
    
    diff()
    screw(MS, l=L+WALL_C, thread_len=TL, head="none", bevel1=true, tolerance="8e", anchor=BOTTOM, $fn=FN_OUTER)
    {
        attach(TOP) move([0,0,-(L-TL)-WALL_C]) cyl(d=M+WALL, l = L-TL+WALL_C, center=false, chamfer2=Chamfer);
        
        tag("remove") move([0,0,-1-L-WALL_C]) attach(TOP) cyl(d=D, l=L, center=false, chamfer2=Chamfer);
        
        tag("remove") move([0,0,-L+TL+1]) attach(TOP) cyl(d=din, l=L-TL-WALL, center=false, chamfer2=Chamfer);
        
    };

    move([0, 0, TL+3.8]) chamfer_cyl(D, din);    
    //echo("D", D, "Din", din);
    
}

module down_screw()
{
    diff()
    cyl(d=M+WALL, l=L+WALL_C+TL2, anchor=TOP, $fn=FN_OUTER, chamfer1=Chamfer)
    {
        attach(TOP) 
            screw_hole(MS, l=TL2, head="none", thread=true, anchor=TOP, tolerance="8G", $slop=0.1);//, bevel1="reverse");
        
        tag("remove") move([0, 0, -L-TL2]) attach(TOP) cyl(d=D, l=L+TL2, center=false, chamfer1=Chamfer);
        
        tag("remove") move([0,0,-L-TL2]) attach(TOP) cyl(d=D + WALL * 1.8, l=L, center=false, chamfer1=Chamfer);
    }
}

module rotate_up()
{
    if (DRAW_UP && !DRAW_DOWN)
    {
        rotate([0,180,0]) children();
    }
    else
    {
        children();
    }
}


perform_cut()
{

    if (DRAW_UP)
    {
        move([0, 0, -TL+JOIN_L+0.5])
        rotate_up()
        color("green") up_screw();
    }


    if (DRAW_DOWN)
    {
        down_screw();
    }
    
    //!tube(h=2, od=26.4, id = 23.7, anchor=BOTTOM);

}
//#circle(d=D);