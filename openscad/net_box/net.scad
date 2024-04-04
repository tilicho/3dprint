Sx = 20;// [1:1:1000]
Sy = 20;// [1:1:1000]
Sw = 1.2;// [0.1:0.1:2.0]
Swsp = 1.2;//[0.1:0.1:5.0]
Sh = 2.4;//[0.1:0.1:3]

Salpha = 45;//[0:1:180]
Nx = 20;// [1:1:1000]
Ny = 20;// [1:1:1000]
FrameW = 2.4;// [0.1:0.1:100]

module net(sx = Sx, sy = Sy, h = Sh, w = Sw, ws = Swsp)
{
    translate([-sx/2, -sy/2, 0])
    {
        dx = (w + ws);
        for (x = [0:dx:sx])
        {
            translate([x, 0, 0]) cube(size = [w, sy, h]);
        }
    
        dy = (w + ws);
        for (y = [0:dy:sy])
        {
            translate([0, y, 0]) cube(size = [sx, w, h]);
        }
    }
}

module rot_net(
    alpha = Salpha,
    nx = Nx, ny = Ny,
    frameW = FrameW,
    h = Sh, w = Sw, ws = Swsp)
{
    union()
    {
    
        difference()
        {
            translate([-nx/2 - frameW, -ny/2 - frameW, 0]) cube(size=[nx + 2*frameW, ny + 2 * frameW, h]);
            translate([-nx/2, -ny/2, 0]) cube(size=[nx, ny, h]);
        }
        
        intersection()
        {
            {
                translate([-nx/2, -ny/2, 0]) cube(size=[nx, ny, h]);
            }
       
            {
                sx = nx * cos(alpha) + ny * cos(90 - alpha);
                sy = nx * cos(90-alpha) + ny * cos(alpha);
                rotate([0, 0, alpha]) net(sx, sy, h, w, ws);
            }
        }
    }
}


//net();
rot_net(0);
translate([0, -Ny/2, Nx/2 + FrameW]) rotate([90, 0, 0]) rot_net();
translate([0, Ny/2 + FrameW, Nx/2 + FrameW]) rotate([90, 0, 0]) rot_net();

translate([-Nx/2 - FrameW, 0, Nx/2 + FrameW]) rotate([0, 90, 0]) rot_net();
translate([Nx/2, 0, Nx/2 + FrameW]) rotate([0, 90, 0]) rot_net();

















