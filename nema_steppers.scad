//////////////////////////////////////////////////////////////////////
// LibFile: nema_steppers.scad
//   Masks and models for NEMA stepper motors.
//   To use, add these lines to the top of your file:
//   ```
//   include <BOSL2/std.scad>
//   include <BOSL2/nema_steppers.scad>
//   ```
//////////////////////////////////////////////////////////////////////


// Section: Functions


// Function: nema_motor_width()
// Description: Gets width of NEMA motor of given standard size.
// Arguments:
//   size = The standard NEMA motor size.
function nema_motor_width(size) = lookup(size, [
		[11.0, 28.2],
		[14.0, 35.2],
		[17.0, 42.3],
		[23.0, 57.0],
		[34.0, 86.0],
	]);


// Function: nema_motor_plinth_height()
// Description: Gets plinth height of NEMA motor of given standard size.
// Arguments:
//   size = The standard NEMA motor size.
function nema_motor_plinth_height(size) = lookup(size, [
		[11.0, 1.5],
		[14.0, 2.0],
		[17.0, 2.0],
		[23.0, 1.6],
		[34.0, 2.03],
	]);


// Function: nema_motor_plinth_diam()
// Description: Gets plinth diameter of NEMA motor of given standard size.
// Arguments:
//   size = The standard NEMA motor size.
function nema_motor_plinth_diam(size) = lookup(size, [
		[11.0, 22.0],
		[14.0, 22.0],
		[17.0, 22.0],
		[23.0, 38.1],
		[34.0, 73.0],
	]);


// Function: nema_motor_screw_spacing()
// Description: Gets screw spacing of NEMA motor of given standard size.
// Arguments:
//   size = The standard NEMA motor size.
function nema_motor_screw_spacing(size) = lookup(size, [
		[11.0, 23.11],
		[14.0, 26.0],
		[17.0, 30.99],
		[23.0, 47.14],
		[34.0, 69.6],
	]);


// Function: nema_motor_screw_size()
// Description: Gets mount screw size of NEMA motor of given standard size.
// Arguments:
//   size = The standard NEMA motor size.
function nema_motor_screw_size(size) = lookup(size, [
		[11.0, 2.6],
		[14.0, 3.0],
		[17.0, 3.0],
		[23.0, 5.1],
		[34.0, 5.5],
	]);


// Function: nema_motor_screw_depth()
// Description: Gets mount screw-hole depth of NEMA motor of given standard size.
// Arguments:
//   size = The standard NEMA motor size.
function nema_motor_screw_depth(size) = lookup(size, [
		[11.0, 3.0],
		[14.0, 4.5],
		[17.0, 4.5],
		[23.0, 4.8],
		[34.0, 9.0],
	]);


// Section: Motor Models


// Module: nema11_stepper()
// Description: Creates a model of a NEMA 11 stepper motor.
// Arguments:
//   h = Length of motor body.  Default: 24mm
//   shaft = Shaft diameter. Default: 5mm
//   shaft_len = Length of shaft protruding out the top of the stepper motor.  Default: 20mm
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `DOWN`.
// Extra Anchors:
//   "shaft-top" = The top of the shaft.
//   "shaft-middle" = The middle of the shaft.
//   "shaft-bottom" = The bottom of the shaft, 0.1mm above the plinth.
//   "plinth-top" = The top of the plinth.
//   "screw1" = The screw-hole in the X+Y+ quadrant.
//   "screw2" = The screw-hole in the X-Y+ quadrant.
//   "screw3" = The screw-hole in the X-Y- quadrant.
//   "screw4" = The screw-hole in the X+Y- quadrant.
// Example:
//   nema11_stepper();
module nema11_stepper(h=24, shaft=5, shaft_len=20, orient=ORIENT_Z, anchor=DOWN)
{
	size = 11;
	motor_width = nema_motor_width(size);
	plinth_height = nema_motor_plinth_height(size);
	plinth_diam = nema_motor_plinth_diam(size);
	screw_spacing = nema_motor_screw_spacing(size);
	screw_size = nema_motor_screw_size(size);
	screw_depth = nema_motor_screw_depth(size);

	anchors = [
		anchorpt("shaft-top", [0,0,h/2+shaft_len]),
		anchorpt("shaft-middle", [0,0,h/2+plinth_height+(shaft_len-plinth_height)/2]),
		anchorpt("shaft-bottom", [0,0,h/2+plinth_height+0.1]),
		anchorpt("plinth-top", [0,0,h/2+plinth_height]),
		anchorpt("screw1", [+screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw2", [-screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw3", [-screw_spacing/2, -screw_spacing/2, h/2]),
		anchorpt("screw4", [+screw_spacing/2, -screw_spacing/2, h/2]),
	];
	orient_and_anchor([motor_width, motor_width, h], orient, anchor, anchors=anchors, orig_anchor=TOP, chain=true) {
		union() {
			difference() {
				color([0.4, 0.4, 0.4]) 
					cuboid(size=[motor_width, motor_width, h], chamfer=2, edges=EDGES_Z_ALL, anchor=TOP);
				color("silver")
					xspread(screw_spacing)
						yspread(screw_spacing)
							cyl(r=screw_size/2, h=screw_depth*2, $fn=max(12,segs(screw_size/2)));
			}
			color([0.6, 0.6, 0.6]) {
				difference() {
					cylinder(h=plinth_height, d=plinth_diam);
					cyl(h=plinth_height*3, d=shaft+0.75);
				}
			}
			color("silver") cylinder(h=shaft_len, d=shaft, $fn=max(12,segs(shaft/2)));
		}
		children();
	}
}



// Module: nema14_stepper()
// Description: Creates a model of a NEMA 14 stepper motor.
// Arguments:
//   h = Length of motor body.  Default: 24mm
//   shaft = Shaft diameter. Default: 5mm
//   shaft_len = Length of shaft protruding out the top of the stepper motor.  Default: 24mm
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `DOWN`.
// Extra Anchors:
//   "shaft-top" = The top of the shaft.
//   "shaft-middle" = The middle of the shaft.
//   "shaft-bottom" = The bottom of the shaft, 0.1mm above the plinth.
//   "plinth-top" = The top of the plinth.
//   "screw1" = The screw-hole in the X+Y+ quadrant.
//   "screw2" = The screw-hole in the X-Y+ quadrant.
//   "screw3" = The screw-hole in the X-Y- quadrant.
//   "screw4" = The screw-hole in the X+Y- quadrant.
// Example:
//   nema14_stepper();
module nema14_stepper(h=24, shaft=5, shaft_len=24, orient=ORIENT_Z, anchor=DOWN)
{
	size = 14;
	motor_width = nema_motor_width(size);
	plinth_height = nema_motor_plinth_height(size);
	plinth_diam = nema_motor_plinth_diam(size);
	screw_spacing = nema_motor_screw_spacing(size);
	screw_size = nema_motor_screw_size(size);
	screw_depth = nema_motor_screw_depth(size);

	anchors = [
		anchorpt("shaft-top", [0,0,h/2+shaft_len]),
		anchorpt("shaft-middle", [0,0,h/2+plinth_height+(shaft_len-plinth_height)/2]),
		anchorpt("shaft-bottom", [0,0,h/2+plinth_height+0.1]),
		anchorpt("plinth-top", [0,0,h/2+plinth_height]),
		anchorpt("screw1", [+screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw2", [-screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw3", [-screw_spacing/2, -screw_spacing/2, h/2]),
		anchorpt("screw4", [+screw_spacing/2, -screw_spacing/2, h/2]),
	];
	orient_and_anchor([motor_width, motor_width, h], orient, anchor, anchors=anchors, orig_anchor=TOP, chain=true) {
		union() {
			difference() {
				color([0.4, 0.4, 0.4])
					cuboid(size=[motor_width, motor_width, h], chamfer=2, edges=EDGES_Z_ALL, anchor=TOP);
				color("silver")
					xspread(screw_spacing)
						yspread(screw_spacing)
							cyl(d=screw_size, h=screw_depth*2, $fn=max(12,segs(screw_size/2)));
			}
			color([0.6, 0.6, 0.6]) {
				difference() {
					cylinder(h=plinth_height, d=plinth_diam);
					cyl(h=plinth_height*3, d=shaft+0.75);
				}
			}
			color("silver") cylinder(h=shaft_len, d=shaft, $fn=max(12,segs(shaft/2)));
		}
		children();
	}
}



// Module: nema17_stepper()
// Description: Creates a model of a NEMA 17 stepper motor.
// Arguments:
//   h = Length of motor body.  Default: 34mm
//   shaft = Shaft diameter. Default: 5mm
//   shaft_len = Length of shaft protruding out the top of the stepper motor.  Default: 20mm
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `DOWN`.
// Extra Anchors:
//   "shaft-top" = The top of the shaft.
//   "shaft-middle" = The middle of the shaft.
//   "shaft-bottom" = The bottom of the shaft, 0.1mm above the plinth.
//   "plinth-top" = The top of the plinth.
//   "screw1" = The screw-hole in the X+Y+ quadrant.
//   "screw2" = The screw-hole in the X-Y+ quadrant.
//   "screw3" = The screw-hole in the X-Y- quadrant.
//   "screw4" = The screw-hole in the X+Y- quadrant.
// Example:
//   nema17_stepper();
module nema17_stepper(h=34, shaft=5, shaft_len=20, orient=ORIENT_Z, anchor=TOP)
{
	size = 17;
	motor_width = nema_motor_width(size);
	plinth_height = nema_motor_plinth_height(size);
	plinth_diam = nema_motor_plinth_diam(size);
	screw_spacing = nema_motor_screw_spacing(size);
	screw_size = nema_motor_screw_size(size);
	screw_depth = nema_motor_screw_depth(size);

	anchors = [
		anchorpt("shaft-top", [0,0,h/2+shaft_len]),
		anchorpt("shaft-middle", [0,0,h/2+plinth_height+(shaft_len-plinth_height)/2]),
		anchorpt("shaft-bottom", [0,0,h/2+plinth_height+0.1]),
		anchorpt("plinth-top", [0,0,h/2+plinth_height]),
		anchorpt("screw1", [+screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw2", [-screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw3", [-screw_spacing/2, -screw_spacing/2, h/2]),
		anchorpt("screw4", [+screw_spacing/2, -screw_spacing/2, h/2]),
	];
	orient_and_anchor([motor_width, motor_width, h], orient, anchor, anchors=anchors, orig_anchor=UP, chain=true) {
		union() {
			difference() {
				color([0.4, 0.4, 0.4])
					cuboid([motor_width, motor_width, h], chamfer=2, edges=EDGES_Z_ALL, anchor=TOP);
				color("silver")
					xspread(screw_spacing)
						yspread(screw_spacing)
							cyl(d=screw_size, h=screw_depth*2, $fn=max(12,segs(screw_size/2)));
			}
			color([0.6, 0.6, 0.6]) {
				difference() {
					cylinder(h=plinth_height, d=plinth_diam);
					cyl(h=plinth_height*3, d=shaft+0.75);
				}
			}
			color([0.9, 0.9, 0.9]) {
				down(h-motor_width/12) {
					fwd(motor_width/2+motor_width/24/2-0.1) {
						difference() {
							cube(size=[motor_width/8, motor_width/24, motor_width/8], center=true);
							cyl(d=motor_width/8-2, h=motor_width/6, orient=ORIENT_Y, $fn=12);
						}
					}
				}
			}
			color("silver") {
				difference() {
					cylinder(h=shaft_len, d=shaft, $fn=max(12,segs(shaft/2)));
					up(shaft_len/2+1) {
						right(shaft-0.75) {
							cube([shaft, shaft, shaft_len], center=true);
						}
					}
				}
			}
		}
		children();
	}
}



// Module: nema23_stepper()
// Description: Creates a model of a NEMA 23 stepper motor.
// Arguments:
//   h = Length of motor body.  Default: 50mm
//   shaft = Shaft diameter. Default: 6.35mm
//   shaft_len = Length of shaft protruding out the top of the stepper motor.  Default: 25mm
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `DOWN`.
// Extra Anchors:
//   "shaft-top" = The top of the shaft.
//   "shaft-middle" = The middle of the shaft.
//   "shaft-bottom" = The bottom of the shaft, 0.1mm above the plinth.
//   "plinth-top" = The top of the plinth.
//   "screw1" = The screw-hole in the X+Y+ quadrant.
//   "screw2" = The screw-hole in the X-Y+ quadrant.
//   "screw3" = The screw-hole in the X-Y- quadrant.
//   "screw4" = The screw-hole in the X+Y- quadrant.
// Example:
//   nema23_stepper();
module nema23_stepper(h=50, shaft=6.35, shaft_len=25, orient=ORIENT_Z, anchor=TOP)
{
	size = 23;
	motor_width = nema_motor_width(size);
	plinth_height = nema_motor_plinth_height(size);
	plinth_diam = nema_motor_plinth_diam(size);
	screw_spacing = nema_motor_screw_spacing(size);
	screw_size = nema_motor_screw_size(size);
	screw_depth = nema_motor_screw_depth(size);

	screw_inset = motor_width - screw_spacing + 1;
	anchors = [
		anchorpt("shaft-top", [0,0,h/2+shaft_len]),
		anchorpt("shaft-middle", [0,0,h/2+plinth_height+(shaft_len-plinth_height)/2]),
		anchorpt("shaft-bottom", [0,0,h/2+plinth_height+0.1]),
		anchorpt("plinth-top", [0,0,h/2+plinth_height]),
		anchorpt("screw1", [+screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw2", [-screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw3", [-screw_spacing/2, -screw_spacing/2, h/2]),
		anchorpt("screw4", [+screw_spacing/2, -screw_spacing/2, h/2]),
	];
	orient_and_anchor([motor_width, motor_width, h], orient, anchor, anchors=anchors, orig_anchor=TOP, chain=true) {
		difference() {
			union() {
				color([0.4, 0.4, 0.4])
					cuboid([motor_width, motor_width, h], chamfer=2, edges=EDGES_Z_ALL, anchor=TOP);
				color([0.4, 0.4, 0.4])
					cylinder(h=plinth_height, d=plinth_diam);
				color("silver")
					cylinder(h=shaft_len, d=shaft, $fn=max(12,segs(shaft/2)));
			}
			color([0.4, 0.4, 0.4]) {
				xspread(screw_spacing) {
					yspread(screw_spacing) {
						cyl(d=screw_size, h=screw_depth*3, $fn=max(12,segs(screw_size/2)));
						down(screw_depth) cuboid([screw_inset, screw_inset, h], anchor=TOP);
					}
				}
			}
		}
		children();
	}
}



// Module: nema34_stepper()
// Description: Creates a model of a NEMA 34 stepper motor.
// Arguments:
//   h = Length of motor body.  Default: 75mm
//   shaft = Shaft diameter. Default: 12.7mm
//   shaft_len = Length of shaft protruding out the top of the stepper motor.  Default: 32mm
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `DOWN`.
// Extra Anchors:
//   "shaft-top" = The top of the shaft.
//   "shaft-middle" = The middle of the shaft.
//   "shaft-bottom" = The bottom of the shaft, 0.1mm above the plinth.
//   "plinth-top" = The top of the plinth.
//   "screw1" = The screw-hole in the X+Y+ quadrant.
//   "screw2" = The screw-hole in the X-Y+ quadrant.
//   "screw3" = The screw-hole in the X-Y- quadrant.
//   "screw4" = The screw-hole in the X+Y- quadrant.
// Example:
//   nema34_stepper();
module nema34_stepper(h=75, shaft=12.7, shaft_len=32, orient=ORIENT_Z, anchor=TOP)
{
	size = 34;
	motor_width = nema_motor_width(size);
	plinth_height = nema_motor_plinth_height(size);
	plinth_diam = nema_motor_plinth_diam(size);
	screw_spacing = nema_motor_screw_spacing(size);
	screw_size = nema_motor_screw_size(size);
	screw_depth = nema_motor_screw_depth(size);

	screw_inset = motor_width - screw_spacing + 1;
	anchors = [
		anchorpt("shaft-top", [0,0,h/2+shaft_len]),
		anchorpt("shaft-middle", [0,0,h/2+plinth_height+(shaft_len-plinth_height)/2]),
		anchorpt("shaft-bottom", [0,0,h/2+plinth_height+0.1]),
		anchorpt("plinth-top", [0,0,h/2+plinth_height]),
		anchorpt("screw1", [+screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw2", [-screw_spacing/2, +screw_spacing/2, h/2]),
		anchorpt("screw3", [-screw_spacing/2, -screw_spacing/2, h/2]),
		anchorpt("screw4", [+screw_spacing/2, -screw_spacing/2, h/2]),
	];
	orient_and_anchor([motor_width, motor_width, h], orient, anchor, anchors=anchors, orig_anchor=TOP, chain=true) {
		difference() {
			union() {
				color([0.4, 0.4, 0.4])
					cuboid(size=[motor_width, motor_width, h], chamfer=2, edges=EDGES_Z_ALL, anchor=TOP);
				color([0.4, 0.4, 0.4])
					cylinder(h=plinth_height, d=plinth_diam);
				color("silver")
					cylinder(h=shaft_len, d=shaft, $fn=max(24,segs(shaft/2)));
			}
			color([0.4, 0.4, 0.4]) {
				xspread(screw_spacing) {
					yspread(screw_spacing) {
						cylinder(d=screw_size, h=screw_depth*3, center=true, $fn=max(12,segs(screw_size/2)));
						down(screw_depth) cube([screw_inset, screw_inset, h], anchor=TOP);
					}
				}
			}
		}
		children();
	}
}



// Section: Masking Modules



// Module: nema_mount_holes()
// Description: Creates a mask to use when making standard NEMA stepper motor mounts.
// Arguments:
//   size = The standard NEMA motor size to make a mount for.
//   depth = The thickness of the mounting hole mask.  Default: 5
//   l = The length of the slots, for making an adjustable motor mount.  Default: 5
//   slop = The printer-specific slop value to make parts fit just right.  Default: `PRINTER_SLOP`
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `CENTER`.
// Extra Anchors:
//   "screw1" = The center top of the screw hole/slot in the X+Y+ quadrant.
//   "screw2" = The center top of the screw hole/slot in the X-Y+ quadrant.
//   "screw3" = The center top of the screw hole/slot in the X-Y- quadrant.
//   "screw4" = The center top of the screw hole/slot in the X+Y- quadrant.
// Example:
//   nema_mount_holes(size=14, depth=5, l=5);
// Example:
//   nema_mount_holes(size=17, depth=5, l=5);
// Example:
//   nema_mount_holes(size=17, depth=5, l=0);
module nema_mount_holes(size=17, depth=5, l=5, slop=PRINTER_SLOP, orient=ORIENT_Z, anchor=CENTER)
{
	motor_width = nema_motor_width(size);
	plinth_diam = nema_motor_plinth_diam(size)+slop;
	screw_spacing = nema_motor_screw_spacing(size);
	screw_size = nema_motor_screw_size(size)+slop;

	anchors = [
		anchorpt("screw1", [+screw_spacing/2, +screw_spacing/2, depth/2]),
		anchorpt("screw2", [-screw_spacing/2, +screw_spacing/2, depth/2]),
		anchorpt("screw3", [-screw_spacing/2, -screw_spacing/2, depth/2]),
		anchorpt("screw4", [+screw_spacing/2, -screw_spacing/2, depth/2]),
	];
	screwfn = quantup(max(8,segs(screw_size/2)),4);
	plinthfn = quantup(max(8,segs(plinth_diam/2)),4);
	orient_and_anchor([screw_spacing+screw_size, screw_spacing+screw_size+l, depth], orient, anchor, chain=true) {
		union() {
			xspread(screw_spacing) {
				yspread(screw_spacing) {
					if (l>0) {
						union() {
							yspread(l) cyl(h=depth, d=screw_size, $fn=screwfn);
							cube([screw_size, l, depth], center=true);
						}
					} else {
						cyl(h=depth, d=screw_size, $fn=screwfn);
					}
				}
			}
			if (l>0) {
				union () {
					yspread(l) cyl(h=depth, d=plinth_diam, $fn=plinthfn);
					cube([plinth_diam, l, depth], center=true);
				}
			} else {
				cyl(h=depth, d=plinth_diam, $fn=plinthfn);
			}
		}
		children();
	}
}



// Module: nema11_mount_holes()
// Description: Creates a mask to use when making NEMA 11 stepper motor mounts.
// Arguments:
//   depth = The thickness of the mounting hole mask.  Default: 5
//   l = The length of the slots, for making an adjustable motor mount.  Default: 5
//   slop = The printer-specific slop value to make parts fit just right.  Default: `PRINTER_SLOP`
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `CENTER`.
// Extra Anchors:
//   "screw1" = The center top of the screw hole/slot in the X+Y+ quadrant.
//   "screw2" = The center top of the screw hole/slot in the X-Y+ quadrant.
//   "screw3" = The center top of the screw hole/slot in the X-Y- quadrant.
//   "screw4" = The center top of the screw hole/slot in the X+Y- quadrant.
// Example:
//   nema11_mount_holes(depth=5, l=5);
// Example:
//   nema11_mount_holes(depth=5, l=0);
module nema11_mount_holes(depth=5, l=5, slop=PRINTER_SLOP, orient=ORIENT_Z, anchor=CENTER)
{
	nema_mount_holes(size=11, depth=depth, l=l, slop=slop, orient=orient, anchor=anchor) children();
}



// Module: nema14_mount_holes()
// Description: Creates a mask to use when making NEMA 14 stepper motor mounts.
// Arguments:
//   depth = The thickness of the mounting hole mask.  Default: 5
//   l = The length of the slots, for making an adjustable motor mount.  Default: 5
//   slop = The printer-specific slop value to make parts fit just right.  Default: `PRINTER_SLOP`
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `CENTER`.
// Extra Anchors:
//   "screw1" = The center top of the screw hole/slot in the X+Y+ quadrant.
//   "screw2" = The center top of the screw hole/slot in the X-Y+ quadrant.
//   "screw3" = The center top of the screw hole/slot in the X-Y- quadrant.
//   "screw4" = The center top of the screw hole/slot in the X+Y- quadrant.
// Example:
//   nema14_mount_holes(depth=5, l=5);
// Example:
//   nema14_mount_holes(depth=5, l=0);
module nema14_mount_holes(depth=5, l=5, slop=PRINTER_SLOP, orient=ORIENT_Z, anchor=CENTER)
{
	nema_mount_holes(size=14, depth=depth, l=l, slop=slop, orient=orient, anchor=anchor) children();
}



// Module: nema17_mount_holes()
// Description: Creates a mask to use when making NEMA 17 stepper motor mounts.
// Arguments:
//   depth = The thickness of the mounting hole mask.  Default: 5
//   l = The length of the slots, for making an adjustable motor mount.  Default: 5
//   slop = The printer-specific slop value to make parts fit just right.  Default: `PRINTER_SLOP`
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `CENTER`.
// Extra Anchors:
//   "screw1" = The center top of the screw hole/slot in the X+Y+ quadrant.
//   "screw2" = The center top of the screw hole/slot in the X-Y+ quadrant.
//   "screw3" = The center top of the screw hole/slot in the X-Y- quadrant.
//   "screw4" = The center top of the screw hole/slot in the X+Y- quadrant.
// Example:
//   nema17_mount_holes(depth=5, l=5);
// Example:
//   nema17_mount_holes(depth=5, l=0);
module nema17_mount_holes(depth=5, l=5, slop=PRINTER_SLOP, orient=ORIENT_Z, anchor=CENTER)
{
	nema_mount_holes(size=17, depth=depth, l=l, slop=slop, orient=orient, anchor=anchor) children();
}



// Module: nema23_mount_holes()
// Description: Creates a mask to use when making NEMA 23 stepper motor mounts.
// Arguments:
//   depth = The thickness of the mounting hole mask.  Default: 5
//   l = The length of the slots, for making an adjustable motor mount.  Default: 5
//   slop = The printer-specific slop value to make parts fit just right.  Default: `PRINTER_SLOP`
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `CENTER`.
// Extra Anchors:
//   "screw1" = The center top of the screw hole/slot in the X+Y+ quadrant.
//   "screw2" = The center top of the screw hole/slot in the X-Y+ quadrant.
//   "screw3" = The center top of the screw hole/slot in the X-Y- quadrant.
//   "screw4" = The center top of the screw hole/slot in the X+Y- quadrant.
// Example:
//   nema23_mount_holes(depth=5, l=5);
// Example:
//   nema23_mount_holes(depth=5, l=0);
module nema23_mount_holes(depth=5, l=5, slop=PRINTER_SLOP, orient=ORIENT_Z, anchor=CENTER)
{
	nema_mount_holes(size=23, depth=depth, l=l, slop=slop, orient=orient, anchor=anchor) children();
}



// Module: nema34_mount_holes()
// Description: Creates a mask to use when making NEMA 34 stepper motor mounts.
// Arguments:
//   depth = The thickness of the mounting hole mask.  Default: 5
//   l = The length of the slots, for making an adjustable motor mount.  Default: 5
//   slop = The printer-specific slop value to make parts fit just right.  Default: `PRINTER_SLOP`
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `CENTER`.
// Extra Anchors:
//   "screw1" = The center top of the screw hole/slot in the X+Y+ quadrant.
//   "screw2" = The center top of the screw hole/slot in the X-Y+ quadrant.
//   "screw3" = The center top of the screw hole/slot in the X-Y- quadrant.
//   "screw4" = The center top of the screw hole/slot in the X+Y- quadrant.
// Example:
//   nema34_mount_holes(depth=5, l=5);
// Example:
//   nema34_mount_holes(depth=5, l=0);
module nema34_mount_holes(depth=5, l=5, slop=PRINTER_SLOP, orient=ORIENT_Z, anchor=CENTER)
{
	nema_mount_holes(size=34, depth=depth, l=l, slop=slop, orient=orient, anchor=anchor) children();
}



// Module: nema34_mount_holes()
// Description: Creates a mask to use when making NEMA 34 stepper motor mounts.
// Arguments:
//   depth = The thickness of the mounting hole mask.  Default: 5
//   l = The length of the slots, for making an adjustable motor mount.  Default: 5
//   slop = The printer-specific slop value to make parts fit just right.  Default: `PRINTER_SLOP`
//   orient = Orientation of the stepper.  Use the `ORIENT_` constants from `constants.scad`.  Default: `ORIENT_Z`.
//   anchor = Alignment of the stepper.  Use the constants from `constants.scad`.  Default: `CENTER`.
// Extra Anchors:
//   "screw1" = The center top of the screw hole/slot in the X+Y+ quadrant.
//   "screw2" = The center top of the screw hole/slot in the X-Y+ quadrant.
//   "screw3" = The center top of the screw hole/slot in the X-Y- quadrant.
//   "screw4" = The center top of the screw hole/slot in the X+Y- quadrant.
// Example:
//   nema34_mount_holes(depth=5, l=5);
// Example:
//   nema34_mount_holes(depth=5, l=0);
module nema34_mount_holes(depth=5, l=5, slop=PRINTER_SLOP, orient=ORIENT_Z, anchor=CENTER)
{
	nema_mount_holes(size=34, depth=depth, l=l, slop=slop, orient=orient, anchor=anchor) children();
}



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
