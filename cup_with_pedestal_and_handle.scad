// OpenSCAD Cup with Pedestal and Handle
// Customizable parameters for easy modification

// Cup dimensions
cup_height = 80;           // Height of the cup
cup_outer_radius = 35;     // Outer radius of the cup
cup_wall_thickness = 3;    // Wall thickness
cup_inner_radius = cup_outer_radius - cup_wall_thickness;

// Pedestal dimensions
pedestal_height = 15;      // Height of the pedestal
pedestal_radius = 45;      // Radius of the pedestal base
pedestal_top_radius = cup_outer_radius; // Top radius matches cup

// Handle dimensions
handle_tube_radius = 6;    // Thickness of the handle tube
handle_major_radius = 25;  // Major radius of the handle torus
handle_minor_radius = handle_tube_radius; // Minor radius of the handle torus
handle_offset_z = 40;      // Vertical position of handle center

// Resolution for smooth curves
$fn = 100;

module cup_body() {
    difference() {
        // Outer cup cylinder
        cylinder(h = cup_height, r = cup_outer_radius);
        
        // Inner hollow space (offset up slightly to create bottom)
        translate([0, 0, cup_wall_thickness])
            cylinder(h = cup_height, r = cup_inner_radius);
    }
}

module pedestal() {
    // Truncated cone pedestal
    cylinder(h = pedestal_height, 
             r1 = pedestal_radius, 
             r2 = pedestal_top_radius);
}

module handle() {
    // Position handle on the side of the cup
    translate([cup_outer_radius + handle_major_radius - handle_tube_radius, 0, handle_offset_z]) {
        rotate([0, 90, 0]) {
            // Create torus for handle
            rotate_extrude() {
                translate([handle_major_radius, 0, 0]) {
                    circle(r = handle_minor_radius);
                }
            }
        }
    }
}

module cup_with_pedestal_and_handle() {
    union() {
        // Main cup body
        translate([0, 0, pedestal_height])
            cup_body();
        
        // Pedestal base
        pedestal();
        
        // Handle
        translate([0, 0, pedestal_height])
            handle();
    }
}

// Render the complete cup
cup_with_pedestal_and_handle();

// Optional: Add some decorative rings on the cup
module decorative_rings() {
    translate([0, 0, pedestal_height]) {
        for (i = [0.2, 0.4, 0.6, 0.8]) {
            translate([0, 0, cup_height * i]) {
                difference() {
                    cylinder(h = 2, r = cup_outer_radius + 1);
                    cylinder(h = 2, r = cup_outer_radius - 1);
                }
            }
        }
    }
}

// Uncomment the line below to add decorative rings
// decorative_rings();