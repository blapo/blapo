// Decorative cup with CURVED and ELEGANT handle

// Parameters
cup_height = 60;
cup_top_radius = 35;
cup_bottom_radius = 25;
cup_wall_thickness = 3;

pedestal_height = 15;
pedestal_radius = 40;
pedestal_top_radius = 28;

handle_width = 8;
handle_thickness = 6;

// Main assembly
union() {
    // Cup with handle
    cup_with_handle();
    
    // Pedestal base
    translate([0, 0, -pedestal_height])
        pedestal();
}

// Cup with handle
module cup_with_handle() {
    union() {
        // Main cup body
        cup_body();
        
        // Curved handle
        curved_handle();
    }
}

// Cup body (hollow cylinder with tapered walls)
module cup_body() {
    difference() {
        // Outer cup shape
        cylinder(h = cup_height, 
                r1 = cup_bottom_radius, 
                r2 = cup_top_radius, 
                $fn = 100);
        
        // Inner hollow space
        translate([0, 0, cup_wall_thickness])
            cylinder(h = cup_height, 
                    r1 = cup_bottom_radius - cup_wall_thickness, 
                    r2 = cup_top_radius - cup_bottom_radius, 
                    $fn = 100);
    }
}

// CURVED HANDLE - Elegant and simple
module curved_handle() {
    // Handle at middle height
    handle_z = cup_height * 0.5;
    cup_r = cup_bottom_radius + (cup_top_radius - cup_bottom_radius) * 0.5;
    
    translate([0, 0, handle_z]) {
        difference() {
            union() {
                // Create handle using multiple small cylinders to form a curve
                for (i = [0:5]) {
                    angle = i * 30; // 0 to 150 degrees
                    x_pos = cup_r + 2 + cos(angle) * 12;
                    z_pos = sin(angle) * 8 - 4;
                    
                    translate([x_pos, 0, z_pos])
                        sphere(r = handle_thickness/2, $fn = 16);
                }
                
                // Connection points to cup
                translate([cup_r + 1, 0, -4])
                    sphere(r = handle_thickness/2, $fn = 16);
                translate([cup_r + 1, 0, 4])
                    sphere(r = handle_thickness/2, $fn = 16);
                
                // Hull to create smooth connections
                hull() {
                    translate([cup_r + 1, 0, -4])
                        sphere(r = handle_thickness/2 - 1, $fn = 16);
                    translate([cup_r + 2 + cos(0) * 12, 0, sin(0) * 8 - 4])
                        sphere(r = handle_thickness/2 - 1, $fn = 16);
                }
                
                hull() {
                    translate([cup_r + 1, 0, 4])
                        sphere(r = handle_thickness/2 - 1, $fn = 16);
                    translate([cup_r + 2 + cos(150) * 12, 0, sin(150) * 8 - 4])
                        sphere(r = handle_thickness/2 - 1, $fn = 16);
                }
            }
            
            // Remove interference with cup
            cylinder(h = 30, r = cup_r, center = true, $fn = 100);
        }
    }
}

// Pedestal base
module pedestal() {
    cylinder(h = pedestal_height, 
            r1 = pedestal_radius, 
            r2 = pedestal_top_radius, 
            $fn = 100);
}