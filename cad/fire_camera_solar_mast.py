"""Parametric fire camera solar mast CAD model (CadQuery).

This script recreates the provided OpenSCAD geometry as true B-Rep solids,
then exports CAD/mesh outputs suitable for Fusion 360 / SolidWorks workflows.

Outputs:
- cad/out/fire_camera_solar_mast.step (assembly solids)
- cad/out/fire_camera_solar_mast.stl  (combined mesh)
- cad/out/fire_camera_solar_mast.glb  (colored preview)
"""

from pathlib import Path

import cadquery as cq
from cadquery import Color
from cadquery import exporters

# =============================
# Parameters (source: inches)
# =============================
IN_TO_MM = 25.4

pole_height = 168.0
pole_radius = 1.5
embed_depth = 30.0

frame_width = 48.0
frame_depth = 42.0
front_leg_height = 132.0
back_leg_height = 156.0
tube_size = 2.0

panel_width = 58.0
panel_depth = 27.0
panel_thickness = 1.5
panel_tilt_deg = 18.0

battery_height = 66.0
battery_box = (20.0, 16.0, 10.0)

camera_size = (6.0, 4.0, 4.0)
footing_radius = 8.0


def inch(v: float) -> float:
    """Convert inches to millimeters."""
    return v * IN_TO_MM


# =============================
# Part builders
# =============================
def make_footing() -> cq.Workplane:
    return (
        cq.Workplane("XY")
        .circle(inch(footing_radius))
        .extrude(inch(embed_depth))
        .translate((0.0, 0.0, -inch(embed_depth) / 2.0))
    )


def make_pole() -> cq.Workplane:
    return (
        cq.Workplane("XY")
        .circle(inch(pole_radius))
        .extrude(inch(pole_height))
        .translate((0.0, 0.0, inch(pole_height / 2.0 - embed_depth)))
    )


def make_leg(height_in: float, x_offset_in: float) -> cq.Workplane:
    return (
        cq.Workplane("XY")
        .box(inch(tube_size), inch(frame_depth), inch(height_in), centered=(True, True, True))
        .translate((inch(x_offset_in), 0.0, inch(height_in / 2.0)))
    )


def make_top_beam() -> cq.Workplane:
    # Loft between two equal rectangular profiles to match OpenSCAD hull behavior.
    return (
        cq.Workplane("XY")
        .workplane(offset=inch(front_leg_height))
        .center(-inch(frame_width / 2.0), 0.0)
        .rect(inch(tube_size), inch(frame_depth))
        .workplane(offset=inch(back_leg_height - front_leg_height))
        .center(inch(frame_width), 0.0)
        .rect(inch(tube_size), inch(frame_depth))
        .loft(combine=True)
    )


def make_cross_brace() -> cq.Workplane:
    return (
        cq.Workplane("XY")
        .box(inch(frame_width), inch(tube_size), inch(tube_size), centered=(True, True, True))
        .translate((0.0, 0.0, inch(battery_height)))
    )


def make_solar_panel() -> cq.Workplane:
    return (
        cq.Workplane("XY")
        .box(inch(panel_width), inch(panel_depth), inch(panel_thickness), centered=(True, True, True))
        .rotate((0.0, 0.0, 0.0), (0.0, 1.0, 0.0), -panel_tilt_deg)
        .translate((0.0, 0.0, inch(back_leg_height + 1.0)))
    )


def make_battery() -> cq.Workplane:
    return (
        cq.Workplane("XY")
        .box(inch(battery_box[0]), inch(battery_box[1]), inch(battery_box[2]), centered=(True, True, True))
        .translate((0.0, 0.0, inch(battery_height)))
    )


def make_camera_mount() -> cq.Workplane:
    return (
        cq.Workplane("XY")
        .box(inch(camera_size[0]), inch(camera_size[1]), inch(camera_size[2]), centered=(True, True, True))
        .translate((0.0, 0.0, inch(pole_height - 12.0)))
    )


def build_assembly() -> tuple[cq.Assembly, list[cq.Shape]]:
    footing = make_footing().val()
    pole = make_pole().val()
    leg_front = make_leg(front_leg_height, -frame_width / 2.0).val()
    leg_back = make_leg(back_leg_height, frame_width / 2.0).val()
    top_beam = make_top_beam().val()
    cross_brace = make_cross_brace().val()
    panel = make_solar_panel().val()
    battery = make_battery().val()
    camera = make_camera_mount().val()

    asm = cq.Assembly(name="fire_camera_solar_mast")
    asm.add(footing, name="footing", color=Color(0.45, 0.45, 0.45))
    asm.add(pole, name="pole", color=Color(0.78, 0.78, 0.78))
    asm.add(leg_front, name="leg_front", color=Color(0.83, 0.83, 0.83))
    asm.add(leg_back, name="leg_back", color=Color(0.83, 0.83, 0.83))
    asm.add(top_beam, name="top_beam", color=Color(0.83, 0.83, 0.83))
    asm.add(cross_brace, name="cross_brace", color=Color(0.83, 0.83, 0.83))
    asm.add(panel, name="solar_panel", color=Color(0.1, 0.24, 0.8))
    asm.add(battery, name="battery_box", color=Color(0.88, 0.84, 0.72))
    asm.add(camera, name="camera_mount", color=Color(0.05, 0.05, 0.05))

    return asm, [footing, pole, leg_front, leg_back, top_beam, cross_brace, panel, battery, camera]


def export_outputs(out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    asm, parts = build_assembly()

    step_path = out_dir / "fire_camera_solar_mast.step"
    stl_path = out_dir / "fire_camera_solar_mast.stl"
    glb_path = out_dir / "fire_camera_solar_mast.glb"

    exporters.export(asm, str(step_path))

    compound = cq.Compound.makeCompound(parts)
    exporters.export(compound, str(stl_path), tolerance=0.1, angularTolerance=0.2)

    exporters.export(asm, str(glb_path))

    print(f"Wrote: {step_path}")
    print(f"Wrote: {stl_path}")
    print(f"Wrote: {glb_path}")


if __name__ == "__main__":
    export_outputs(Path(__file__).parent / "out")
