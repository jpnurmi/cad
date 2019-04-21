front_width = 4200;
front_height = 2400;

back_width = 4200;
back_height = 2100;

side_width = 2100;

base_depth = 2100;

wall = 100;
roof_height = 300;

door_width = 900;
door_height = 1800;

front_window_width = 1200;
front_window_height = 1200;
front_window_bottom = 600;
front_spacing = (front_width - front_window_width - door_width) / 3;

side_window_width = 1200;
side_window_height = 600;
side_window_bottom = 1200;
side_spacing = (side_width - side_window_width) / 2;

chimney_x = 220;
chimney_y = 220;
chimney_size = 120;
chimney_height = 3000;

$vpt = [400, 200, 1000];
$vpr = [60, 0, 40];
$vpd = 16000;

//offset = [-(front_width + back_width) / 4, -side_width / 2];
//translate(offset) sauna();
sauna();

module sauna() {
    base();
//    translate([0, 0, back_height]) {
//        roof();
//    }
//    chimney();
}

module side_wall()
{
    points = [
        [0, wall, 0],
        [0, wall + side_width, 0],
        [0, wall + side_width, back_height],
        [0, wall, front_height],
        [wall, wall, 0],
        [wall, wall + side_width, 0],
        [wall, wall + side_width, back_height],
        [wall, wall, front_height]
    ];
    faces = [
        [0, 1, 2, 3], [3, 2, 1, 0],
        [4, 5, 6, 7], [7, 6, 5, 4]
    ];

    difference() {
        polyhedron(points, faces, convexity = 10);

        // window hole
        translate([-1, wall + side_spacing, side_window_bottom]) cube([wall + 2, side_window_width, side_window_height]);
    }
}

module bottom(w, d, h)
{
    color() {
        for (i = [0:2]) {
            translate([0, i * (d / 2 + 45), 0]) cube([w + 45, 45, h]);
        }
    }

    color() {
        for (i = [0:7]) {
            translate([i * 600, 45, 0]) cube([45, d / 2, h]);
            translate([i * 600, d / 2 + 2 * 45, 0]) cube([45, d / 2, h]);
        }
    }

    color("green") {
        translate([0, 0, h]) {
            cube([w + 45, 90, 45]);
            translate([0, d + 45, 0]) cube([w + 45, 90, 45]);

            translate([0, 90, 0]) cube([90, d - 45, 45]);
            translate([w - 45, 90, 0]) cube([90, d - 45, 45]);
        }
    }
}

module front_wall(w, h)
{
    color("blue") {
        for (i = [0:7]) {
            translate([i * 600, 0, 0]) cube([45, 90, h]);
        }
    }
    color("magenta") {
        translate([0, 0, h]) cube([w + 45, 90, 45]);
    }
}

module back_wall(w, h)
{
    color("blue") {
        for (i = [0:7]) {
            translate([i * 600, 0, 0]) cube([45, 90, h]);
        }
    }
    color("magenta") {
        translate([0, 0, h]) cube([w + 45, 90, 45]);
    }
}

module side_wall(w, fh, bh)
{
    translate([0, 90, 0]) {
        color("red") {
            difference() {
                union() {
                    for (i = [0:4]) {
                        h = fh - (fh - bh) / 4 * i;
                        translate([0, i * 600, 0]) cube([90, 45, h]);
                    }
                }
                translate([-1, 1200-1, 1200-1]) cube([92, 47, 645]);
            }
            translate([0, 600 + 45, 0]) cube([90, 45, 1800]);
            translate([0, 1800 - 45, 0]) cube([90, 45, 1800]);

            translate([0, 600 + 90, 0]) cube([90, 45, 1200]);
            translate([0, 1800 - 90, 0]) cube([90, 45, 1200]);

            translate([0, 600 + 45, 1800]) cube([90, 1200 - 45, 45]);
            translate([0, 600 + 90, 1200]) cube([90, 1200 - 135, 45]);
        }
    }
    color("magenta") {
        a = pow(w, 2);
        b = pow(fh - bh, 2);
        l = sqrt(a + b);
        // ### TODO: calculate the angle
        translate([0, 45, fh]) rotate([-7, 0, 0]) cube([90, l, 45]);
    }
}

module base()
{
    w = 4200;
    d = 2400 + 90;
    b = 170;
    fh = 2400;
    bh = 2100;

    bottom(w, d, b);
    translate([0, 0, 170 + 45]) {
        front_wall(w, fh);
        translate([0, d + 45, 0]) back_wall(w, bh);
        side_wall(d, fh, bh);
        translate([w - 45, 0, 0]) side_wall(d, fh, bh);
    }
    
/*    
    difference() {
        color("red") cube([front_width, wall, front_height]);

        // door hole
        translate([front_width - front_spacing - door_width, -1, -1]) cube([door_width, wall + 2, door_height + 1]);
        
        // front window hole
        translate([front_spacing, -1, front_window_bottom]) cube([front_window_width, wall + 2, front_window_height]);
    }

    color("green") translate([0, wall + side_width, 0]) cube([back_width, wall, back_height]);

    color("blue") side_wall();
    color("magenta") translate([front_width - wall, 0, 0]) side_wall();
*/

    /*
    difference() {
        
        // walls
        points = [ 
            [0, 0, 0], // 0
            [front_width, 0, 0], // 1
            [back_width, side_width, 0], // 2
            [0, side_width, 0], // 3
            [0, 0, front_height], // 4
            [front_width, 0, front_height], // 5
            [back_width, side_width, back_height], // 6
            [0, side_width, back_height] // 7
        ];
        faces = [
            [4, 5, 1, 0], [0, 1, 5, 4], // front
            [7, 6, 2, 3], [3, 2, 6, 7], // back
            [4, 7, 3, 0], [0, 3, 7, 4], // side
            [5, 6, 2, 1], [1, 2, 6, 5] // side
        ];
        color("white") polyhedron(points, faces, convexity = 10);

        // door hole
        translate([front_width - front_spacing - door_width, -1, -1]) cube([door_width, wall + 2, door_height + 1]);
    }
    */
/*
    difference() {
        // shell
        color("white") cube([base_width, base_depth, back_height]);
        translate([wall, wall, -1]) cube([base_width - 2 * wall, base_depth - 2 * wall, back_height + 2]);

        // door hole
        translate([base_width - front_spacing - door_width, -1, -1]) cube([door_width, wall + 2, door_height + 1]);

        // front window hole
        translate([front_spacing, -1, front_window_bottom]) cube([front_window_width, wall + 2, front_window_height]);

        // side window hole
        translate([base_width - wall - 1, side_spacing, side_window_bottom]) cube([wall + 2, side_window_width, side_window_height]);

        // back window hole
        translate([-1, side_spacing, side_window_bottom]) cube([wall + 2, side_window_width, side_window_height]);
    }

    // door
    color("gray", 0.75) translate([base_width - front_spacing - door_width, 0, 0]) translate([door_width,0,0]) rotate(45) translate([-door_width,0,0]) cube([door_width, wall / 2, door_height]);

    // front window
    color("gray", 0.25) translate([front_spacing, 0, front_window_bottom]) cube([front_window_width, wall, front_window_height]);

    // side window
    color("gray", 0.25) translate([base_width - wall, side_spacing, side_window_bottom]) cube([wall, side_window_width, side_window_height]);

    // back window
    color("gray", 0.25) translate([0, side_spacing, side_window_bottom]) cube([wall, side_window_width, side_window_height]);
*/
}

module roof() {
/*    points = [ 
        [0, 0, 0],
        [base_width, 0, 0],
        [base_width, base_depth, 0], [0, base_depth, 0], // base corners
        [0, 0, roof_height],
        [base_width, 0, roof_height]      // roof corners
    ];
    faces = [ 
        [0, 1, 2, 3],   // base
        [3, 4, 0],      // left triangle
        [1, 5, 2],      // right triangle
        [4, 5, 1, 0],   // front side,
        [5, 4, 3, 2]    // back side
    ];
    color("darkgray") polyhedron(points, faces, convexity = 10);
*/
}

module chimney() {
    translate([chimney_x, chimney_y, 0]) color("black") cube([chimney_size, chimney_size, chimney_height]);
}

module rcube(size, radius) {
    if(radius < 1){
        cube(size);
    } else {
        hull() {
            translate([radius, radius]) cylinder(r = radius, h = size[2]);
            translate([size[0] - radius, radius]) cylinder(r = radius, h = size[2]);
            translate([size[0] - radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
            translate([radius, size[1] - radius]) cylinder(r = radius, h = size[2]);
        }
    }
}
