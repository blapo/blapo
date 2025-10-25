// Decorative cup with SIMPLE and FUNCTIONAL handle

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
        
        // Simple handle
        simple_handle();
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

// SIMPLE HANDLE - Easy to understand and functional
module simple_handle() {
    // Handle height and cup radius at that height
    handle_z = cup_height * 0.5; // Middle height
    cup_r = cup_bottom_radius + (cup_top_radius - cup_bottom_radius) * 0.5; // Radius at middle
    
    translate([0, 0, handle_z]) {
        // Rotate to position handle on the side
        rotate([0, 0, 0]) {
            union() {
                // Vertical connection to cup
                translate([cup_r - 1, 0, 0])
                    cube([4, handle_thickness, 20], center = true);
                
                // Horizontal top part
                translate([cup_r + 8, 0, 8])
                    cube([16, handle_thickness, 4], center = true);
                
                // Horizontal bottom part  
                translate([cup_r + 8, 0, -8])
                    cube([16, handle_thickness, 4], center = true);
                
                // Vertical outer part
                translate([cup_r + 16, 0, 0])
                    cube([4, handle_thickness, 20], center = true);
                
                // Rounded corners for better look
                translate([cup_r + 16, 0, 8])
                    cylinder(h = 4, r = handle_thickness/2, center = true, $fn = 20);
                translate([cup_r + 16, 0, -8])
                    cylinder(h = 4, r = handle_thickness/2, center = true, $fn = 20);
            }
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