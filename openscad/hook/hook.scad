include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/turtle3d.scad>
//color("green")stroke(square(4), width=0.1);
$fn=40;
H1 = 30;
W1 = 25;
H2 = 50;
W2 = 20;
H3 = 30;
W = 4.2;
S = 5;

module hook_smooth_path()
{
    path=[
    [0, 0], [0, H1], 
    [W1, H1], [W1, H1-H2], 
    [W1 + W2, H1 - H2], [W1 + W2, H1 - H2 + H3]
    ];

    linear_extrude(W)
    stroke(smooth_path(path, size=S), width=W);
}

module offset_path()
{
    path=[
    [0, 0], [0, H1], 
    [W1, H1], [W1, H1-H2], 
    [W1 + W2, H1 - H2], [W1 + W2, H1 - H2 + H3]
    ];

    linear_extrude(W)
    offset_stroke(path, width=W, $fn=16);

}

module turtle_path()
{

    path = turtle3d(
        [
           // "up",
            "move", H1, 
            
            "left", 
            "move", W1,
            
            "left",
            "move", H2,
            
            "right",
            "move", W2,
            
            "right",
            "move", H3,
        
        ]
    );
    
    stroke(path, width=5);
}

hook_smooth_path();

//offset_path();

//turtle_path();