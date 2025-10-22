#!/usr/bin/env python3
"""
FreeCAD Python script to create a cube

This script creates a simple cube in FreeCAD using the Part workbench.
The cube will be 10x10x10 units in size and positioned at the origin.

Usage:
1. Open FreeCAD
2. Open the Python console (View -> Panels -> Python console)
3. Execute this script: exec(open('/path/to/freecad_cube.py').read())

Or run directly in FreeCAD's macro environment.
"""

import FreeCAD as App
import Part

def create_cube(length=10.0, width=10.0, height=10.0, x=0.0, y=0.0, z=0.0):
    """
    Create a cube in FreeCAD
    
    Args:
        length (float): Length of the cube (X dimension)
        width (float): Width of the cube (Y dimension) 
        height (float): Height of the cube (Z dimension)
        x (float): X position of the cube center
        y (float): Y position of the cube center
        z (float): Z position of the cube center
    
    Returns:
        FreeCAD Part object: The created cube
    """
    
    # Create a new document if none exists
    if not App.ActiveDocument:
        doc = App.newDocument("CubeDocument")
    else:
        doc = App.ActiveDocument
    
    # Create the cube using Part.makeBox
    # makeBox(length, width, height, [position], [direction])
    cube_shape = Part.makeBox(length, width, height, 
                             App.Vector(x - length/2, y - width/2, z - height/2))
    
    # Create a Part object in the document
    cube_obj = doc.addObject("Part::Feature", "Cube")
    cube_obj.Shape = cube_shape
    cube_obj.Label = f"Cube_{length}x{width}x{height}"
    
    # Set visual properties
    cube_obj.ViewObject.ShapeColor = (0.8, 0.8, 0.9)  # Light blue color
    cube_obj.ViewObject.Transparency = 0
    
    # Recompute the document to update the view
    doc.recompute()
    
    # Fit the view to show the cube
    try:
        import FreeCADGui as Gui
        Gui.SendMsgToActiveView("ViewFit")
    except ImportError:
        # FreeCADGui might not be available in headless mode
        pass
    
    print(f"Created cube: {length} x {width} x {height} at position ({x}, {y}, {z})")
    
    return cube_obj

def create_multiple_cubes():
    """
    Example function to create multiple cubes with different sizes and positions
    """
    cubes = []
    
    # Create cubes of different sizes
    sizes_and_positions = [
        (10, 10, 10, 0, 0, 0),      # Standard cube at origin
        (5, 5, 5, 20, 0, 0),        # Smaller cube to the right
        (15, 8, 12, -25, 0, 0),     # Rectangular box to the left
        (8, 8, 20, 0, 25, 0),       # Tall cube behind
    ]
    
    for length, width, height, x, y, z in sizes_and_positions:
        cube = create_cube(length, width, height, x, y, z)
        cubes.append(cube)
    
    return cubes

# Main execution
if __name__ == "__main__":
    print("Creating FreeCAD cube...")
    
    # Create a single cube with default parameters
    main_cube = create_cube()
    
    # Uncomment the line below to create multiple cubes instead
    # multiple_cubes = create_multiple_cubes()
    
    print("Cube creation completed!")
    print("You can modify the cube properties in the FreeCAD interface.")
    print("To create cubes with different dimensions, call:")
    print("create_cube(length, width, height, x, y, z)")