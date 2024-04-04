include <BOSL2/std.scad>
include <BOSL2/screws.scad>
spec = screw_info("M6,18",head="hex");
newspec = struct_set(spec,["head_size",20,"head_height",5]);
rotate([180, 0, 0]) 
    screw(newspec, tolerance="6g", thread_len=10);