# FreeCAD Cube Generation Guide

This repository contains Python scripts for generating cubes in FreeCAD programmatically.

## Files

1. **`freecad_cube.py`** - Basic cube creation script
2. **`freecad_advanced_cube.py`** - Advanced cube creation with various techniques
3. **`FREECAD_CUBE_GUIDE.md`** - This guide

## Basic Usage

### Method 1: Using FreeCAD's Python Console

1. Open FreeCAD
2. Go to `View` → `Panels` → `Python console`
3. Navigate to the script directory or copy the script content
4. Execute the script:
   ```python
   exec(open('/path/to/freecad_cube.py').read())
   ```

### Method 2: Using FreeCAD Macros

1. Open FreeCAD
2. Go to `Macro` → `Macros...`
3. Click `Create` and paste the script content
4. Save and run the macro

### Method 3: Direct Python Execution

If you have FreeCAD's Python libraries in your path:
```bash
python freecad_cube.py
```

## Script Features

### Basic Cube Script (`freecad_cube.py`)

- **`create_cube(length, width, height, x, y, z)`** - Creates a single cube
- **`create_multiple_cubes()`** - Creates multiple cubes with different sizes
- Default cube size: 10×10×10 units
- Automatic document creation
- Visual properties setup (color, transparency)

#### Example Usage:
```python
# Create a default cube
cube = create_cube()

# Create a custom cube
custom_cube = create_cube(length=20, width=15, height=10, x=5, y=5, z=0)
```

### Advanced Cube Script (`freecad_advanced_cube.py`)

- **`create_parametric_cube()`** - Creates parametric cubes that can be easily modified
- **`create_rounded_cube()`** - Creates cubes with filleted (rounded) edges
- **`create_hollow_cube()`** - Creates hollow cubes using boolean operations
- **`create_cube_array()`** - Creates arrays of cubes with different colors
- **`demo_all_cubes()`** - Demonstrates all cube types

#### Example Usage:
```python
# Create different types of cubes
param_cube = create_parametric_cube("MyParamCube", 15, 15, 15)
rounded_cube = create_rounded_cube("MyRoundedCube", 12, 2)
hollow_cube = create_hollow_cube("MyHollowCube", 20, 3)

# Create a 4x4 array of small cubes
cube_array = create_cube_array("MyArray", 4, 4, 1, 4, 8)

# Run the full demonstration
demo_all_cubes()
```

## Customization Options

### Colors
Cubes can be colored by modifying the `ShapeColor` property:
```python
cube.ViewObject.ShapeColor = (r, g, b)  # RGB values from 0.0 to 1.0
```

### Transparency
```python
cube.ViewObject.Transparency = 50  # 0-100, where 0 is opaque
```

### Positioning
```python
cube.Placement.Base = App.Vector(x, y, z)
```

### Rotation
```python
cube.Placement.Rotation = App.Rotation(App.Vector(0,0,1), angle_degrees)
```

## Requirements

- FreeCAD (version 0.18 or later recommended)
- Python 3.x (usually included with FreeCAD)

## Troubleshooting

1. **Import errors**: Make sure FreeCAD is properly installed and the Python path includes FreeCAD modules
2. **No active document**: The scripts automatically create documents, but you can manually create one with `App.newDocument()`
3. **View not updating**: Try calling `doc.recompute()` and `Gui.SendMsgToActiveView("ViewFit")`

## Advanced Tips

1. **Batch Operations**: Use the array functions to create multiple objects efficiently
2. **Boolean Operations**: Combine cubes using `union()`, `cut()`, and `common()` methods
3. **Parametric Modeling**: Use the parametric cube functions for designs that need frequent modifications
4. **Export**: Save your cubes in various formats using FreeCAD's export functionality

## Example Output

The scripts will create:
- Standard cubes with customizable dimensions
- Rounded cubes with filleted edges
- Hollow cubes with adjustable wall thickness
- Colorful arrays of cubes
- Parametric cubes that can be easily modified

Happy modeling with FreeCAD!