// Decorative cup with corrected handle - FINAL VERSION

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
        
        // Handle - COMPLETELY REWRITTEN
        handle_new();
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

// NEW HANDLE - Completely rewritten approach
module handle_new() {
    // Handle positioned at 40% height
    handle_z = cup_height * 0.4;
    // Cup radius at handle height (linear interpolation)
    cup_r = cup_bottom_radius + (cup_top_radius - cup_bottom_radius) * 0.4;
    
    translate([0, 0, handle_z]) {
        difference() {
            union() {
                // Main handle loop - using hull between two cylinders
                hull() {
                    // Inner attachment point
                    translate([cup_r + 2, 0, 0])
                        cylinder(h = handle_width, r = handle_thickness/2, center = true, $fn = 20);
                    
                    // Outer curve point
                    translate([cup_r + 20, 0, 8])
                        cylinder(h = handle_width, r = handle_thickness/2, center = true, $fn = 20);
                }
                
                hull() {
                    // Outer curve point (top)
                    translate([cup_r + 20, 0, 8])
                        cylinder(h = handle_width, r = handle_thickness/2, center = true, $fn = 20);
                    
                    // Outer curve point (bottom)
                    translate([cup_r + 20, 0, -8])
                        cylinder(h = handle_width, r = handle_thickness/2, center = true, $fn = 20);
                }
                
                hull() {
                    // Outer curve point (bottom)
                    translate([cup_r + 20, 0, -8])
                        cylinder(h = handle_width, r = handle_thickness/2, center = true, $fn = 20);
                    
                    // Inner attachment point (bottom)
                    translate([cup_r + 2, 0, -6])
                        cylinder(h = handle_width, r = handle_thickness/2, center = true, $fn = 20);
                }
            }
            
            // Remove interference with cup
            translate([0, 0, -handle_width])
                cylinder(h = handle_width*2, r = cup_r + 1, $fn = 100);
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