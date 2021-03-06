//////////////////////////////////////////////////////////////////////
// LibFile: arrays.scad
//   List and Array manipulation functions.
//   To use, add the following lines to the beginning of your file:
//   ```
//   use <BOSL2/std.scad>
//   ```
//////////////////////////////////////////////////////////////////////


// Section: Terminology
//   - **List**: An ordered collection of zero or more items.  ie: ["a", "b", "c"]
//   - **Vector**: A list of numbers. ie: [4, 5, 6]
//   - **Array**: A nested list of lists, or list of lists of lists, or deeper.  ie: [[2,3], [4,5], [6,7]]
//   - **Dimension**: The depth of nesting of lists in an array.  A List is 1D.  A list of lists is 2D.  etc.


// Section: List Operations


// Function: replist()
// Usage:
//   replist(val, n)
// Description:
//   Generates a list or array of `n` copies of the given `list`.
//   If the count `n` is given as a list of counts, then this creates a
//   multi-dimensional array, filled with `val`.
// Arguments:
//   val = The value to repeat to make the list or array.
//   n = The number of copies to make of `val`.
// Example:
//   replist(1, 4);        // Returns [1,1,1,1]
//   replist(8, [2,3]);    // Returns [[8,8,8], [8,8,8]]
//   replist(0, [2,2,3]);  // Returns [[[0,0,0],[0,0,0]], [[0,0,0],[0,0,0]]]
//   replist([1,2,3],3);   // Returns [[1,2,3], [1,2,3], [1,2,3]]
function replist(val, n, i=0) =
	is_num(n)? [for(j=[1:n]) val] :
	(i>=len(n))? val :
	[for (j=[1:n[i]]) replist(val, n, i+1)];


// Function: in_list()
// Description: Returns true if value `x` is in list `l`.
// Arguments:
//   x = The value to search for.
//   l = The list to search.
//   idx = If given, searches the given subindexes for matches for `x`.
// Example:
//   in_list("bar", ["foo", "bar", "baz"]);  // Returns true.
//   in_list("bee", ["foo", "bar", "baz"]);  // Returns false.
//   in_list("bar", [[2,"foo"], [4,"bar"], [3,"baz"]], idx=1);  // Returns true.
function in_list(x,l,idx=undef) = search([x], l, num_returns_per_match=1, index_col_num=idx) != [[]];


// Function: slice()
// Description:
//   Returns a slice of a list.  The first item is index 0.
//   Negative indexes are counted back from the end.  The last item is -1.
// Arguments:
//   arr = The array/list to get the slice of.
//   st = The index of the first item to return.
//   end = The index after the last item to return, unless negative, in which case the last item to return.
// Example:
//   slice([3,4,5,6,7,8,9], 3, 5);   // Returns [6,7]
//   slice([3,4,5,6,7,8,9], 2, -1);  // Returns [5,6,7,8,9]
//   slice([3,4,5,6,7,8,9], 1, 1);   // Returns []
//   slice([3,4,5,6,7,8,9], 6, -1);  // Returns [9]
//   slice([3,4,5,6,7,8,9], 2, -2);  // Returns [5,6,7,8]
function slice(arr,st,end) = let(
		s=st<0?(len(arr)+st):st,
		e=end<0?(len(arr)+end+1):end
	) (s==e)? [] : [for (i=[s:e-1]) if (e>s) arr[i]];


// Function: select()
// Description:
//   Returns a portion of a list, wrapping around past the beginning, if end<start. 
//   The first item is index 0. Negative indexes are counted back from the end.
//   The last item is -1.  If only the `start` index is given, returns just the value
//   at that position.
// Usage:
//   select(list,start)
//   select(list,start,end)
// Arguments:
//   list = The list to get the portion of.
//   start = The index of the first item.
//   end = The index of the last item.
// Example:
//   l = [3,4,5,6,7,8,9];
//   select(l, 5, 6);   // Returns [8,9]
//   select(l, 5, 8);   // Returns [8,9,3,4]
//   select(l, 5, 2);   // Returns [8,9,3,4,5]
//   select(l, -3, -1); // Returns [7,8,9]
//   select(l, 3, 3);   // Returns [6]
//   select(l, 4);      // Returns 7
//   select(l, -2);     // Returns 8
//   select(l, [1:3]);  // Returns [4,5,6]
//   select(l, [1,3]);  // Returns [4,6]
function select(list, start, end=undef) =
	let(l=len(list))
	(list==[])? [] :
	end==undef? (
		is_num(start)?
			let(s=(start%l+l)%l) list[s] :
			[for (i=start) list[(i%l+l)%l]]
	) : (
		let(s=(start%l+l)%l, e=(end%l+l)%l)
		(s<=e)?
			[for (i = [s:e]) list[i]] :
			concat([for (i = [s:l-1]) list[i]], [for (i = [0:e]) list[i]])
	);


// Function: list_range()
// Usage:
//   list_range(n, [s], [e], [step])
//   list_range(e, [step])
//   list_range(s, e, [step])
// Description:
//   Returns a list, counting up from starting value `s`, by `step` increments,
//   until either `n` values are in the list, or it reaches the end value `e`.
// Arguments:
//   n = Desired number of values in returned list, if given.
//   s = Starting value.  Default: 0
//   e = Ending value to stop at, if given.
//   step = Amount to increment each value.  Default: 1
// Example:
//   list_range(4);                  // Returns [0,1,2,3]
//   list_range(n=4, step=2);        // Returns [0,2,4,6]
//   list_range(n=4, s=3, step=3);   // Returns [3,6,9,12]
//   list_range(n=4, s=3, e=9, step=3);  // Returns [3,6,9]
//   list_range(e=3);                // Returns [0,1,2,3]
//   list_range(e=6, step=2);        // Returns [0,2,4,6]
//   list_range(s=3, e=5);           // Returns [3,4,5]
//   list_range(s=3, e=8, step=2);   // Returns [3,5,7]
//   list_range(s=4, e=8, step=2);   // Returns [4,6,8]
//   list_range(n=4, s=[3,4], step=[2,3]);  // Returns [[3,4], [5,7], [7,10], [9,13]]
function list_range(n=undef, s=0, e=undef, step=1) =
	(n!=undef && e!=undef)? [for (i=[0:n-1]) let(v=s+step*i) if (v<=e) v] :
	(n!=undef)? [for (i=[0:n-1]) let(v=s+step*i) v] :
	(e!=undef)? [for (v=[s:step:e]) v] :
	assert(e!=undef||n!=undef, "Must supply one of `n` or `e`.");


// Function: reverse()
// Description: Reverses a list/array.
// Arguments:
//   list = The list to reverse.
// Example:
//   reverse([3,4,5,6]);  // Returns [6,5,4,3]
function reverse(list) = [ for (i = [len(list)-1 : -1 : 0]) list[i] ];


// Function: list_remove()
// Usage:
//   list_remove(list, elements)
// Description:
//   Remove all items from `list` whose indexes are in `elements`.
// Arguments:
//   list = The list to remove items from.
//   elements = The list of indexes of items to remove.
function list_remove(list, elements) = [
	for (i = [0:len(list)-1]) if (!search(i, elements)) list[i]
];


// Function: list_insert()
// Usage:
//   list_insert(list, pos, elements);
// Description:
//   Insert `elements` into `list` before position `pos`.
function list_insert(list, pos, elements) =
	concat(
		slice(list,0,pos),
		elements,
		(pos<len(list)? slide(list,pos,-1) : [])
	);


// Function: list_shortest()
// Description:
//   Returns the length of the shortest sublist in a list of lists.
// Arguments:
//   vecs = A list of lists.
function list_shortest(vecs) =
	min([for (v = vecs) len(v)]);


// Function: list_longest()
// Description:
//   Returns the length of the longest sublist in a list of lists.
// Arguments:
//   vecs = A list of lists.
function list_longest(vecs) =
	max([for (v = vecs) len(v)]);


// Function: list_pad()
// Description:
//   If the list `v` is shorter than `minlen` length, pad it to length with the value given in `fill`.
// Arguments:
//   v = A list.
//   minlen = The minimum length to pad the list to.
//   fill = The value to pad the list with.
function list_pad(v, minlen, fill=undef) =
	let(l=len(v)) [for (i=[0:max(l,minlen)-1]) i<l? v[i] : fill];


// Function: list_trim()
// Description:
//   If the list `v` is longer than `maxlen` length, truncates it to be `maxlen` items long.
// Arguments:
//   v = A list.
//   minlen = The minimum length to pad the list to.
function list_trim(v, maxlen) =
	maxlen<1? [] : [for (i=[0:min(len(v),maxlen)-1]) v[i]];


// Function: list_fit()
// Description:
//   If the list `v` is longer than `length` items long, truncates it to be exactly `length` items long.
//   If the list `v` is shorter than `length` items long, pad it to length with the value given in `fill`.
// Arguments:
//   v = A list.
//   minlen = The minimum length to pad the list to.
//   fill = The value to pad the list with.
function list_fit(v, length, fill) =
	let(l=len(v)) (l==length)? v : (l>length)? list_trim(v,length) : list_pad(v,length,fill);


// Function: enumerate()
// Description:
//   Returns a list, with each item of the given list `l` numbered in a sublist.
//   Something like: `[[0,l[0]], [1,l[1]], [2,l[2]], ...]`
// Arguments:
//   l = List to enumerate.
//   idx = If given, enumerates just the given subindex items of `l`.
// Example:
//   enumerate(["a","b","c"]);  // Returns: [[0,"a"], [1,"b"], [2,"c"]]
//   enumerate([[88,"a"],[76,"b"],[21,"c"]], idx=1);  // Returns: [[0,"a"], [1,"b"], [2,"c"]]
//   enumerate([["cat","a",12],["dog","b",10],["log","c",14]], idx=[1:2]);  // Returns: [[0,"a",12], [1,"b",10], [2,"c",14]]
function enumerate(l,idx=undef) =
	(l==[])? [] :
	(idx==undef)?
		[for (i=[0:len(l)-1]) [i,l[i]]] :
		[for (i=[0:len(l)-1]) concat([i], [for (j=idx) l[i][j]])];


// Function: sort()
// Usage:
//   sort(arr, [idx])
// Description:
//   Sorts the given list using `compare_vals()`.  Results are undefined if list elements are not of similar type.
// Arguments:
//   arr = The list to sort.
//   idx = If given, the index, range, or list of indices of sublist items to compare.
// Example:
//   l = [45,2,16,37,8,3,9,23,89,12,34];
//   sorted = sort(l);  // Returns [2,3,8,9,12,16,23,34,37,45,89]
function sort(arr, idx=undef) =
	(len(arr)<=1) ? arr :
	let(
		pivot = arr[floor(len(arr)/2)],
		pivotval = idx==undef? pivot : [for (i=idx) pivot[i]],
		compare = [
			for (entry = arr) let(
				val = idx==undef? entry : [for (i=idx) entry[i]],
				cmp = compare_vals(val, pivotval)
			) cmp
		],
		lesser  = [ for (i = [0:len(arr)-1]) if (compare[i] < 0) arr[i] ],
		equal   = [ for (i = [0:len(arr)-1]) if (compare[i] ==0) arr[i] ],
		greater = [ for (i = [0:len(arr)-1]) if (compare[i] > 0) arr[i] ]
	)
	concat(sort(lesser,idx), equal, sort(greater,idx));


// Function: sortidx()
// Description:
//   Given a list, calculates the sort order of the list, and returns
//   a list of indexes into the original list in that sorted order.
//   If you iterate the returned list in order, and use the list items
//   to index into the original list, you will be iterating the original
//   values in sorted order.
// Example:
//   lst = ["d","b","e","c"];
//   idxs = sortidx(lst);  // Returns: [1,3,0,2]
//   ordered = [for (i=idxs) lst[i]];  // Returns: ["b", "c", "d", "e"]
// Example:
//   lst = [
//   	["foo", 88, [0,0,1], false],
//   	["bar", 90, [0,1,0], true],
//   	["baz", 89, [1,0,0], false],
//   	["qux", 23, [1,1,1], true]
//   ];
//   idxs1 = sortidx(lst, idx=1); // Returns: [3,0,2,1]
//   idxs2 = sortidx(lst, idx=0); // Returns: [1,2,0,3]
//   idxs3 = sortidx(lst, idx=[1,3]); // Returns: [3,0,2,1]
function sortidx(l, idx=undef) =
	(l==[])? [] :
	let(
		ll=enumerate(l,idx=idx),
		sidx = [1:len(ll[0])-1]
	)
	array_subindex(sort(ll, idx=sidx), 0);


// Function: unique()
// Usage:
//   unique(arr);
// Description:
//   Returns a sorted list with all repeated items removed.
// Arguments:
//   arr = The list to uniquify.
function unique(arr) =
	len(arr)<=1? arr : let(
		sorted = sort(arr)
	) [
		for (i=[0:len(sorted)-1])
			if (i==0 || (sorted[i] != sorted[i-1]))
				sorted[i]
	];



// Section: Array Manipulation

// Function: array_subindex()
// Description:
//   For each array item, return the indexed subitem.
//   Returns a list of the values of each vector at the specfied
//   index list or range.  If the index list or range has
//   only one entry the output list is flattened.  
// Arguments:
//   v = The given list of lists.
//   idx = The index, list of indices, or range of indices to fetch.
// Example:
//   v = [[[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]];
//   array_subindex(v,2);      // Returns [3, 7, 11, 15]
//   array_subindex(v,[2,1]);  // Returns [[3, 2], [7, 6], [11, 10], [15, 14]]
//   array_subindex(v,[1:3]);  // Returns [[2, 3, 4], [6, 7, 8], [10, 11, 12], [14, 15, 16]]
function array_subindex(v, idx) = [
	for(val=v) let(value=[for(i=idx) val[i]])
		len(value)==1 ? value[0] : value
];


// Function: array_zip()
// Usage:
//   array_zip(v1, v2, v3, [fit], [fill]);
//   array_zip(vecs, [fit], [fill]);
// Description:
//   Zips together corresponding items from two or more lists.
//   Returns a list of lists, where each sublist contains corresponding
//   items from each of the input lists.  `[[A1, B1, C1], [A2, B2, C2], ...]`
// Arguments:
//   vecs = A list of two or more lists to zipper together.
//   fit = If `fit=="short"`, the zips together up to the length of the shortest list in vecs.  If `fit=="long"`, then pads all lists to the length of the longest, using the value in `fill`.  If `fit==false`, then requires all lists to be the same length.  Default: false.
//   fill = The default value to fill in with if one or more lists if short.  Default: undef
// Example:
//   v1 = [1,2,3,4];
//   v2 = [5,6,7];
//   v3 = [8,9,10,11];
//   array_zip(v1,v3);                       // returns [[1,8], [2,9], [3,10], [4,11]]
//   array_zip([v1,v3]);                     // returns [[1,8], [2,9], [3,10], [4,11]]
//   array_zip([v1,v2], fit="short");        // returns [[1,5], [2,6], [3,7]]
//   array_zip([v1,v2], fit="long");         // returns [[1,5], [2,6], [3,7], [4,undef]]
//   array_zip([v1,v2], fit="long, fill=0);  // returns [[1,5], [2,6], [3,7], [4,0]]
//   array_zip([v1,v2,v3], fit="long");      // returns [[1,5,8], [2,6,9], [3,7,10], [4,undef,11]]
// Example:
//   v1 = [[1,2,3], [4,5,6], [7,8,9]];
//   v2 = [[20,19,18], [17,16,15], [14,13,12]];
//   array_zip(v1,v2);    // Returns [[1,2,3,20,19,18], [4,5,6,17,16,15], [7,8,9,14,13,12]]
function array_zip(vecs, v2, v3, fit=false, fill=undef) =
	(v3!=undef)? array_zip([vecs,v2,v3], fit=fit, fill=fill) :
	(v2!=undef)? array_zip([vecs,v2], fit=fit, fill=fill) :
	let(
		dummy1 = assert_in_list("fit", fit, [false, "short", "long"]),
		minlen = list_shortest(vecs),
		maxlen = list_longest(vecs),
		dummy2 = (fit==false)? assert(minlen==maxlen, "Input vectors must have the same length") : 0
	) (fit == "long")?
		[for(i=[0:maxlen-1]) [for(v=vecs) for(x=(i<len(v)? v[i] : (fill==undef)? [fill] : fill)) x] ] :
		[for(i=[0:minlen-1]) [for(v=vecs) for(x=v[i]) x] ];



// Function: array_group()
// Description:
//   Takes a flat array of values, and groups items in sets of `cnt` length.
//   The opposite of this is `flatten()`.
// Arguments:
//   v = The list of items to group.
//   cnt = The number of items to put in each grouping.
//   dflt = The default value to fill in with is the list is not a multiple of `cnt` items long.
// Example:
//   v = [1,2,3,4,5,6];
//   array_group(v,2) returns [[1,2], [3,4], [5,6]]
//   array_group(v,3) returns [[1,2,3], [4,5,6]]
//   array_group(v,4,0) returns [[1,2,3,4], [5,6,0,0]]
function array_group(v, cnt=2, dflt=0) = [for (i = [0:cnt:len(v)-1]) [for (j = [0:cnt-1]) default(v[i+j], dflt)]];


// Function: flatten()
// Description: Takes a list of lists and flattens it by one level.
// Arguments:
//   l = List to flatten.
// Example:
//   flatten([[1,2,3], [4,5,[6,7,8]]]) returns [1,2,3,4,5,[6,7,8]]
function flatten(l) = [for (a = l) for (b = a) b];


// Internal.  Not exposed.
function _array_dim_recurse(v) =
    !is_list(v[0])?  (
		sum( [for(entry=v) is_list(entry) ? 1 : 0]) == 0 ? [] : [undef]
	) : let(
		firstlen = len(v[0]),
		first = sum( [for(entry = v) len(entry) == firstlen  ? 0 : 1]   ) == 0 ? firstlen : undef,
		leveldown = flatten(v)
	) is_list(leveldown[0])? (
		concat([first],_array_dim_recurse(leveldown))
	) : [first];


// Function: array_dim()
// Usage:
//   array_dim(v, [depth])
// Description:
//   Returns the size of a multi-dimensional array.  Returns a list of
//   dimension lengths.  The length of `v` is the dimension `0`.  The
//   length of the items in `v` is dimension `1`.  The length of the
//   items in the items in `v` is dimension `2`, etc.  For each dimension,
//   if the length of items at that depth is inconsistent, `undef` will
//   be returned.  If no items of that dimension depth exist, `0` is
//   returned.  Otherwise, the consistent length of items in that
//   dimensional depth is returned.
// Arguments:
//   v = Array to get dimensions of.
//   depth = Dimension to get size of.  If not given, returns a list of dimension lengths.
// Examples:
//   array_dim([[[1,2,3],[4,5,6]],[[7,8,9],[10,11,12]]]);     // Returns [2,2,3]
//   array_dim([[[1,2,3],[4,5,6]],[[7,8,9],[10,11,12]]], 0);  // Returns 2
//   array_dim([[[1,2,3],[4,5,6]],[[7,8,9],[10,11,12]]], 2);  // Returns 3
//   array_dim([[[1,2,3],[4,5,6]],[[7,8,9]]]);                // Returns [2,undef,3]
function array_dim(v, depth=undef) =
	(depth == undef)? (
		concat([len(v)], _array_dim_recurse(v))
	) : (depth == 0)? (
		len(v)
	) : (
		let(dimlist = _array_dim_recurse(v))
		(depth > len(dimlist))? 0 : dimlist[depth-1]
	);



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap
