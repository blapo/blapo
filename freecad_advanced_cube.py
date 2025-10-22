#!/usr/bin/env python3
"""
Advanced FreeCAD Cube Creation Script

This script demonstrates more advanced cube creation techniques including:
- Parametric cubes using FreeCAD's parametric modeling
- Cubes with rounded edges
- Boolean operations with cubes
- Material properties and colors

Usage: Run in FreeCAD's Python console or as a macro
"""

import FreeCAD as App
import Part
import math

def create_parametric_cube(name="ParametricCube", length=10, width=10, height=10):
    """
    Create a parametric cube that can be easily modified through properties
    
    Args:
        name (str): Name of the cube object
        length (float): Length dimension
        width (float): Width dimension  
        height (float): Height dimension
    
    Returns:
        FreeCAD object: Parametric cube object
    """
    
    # Ensure we have a document
    if not App.ActiveDocument:
        doc = App.newDocument("ParametricCubeDoc")
    else:
        doc = App.ActiveDocument
    
    # Create a Box object (parametric)
    cube = doc.addObject("Part::Box", name)
    cube.Length = length
    cube.Width = width
    cube.Height = height
    cube.Label = name
    
    # Add custom properties for easy modification
    cube.addProperty("App::PropertyFloat", "Scale", "Dimensions", "Scale factor for the cube")
    cube.Scale = 1.0
    
    doc.recompute()
    return cube

def create_rounded_cube(name="RoundedCube", size=10, radius=1):
    """
    Create a cube with rounded edges using fillets
    
    Args:
        name (str): Name of the object
        size (float): Size of the cube
        radius (float): Radius of the rounded edges
    
    Returns:
        FreeCAD object: Rounded cube object
    """
    
    if not App.ActiveDocument:
        doc = App.newDocument("RoundedCubeDoc")
    else:
        doc = App.ActiveDocument
    
    # Create base cube
    cube_shape = Part.makeBox(size, size, size)
    
    # Create rounded edges by filleting
    try:
        # Get all edges
        edges = cube_shape.Edges
        
        # Apply fillet to all edges
        rounded_shape = cube_shape.makeFillet(radius, edges)
        
        # Create the object
        rounded_cube = doc.addObject("Part::Feature", name)
        rounded_cube.Shape = rounded_shape
        rounded_cube.Label = name
        
        # Set appearance
        rounded_cube.ViewObject.ShapeColor = (0.9, 0.7, 0.3)  # Golden color
        
    except Exception as e:
        print(f"Error creating rounded cube: {e}")
        # Fallback to regular cube
        rounded_cube = doc.addObject("Part::Feature", name)
        rounded_cube.Shape = cube_shape
        rounded_cube.Label = name + "_Fallback"
    
    doc.recompute()
    return rounded_cube

def create_hollow_cube(name="HollowCube", outer_size=20, wall_thickness=2):
    """
    Create a hollow cube using boolean operations
    
    Args:
        name (str): Name of the object
        outer_size (float): Outer dimensions of the cube
        wall_thickness (float): Thickness of the walls
    
    Returns:
        FreeCAD object: Hollow cube object
    """
    
    if not App.ActiveDocument:
        doc = App.newDocument("HollowCubeDoc")
    else:
        doc = App.ActiveDocument
    
    # Create outer cube
    outer_cube = Part.makeBox(outer_size, outer_size, outer_size)
    
    # Create inner cube (smaller)
    inner_size = outer_size - 2 * wall_thickness
    if inner_size > 0:
        inner_cube = Part.makeBox(inner_size, inner_size, inner_size,
                                 App.Vector(wall_thickness, wall_thickness, wall_thickness))
        
        # Subtract inner from outer to create hollow cube
        hollow_shape = outer_cube.cut(inner_cube)
    else:
        print("Warning: Wall thickness too large, creating solid cube")
        hollow_shape = outer_cube
    
    # Create the object
    hollow_cube = doc.addObject("Part::Feature", name)
    hollow_cube.Shape = hollow_shape
    hollow_cube.Label = name
    
    # Set appearance
    hollow_cube.ViewObject.ShapeColor = (0.7, 0.3, 0.9)  # Purple color
    hollow_cube.ViewObject.Transparency = 30  # Semi-transparent
    
    doc.recompute()
    return hollow_cube

def create_cube_array(name_prefix="CubeArray", count_x=3, count_y=3, count_z=1, 
                     cube_size=5, spacing=8):
    """
    Create an array of cubes
    
    Args:
        name_prefix (str): Prefix for cube names
        count_x (int): Number of cubes in X direction
        count_y (int): Number of cubes in Y direction  
        count_z (int): Number of cubes in Z direction
        cube_size (float): Size of each cube
        spacing (float): Spacing between cube centers
    
    Returns:
        list: List of created cube objects
    """
    
    if not App.ActiveDocument:
        doc = App.newDocument("CubeArrayDoc")
    else:
        doc = App.ActiveDocument
    
    cubes = []
    
    for i in range(count_x):
        for j in range(count_y):
            for k in range(count_z):
                # Calculate position
                x = i * spacing
                y = j * spacing
                z = k * spacing
                
                # Create cube
                cube_shape = Part.makeBox(cube_size, cube_size, cube_size,
                                        App.Vector(x, y, z))
                
                # Create object
                cube_name = f"{name_prefix}_{i}_{j}_{k}"
                cube_obj = doc.addObject("Part::Feature", cube_name)
                cube_obj.Shape = cube_shape
                cube_obj.Label = cube_name
                
                # Vary colors
                hue = (i + j + k) / (count_x + count_y + count_z)
                color = hsv_to_rgb(hue, 0.8, 0.9)
                cube_obj.ViewObject.ShapeColor = color
                
                cubes.append(cube_obj)
    
    doc.recompute()
    return cubes

def hsv_to_rgb(h, s, v):
    """Convert HSV color to RGB"""
    i = int(h * 6.0)
    f = (h * 6.0) - i
    p = v * (1.0 - s)
    q = v * (1.0 - s * f)
    t = v * (1.0 - s * (1.0 - f))
    
    i = i % 6
    if i == 0:
        return (v, t, p)
    elif i == 1:
        return (q, v, p)
    elif i == 2:
        return (p, v, t)
    elif i == 3:
        return (p, q, v)
    elif i == 4:
        return (t, p, v)
    elif i == 5:
        return (v, p, q)

def demo_all_cubes():
    """
    Demonstration function that creates all types of cubes
    """
    print("Creating demonstration of various cube types...")
    
    # Create different types of cubes
    param_cube = create_parametric_cube("ParamCube", 15, 15, 15)
    rounded_cube = create_rounded_cube("RoundedCube", 12, 1.5)
    hollow_cube = create_hollow_cube("HollowCube", 18, 2)
    
    # Position them for better viewing
    param_cube.Placement.Base = App.Vector(-25, 0, 0)
    rounded_cube.Placement.Base = App.Vector(0, 0, 0)
    hollow_cube.Placement.Base = App.Vector(25, 0, 0)
    
    # Create a small array
    cube_array = create_cube_array("ArrayCube", 3, 3, 1, 3, 6)
    
    # Position the array
    for cube in cube_array:
        current_pos = cube.Placement.Base
        cube.Placement.Base = App.Vector(current_pos.x - 40, current_pos.y + 30, current_pos.z)
    
    # Fit view
    try:
        import FreeCADGui as Gui
        Gui.SendMsgToActiveView("ViewFit")
    except ImportError:
        pass
    
    print("Demo completed! Created:")
    print("- Parametric cube (left)")
    print("- Rounded cube (center)")  
    print("- Hollow cube (right)")
    print("- 3x3 cube array (back left)")

# Main execution
if __name__ == "__main__":
    print("Advanced FreeCAD Cube Creation")
    print("=" * 40)
    
    # Run the demonstration
    demo_all_cubes()
    
    print("\nAll cubes created successfully!")
    print("You can modify parametric cubes through their properties panel.")