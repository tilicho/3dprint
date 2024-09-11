include <BOSL2/std.scad>
txt = "совершенно секретно ";
txt2="ССБ";
D = 40;
SA = 90;
H = 5;
TEXT_EXTRUDE = 1.2;
FONT_SIZE = 8;
$fn=80;
E = 0.1;
font = "Helvetica Neue";//"Lucida Calligraphy";

module frame_cyl(d, w=0.6, h=TEXT_EXTRUDE, anchor=TOP)
{
    difference()
    {
        cyl(d=d,h=h,anchor=anchor);
        down(E/2)
        cyl(d=d-w,h=h+E,anchor=anchor);
    };
}


yflip()
{

linear_extrude(TEXT_EXTRUDE)
arc_copies(d=D, n=len(txt), sa=SA, ea=SA+360)
    text(select(txt,-0-$idx), size=FONT_SIZE, 
    anchor=str("baseline",CENTER), 
    font=font,//"Times New Roman",
    spacing=1.2,
    spin=-90);
    
    
 linear_extrude(TEXT_EXTRUDE)
    text(
    txt2, size=FONT_SIZE, 
    anchor=CENTER, 
    font=font,//"Times New Roman",
    spacing=1.2,
    spin=-90);
    
 cyl(d=D+FONT_SIZE*2+2, d2=D+FONT_SIZE*2, h = H, anchor=TOP);
 
 frame_cyl(D+FONT_SIZE*2, anchor=BOTTOM);
 
 frame_cyl(D-FONT_SIZE, anchor=BOTTOM);
 };