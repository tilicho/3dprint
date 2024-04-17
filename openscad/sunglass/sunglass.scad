include <BOSL2/std.scad>

H1 = 18.6;
H2 = 17.6;
R1 = 11;
R1_ = 10;
R2 = 6;
R2_ = 5;
X1 = 11;
W = 6.3;
W2 = 1.8;
DX = 10;

IR = 1;
$fn = 50;

module pie_slice_pro(
    ang1, ang2, l, r1, r2)
{
    rotate([0, 0, ang1])
    pie_slice(ang=ang2 - ang1, l=W, r1=R2, r2=R2_);

}

module ver1()
{

    DRX = (H1 - H2) + (R1 - R1_);

    rotate([180, 0, 0])
    {

    rotate([90, 0, 0])
    prismoid(size1=[X1, H1+R1], 
        size2=[X1, H2+R1_], 
        h = W,
        rounding = [IR, IR, 0, IR]);
        
        

    translate([X1/2, 0, (H1 - R1)/2])
    difference()
    {
    translate([0, 0, H1/2])
    rotate([0, 180, 0])
    rotate([90, 0, 0])
    pie_slice(ang=90, l=W, r1=R1, r2=R1_);


    //DRX = H2 - H1;

    translate([-X1/2, 0, H1/2+R1/2])
    rotate([90, 0, 0])
    prismoid(size1=[R1*2, R1], 
        size2=[R1*2+DRX, R1+DRX], 
        h = W,
        rounding = IR);
    }

    difference()
    {
    translate([-X1/2, 0, -(H1+R1)/2])//H1/2+R2/2])

    rotate([0, 180, 0])
    rotate([90, 0, 0])
    pie_slice_pro(ang1=270, ang2=360, l=W, r1=R2, r2=R2_);

    //DRX = H2 - H1;

    translate([-X1/2, 0, -(H1+R1)/2 - R2/2])//-H1/2-R1/2-R2/2])
    rotate([90, 0, 0])
    prismoid(size1=[R2*2, R2], 
        size2=[R2*2+DRX, R2+DRX], 
        h = W);//,
        //rounding = IR);

    }
    }
}

DY = R1 + H1 + W2;//R2;
DRX = (H1 - H2) + (R1 - R1_);
E = 0;

rotate([0, 90, 0])
difference()
{

translate([-R2/2, -W/2, 0]) rotate([90, 0, 0])cuboid([DX, DY+E, W+W2*2], rounding=IR, edges="X");

difference()
{
translate([-R2/2, -W/2, 0]) rotate([90, 0, 0])cuboid([R1+R2-E, DY-E, W-E]);

translate([R1/2, 0, DY/2])
    rotate([0, 180, 0])
    rotate([90, 0, 0])
pie_slice(ang=90, l=W, r1=R1, r2=R1_);


/*translate([-X1/2, 0, -DY/2])//H1/2+R2/2])
rotate([0, 180, 0])
rotate([90, 0, 0])
pie_slice_pro(ang1=270, ang2=360, l=W, r1=R2, r2=R2_);

*/
#translate([-W/2, 0, -DY/2+W2/2])//+R2/2])//H1/2+R2/2])
rotate([90, 0, 0])
    prismoid(size1=[DX, W2],//R2], 
        size2=[DX, W2],//R2_], 
        h = W);
};

}
//pie_slice_pro(ang1=90, ang2=180, l=W, r1=R2, r2=R2_);