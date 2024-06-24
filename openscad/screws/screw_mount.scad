include <BOSL2/std.scad>
include <BOSL2/screws.scad>

NUT_THREAD = "M8";

SCREW_LEN = 10;
SCREW_D = "M8";
THREAD = str(SCREW_D, ",", str(SCREW_LEN));
THREAD_D_EXT = 10;//10;
THREAD_LEN_SCREW = 10;

SLOP = 0.2;
SLOP_SCREW = 0.05;
HEAD_SIZE = 10;
HEAD_H = 10;
HEAD_TYPE="hex";//"socket";

$fn=50;

CON_X = 17;
CON_Y = 3;
CON_Z = 12;
CON_E = 0;//0.02;
CON_R = 6;
CON_ANCHOR = LEFT;
CON_THREADED = true;

THREAD_LEN = CON_Y*2+CON_E*2;
E = 0.1;

CON_LEFT = 1;
CON_RIGHT = 2;

SHOW_CON = "ALL";//["ALL", "LEFT", "RIGHT"]

SHOW = (SHOW_CON == "ALL" ? [CON_LEFT, CON_RIGHT] :
    (SHOW_CON == "LEFT" ? [CON_LEFT] : [CON_RIGHT]));

module perform_cut(cut=false)
{
    if (cut)
        front_half(s=200) children();
    else children();
}

module hole(hole_len, thread=true, slop=SLOP,
    teardrop=true)
{
    if (thread)
        screw_hole(NUT_THREAD, l=hole_len
                  , head="none", 
                  thread=thread,  
                  tolerance="8G", 
                  $slop=slop,
                  teardrop=teardrop,
                  bevel=true
                  );
    else
        screw_hole(NUT_THREAD, l=hole_len, head="none", 
                  thread=false,  
                  //tolerance="8G", 
                  $slop=slop);
                  //anchor=anchor);
}

module hole_hex(hole_len,rot_cyl=180/6)
{
    yrot(rot_cyl)
      ycyl(
         d = THREAD_D_EXT, 
         l=hole_len+E, $fn=6);
}

module screw_(anchor=CON_ANCHOR, 
    screw_len=SCREW_LEN)
{
    thread = str(SCREW_D, ",", str(screw_len));

    spec = screw_info(thread,head=HEAD_TYPE);
    newspec = struct_set(spec,[
        "head_size",HEAD_SIZE,
        "head_height",HEAD_H]
        );

    screw(newspec, 
        //tolerance="6e", 
        thread_len=THREAD_LEN_SCREW, 
        atype="shaft",
        undersize=SLOP_SCREW);
        //anchor=anchor);
}


module connection_base(h, dx, dy, threaded = true, anchor=CON_ANCHOR,
    rot_cyl = 180/6, slop=SLOP)
{
    dx_shift = 0;//sqrt(dx*dx / 4 + h*h/4) - min(dx,h)/2;
    diff()
    {
       cuboid([h, dy, h],
           rounding=h/2,//CON_R,
                edges = "Y",
                except=[RIGHT],
                anchor=anchor)
      {
            if (threaded)
                tag("remove")
                rotate([90,0,0])
                hole(dy+E, slop=slop);
            else
                tag("remove")
                attach(CENTER)
                hole_hex(dy+E,rot_cyl=rot_cyl);
       
            attach(RIGHT)
            {
                cuboid([dy, h, dx-h]
                 ,anchor=BOTTOM);
            };
       }
       
    }
}


module connection(
    h = CON_Z,
    dx = CON_X,
    dy = CON_Y,
    threaded = true, 
    anchor = CON_ANCHOR,
    show = [CON_LEFT, CON_RIGHT],
    rot_cyl = 180/6,
    slop=SLOP)
{
    show_left = len(search(CON_LEFT, show));
    show_right = len(search(CON_RIGHT, show));
    
    shift_y = dy/2+CON_E/2;
    dx_shift = 0;//sqrt(dx*dx / 4 + h*h/4) - min(dx,h)/2;
    
    if (show_left)
    translate([dx_shift, shift_y,0])
    connection_base(h, dx, dy, threaded=threaded, anchor=anchor, rot_cyl = rot_cyl, slop=slop);
    
    
    if (show_right)
    //rotate([0,45,0])
    translate([-dx_shift, -shift_y,0])
    xflip()
        connection_base(h, dx, dy, threaded=threaded, anchor=anchor, rot_cyl = rot_cyl, slop=slop);

}

module test_screw()
{

perform_cut(true)
{
rotate([0,180,0]) screw_(screw_len=20);

difference()
{
cuboid([20, 10, 5]);
hole(6, thread=false);
}
}
}

module test_connection()
{
connection(
        h=12
        ,dx = 60 
        ,dy = 5
        ,threaded=true 
        ,show=[1] 
        ,anchor=RIGHT);
        
}
//rotate([90,0,0])
//connection(threaded = CON_THREADED, show=SHOW);
//test_screw();

test_connection();
