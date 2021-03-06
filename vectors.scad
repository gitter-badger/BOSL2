//////////////////////////////////////////////////////////////////////
// LibFile: vectors.scad
//   Vector math functions.
//   To use, add the following lines to the beginning of your file:
//   ```
//   use <BOSL2/std.scad>
//   ```
//////////////////////////////////////////////////////////////////////


// Section: Vector Manipulation

// Function: vmul()
// Description:
//   Element-wise vector multiplication.  Multiplies each element of vector `v1` by
//   the corresponding element of vector `v2`.  Returns a vector of the products.
// Arguments:
//   v1 = The first vector.
//   v2 = The second vector.
// Example:
//   vmul([3,4,5], [8,7,6]);  // Returns [24, 28, 30]
function vmul(v1, v2) = [for (i = [0:len(v1)-1]) v1[i]*v2[i]];


// Function: vdiv()
// Description:
//   Element-wise vector division.  Divides each element of vector `v1` by
//   the corresponding element of vector `v2`.  Returns a vector of the quotients.
// Arguments:
//   v1 = The first vector.
//   v2 = The second vector.
// Example:
//   vdiv([24,28,30], [8,7,6]);  // Returns [3, 4, 5]
function vdiv(v1, v2) = [for (i = [0:len(v1)-1]) v1[i]/v2[i]];


// Function: vabs()
// Description: Returns a vector of the absolute value of each element of vector `v`.
// Arguments:
//   v = The vector to get the absolute values of.
function vabs(v) = [for (x=v) abs(x)];


// Function: normalize()
// Description:
//   Returns unit length normalized version of vector v.
// Arguments:
//   v = The vector to normalize.
function normalize(v) = v/norm(v);


// Function: vquant()
// Usage:
//   vquant(v,m)
// Description:
//   Quantizes each scalar in the vector `v` to an integer multiple of `m`, rounding to the nearest multiple.
// Arguments:
//   v = The vector to quantize.
//   m = The multiple to quantize to.
function vquant(v,m) = [for (x=v) quant(x,m)];


// Function: vquantdn()
// Usage:
//   vquantdn(v,m)
// Description:
//   Quantizes each scalar in the vector `v` to an integer multiple of `m`, rounding down to the nearest multiple.
// Arguments:
//   v = The vector to quantize.
//   m = The multiple to quantize to.
function vquantdn(v,m) = [for (x=v) quantdn(x,m)];


// Function: vquantup()
// Usage:
//   vquantup(v,m)
// Description:
//   Quantizes each scalar in the vector `v` to an integer multiple of `m`, rounding up to the nearest multiple.
// Arguments:
//   v = The vector to quantize.
//   m = The multiple to quantize to.
function vquantup(v,m) = [for (x=v) quantup(x,m)];


// Function: vector_angle()
// Usage:
//   vector_angle(v1,v2);
// Description:
//   Returns angle in degrees between two vectors of similar dimensions.
// Arguments:
//   v1 = First vector.
//   v2 = Second vector.
// NOTE: constrain() corrects crazy FP rounding errors that exceed acos()'s domain.
function vector_angle(v1,v2) =
	assert(is_vector(v1))
	assert(is_vector(v2))
	acos(constrain((v1*v2)/(norm(v1)*norm(v2)), -1, 1));


// Function: vector_axis()
// Usage:
//   vector_xis(v1,v2);
// Description:
//   Returns the vector perpendicular to both of the given vectors.
// Arguments:
//   v1 = First vector.
//   v2 = Second vector.
function vector_axis(v1,v2) =
	let(
		eps = 1e-6,
		v1 = point3d(v1/norm(v1)),
		v2 = point3d(v2/norm(v2)),
		v3 = (norm(v1-v2) > eps && norm(v1+v2) > eps)? v2 :
			(norm(vabs(v2)-UP) > eps)? UP :
			RIGHT
	) normalize(cross(v1,v3));


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
