// Parametric Cup with Pedestal and Handle (OpenSCAD)
// Units: millimeters

$fn = 128; // smoothness

// ---------- Parameters ----------
// Cup
cup_outer_radius = 40;
cup_height       = 90;
wall_thickness   = 3;
base_thickness   = 4;
lip_height       = 2;    // small flare at rim
lip_thickness    = 1.2;  // radial increase at rim

// Pedestal
pedestal_base_radius = 28;
pedestal_base_height = 5;
pedestal_stem_radius = 18;
pedestal_stem_height = 12;

// Handle (torus segment)
handle_tube_radius = 5;     // thickness of the handle tube
handle_sweep_deg   = 220;   // sweep angle of handle arc (<= 360)
handle_overlap     = 0.6;   // radial overlap into cup wall for a solid union
handle_center_frac = 0.60;  // vertical placement along cup height (0..1)

// ---------- Derived -----------
pedestal_total_height = pedestal_base_height + pedestal_stem_height;
cup_bottom_z          = pedestal_total_height;
handle_center_z       = cup_bottom_z + cup_height * handle_center_frac;
// Set ring radius so the handle slightly overlaps the cup outer wall
// Ensures (ring_r - tube_r) = cup_outer_radius - handle_overlap
handle_ring_radius    = cup_outer_radius + handle_tube_radius - handle_overlap;

// ---------- Modules ----------
module cup_shell(h, r_outer, wall, base_t, lip_h, lip_t) {
  difference() {
    union() {
      cylinder(h = h, r = r_outer, center = false);
      // Slight lip at the top
      if (lip_h > 0 && lip_t > 0)
        translate([0, 0, h - lip_h])
          cylinder(h = lip_h, r1 = r_outer, r2 = r_outer + lip_t, center = false);
    }
    // Hollow interior with a solid bottom thickness
    translate([0, 0, base_t])
      cylinder(h = h - base_t, r = r_outer - wall, center = false);
  }
}

module pedestal(stem_h, stem_r, base_h, base_r) {
  union() {
    // Base disk
    cylinder(h = base_h, r = base_r, center = false);
    // Stem
    translate([0, 0, base_h])
      cylinder(h = stem_h, r = stem_r, center = false);
  }
}

// Handle built as a torus segment around the Y axis, then oriented so its opening faces outward
module cup_handle(center_z, ring_r, tube_r, sweep_deg) {
  translate([0, 0, center_z])
    rotate([90, 0, 0])                // make ring axis = Y
      rotate([0, -(sweep_deg/2 + 180), 0]) // center the missing wedge on +X (outer side)
        rotate_extrude(angle = sweep_deg, convexity = 10)
          translate([ring_r, 0, 0])
            circle(r = tube_r);
}

module mug() {
  union() {
    // Pedestal at Z=0
    pedestal(pedestal_stem_height, pedestal_stem_radius,
             pedestal_base_height, pedestal_base_radius);

    // Cup on top of pedestal
    translate([0, 0, cup_bottom_z])
      cup_shell(cup_height, cup_outer_radius, wall_thickness,
                base_thickness, lip_height, lip_thickness);

    // Handle on the side
    cup_handle(handle_center_z, handle_ring_radius, handle_tube_radius, handle_sweep_deg);
  }
}

// ---------- Render ----------
mug();
