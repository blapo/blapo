// A decorative cup with a circular pedestal base - CORRECTED VERSION

// Parameters
cup_height = 60;        // Height of the cup
cup_top_radius = 35;    // Radius at the top of the cup
cup_bottom_radius = 25; // Radius at the bottom of the cup
cup_wall_thickness = 3; // Thickness of the cup walls

pedestal_height = 15;   // Height of the pedestal
pedestal_radius = 40;   // Radius of the pedestal base
pedestal_top_radius = 28; // Radius where pedestal meets cup

handle_width = 8;       // Width of the handle
handle_thickness = 6;   // Thickness of the handle
handle_offset = 25;     // Distance from cup center to handle

// Main assembly
union() {
    // Cup with handle
    cup_with_handle();
    
    // Pedestal base
    translate([0, 0, -pedestal_height])
        pedestal();
}

// Cup module
module cup_with_handle() {
    union() {
        // Main cup body
        cup_body();
        
        // Handle
        handle();
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
                    r2 = cup_top_radius - cup_wall_thickness, 
                    $fn = 100);
    }
}

// CORRECTED Handle module
module handle() {
    // Fixed values to avoid calculation issues
    handle_height = cup_height * 0.4; // = 24
    handle_radius = 29; // Approximate radius at handle height
    
    translate([0, 0, handle_height]) {
        union() {
            // Main handle loop
            difference() {
                // Outer handle shape - toro
                translate([handle_radius + 14, 0, 0]) {
                    rotate([90, 0, 0]) {
                        rotate_extrude($fn = 50) {
                            translate([12, 0, 0]) {
                                circle(r = handle_width/2, $fn = 20);
                            }
                        }
                    }
                }
                
                // Cut away inner part to avoid interference with cup
                cylinder(h = handle_width*2, 
                        r = handle_radius + 5, 
                        center = true, 
                        $fn = 100);
                
                // Cut to create C-shape opening toward cup
                translate([handle_radius - 5, -handle_width, -handle_width])
                    cube([30, handle_width*2, handle_width*2]);
            }
            
            // Connection piece to cup wall
            hull() {
                translate([handle_radius, 0, 0])
                    sphere(r = handle_width/3, $fn = 20);
                translate([handle_radius + 2, 0, 0])
                    sphere(r = handle_width/3, $fn = 20);
            }
            
            // Upper connection
            hull() {
                translate([handle_radius, 0, 6])
                    sphere(r = handle_width/4, $fn = 20);
                translate([handle_radius + 4, 0, 6])
                    sphere(r = handle_width/4, $fn = 20);
            }
            
            // Lower connection  
            hull() {
                translate([handle_radius, 0, -6])
                    sphere(r = handle_width/4, $fn = 20);
                translate([handle_radius + 4, 0, -6])
                    sphere(r = handle_width/4, $fn = 20);
            }
        }
    }
}

// Pedestal base
module pedestal() {
    // Tapered pedestal
    cylinder(h = pedestal_height, 
            r1 = pedestal_radius, 
            r2 = pedestal_top_radius, 
            $fn = 100);
}

// Optional: Add decorative rings to the pedestal
module decorative_pedestal() {
    union() {
        // Main pedestal
        pedestal();
        
        // Decorative rings
        for (i = [0.3, 0.7]) {
            translate([0, 0, pedestal_height * i])
                difference() {
                    cylinder(h = 2, 
                            r = pedestal_radius * (1 - i * 0.3) + 2, 
                            $fn = 100);
                    cylinder(h = 2, 
                            r = pedestal_radius * (1 - i * 0.3) - 1, 
                            $fn = 100);
                }
        }
    }
}