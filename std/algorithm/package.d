// Written in the D programming language.

/**
Implements algorithms oriented mainly towards processing of
sequences. Sequences processed by these functions define range-based interfaces.
See also $(LINK2 std_range.html, Reference on ranges) and
$(WEB ddili.org/ders/d.en/ranges.html, tutorial on ranges).

<script type="text/javascript">inhibitQuickIndex = 1</script>

$(BOOKTABLE ,
$(TR $(TH Category) $(TH Functions)
)
$(TR $(TDNW Searching) $(TD $(MYREF all) $(MYREF any) $(MYREF balancedParens) $(MYREF
boyerMooreFinder) $(MYREF canFind) $(MYREF commonPrefix) $(MYREF count)
$(MYREF countUntil) $(MYREF endsWith) $(MYREF find) $(MYREF
findAdjacent) $(MYREF findAmong) $(MYREF findSkip) $(MYREF findSplit)
$(MYREF findSplitAfter) $(MYREF findSplitBefore) $(MYREF minCount)
$(MYREF minPos) $(MYREF skipOver) $(MYREF startsWith)
$(MYREF until) )
)
$(TR $(TDNW Comparison) $(TD $(MYREF among) $(MYREF castSwitch) $(MYREF clamp)
$(MYREF cmp) $(MYREF equal) $(MYREF levenshteinDistance) $(MYREF
levenshteinDistanceAndPath) $(MYREF max) $(MYREF min) $(MYREF mismatch)
$(MYREF predSwitch))
)
$(TR $(TDNW Iteration) $(TD $(MYREF cache) $(MYREF cacheBidirectional)
$(MYREF each) $(MYREF filter) $(MYREF filterBidirectional)
$(MYREF group) $(MYREF groupBy) $(MYREF joiner) $(MYREF map) $(MYREF reduce)
$(MYREF splitter) $(MYREF sum) $(MYREF uniq) )
)
$(TR $(TDNW Sorting) $(TD $(MYREF completeSort) $(MYREF isPartitioned)
$(MYREF isSorted) $(MYREF makeIndex) $(MYREF multiSort) $(MYREF
nextEvenPermutation) $(MYREF nextPermutation) $(MYREF partialSort)
$(MYREF partition) $(MYREF partition3) $(MYREF schwartzSort) $(MYREF sort)
$(MYREF topN) $(MYREF topNCopy) )
)
$(TR $(TDNW Set&nbsp;operations) $(TD $(MYREF cartesianProduct) $(MYREF
largestPartialIntersection) $(MYREF largestPartialIntersectionWeighted)
$(MYREF nWayUnion) $(MYREF setDifference) $(MYREF setIntersection) $(MYREF
setSymmetricDifference) $(MYREF setUnion) )
)
$(TR $(TDNW Mutation) $(TD $(MYREF bringToFront) $(MYREF copy) $(MYREF
fill) $(MYREF initializeAll) $(MYREF move) $(MYREF moveAll) $(MYREF
moveSome) $(MYREF remove) $(MYREF reverse) $(MYREF strip) $(MYREF stripLeft)
$(MYREF stripRight) $(MYREF swap) $(MYREF swapRanges) $(MYREF uninitializedFill) )
)
$(TR $(TDNW Utility) $(TD $(MYREF forward) ))
)

Many functions in this module are parameterized with a function or a
$(GLOSSARY predicate). The predicate may be passed either as a
function name, a delegate name, a $(GLOSSARY functor) name, or a
compile-time string. The string may consist of $(B any) legal D
expression that uses the symbol $(D a) (for unary functions) or the
symbols $(D a) and $(D b) (for binary functions). These names will NOT
interfere with other homonym symbols in user code because they are
evaluated in a different context. The default for all binary
comparison predicates is $(D "a == b") for unordered operations and
$(D "a < b") for ordered operations.

Example:

----
int[] a = ...;
static bool greater(int a, int b)
{
    return a > b;
}
sort!(greater)(a);  // predicate as alias
sort!("a > b")(a);  // predicate as string
                    // (no ambiguity with array name)
sort(a);            // no predicate, "a < b" is implicit
----

$(BOOKTABLE Cheat Sheet,

$(TR $(TH Function Name) $(TH Description))

$(LEADINGROW Searching)

$(T2 all,
        $(D all!"a > 0"([1, 2, 3, 4])) returns $(D true) because all elements
        are positive)
$(T2 any,
        $(D any!"a > 0"([1, 2, -3, -4])) returns $(D true) because at least one
        element is positive)
$(T2 balancedParens,
        $(D balancedParens("((1 + 1) / 2)")) returns $(D true) because the
        string has balanced parentheses.)
$(T2 boyerMooreFinder,
        $(D find("hello world", boyerMooreFinder("or"))) returns $(D "orld")
        using the $(LUCKY Boyer-Moore _algorithm).)
$(T2 canFind,
        $(D canFind("hello world", "or")) returns $(D true).)
$(T2 count,
        Counts elements that are equal to a specified value or satisfy a
        predicate.  $(D count([1, 2, 1], 1)) returns $(D 2) and
        $(D count!"a < 0"([1, -3, 0])) returns $(D 1).)
$(T2 countUntil,
        $(D countUntil(a, b)) returns the number of steps taken in $(D a) to
        reach $(D b); for example, $(D countUntil("hello!", "o")) returns
        $(D 4).)
$(T2 commonPrefix,
        $(D commonPrefix("parakeet", "parachute")) returns $(D "para").)
$(T2 endsWith,
        $(D endsWith("rocks", "ks")) returns $(D true).)
$(T2 find,
        $(D find("hello world", "or")) returns $(D "orld") using linear search.
        (For binary search refer to $(XREF range,sortedRange).))
$(T2 findAdjacent,
        $(D findAdjacent([1, 2, 3, 3, 4])) returns the subrange starting with
        two equal adjacent elements, i.e. $(D [3, 3, 4]).)
$(T2 findAmong,
        $(D findAmong("abcd", "qcx")) returns $(D "cd") because $(D 'c') is
        among $(D "qcx").)
$(T2 findSkip,
        If $(D a = "abcde"), then $(D findSkip(a, "x")) returns $(D false) and
        leaves $(D a) unchanged, whereas $(D findSkip(a, 'c')) advances $(D a)
        to $(D "cde") and returns $(D true).)
$(T2 findSplit,
        $(D findSplit("abcdefg", "de")) returns the three ranges $(D "abc"),
        $(D "de"), and $(D "fg").)
$(T2 findSplitAfter,
        $(D findSplitAfter("abcdefg", "de")) returns the two ranges
        $(D "abcde") and $(D "fg").)
$(T2 findSplitBefore,
        $(D findSplitBefore("abcdefg", "de")) returns the two ranges $(D "abc")
        and $(D "defg").)
$(T2 minCount,
        $(D minCount([2, 1, 1, 4, 1])) returns $(D tuple(1, 3)).)
$(T2 minPos,
        $(D minPos([2, 3, 1, 3, 4, 1])) returns the subrange $(D [1, 3, 4, 1]),
        i.e., positions the range at the first occurrence of its minimal
        element.)
$(T2 mismatch,
        $(D mismatch("parakeet", "parachute")) returns the two ranges
        $(D "keet") and $(D "chute").)
$(T2 skipOver,
        Assume $(D a = "blah"). Then $(D skipOver(a, "bi")) leaves $(D a)
        unchanged and returns $(D false), whereas $(D skipOver(a, "bl"))
        advances $(D a) to refer to $(D "ah") and returns $(D true).)
$(T2 startsWith,
        $(D startsWith("hello, world", "hello")) returns $(D true).)
$(T2 until,
        Lazily iterates a range until a specific value is found.)

$(LEADINGROW Comparison)

$(T2 among,
        Checks if a value is among a set of values, e.g.
        $(D if (v.among(1, 2, 3)) // `v` is 1, 2 or 3))
$(T2 castSwitch,
        $(D (new A()).castSwitch((A a)=>1,(B b)=>2)) returns $(D 1).)
$(T2 clamp,
        $(D clamp(1, 3, 6)) returns $(D 3). $(D clamp(4, 3, 6)) returns $(D 4).)
$(T2 cmp,
        $(D cmp("abc", "abcd")) is $(D -1), $(D cmp("abc", "aba")) is $(D 1),
        and $(D cmp("abc", "abc")) is $(D 0).)
$(T2 equal,
        Compares ranges for element-by-element equality, e.g.
        $(D equal([1, 2, 3], [1.0, 2.0, 3.0])) returns $(D true).)
$(T2 levenshteinDistance,
        $(D levenshteinDistance("kitten", "sitting")) returns $(D 3) by using
        the $(LUCKY Levenshtein distance _algorithm).)
$(T2 levenshteinDistanceAndPath,
        $(D levenshteinDistanceAndPath("kitten", "sitting")) returns
        $(D tuple(3, "snnnsni")) by using the $(LUCKY Levenshtein distance
        _algorithm).)
$(T2 max,
        $(D max(3, 4, 2)) returns $(D 4).)
$(T2 min,
        $(D min(3, 4, 2)) returns $(D 2).)
$(T2 mismatch,
        $(D mismatch("oh hi", "ohayo")) returns $(D tuple(" hi", "ayo")).)
$(T2 predSwitch,
        $(D 2.predSwitch(1, "one", 2, "two", 3, "three")) returns $(D "two").)

$(LEADINGROW Iteration)

$(T2 cache,
        Eagerly evaluates and caches another range's $(D front).)
$(T2 cacheBidirectional,
        As above, but also provides $(D back) and $(D popBack).)
$(T2 each,
        $(D each!writeln([1, 2, 3])) eagerly prints the numbers $(D 1), $(D 2)
        and $(D 3) on their own lines.)
$(T2 filter,
        $(D filter!"a > 0"([1, -1, 2, 0, -3])) iterates over elements $(D 1)
        and $(D 2).)
$(T2 filterBidirectional,
        Similar to $(D filter), but also provides $(D back) and $(D popBack) at
        a small increase in cost.)
$(T2 group,
        $(D group([5, 2, 2, 3, 3])) returns a range containing the tuples
        $(D tuple(5, 1)), $(D tuple(2, 2)), and $(D tuple(3, 2)).)
$(T2 groupBy,
        $(D groupBy!((a,b) => a[1] == b[1])([[1, 1], [1, 2], [2, 2], [2, 1]]))
        returns a range containing 3 subranges: the first with just
        $(D [1, 1]); the second with the elements $(D [1, 2]) and $(D [2, 2]);
        and the third with just $(D [2, 1]).)
$(T2 joiner,
        $(D joiner(["hello", "world!"], "; ")) returns a range that iterates
        over the characters $(D "hello; world!"). No new string is created -
        the existing inputs are iterated.)
$(T2 map,
        $(D map!"2 * a"([1, 2, 3])) lazily returns a range with the numbers
        $(D 2), $(D 4), $(D 6).)
$(T2 reduce,
        $(D reduce!"a + b"([1, 2, 3, 4])) returns $(D 10).)
$(T2 splitter,
        Lazily splits a range by a separator.)
$(T2 sum,
        Same as $(D reduce), but specialized for accurate summation.)
$(T2 uniq,
        Iterates over the unique elements in a range, which is assumed sorted.)

$(LEADINGROW Sorting)

$(T2 completeSort,
        If $(D a = [10, 20, 30]) and $(D b = [40, 6, 15]), then
        $(D completeSort(a, b)) leaves $(D a = [6, 10, 15]) and $(D b = [20,
        30, 40]).
        The range $(D a) must be sorted prior to the call, and as a result the
        combination $(D $(XREF range,chain)(a, b)) is sorted.)
$(T2 isPartitioned,
        $(D isPartitioned!"a < 0"([-1, -2, 1, 0, 2])) returns $(D true) because
        the predicate is $(D true) for a portion of the range and $(D false)
        afterwards.)
$(T2 isSorted,
        $(D isSorted([1, 1, 2, 3])) returns $(D true).)
$(T2 makeIndex,
        Creates a separate index for a range.)
$(T2 nextEvenPermutation,
        Computes the next lexicographically greater even permutation of a range
        in-place.)
$(T2 nextPermutation,
        Computes the next lexicographically greater permutation of a range
        in-place.)
$(T2 partialSort,
        If $(D a = [5, 4, 3, 2, 1]), then $(D partialSort(a, 3)) leaves
        $(D a[0 .. 3] = [1, 2, 3]).
        The other elements of $(D a) are left in an unspecified order.)
$(T2 partition,
        Partitions a range according to a predicate.)
$(T2 partition3,
        Partitions a range in three parts (less than, equal, greater than the
        given pivot).)
$(T2 schwartzSort,
        Sorts with the help of the $(LUCKY Schwartzian transform).)
$(T2 sort,
        Sorts.)
$(T2 topN,
        Separates the top elements in a range.)
$(T2 topNCopy,
        Copies out the top elements of a range.)

$(LEADINGROW Set operations)

$(T2 cartesianProduct,
        Computes Cartesian product of two ranges.)
$(T2 largestPartialIntersection,
        Copies out the values that occur most frequently in a range of ranges.)
$(T2 largestPartialIntersectionWeighted,
        Copies out the values that occur most frequently (multiplied by
        per-value weights) in a range of ranges.)
$(T2 nWayUnion,
        Computes the union of a set of sets implemented as a range of sorted
        ranges.)
$(T2 setDifference,
        Lazily computes the set difference of two or more sorted ranges.)
$(T2 setIntersection,
        Lazily computes the intersection of two or more sorted ranges.)
$(T2 setSymmetricDifference,
        Lazily computes the symmetric set difference of two or more sorted
        ranges.)
$(T2 setUnion,
        Lazily computes the set union of two or more sorted ranges.)

$(LEADINGROW Mutation)

$(T2 bringToFront,
        If $(D a = [1, 2, 3]) and $(D b = [4, 5, 6, 7]),
        $(D bringToFront(a, b)) leaves $(D a = [4, 5, 6]) and
        $(D b = [7, 1, 2, 3]).)
$(T2 copy,
        Copies a range to another. If
        $(D a = [1, 2, 3]) and $(D b = new int[5]), then $(D copy(a, b))
        leaves $(D b = [1, 2, 3, 0, 0]) and returns $(D b[3 .. $]).)
$(T2 fill,
        Fills a range with a pattern,
        e.g., if $(D a = new int[3]), then $(D fill(a, 4))
        leaves $(D a = [4, 4, 4]) and $(D fill(a, [3, 4])) leaves
        $(D a = [3, 4, 3]).)
$(T2 initializeAll,
        If $(D a = [1.2, 3.4]), then $(D initializeAll(a)) leaves
        $(D a = [double.init, double.init]).)
$(T2 move,
        $(D move(a, b)) moves $(D a) into $(D b). $(D move(a)) reads $(D a)
        destructively.)
$(T2 moveAll,
        Moves all elements from one range to another.)
$(T2 moveSome,
        Moves as many elements as possible from one range to another.)
$(T2 remove,
        Removes elements from a range in-place, and returns the shortened
        range.)
$(T2 reverse,
        If $(D a = [1, 2, 3]), $(D reverse(a)) changes it to $(D [3, 2, 1]).)
$(T2 strip,
        Strips all leading and trailing elements equal to a value, or that
        satisfy a predicate.
        If $(D a = [1, 1, 0, 1, 1]), then $(D strip(a, 1)) and
        $(D strip!(e => e == 1)(a)) returns $(D [0]).)
$(T2 stripLeft,
        Strips all leading elements equal to a value, or that satisfy a
        predicate.  If $(D a = [1, 1, 0, 1, 1]), then $(D stripLeft(a, 1)) and
        $(D stripLeft!(e => e == 1)(a)) returns $(D [0, 1, 1]).)
$(T2 stripRight,
        Strips all trailing elements equal to a value, or that satisfy a
        predicate.
        If $(D a = [1, 1, 0, 1, 1]), then $(D stripRight(a, 1)) and
        $(D stripRight!(e => e == 1)(a)) returns $(D [1, 1, 0]).)
$(T2 swap,
        Swaps two values.)
$(T2 swapRanges,
        Swaps all elements of two ranges.)
$(T2 uninitializedFill,
        Fills a range (assumed uninitialized) with a value.)
)

Macros:
T2=$(TR $(TDNW $(LREF $1)) $(TD $+))
WIKI = Phobos/StdAlgorithm

Copyright: Andrei Alexandrescu 2008-.

License: $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: $(WEB erdani.com, Andrei Alexandrescu)

Source: $(PHOBOSSRC std/_algorithm.d)
 */
module std.algorithm;
//debug = std_algorithm;

public import std.algorithm.comparison;
public import std.algorithm.iteration;
public import std.algorithm.setops;
public import std.algorithm.searching;
public import std.algorithm.sorting;

// FIXME
import std.functional; // : unaryFun, binaryFun;
import std.range.primitives;
// FIXME
import std.range; // : SortedRange;
import std.traits;
// FIXME
import std.typecons; // : tuple, Tuple;
// FIXME
import std.typetuple; // : TypeTuple, staticMap, allSatisfy, anySatisfy;

version(unittest) debug(std_algorithm) import std.stdio;

package T* addressOf(T)(ref T val) { return &val; }

// Same as std.string.format, but "self-importing".
// Helps reduce code and imports, particularly in static asserts.
// Also helps with missing imports errors.
package template algoFormat()
{
    import std.format : format;
    alias algoFormat = format;
}

// each
/**
Eagerly iterates over $(D r) and calls $(D pred) over _each element.

Params:
    pred = predicate to apply to each element of the range
    r = range or iterable over which each iterates

Example:
---
void deleteOldBackups()
{
    import std.algorithm, std.datetime, std.file;
    auto cutoff = Clock.currTime() - 7.days;
    dirEntries("", "*~", SpanMode.depth)
        .filter!(de => de.timeLastModified < cutoff)
        .each!remove();
}
---

If the range supports it, the value can be mutated in place. Examples:
---
arr.each!((ref a) => a++);
arr.each!"a++";
---

If no predicate is specified, $(D each) will default to doing nothing
but consuming the entire range. $(D .front) will be evaluated, but this
can be avoided by explicitly specifying a predicate lambda with a
$(D lazy) parameter.

$(D each) also supports $(D opApply)-based iterators, so it will work
with e.g. $(XREF parallelism, parallel).

See_Also: $(XREF range,tee)

 */
template each(alias pred = "a")
{
    alias BinaryArgs = TypeTuple!(pred, "i", "a");

    enum isRangeUnaryIterable(R) =
        is(typeof(unaryFun!pred(R.init.front)));

    enum isRangeBinaryIterable(R) =
        is(typeof(binaryFun!BinaryArgs(0, R.init.front)));

    enum isRangeIterable(R) =
        isInputRange!R &&
        (isRangeUnaryIterable!R || isRangeBinaryIterable!R);

    enum isForeachUnaryIterable(R) =
        is(typeof((R r) {
            foreach (ref a; r)
                cast(void)unaryFun!pred(a);
        }));

    enum isForeachBinaryIterable(R) =
        is(typeof((R r) {
            foreach (i, ref a; r)
                cast(void)binaryFun!BinaryArgs(i, a);
        }));

    enum isForeachIterable(R) =
        (!isForwardRange!R || isDynamicArray!R) &&
        (isForeachUnaryIterable!R || isForeachBinaryIterable!R);

    void each(Range)(Range r)
    if (isRangeIterable!Range && !isForeachIterable!Range)
    {
        debug(each) pragma(msg, "Using while for ", Range.stringof);
        static if (isRangeUnaryIterable!Range)
        {
            while (!r.empty)
            {
                cast(void)unaryFun!pred(r.front);
                r.popFront();
            }
        }
        else // if (isRangeBinaryIterable!Range)
        {
            size_t i = 0;
            while (!r.empty)
            {
                cast(void)binaryFun!BinaryArgs(i, r.front);
                r.popFront();
                i++;
            }
        }
    }

    void each(Iterable)(Iterable r)
        if (isForeachIterable!Iterable)
    {
        debug(each) pragma(msg, "Using foreach for ", Iterable.stringof);
        static if (isForeachUnaryIterable!Iterable)
        {
            foreach (ref e; r)
                cast(void)unaryFun!pred(e);
        }
        else // if (isForeachBinaryIterable!Iterable)
        {
            foreach (i, ref e; r)
                cast(void)binaryFun!BinaryArgs(i, e);
        }
    }
}

unittest
{
    long[] arr;
    // Note: each over arrays should resolve to the
    // foreach variant, but as this is a performance
    // improvement it is not unit-testable.
    iota(5).each!(n => arr ~= n);
    assert(arr == [0, 1, 2, 3, 4]);

    // in-place mutation
    arr.each!((ref n) => n++);
    assert(arr == [1, 2, 3, 4, 5]);

    // by-ref lambdas should not be allowed for non-ref ranges
    static assert(!is(typeof(arr.map!(n => n).each!((ref n) => n++))));

    // default predicate (walk / consume)
    auto m = arr.map!(n => n);
    (&m).each();
    assert(m.empty);

    // in-place mutation with index
    arr[] = 0;
    arr.each!"a=i"();
    assert(arr == [0, 1, 2, 3, 4]);

    // opApply iterators
    static assert(is(typeof({
        import std.parallelism;
        arr.parallel.each!"a++";
    })));
}

/**
Assigns $(D value) to each element of input range $(D range).

Params:
        range = An $(XREF2 range, isInputRange, input range) that exposes references to its elements
                and has assignable elements
        value = Assigned to each element of range

See_Also:
        $(LREF uninitializedFill)
        $(LREF initializeAll)
 */
void fill(Range, Value)(Range range, Value value)
    if (isInputRange!Range && is(typeof(range.front = value)))
{
    alias T = ElementType!Range;

    static if (is(typeof(range[] = value)))
    {
        range[] = value;
    }
    else static if (is(typeof(range[] = T(value))))
    {
        range[] = T(value);
    }
    else
    {
        for ( ; !range.empty; range.popFront() )
        {
            range.front = value;
        }
    }
}

///
@safe unittest
{
    int[] a = [ 1, 2, 3, 4 ];
    fill(a, 5);
    assert(a == [ 5, 5, 5, 5 ]);
}

@safe unittest
{
    import std.conv : text;
    import std.internal.test.dummyrange;

    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");

    int[] a = [ 1, 2, 3 ];
    fill(a, 6);
    assert(a == [ 6, 6, 6 ], text(a));

    void fun0()
    {
        foreach (i; 0 .. 1000)
        {
            foreach (ref e; a) e = 6;
        }
    }
    void fun1() { foreach (i; 0 .. 1000) fill(a, 6); }
    //void fun2() { foreach (i; 0 .. 1000) fill2(a, 6); }
    //writeln(benchmark!(fun0, fun1, fun2)(10000));

    // fill should accept InputRange
    alias InputRange = DummyRange!(ReturnBy.Reference, Length.No, RangeType.Input);
    enum filler = uint.max;
    InputRange range;
    fill(range, filler);
    foreach (value; range.arr)
        assert(value == filler);
}

@safe unittest
{
    //ER8638_1 IS_NOT self assignable
    static struct ER8638_1
    {
        void opAssign(int){}
    }

    //ER8638_1 IS self assignable
    static struct ER8638_2
    {
        void opAssign(ER8638_2){}
        void opAssign(int){}
    }

    auto er8638_1 = new ER8638_1[](10);
    auto er8638_2 = new ER8638_2[](10);
    er8638_1.fill(5); //generic case
    er8638_2.fill(5); //opSlice(T.init) case
}

@safe unittest
{
    {
        int[] a = [1, 2, 3];
        immutable(int) b = 0;
        static assert(__traits(compiles, a.fill(b)));
    }
    {
        double[] a = [1, 2, 3];
        immutable(int) b = 0;
        static assert(__traits(compiles, a.fill(b)));
    }
}

/**
Fills $(D range) with a pattern copied from $(D filler). The length of
$(D range) does not have to be a multiple of the length of $(D
filler). If $(D filler) is empty, an exception is thrown.

Params:
    range = An $(XREF2 range, isInputRange, input range) that exposes
            references to its elements and has assignable elements.
    filler = The $(XREF2 range, isForwardRange, forward range) representing the
             _fill pattern.
 */
void fill(Range1, Range2)(Range1 range, Range2 filler)
    if (isInputRange!Range1
        && (isForwardRange!Range2
            || (isInputRange!Range2 && isInfinite!Range2))
        && is(typeof(Range1.init.front = Range2.init.front)))
{
    static if (isInfinite!Range2)
    {
        //Range2 is infinite, no need for bounds checking or saving
        static if (hasSlicing!Range2 && hasLength!Range1
            && is(typeof(filler[0 .. range.length])))
        {
            copy(filler[0 .. range.length], range);
        }
        else
        {
            //manual feed
            for ( ; !range.empty; range.popFront(), filler.popFront())
            {
                range.front = filler.front;
            }
        }
    }
    else
    {
        import std.exception : enforce;

        enforce(!filler.empty, "Cannot fill range with an empty filler");

        static if (hasLength!Range1 && hasLength!Range2
            && is(typeof(range.length > filler.length)))
        {
            //Case we have access to length
            auto len = filler.length;
            //Start by bulk copies
            while (range.length > len)
            {
                range = copy(filler.save, range);
            }

            //and finally fill the partial range. No need to save here.
            static if (hasSlicing!Range2 && is(typeof(filler[0 .. range.length])))
            {
                //use a quick copy
                auto len2 = range.length;
                range = copy(filler[0 .. len2], range);
            }
            else
            {
                //iterate. No need to check filler, it's length is longer than range's
                for (; !range.empty; range.popFront(), filler.popFront())
                {
                    range.front = filler.front;
                }
            }
        }
        else
        {
            //Most basic case.
            auto bck = filler.save;
            for (; !range.empty; range.popFront(), filler.popFront())
            {
                if (filler.empty) filler = bck.save;
                range.front = filler.front;
            }
        }
    }
}

///
@safe unittest
{
    int[] a = [ 1, 2, 3, 4, 5 ];
    int[] b = [ 8, 9 ];
    fill(a, b);
    assert(a == [ 8, 9, 8, 9, 8 ]);
}

@safe unittest
{
    import std.exception : assertThrown;
    import std.internal.test.dummyrange;

    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");

    int[] a = [ 1, 2, 3, 4, 5 ];
    int[] b = [1, 2];
    fill(a, b);
    assert(a == [ 1, 2, 1, 2, 1 ]);

    // fill should accept InputRange
    alias InputRange = DummyRange!(ReturnBy.Reference, Length.No, RangeType.Input);
    InputRange range;
    fill(range,[1,2]);
    foreach (i,value;range.arr)
    assert(value == (i%2==0?1:2));

    //test with a input being a "reference forward" range
    fill(a, new ReferenceForwardRange!int([8, 9]));
    assert(a == [8, 9, 8, 9, 8]);

    //test with a input being an "infinite input" range
    fill(a, new ReferenceInfiniteInputRange!int());
    assert(a == [0, 1, 2, 3, 4]);

    //empty filler test
    assertThrown(fill(a, a[$..$]));
}

/**
Initializes each element of $(D range) with $(D value).
Assumes that the elements of the range are uninitialized.
This is of interest for structs that
define copy constructors (for all other types, $(LREF fill) and
uninitializedFill are equivalent).

Params:
        range = An $(XREF2 range, isInputRange, input range) that exposes references to its elements
                and has assignable elements
        value = Assigned to each element of range

See_Also:
        $(LREF fill)
        $(LREF initializeAll)

Example:
----
struct S { ... }
S[] s = (cast(S*) malloc(5 * S.sizeof))[0 .. 5];
uninitializedFill(s, 42);
assert(s == [ 42, 42, 42, 42, 42 ]);
----
 */
void uninitializedFill(Range, Value)(Range range, Value value)
    if (isInputRange!Range && hasLvalueElements!Range && is(typeof(range.front = value)))
{
    alias T = ElementType!Range;
    static if (hasElaborateAssign!T)
    {
        import std.conv : emplaceRef;

        // Must construct stuff by the book
        for (; !range.empty; range.popFront())
            emplaceRef!T(range.front, value);
    }
    else
        // Doesn't matter whether fill is initialized or not
        return fill(range, value);
}

/**
Initializes all elements of $(D range) with their $(D .init) value.
Assumes that the elements of the range are uninitialized.

Params:
        range = An $(XREF2 range, isInputRange, input range) that exposes references to its elements
                and has assignable elements

See_Also:
        $(LREF fill)
        $(LREF uninitializeFill)

Example:
----
struct S { ... }
S[] s = (cast(S*) malloc(5 * S.sizeof))[0 .. 5];
initializeAll(s);
assert(s == [ 0, 0, 0, 0, 0 ]);
----
 */
void initializeAll(Range)(Range range)
    if (isInputRange!Range && hasLvalueElements!Range && hasAssignableElements!Range)
{
    import core.stdc.string : memset, memcpy;

    alias T = ElementType!Range;
    static if (hasElaborateAssign!T)
    {
        //Elaborate opAssign. Must go the memcpy road.
        //We avoid calling emplace here, because our goal is to initialize to
        //the static state of T.init,
        //So we want to avoid any un-necassarilly CC'ing of T.init
        auto p = typeid(T).init().ptr;
        if (p)
            for ( ; !range.empty ; range.popFront() )
                memcpy(addressOf(range.front), p, T.sizeof);
        else
            static if (isDynamicArray!Range)
                memset(range.ptr, 0, range.length * T.sizeof);
            else
                for ( ; !range.empty ; range.popFront() )
                    memset(addressOf(range.front), 0, T.sizeof);
    }
    else
        fill(range, T.init);
}

// ditto
void initializeAll(Range)(Range range)
    if (is(Range == char[]) || is(Range == wchar[]))
{
    alias T = ElementEncodingType!Range;
    range[] = T.init;
}

unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");

    //Test strings:
    //Must work on narrow strings.
    //Must reject const
    char[3] a = void;
    a[].initializeAll();
    assert(a[] == [char.init, char.init, char.init]);
    string s;
    assert(!__traits(compiles, s.initializeAll()));

    //Note: Cannot call uninitializedFill on narrow strings

    enum e {e1, e2}
    e[3] b1 = void;
    b1[].initializeAll();
    assert(b1[] == [e.e1, e.e1, e.e1]);
    e[3] b2 = void;
    b2[].uninitializedFill(e.e2);
    assert(b2[] == [e.e2, e.e2, e.e2]);

    static struct S1
    {
        int i;
    }
    static struct S2
    {
        int i = 1;
    }
    static struct S3
    {
        int i;
        this(this){}
    }
    static struct S4
    {
        int i = 1;
        this(this){}
    }
    static assert (!hasElaborateAssign!S1);
    static assert (!hasElaborateAssign!S2);
    static assert ( hasElaborateAssign!S3);
    static assert ( hasElaborateAssign!S4);
    assert (!typeid(S1).init().ptr);
    assert ( typeid(S2).init().ptr);
    assert (!typeid(S3).init().ptr);
    assert ( typeid(S4).init().ptr);

    foreach(S; TypeTuple!(S1, S2, S3, S4))
    {
        //initializeAll
        {
            //Array
            S[3] ss1 = void;
            ss1[].initializeAll();
            assert(ss1[] == [S.init, S.init, S.init]);

            //Not array
            S[3] ss2 = void;
            auto sf = ss2[].filter!"true"();

            sf.initializeAll();
            assert(ss2[] == [S.init, S.init, S.init]);
        }
        //uninitializedFill
        {
            //Array
            S[3] ss1 = void;
            ss1[].uninitializedFill(S(2));
            assert(ss1[] == [S(2), S(2), S(2)]);

            //Not array
            S[3] ss2 = void;
            auto sf = ss2[].filter!"true"();
            sf.uninitializedFill(S(2));
            assert(ss2[] == [S(2), S(2), S(2)]);
        }
    }
}

// move
/**
Moves $(D source) into $(D target) via a destructive copy.

Params:
    source = Data to copy. If a destructor or postblit is defined, it is reset
        to its $(D .init) value after it is moved into target.  Note that data
        with internal pointers that point to itself cannot be moved, and will
        trigger an assertion failure.
    target = Where to copy into. The destructor, if any, is invoked before the
        copy is performed.
*/
void move(T)(ref T source, ref T target)
{
    import core.stdc.string : memcpy;

    static if (hasAliasing!T) if (!__ctfe)
    {
        import std.exception : doesPointTo;
        assert(!doesPointTo(source, source), "Cannot move object with internal pointer.");
    }

    static if (is(T == struct))
    {
        if (&source == &target) return;
        // Most complicated case. Destroy whatever target had in it
        // and bitblast source over it
        static if (hasElaborateDestructor!T) typeid(T).destroy(&target);

        static if (hasElaborateAssign!T || !isAssignable!T)
            memcpy(&target, &source, T.sizeof);
        else
            target = source;

        // If the source defines a destructor or a postblit hook, we must obliterate the
        // object in order to avoid double freeing and undue aliasing
        static if (hasElaborateDestructor!T || hasElaborateCopyConstructor!T)
        {
            static T empty;
            static if (T.tupleof.length > 0 &&
                       T.tupleof[$-1].stringof.endsWith("this"))
            {
                // If T is nested struct, keep original context pointer
                memcpy(&source, &empty, T.sizeof - (void*).sizeof);
            }
            else
            {
                memcpy(&source, &empty, T.sizeof);
            }
        }
    }
    else
    {
        // Primitive data (including pointers and arrays) or class -
        // assignment works great
        target = source;
    }
}

unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    import std.exception : assertCTFEable;
    assertCTFEable!((){
        Object obj1 = new Object;
        Object obj2 = obj1;
        Object obj3;
        move(obj2, obj3);
        assert(obj3 is obj1);

        static struct S1 { int a = 1, b = 2; }
        S1 s11 = { 10, 11 };
        S1 s12;
        move(s11, s12);
        assert(s11.a == 10 && s11.b == 11 && s12.a == 10 && s12.b == 11);

        static struct S2 { int a = 1; int * b; }
        S2 s21 = { 10, null };
        s21.b = new int;
        S2 s22;
        move(s21, s22);
        assert(s21 == s22);
    });
    // Issue 5661 test(1)
    static struct S3
    {
        static struct X { int n = 0; ~this(){n = 0;} }
        X x;
    }
    static assert(hasElaborateDestructor!S3);
    S3 s31, s32;
    s31.x.n = 1;
    move(s31, s32);
    assert(s31.x.n == 0);
    assert(s32.x.n == 1);

    // Issue 5661 test(2)
    static struct S4
    {
        static struct X { int n = 0; this(this){n = 0;} }
        X x;
    }
    static assert(hasElaborateCopyConstructor!S4);
    S4 s41, s42;
    s41.x.n = 1;
    move(s41, s42);
    assert(s41.x.n == 0);
    assert(s42.x.n == 1);
}

/// Ditto
T move(T)(ref T source)
{
    import core.stdc.string : memcpy;

    static if (hasAliasing!T) if (!__ctfe)
    {
        import std.exception : doesPointTo;
        assert(!doesPointTo(source, source), "Cannot move object with internal pointer.");
    }

    T result = void;
    static if (is(T == struct))
    {
        // Can avoid destructing result.
        static if (hasElaborateAssign!T || !isAssignable!T)
            memcpy(&result, &source, T.sizeof);
        else
            result = source;

        // If the source defines a destructor or a postblit hook, we must obliterate the
        // object in order to avoid double freeing and undue aliasing
        static if (hasElaborateDestructor!T || hasElaborateCopyConstructor!T)
        {
            static T empty;
            static if (T.tupleof.length > 0 &&
                       T.tupleof[$-1].stringof.endsWith("this"))
            {
                // If T is nested struct, keep original context pointer
                memcpy(&source, &empty, T.sizeof - (void*).sizeof);
            }
            else
            {
                memcpy(&source, &empty, T.sizeof);
            }
        }
    }
    else
    {
        // Primitive data (including pointers and arrays) or class -
        // assignment works great
        result = source;
    }
    return result;
}

unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    import std.exception : assertCTFEable;
    assertCTFEable!((){
        Object obj1 = new Object;
        Object obj2 = obj1;
        Object obj3 = move(obj2);
        assert(obj3 is obj1);

        static struct S1 { int a = 1, b = 2; }
        S1 s11 = { 10, 11 };
        S1 s12 = move(s11);
        assert(s11.a == 10 && s11.b == 11 && s12.a == 10 && s12.b == 11);

        static struct S2 { int a = 1; int * b; }
        S2 s21 = { 10, null };
        s21.b = new int;
        S2 s22 = move(s21);
        assert(s21 == s22);
    });

    // Issue 5661 test(1)
    static struct S3
    {
        static struct X { int n = 0; ~this(){n = 0;} }
        X x;
    }
    static assert(hasElaborateDestructor!S3);
    S3 s31;
    s31.x.n = 1;
    S3 s32 = move(s31);
    assert(s31.x.n == 0);
    assert(s32.x.n == 1);

    // Issue 5661 test(2)
    static struct S4
    {
        static struct X { int n = 0; this(this){n = 0;} }
        X x;
    }
    static assert(hasElaborateCopyConstructor!S4);
    S4 s41;
    s41.x.n = 1;
    S4 s42 = move(s41);
    assert(s41.x.n == 0);
    assert(s42.x.n == 1);
}

unittest//Issue 6217
{
    auto x = map!"a"([1,2,3]);
    x = move(x);
}

unittest// Issue 8055
{
    static struct S
    {
        int x;
        ~this()
        {
            assert(x == 0);
        }
    }
    S foo(S s)
    {
        return move(s);
    }
    S a;
    a.x = 0;
    auto b = foo(a);
    assert(b.x == 0);
}

unittest// Issue 8057
{
    int n = 10;
    struct S
    {
        int x;
        ~this()
        {
            // Access to enclosing scope
            assert(n == 10);
        }
    }
    S foo(S s)
    {
        // Move nested struct
        return move(s);
    }
    S a;
    a.x = 1;
    auto b = foo(a);
    assert(b.x == 1);

    // Regression 8171
    static struct Array(T)
    {
        // nested struct has no member
        struct Payload
        {
            ~this() {}
        }
    }
    Array!int.Payload x = void;
    static assert(__traits(compiles, move(x)    ));
    static assert(__traits(compiles, move(x, x) ));
}

// moveAll
/**
For each element $(D a) in $(D src) and each element $(D b) in $(D
tgt) in lockstep in increasing order, calls $(D move(a, b)).

Preconditions:
$(D walkLength(src) <= walkLength(tgt)).
An exception will be thrown if this condition does not hold, i.e., there is not
enough room in $(D tgt) to accommodate all of $(D src).

Params:
    src = An $(XREF2 range, isInputRange, input range) with movable elements.
    tgt = An $(XREF2 range, isInputRange, input range) with elements that
        elements from $(D src) can be moved into.

Returns: The leftover portion of $(D tgt) after all elements from $(D src) have
been moved.
 */
Range2 moveAll(Range1, Range2)(Range1 src, Range2 tgt)
if (isInputRange!Range1 && isInputRange!Range2
        && is(typeof(move(src.front, tgt.front))))
{
    import std.exception : enforce;

    static if (isRandomAccessRange!Range1 && hasLength!Range1 && hasLength!Range2
         && hasSlicing!Range2 && isRandomAccessRange!Range2)
    {
        auto toMove = src.length;
        enforce(toMove <= tgt.length);  // shouldn't this be an assert?
        foreach (idx; 0 .. toMove)
            move(src[idx], tgt[idx]);
        return tgt[toMove .. tgt.length];
    }
    else
    {
        for (; !src.empty; src.popFront(), tgt.popFront())
        {
            enforce(!tgt.empty);  //ditto?
            move(src.front, tgt.front);
        }
        return tgt;
    }
}

unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    int[] a = [ 1, 2, 3 ];
    int[] b = new int[5];
    assert(moveAll(a, b) is b[3 .. $]);
    assert(a == b[0 .. 3]);
    assert(a == [ 1, 2, 3 ]);
}

// moveSome
/**
For each element $(D a) in $(D src) and each element $(D b) in $(D
tgt) in lockstep in increasing order, calls $(D move(a, b)). Stops
when either $(D src) or $(D tgt) have been exhausted.

Params:
    src = An $(XREF2 range, isInputRange, input range) with movable elements.
    tgt = An $(XREF2 range, isInputRange, input range) with elements that
        elements from $(D src) can be moved into.

Returns: The leftover portions of the two ranges after one or the other of the
ranges have been exhausted.
 */
Tuple!(Range1, Range2) moveSome(Range1, Range2)(Range1 src, Range2 tgt)
if (isInputRange!Range1 && isInputRange!Range2
        && is(typeof(move(src.front, tgt.front))))
{
    import std.exception : enforce;

    for (; !src.empty && !tgt.empty; src.popFront(), tgt.popFront())
    {
        enforce(!tgt.empty);
        move(src.front, tgt.front);
    }
    return tuple(src, tgt);
}

unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
   int[] a = [ 1, 2, 3, 4, 5 ];
    int[] b = new int[3];
    assert(moveSome(a, b)[0] is a[3 .. $]);
    assert(a[0 .. 3] == b);
    assert(a == [ 1, 2, 3, 4, 5 ]);
}

// swap
/**
Swaps $(D lhs) and $(D rhs). The instances $(D lhs) and $(D rhs) are moved in
memory, without ever calling $(D opAssign), nor any other function. $(D T)
need not be assignable at all to be swapped.

If $(D lhs) and $(D rhs) reference the same instance, then nothing is done.

$(D lhs) and $(D rhs) must be mutable. If $(D T) is a struct or union, then
its fields must also all be (recursively) mutable.

Params:
    lhs = Data to be swapped with $(D rhs).
    rhs = Data to be swapped with $(D lhs).
*/
void swap(T)(ref T lhs, ref T rhs) @trusted pure nothrow @nogc
if (isBlitAssignable!T && !is(typeof(lhs.proxySwap(rhs))))
{
    static if (hasAliasing!T) if (!__ctfe)
    {
        import std.exception : doesPointTo;
        assert(!doesPointTo(lhs, lhs), "Swap: lhs internal pointer.");
        assert(!doesPointTo(rhs, rhs), "Swap: rhs internal pointer.");
        assert(!doesPointTo(lhs, rhs), "Swap: lhs points to rhs.");
        assert(!doesPointTo(rhs, lhs), "Swap: rhs points to lhs.");
    }

    static if (hasElaborateAssign!T || !isAssignable!T)
    {
        if (&lhs != &rhs)
        {
            // For structs with non-trivial assignment, move memory directly
            ubyte[T.sizeof] t = void;
            auto a = (cast(ubyte*) &lhs)[0 .. T.sizeof];
            auto b = (cast(ubyte*) &rhs)[0 .. T.sizeof];
            t[] = a[];
            a[] = b[];
            b[] = t[];
        }
    }
    else
    {
        //Avoid assigning overlapping arrays. Dynamic arrays are fine, because
        //it's their ptr and length properties which get assigned rather
        //than their elements when assigning them, but static arrays are value
        //types and therefore all of their elements get copied as part of
        //assigning them, which would be assigning overlapping arrays if lhs
        //and rhs were the same array.
        static if (isStaticArray!T)
        {
            if (lhs.ptr == rhs.ptr)
                return;
        }

        // For non-struct types, suffice to do the classic swap
        auto tmp = lhs;
        lhs = rhs;
        rhs = tmp;
    }
}

// Not yet documented
void swap(T)(ref T lhs, ref T rhs) if (is(typeof(lhs.proxySwap(rhs))))
{
    lhs.proxySwap(rhs);
}

@safe unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    int a = 42, b = 34;
    swap(a, b);
    assert(a == 34 && b == 42);

    static struct S { int x; char c; int[] y; }
    S s1 = { 0, 'z', [ 1, 2 ] };
    S s2 = { 42, 'a', [ 4, 6 ] };
    //writeln(s2.tupleof.stringof);
    swap(s1, s2);
    assert(s1.x == 42);
    assert(s1.c == 'a');
    assert(s1.y == [ 4, 6 ]);

    assert(s2.x == 0);
    assert(s2.c == 'z');
    assert(s2.y == [ 1, 2 ]);

    immutable int imm1, imm2;
    static assert(!__traits(compiles, swap(imm1, imm2)));
}

@safe unittest
{
    static struct NoCopy
    {
        this(this) { assert(0); }
        int n;
        string s;
    }
    NoCopy nc1, nc2;
    nc1.n = 127; nc1.s = "abc";
    nc2.n = 513; nc2.s = "uvwxyz";
    swap(nc1, nc2);
    assert(nc1.n == 513 && nc1.s == "uvwxyz");
    assert(nc2.n == 127 && nc2.s == "abc");
    swap(nc1, nc1);
    swap(nc2, nc2);
    assert(nc1.n == 513 && nc1.s == "uvwxyz");
    assert(nc2.n == 127 && nc2.s == "abc");

    static struct NoCopyHolder
    {
        NoCopy noCopy;
    }
    NoCopyHolder h1, h2;
    h1.noCopy.n = 31; h1.noCopy.s = "abc";
    h2.noCopy.n = 65; h2.noCopy.s = null;
    swap(h1, h2);
    assert(h1.noCopy.n == 65 && h1.noCopy.s == null);
    assert(h2.noCopy.n == 31 && h2.noCopy.s == "abc");
    swap(h1, h1);
    swap(h2, h2);
    assert(h1.noCopy.n == 65 && h1.noCopy.s == null);
    assert(h2.noCopy.n == 31 && h2.noCopy.s == "abc");

    const NoCopy const1, const2;
    static assert(!__traits(compiles, swap(const1, const2)));
}

@safe unittest
{
    //Bug# 4789
    int[1] s = [1];
    swap(s, s);
}

@safe unittest
{
    static struct NoAssign
    {
        int i;
        void opAssign(NoAssign) @disable;
    }
    auto s1 = NoAssign(1);
    auto s2 = NoAssign(2);
    swap(s1, s2);
    assert(s1.i == 2);
    assert(s2.i == 1);
}

@safe unittest
{
    struct S
    {
        const int i;
    }
    S s;
    static assert(!__traits(compiles, swap(s, s)));
}

@safe unittest
{
    //11853
    alias T = Tuple!(int, double);
    static assert(isAssignable!T);
}

@safe unittest
{
    // 12024
    import std.datetime;
    SysTime a, b;
}

unittest // 9975
{
    import std.exception : doesPointTo, mayPointTo;
    static struct S2
    {
        union
        {
            size_t sz;
            string s;
        }
    }
    S2 a , b;
    a.sz = -1;
    assert(!doesPointTo(a, b));
    assert( mayPointTo(a, b));
    swap(a, b);

    //Note: we can catch an error here, because there is no RAII in this test
    import std.exception : assertThrown;
    void* p, pp;
    p = &p;
    assertThrown!Error(move(p));
    assertThrown!Error(move(p, pp));
    assertThrown!Error(swap(p, pp));
}

unittest
{
    static struct A
    {
        int* x;
        this(this) { x = new int; }
    }
    A a1, a2;
    swap(a1, a2);

    static struct B
    {
        int* x;
        void opAssign(B) { x = new int; }
    }
    B b1, b2;
    swap(b1, b2);
}

void swapFront(R1, R2)(R1 r1, R2 r2)
    if (isInputRange!R1 && isInputRange!R2)
{
    static if (is(typeof(swap(r1.front, r2.front))))
    {
        swap(r1.front, r2.front);
    }
    else
    {
        auto t1 = moveFront(r1), t2 = moveFront(r2);
        r1.front = move(t2);
        r2.front = move(t1);
    }
}

/**
Forwards function arguments with saving ref-ness.
*/
template forward(args...)
{
    import std.typetuple;

    static if (args.length)
    {
        alias arg = args[0];
        static if (__traits(isRef, arg))
            alias fwd = arg;
        else
            @property fwd()(){ return move(arg); }
        alias forward = TypeTuple!(fwd, forward!(args[1..$]));
    }
    else
        alias forward = TypeTuple!();
}

///
@safe unittest
{
    class C
    {
        static int foo(int n) { return 1; }
        static int foo(ref int n) { return 2; }
    }
    int bar()(auto ref int x) { return C.foo(forward!x); }

    assert(bar(1) == 1);
    int i;
    assert(bar(i) == 2);
}

///
@safe unittest
{
    void foo(int n, ref string s) { s = null; foreach (i; 0..n) s ~= "Hello"; }

    // forwards all arguments which are bound to parameter tuple
    void bar(Args...)(auto ref Args args) { return foo(forward!args); }

    // forwards all arguments with swapping order
    void baz(Args...)(auto ref Args args) { return foo(forward!args[$/2..$], forward!args[0..$/2]); }

    string s;
    bar(1, s);
    assert(s == "Hello");
    baz(s, 2);
    assert(s == "HelloHello");
}

@safe unittest
{
    auto foo(TL...)(auto ref TL args)
    {
        string result = "";
        foreach (i, _; args)
        {
            //pragma(msg, "[",i,"] ", __traits(isRef, args[i]) ? "L" : "R");
            result ~= __traits(isRef, args[i]) ? "L" : "R";
        }
        return result;
    }

    string bar(TL...)(auto ref TL args)
    {
        return foo(forward!args);
    }
    string baz(TL...)(auto ref TL args)
    {
        int x;
        return foo(forward!args[3], forward!args[2], 1, forward!args[1], forward!args[0], x);
    }

    struct S {}
    S makeS(){ return S(); }
    int n;
    string s;
    assert(bar(S(), makeS(), n, s) == "RRLL");
    assert(baz(S(), makeS(), n, s) == "LLRRRL");
}

@safe unittest
{
    ref int foo(ref int a) { return a; }
    ref int bar(Args)(auto ref Args args)
    {
        return foo(forward!args);
    }
    static assert(!__traits(compiles, { auto x1 = bar(3); })); // case of NG
    int value = 3;
    auto x2 = bar(value); // case of OK
}

// overwriteAdjacent
/*
Reduces $(D r) by shifting it to the left until no adjacent elements
$(D a), $(D b) remain in $(D r) such that $(D pred(a, b)). Shifting is
performed by evaluating $(D move(source, target)) as a primitive. The
algorithm is stable and runs in $(BIGOH r.length) time. Returns the
reduced range.

The default $(XREF _algorithm, move) performs a potentially
destructive assignment of $(D source) to $(D target), so the objects
beyond the returned range should be considered "empty". By default $(D
pred) compares for equality, in which case $(D overwriteAdjacent)
collapses adjacent duplicate elements to one (functionality akin to
the $(WEB wikipedia.org/wiki/Uniq, uniq) system utility).

Example:
----
int[] arr = [ 1, 2, 2, 2, 2, 3, 4, 4, 4, 5 ];
auto r = overwriteAdjacent(arr);
assert(r == [ 1, 2, 3, 4, 5 ]);
----
*/
// Range overwriteAdjacent(alias pred, alias move, Range)(Range r)
// {
//     if (r.empty) return r;
//     //auto target = begin(r), e = end(r);
//     auto target = r;
//     auto source = r;
//     source.popFront();
//     while (!source.empty)
//     {
//         if (!pred(target.front, source.front))
//         {
//             target.popFront();
//             continue;
//         }
//         // found an equal *source and *target
//         for (;;)
//         {
//             //@@@
//             //move(source.front, target.front);
//             target[0] = source[0];
//             source.popFront();
//             if (source.empty) break;
//             if (!pred(target.front, source.front)) target.popFront();
//         }
//         break;
//     }
//     return range(begin(r), target + 1);
// }

// /// Ditto
// Range overwriteAdjacent(
//     string fun = "a == b",
//     alias move = .move,
//     Range)(Range r)
// {
//     return .overwriteAdjacent!(binaryFun!(fun), move, Range)(r);
// }

// unittest
// {
//     int[] arr = [ 1, 2, 2, 2, 2, 3, 4, 4, 4, 5 ];
//     auto r = overwriteAdjacent(arr);
//     assert(r == [ 1, 2, 3, 4, 5 ]);
//     assert(arr == [ 1, 2, 3, 4, 5, 3, 4, 4, 4, 5 ]);

// }

// copy
/**
Copies the content of $(D source) into $(D target) and returns the
remaining (unfilled) part of $(D target).

Preconditions: $(D target) shall have enough room to accomodate
$(D source).

See_Also:
    $(WEB sgi.com/tech/stl/_copy.html, STL's _copy)
 */
Range2 copy(Range1, Range2)(Range1 source, Range2 target)
if (isInputRange!Range1 && isOutputRange!(Range2, ElementType!Range1))
{
    static Range2 genericImpl(Range1 source, Range2 target)
    {
        // Specialize for 2 random access ranges.
        // Typically 2 random access ranges are faster iterated by common
        // index then by x.popFront(), y.popFront() pair
        static if (isRandomAccessRange!Range1 && hasLength!Range1
            && hasSlicing!Range2 && isRandomAccessRange!Range2 && hasLength!Range2)
        {
            assert(target.length >= source.length,
                "Cannot copy a source range into a smaller target range.");

            auto len = source.length;
            foreach (idx; 0 .. len)
                target[idx] = source[idx];
            return target[len .. target.length];
        }
        else
        {
            put(target, source);
            return target;
        }
    }

    static if (isArray!Range1 && isArray!Range2 &&
               is(Unqual!(typeof(source[0])) == Unqual!(typeof(target[0]))))
    {
        immutable overlaps = () @trusted {
            return source.ptr < target.ptr + target.length &&
                   target.ptr < source.ptr + source.length; }();

        if (overlaps)
        {
            return genericImpl(source, target);
        }
        else
        {
            // Array specialization.  This uses optimized memory copying
            // routines under the hood and is about 10-20x faster than the
            // generic implementation.
            assert(target.length >= source.length,
                "Cannot copy a source array into a smaller target array.");
            target[0..source.length] = source[];

            return target[source.length..$];
        }
    }
    else
    {
        return genericImpl(source, target);
    }
}

///
@safe unittest
{
    int[] a = [ 1, 5 ];
    int[] b = [ 9, 8 ];
    int[] buf = new int[a.length + b.length + 10];
    auto rem = copy(a, buf);    // copy a into buf
    rem = copy(b, rem);         // copy b into remainder of buf
    assert(buf[0 .. a.length + b.length] == [1, 5, 9, 8]);
    assert(rem.length == 10);   // unused slots in buf
}

/**
As long as the target range elements support assignment from source
range elements, different types of ranges are accepted:
*/
@safe unittest
{
    float[] src = [ 1.0f, 5 ];
    double[] dest = new double[src.length];
    copy(src, dest);
}

/**
To _copy at most $(D n) elements from a range, you may want to use
$(XREF range, take):
*/
@safe unittest
{
    import std.range;
    int[] src = [ 1, 5, 8, 9, 10 ];
    auto dest = new int[3];
    copy(take(src, dest.length), dest);
    assert(dest[0 .. $] == [ 1, 5, 8 ]);
}

/**
To _copy just those elements from a range that satisfy a predicate you
may want to use $(LREF filter):
*/
@safe unittest
{
    int[] src = [ 1, 5, 8, 9, 10, 1, 2, 0 ];
    auto dest = new int[src.length];
    auto rem = copy(src.filter!(a => (a & 1) == 1), dest);
    assert(dest[0 .. $ - rem.length] == [ 1, 5, 9, 1 ]);
}

/**
$(XREF range, retro) can be used to achieve behavior similar to
$(WEB sgi.com/tech/stl/copy_backward.html, STL's copy_backward'):
*/
@safe unittest
{
    import std.algorithm, std.range;
    int[] src = [1, 2, 4];
    int[] dest = [0, 0, 0, 0, 0];
    copy(src.retro, dest.retro);
    assert(dest == [0, 0, 1, 2, 4]);
}

@safe unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    {
        int[] a = [ 1, 5 ];
        int[] b = [ 9, 8 ];
        auto e = copy(filter!("a > 1")(a), b);
        assert(b[0] == 5 && e.length == 1);
    }

    {
        int[] a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        copy(a[5..10], a[4..9]);
        assert(a[4..9] == [6, 7, 8, 9, 10]);
    }

    {   // Test for bug 7898
        enum v =
        {
            import std.algorithm;
            int[] arr1 = [10, 20, 30, 40, 50];
            int[] arr2 = arr1.dup;
            copy(arr1, arr2);
            return 35;
        }();
    }
}

// swapRanges
/**
Swaps all elements of $(D r1) with successive elements in $(D r2).
Returns a tuple containing the remainder portions of $(D r1) and $(D
r2) that were not swapped (one of them will be empty). The ranges may
be of different types but must have the same element type and support
swapping.
*/
Tuple!(Range1, Range2)
swapRanges(Range1, Range2)(Range1 r1, Range2 r2)
    if (isInputRange!(Range1) && isInputRange!(Range2)
            && hasSwappableElements!(Range1) && hasSwappableElements!(Range2)
            && is(ElementType!(Range1) == ElementType!(Range2)))
{
    for (; !r1.empty && !r2.empty; r1.popFront(), r2.popFront())
    {
        swap(r1.front, r2.front);
    }
    return tuple(r1, r2);
}

///
@safe unittest
{
    int[] a = [ 100, 101, 102, 103 ];
    int[] b = [ 0, 1, 2, 3 ];
    auto c = swapRanges(a[1 .. 3], b[2 .. 4]);
    assert(c[0].empty && c[1].empty);
    assert(a == [ 100, 2, 3, 103 ]);
    assert(b == [ 0, 1, 101, 102 ]);
}

// reverse
/**
Reverses $(D r) in-place.  Performs $(D r.length / 2) evaluations of $(D
swap).

See_Also:
    $(WEB sgi.com/tech/stl/_reverse.html, STL's _reverse)
*/
void reverse(Range)(Range r)
if (isBidirectionalRange!Range && !isRandomAccessRange!Range
    && hasSwappableElements!Range)
{
    while (!r.empty)
    {
        swap(r.front, r.back);
        r.popFront();
        if (r.empty) break;
        r.popBack();
    }
}

///
@safe unittest
{
    int[] arr = [ 1, 2, 3 ];
    reverse(arr);
    assert(arr == [ 3, 2, 1 ]);
}

///ditto
void reverse(Range)(Range r)
if (isRandomAccessRange!Range && hasLength!Range)
{
    //swapAt is in fact the only way to swap non lvalue ranges
    immutable last = r.length-1;
    immutable steps = r.length/2;
    for (size_t i = 0; i < steps; i++)
    {
        swapAt(r, i, last-i);
    }
}

@safe unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    int[] range = null;
    reverse(range);
    range = [ 1 ];
    reverse(range);
    assert(range == [1]);
    range = [1, 2];
    reverse(range);
    assert(range == [2, 1]);
    range = [1, 2, 3];
    reverse(range);
    assert(range == [3, 2, 1]);
}

/**
Reverses $(D r) in-place, where $(D r) is a narrow string (having
elements of type $(D char) or $(D wchar)). UTF sequences consisting of
multiple code units are preserved properly.
*/
void reverse(Char)(Char[] s)
if (isNarrowString!(Char[]) && !is(Char == const) && !is(Char == immutable))
{
    import std.string : representation;
    import std.utf : stride;

    auto r = representation(s);
    for (size_t i = 0; i < s.length; )
    {
        immutable step = std.utf.stride(s, i);
        if (step > 1)
        {
            .reverse(r[i .. i + step]);
            i += step;
        }
        else
        {
            ++i;
        }
    }
    reverse(r);
}

///
@safe unittest
{
    char[] arr = "hello\U00010143\u0100\U00010143".dup;
    reverse(arr);
    assert(arr == "\U00010143\u0100\U00010143olleh");
}

@safe unittest
{
    void test(string a, string b)
    {
        auto c = a.dup;
        reverse(c);
        assert(c == b, c ~ " != " ~ b);
    }

    test("a", "a");
    test(" ", " ");
    test("\u2029", "\u2029");
    test("\u0100", "\u0100");
    test("\u0430", "\u0430");
    test("\U00010143", "\U00010143");
    test("abcdefcdef", "fedcfedcba");
    test("hello\U00010143\u0100\U00010143", "\U00010143\u0100\U00010143olleh");
}

/**
    The strip group of functions allow stripping of either leading, trailing,
    or both leading and trailing elements.

    The $(D stripLeft) function will strip the $(D front) of the range,
    the $(D stripRight) function will strip the $(D back) of the range,
    while the $(D strip) function will strip both the $(D front) and $(D back)
    of the range.

    Note that the $(D strip) and $(D stripRight) functions require the range to
    be a $(LREF BidirectionalRange) range.

    All of these functions come in two varieties: one takes a target element,
    where the range will be stripped as long as this element can be found.
    The other takes a lambda predicate, where the range will be stripped as
    long as the predicate returns true.
*/
Range strip(Range, E)(Range range, E element)
    if (isBidirectionalRange!Range && is(typeof(range.front == element) : bool))
{
    return range.stripLeft(element).stripRight(element);
}

/// ditto
Range strip(alias pred, Range)(Range range)
    if (isBidirectionalRange!Range && is(typeof(pred(range.back)) : bool))
{
    return range.stripLeft!pred().stripRight!pred();
}

/// ditto
Range stripLeft(Range, E)(Range range, E element)
    if (isInputRange!Range && is(typeof(range.front == element) : bool))
{
    return find!((auto ref a) => a != element)(range);
}

/// ditto
Range stripLeft(alias pred, Range)(Range range)
    if (isInputRange!Range && is(typeof(pred(range.front)) : bool))
{
    import std.functional : not;

    return find!(not!pred)(range);
}

/// ditto
Range stripRight(Range, E)(Range range, E element)
    if (isBidirectionalRange!Range && is(typeof(range.back == element) : bool))
{
    for (; !range.empty; range.popBack())
    {
        if (range.back != element)
            break;
    }
    return range;
}

/// ditto
Range stripRight(alias pred, Range)(Range range)
    if (isBidirectionalRange!Range && is(typeof(pred(range.back)) : bool))
{
    for (; !range.empty; range.popBack())
    {
        if (!pred(range.back))
            break;
    }
    return range;
}

/// Strip leading and trailing elements equal to the target element.
@safe pure unittest
{
    assert("  foobar  ".strip(' ') == "foobar");
    assert("00223.444500".strip('0') == "223.4445");
    assert("ëëêéüŗōpéêëë".strip('ë') == "êéüŗōpéê");
    assert([1, 1, 0, 1, 1].strip(1) == [0]);
    assert([0.0, 0.01, 0.01, 0.0].strip(0).length == 2);
}

/// Strip leading and trailing elements while the predicate returns true.
@safe pure unittest
{
    assert("  foobar  ".strip!(a => a == ' ')() == "foobar");
    assert("00223.444500".strip!(a => a == '0')() == "223.4445");
    assert("ëëêéüŗōpéêëë".strip!(a => a == 'ë')() == "êéüŗōpéê");
    assert([1, 1, 0, 1, 1].strip!(a => a == 1)() == [0]);
    assert([0.0, 0.01, 0.5, 0.6, 0.01, 0.0].strip!(a => a < 0.4)().length == 2);
}

/// Strip leading elements equal to the target element.
@safe pure unittest
{
    assert("  foobar  ".stripLeft(' ') == "foobar  ");
    assert("00223.444500".stripLeft('0') == "223.444500");
    assert("ůůűniçodêéé".stripLeft('ů') == "űniçodêéé");
    assert([1, 1, 0, 1, 1].stripLeft(1) == [0, 1, 1]);
    assert([0.0, 0.01, 0.01, 0.0].stripLeft(0).length == 3);
}

/// Strip leading elements while the predicate returns true.
@safe pure unittest
{
    assert("  foobar  ".stripLeft!(a => a == ' ')() == "foobar  ");
    assert("00223.444500".stripLeft!(a => a == '0')() == "223.444500");
    assert("ůůűniçodêéé".stripLeft!(a => a == 'ů')() == "űniçodêéé");
    assert([1, 1, 0, 1, 1].stripLeft!(a => a == 1)() == [0, 1, 1]);
    assert([0.0, 0.01, 0.10, 0.5, 0.6].stripLeft!(a => a < 0.4)().length == 2);
}

/// Strip trailing elements equal to the target element.
@safe pure unittest
{
    assert("  foobar  ".stripRight(' ') == "  foobar");
    assert("00223.444500".stripRight('0') == "00223.4445");
    assert("ùniçodêéé".stripRight('é') == "ùniçodê");
    assert([1, 1, 0, 1, 1].stripRight(1) == [1, 1, 0]);
    assert([0.0, 0.01, 0.01, 0.0].stripRight(0).length == 3);
}

/// Strip trailing elements while the predicate returns true.
@safe pure unittest
{
    assert("  foobar  ".stripRight!(a => a == ' ')() == "  foobar");
    assert("00223.444500".stripRight!(a => a == '0')() == "00223.4445");
    assert("ùniçodêéé".stripRight!(a => a == 'é')() == "ùniçodê");
    assert([1, 1, 0, 1, 1].stripRight!(a => a == 1)() == [1, 1, 0]);
    assert([0.0, 0.01, 0.10, 0.5, 0.6].stripRight!(a => a > 0.4)().length == 3);
}

// bringToFront
/**
The $(D bringToFront) function has considerable flexibility and
usefulness. It can rotate elements in one buffer left or right, swap
buffers of equal length, and even move elements across disjoint
buffers of different types and different lengths.

$(D bringToFront) takes two ranges $(D front) and $(D back), which may
be of different types. Considering the concatenation of $(D front) and
$(D back) one unified range, $(D bringToFront) rotates that unified
range such that all elements in $(D back) are brought to the beginning
of the unified range. The relative ordering of elements in $(D front)
and $(D back), respectively, remains unchanged.

Performs $(BIGOH max(front.length, back.length)) evaluations of $(D
swap).

Preconditions:

Either $(D front) and $(D back) are disjoint, or $(D back) is
reachable from $(D front) and $(D front) is not reachable from $(D
back).

Returns:

The number of elements brought to the front, i.e., the length of $(D
back).

See_Also:
    $(WEB sgi.com/tech/stl/_rotate.html, STL's rotate)
*/
size_t bringToFront(Range1, Range2)(Range1 front, Range2 back)
    if (isInputRange!Range1 && isForwardRange!Range2)
{
    import std.range: Take, take;
    enum bool sameHeadExists = is(typeof(front.sameHead(back)));
    size_t result;
    for (bool semidone; !front.empty && !back.empty; )
    {
        static if (sameHeadExists)
        {
            if (front.sameHead(back)) break; // shortcut
        }
        // Swap elements until front and/or back ends.
        auto back0 = back.save;
        size_t nswaps;
        do
        {
            static if (sameHeadExists)
            {
                // Detect the stepping-over condition.
                if (front.sameHead(back0)) back0 = back.save;
            }
            swapFront(front, back);
            ++nswaps;
            front.popFront();
            back.popFront();
        }
        while (!front.empty && !back.empty);

        if (!semidone) result += nswaps;

        // Now deal with the remaining elements.
        if (back.empty)
        {
            if (front.empty) break;
            // Right side was shorter, which means that we've brought
            // all the back elements to the front.
            semidone = true;
            // Next pass: bringToFront(front, back0) to adjust the rest.
            back = back0;
        }
        else
        {
            assert(front.empty);
            // Left side was shorter. Let's step into the back.
            static if (is(Range1 == Take!Range2))
            {
                front = take(back0, nswaps);
            }
            else
            {
                immutable subresult = bringToFront(take(back0, nswaps),
                                                   back);
                if (!semidone) result += subresult;
                break; // done
            }
        }
    }
    return result;
}

/**
The simplest use of $(D bringToFront) is for rotating elements in a
buffer. For example:
*/
@safe unittest
{
    auto arr = [4, 5, 6, 7, 1, 2, 3];
    auto p = bringToFront(arr[0 .. 4], arr[4 .. $]);
    assert(p == arr.length - 4);
    assert(arr == [ 1, 2, 3, 4, 5, 6, 7 ]);
}

/**
The $(D front) range may actually "step over" the $(D back)
range. This is very useful with forward ranges that cannot compute
comfortably right-bounded subranges like $(D arr[0 .. 4]) above. In
the example below, $(D r2) is a right subrange of $(D r1).
*/
@safe unittest
{
    import std.container : SList;

    auto list = SList!(int)(4, 5, 6, 7, 1, 2, 3);
    auto r1 = list[];
    auto r2 = list[]; popFrontN(r2, 4);
    assert(equal(r2, [ 1, 2, 3 ]));
    bringToFront(r1, r2);
    assert(equal(list[], [ 1, 2, 3, 4, 5, 6, 7 ]));
}


/**
Elements can be swapped across ranges of different types:
*/
@safe unittest
{
    import std.container : SList;

    auto list = SList!(int)(4, 5, 6, 7);
    auto vec = [ 1, 2, 3 ];
    bringToFront(list[], vec);
    assert(equal(list[], [ 1, 2, 3, 4 ]));
    assert(equal(vec, [ 5, 6, 7 ]));
}

@safe unittest
{
    import std.conv : text;
    import std.random : Random, unpredictableSeed, uniform;

    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");

    // a more elaborate test
    {
        auto rnd = Random(unpredictableSeed);
        int[] a = new int[uniform(100, 200, rnd)];
        int[] b = new int[uniform(100, 200, rnd)];
        foreach (ref e; a) e = uniform(-100, 100, rnd);
        foreach (ref e; b) e = uniform(-100, 100, rnd);
        int[] c = a ~ b;
        // writeln("a= ", a);
        // writeln("b= ", b);
        auto n = bringToFront(c[0 .. a.length], c[a.length .. $]);
        //writeln("c= ", c);
        assert(n == b.length);
        assert(c == b ~ a, text(c, "\n", a, "\n", b));
    }
    // different types, moveFront, no sameHead
    {
        static struct R(T)
        {
            T[] data;
            size_t i;
            @property
            {
                R save() { return this; }
                bool empty() { return i >= data.length; }
                T front() { return data[i]; }
                T front(real e) { return data[i] = cast(T) e; }
            }
            void popFront() { ++i; }
        }
        auto a = R!int([1, 2, 3, 4, 5]);
        auto b = R!real([6, 7, 8, 9]);
        auto n = bringToFront(a, b);
        assert(n == 4);
        assert(a.data == [6, 7, 8, 9, 1]);
        assert(b.data == [2, 3, 4, 5]);
    }
    // front steps over back
    {
        int[] arr, r1, r2;

        // back is shorter
        arr = [4, 5, 6, 7, 1, 2, 3];
        r1 = arr;
        r2 = arr[4 .. $];
        bringToFront(r1, r2) == 3 || assert(0);
        assert(equal(arr, [1, 2, 3, 4, 5, 6, 7]));

        // front is shorter
        arr = [5, 6, 7, 1, 2, 3, 4];
        r1 = arr;
        r2 = arr[3 .. $];
        bringToFront(r1, r2) == 4 || assert(0);
        assert(equal(arr, [1, 2, 3, 4, 5, 6, 7]));
    }
}

// SwapStrategy
/**
Defines the swapping strategy for algorithms that need to swap
elements in a range (such as partition and sort). The strategy
concerns the swapping of elements that are not the core concern of the
algorithm. For example, consider an algorithm that sorts $(D [ "abc",
"b", "aBc" ]) according to $(D toUpper(a) < toUpper(b)). That
algorithm might choose to swap the two equivalent strings $(D "abc")
and $(D "aBc"). That does not affect the sorting since both $(D [
"abc", "aBc", "b" ]) and $(D [ "aBc", "abc", "b" ]) are valid
outcomes.

Some situations require that the algorithm must NOT ever change the
relative ordering of equivalent elements (in the example above, only
$(D [ "abc", "aBc", "b" ]) would be the correct result). Such
algorithms are called $(B stable). If the ordering algorithm may swap
equivalent elements discretionarily, the ordering is called $(B
unstable).

Yet another class of algorithms may choose an intermediate tradeoff by
being stable only on a well-defined subrange of the range. There is no
established terminology for such behavior; this library calls it $(B
semistable).

Generally, the $(D stable) ordering strategy may be more costly in
time and/or space than the other two because it imposes additional
constraints. Similarly, $(D semistable) may be costlier than $(D
unstable). As (semi-)stability is not needed very often, the ordering
algorithms in this module parameterized by $(D SwapStrategy) all
choose $(D SwapStrategy.unstable) as the default.
*/

enum SwapStrategy
{
    /**
       Allows freely swapping of elements as long as the output
       satisfies the algorithm's requirements.
    */
    unstable,
    /**
       In algorithms partitioning ranges in two, preserve relative
       ordering of elements only to the left of the partition point.
    */
    semistable,
    /**
       Preserve the relative ordering of elements to the largest
       extent allowed by the algorithm's requirements.
    */
    stable,
}

/**
Eliminates elements at given offsets from $(D range) and returns the
shortened range. In the simplest call, one element is removed.

----
int[] a = [ 3, 5, 7, 8 ];
assert(remove(a, 1) == [ 3, 7, 8 ]);
assert(a == [ 3, 7, 8, 8 ]);
----

In the case above the element at offset $(D 1) is removed and $(D
remove) returns the range smaller by one element. The original array
has remained of the same length because all functions in $(D
std.algorithm) only change $(I content), not $(I topology). The value
$(D 8) is repeated because $(XREF algorithm, move) was invoked to move
elements around and on integers $(D move) simply copies the source to
the destination. To replace $(D a) with the effect of the removal,
simply assign $(D a = remove(a, 1)). The slice will be rebound to the
shorter array and the operation completes with maximal efficiency.

Multiple indices can be passed into $(D remove). In that case,
elements at the respective indices are all removed. The indices must
be passed in increasing order, otherwise an exception occurs.

----
int[] a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
assert(remove(a, 1, 3, 5) ==
    [ 0, 2, 4, 6, 7, 8, 9, 10 ]);
----

(Note how all indices refer to slots in the $(I original) array, not
in the array as it is being progressively shortened.) Finally, any
combination of integral offsets and tuples composed of two integral
offsets can be passed in.

----
int[] a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
assert(remove(a, 1, tuple(3, 5), 9) == [ 0, 2, 6, 7, 8, 10 ]);
----

In this case, the slots at positions 1, 3, 4, and 9 are removed from
the array. The tuple passes in a range closed to the left and open to
the right (consistent with built-in slices), e.g. $(D tuple(3, 5))
means indices $(D 3) and $(D 4) but not $(D 5).

If the need is to remove some elements in the range but the order of
the remaining elements does not have to be preserved, you may want to
pass $(D SwapStrategy.unstable) to $(D remove).

----
int[] a = [ 0, 1, 2, 3 ];
assert(remove!(SwapStrategy.unstable)(a, 1) == [ 0, 3, 2 ]);
----

In the case above, the element at slot $(D 1) is removed, but replaced
with the last element of the range. Taking advantage of the relaxation
of the stability requirement, $(D remove) moved elements from the end
of the array over the slots to be removed. This way there is less data
movement to be done which improves the execution time of the function.

The function $(D remove) works on any forward range. The moving
strategy is (listed from fastest to slowest): $(UL $(LI If $(D s ==
SwapStrategy.unstable && isRandomAccessRange!Range && hasLength!Range
&& hasLvalueElements!Range), then elements are moved from the end
of the range into the slots to be filled. In this case, the absolute
minimum of moves is performed.)  $(LI Otherwise, if $(D s ==
SwapStrategy.unstable && isBidirectionalRange!Range && hasLength!Range
&& hasLvalueElements!Range), then elements are still moved from the
end of the range, but time is spent on advancing between slots by repeated
calls to $(D range.popFront).)  $(LI Otherwise, elements are moved
incrementally towards the front of $(D range); a given element is never
moved several times, but more elements are moved than in the previous
cases.))
 */
Range remove
(SwapStrategy s = SwapStrategy.stable, Range, Offset...)
(Range range, Offset offset)
if (s != SwapStrategy.stable
    && isBidirectionalRange!Range
    && hasLvalueElements!Range
    && hasLength!Range
    && Offset.length >= 1)
{
    Tuple!(size_t, "pos", size_t, "len")[offset.length] blackouts;
    foreach (i, v; offset)
    {
        static if (is(typeof(v[0]) : size_t) && is(typeof(v[1]) : size_t))
        {
            blackouts[i].pos = v[0];
            blackouts[i].len = v[1] - v[0];
        }
        else
        {
            static assert(is(typeof(v) : size_t), typeof(v).stringof);
            blackouts[i].pos = v;
            blackouts[i].len = 1;
        }
        static if (i > 0)
        {
            import std.exception : enforce;

            enforce(blackouts[i - 1].pos + blackouts[i - 1].len
                    <= blackouts[i].pos,
                "remove(): incorrect ordering of elements to remove");
        }
    }

    size_t left = 0, right = offset.length - 1;
    auto tgt = range.save;
    size_t steps = 0;

    while (left <= right)
    {
        // Look for a blackout on the right
        if (blackouts[right].pos + blackouts[right].len >= range.length)
        {
            range.popBackExactly(blackouts[right].len);

            // Since right is unsigned, we must check for this case, otherwise
            // we might turn it into size_t.max and the loop condition will not
            // fail when it should.
            if (right > 0)
            {
                --right;
                continue;
            }
            else
                break;
        }
        // Advance to next blackout on the left
        assert(blackouts[left].pos >= steps);
        tgt.popFrontExactly(blackouts[left].pos - steps);
        steps = blackouts[left].pos;
        auto toMove = min(
            blackouts[left].len,
            range.length - (blackouts[right].pos + blackouts[right].len));
        foreach (i; 0 .. toMove)
        {
            move(range.back, tgt.front);
            range.popBack();
            tgt.popFront();
        }
        steps += toMove;
        if (toMove == blackouts[left].len)
        {
            // Filled the entire left hole
            ++left;
            continue;
        }
    }

    return range;
}

// Ditto
Range remove
(SwapStrategy s = SwapStrategy.stable, Range, Offset...)
(Range range, Offset offset)
if (s == SwapStrategy.stable
    && isBidirectionalRange!Range
    && hasLvalueElements!Range
    && Offset.length >= 1)
{
    auto result = range;
    auto src = range, tgt = range;
    size_t pos;
    foreach (pass, i; offset)
    {
        static if (is(typeof(i[0])) && is(typeof(i[1])))
        {
            auto from = i[0], delta = i[1] - i[0];
        }
        else
        {
            auto from = i;
            enum delta = 1;
        }

        static if (pass > 0)
        {
            import std.exception : enforce;
            enforce(pos <= from,
                    "remove(): incorrect ordering of elements to remove");

            for (; pos < from; ++pos, src.popFront(), tgt.popFront())
            {
                move(src.front, tgt.front);
            }
        }
        else
        {
            src.popFrontExactly(from);
            tgt.popFrontExactly(from);
            pos = from;
        }
        // now skip source to the "to" position
        src.popFrontExactly(delta);
        result.popBackExactly(delta);
        pos += delta;
    }
    // leftover move
    moveAll(src, tgt);
    return result;
}

@safe unittest
{
    import std.exception : assertThrown;
    import std.range;

    // http://d.puremagic.com/issues/show_bug.cgi?id=10173
    int[] test = iota(0, 10).array();
    assertThrown(remove!(SwapStrategy.stable)(test, tuple(2, 4), tuple(1, 3)));
    assertThrown(remove!(SwapStrategy.unstable)(test, tuple(2, 4), tuple(1, 3)));
    assertThrown(remove!(SwapStrategy.stable)(test, 2, 4, 1, 3));
    assertThrown(remove!(SwapStrategy.unstable)(test, 2, 4, 1, 3));
}

@safe unittest
{
    import std.range;
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    int[] a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    //writeln(remove!(SwapStrategy.stable)(a, 1));
    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    assert(remove!(SwapStrategy.stable)(a, 1) ==
        [ 0, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]);

    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    assert(remove!(SwapStrategy.unstable)(a, 0, 10) ==
           [ 9, 1, 2, 3, 4, 5, 6, 7, 8 ]);

    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    assert(remove!(SwapStrategy.unstable)(a, 0, tuple(9, 11)) ==
            [ 8, 1, 2, 3, 4, 5, 6, 7 ]);
    // http://d.puremagic.com/issues/show_bug.cgi?id=5224
    a = [ 1, 2, 3, 4 ];
    assert(remove!(SwapStrategy.unstable)(a, 2) ==
           [ 1, 2, 4 ]);

    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    //writeln(remove!(SwapStrategy.stable)(a, 1, 5));
    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    assert(remove!(SwapStrategy.stable)(a, 1, 5) ==
        [ 0, 2, 3, 4, 6, 7, 8, 9, 10 ]);

    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    //writeln(remove!(SwapStrategy.stable)(a, 1, 3, 5));
    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    assert(remove!(SwapStrategy.stable)(a, 1, 3, 5)
            == [ 0, 2, 4, 6, 7, 8, 9, 10]);
    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    //writeln(remove!(SwapStrategy.stable)(a, 1, tuple(3, 5)));
    a = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ];
    assert(remove!(SwapStrategy.stable)(a, 1, tuple(3, 5))
            == [ 0, 2, 5, 6, 7, 8, 9, 10]);

    a = iota(0, 10).array();
    assert(remove!(SwapStrategy.unstable)(a, tuple(1, 4), tuple(6, 7))
            == [0, 9, 8, 7, 4, 5]);
}

@safe unittest
{
    // Issue 11576
    auto arr = [1,2,3];
    arr = arr.remove!(SwapStrategy.unstable)(2);
    assert(arr == [1,2]);

}

@safe unittest
{
    import std.range;
    // Bug# 12889
    int[1][] arr = [[0], [1], [2], [3], [4], [5], [6]];
    auto orig = arr.dup;
    foreach (i; iota(arr.length))
    {
        assert(orig == arr.remove!(SwapStrategy.unstable)(tuple(i,i)));
        assert(orig == arr.remove!(SwapStrategy.stable)(tuple(i,i)));
    }
}

/**
Reduces the length of the bidirectional range $(D range) by removing
elements that satisfy $(D pred). If $(D s = SwapStrategy.unstable),
elements are moved from the right end of the range over the elements
to eliminate. If $(D s = SwapStrategy.stable) (the default),
elements are moved progressively to front such that their relative
order is preserved. Returns the filtered range.
*/
Range remove(alias pred, SwapStrategy s = SwapStrategy.stable, Range)
(Range range)
if (isBidirectionalRange!Range
    && hasLvalueElements!Range)
{
    auto result = range;
    static if (s != SwapStrategy.stable)
    {
        for (;!range.empty;)
        {
            if (!unaryFun!pred(range.front))
            {
                range.popFront();
                continue;
            }
            move(range.back, range.front);
            range.popBack();
            result.popBack();
        }
    }
    else
    {
        auto tgt = range;
        for (; !range.empty; range.popFront())
        {
            if (unaryFun!(pred)(range.front))
            {
                // yank this guy
                result.popBack();
                continue;
            }
            // keep this guy
            move(range.front, tgt.front);
            tgt.popFront();
        }
    }
    return result;
}

///
@safe unittest
{
    static immutable base = [1, 2, 3, 2, 4, 2, 5, 2];

    int[] arr = base[].dup;

    // using a string-based predicate
    assert(remove!("a == 2")(arr) == [ 1, 3, 4, 5 ]);

    // The original array contents have been modified,
    // so we need to reset it to its original state.
    // The length is unmodified however.
    arr[] = base[];

    // using a lambda predicate
    assert(remove!(a => a == 2)(arr) == [ 1, 3, 4, 5 ]);
}

@safe unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    int[] a = [ 1, 2, 3, 2, 3, 4, 5, 2, 5, 6 ];
    assert(remove!("a == 2", SwapStrategy.unstable)(a) ==
            [ 1, 6, 3, 5, 3, 4, 5 ]);
    a = [ 1, 2, 3, 2, 3, 4, 5, 2, 5, 6 ];
    //writeln(remove!("a != 2", SwapStrategy.stable)(a));
    assert(remove!("a == 2", SwapStrategy.stable)(a) ==
            [ 1, 3, 3, 4, 5, 5, 6 ]);
}

// eliminate
/* *
Reduces $(D r) by overwriting all elements $(D x) that satisfy $(D
pred(x)). Returns the reduced range.

Example:
----
int[] arr = [ 1, 2, 3, 4, 5 ];
// eliminate even elements
auto r = eliminate!("(a & 1) == 0")(arr);
assert(r == [ 1, 3, 5 ]);
assert(arr == [ 1, 3, 5, 4, 5 ]);
----
*/
// Range eliminate(alias pred,
//                 SwapStrategy ss = SwapStrategy.unstable,
//                 alias move = .move,
//                 Range)(Range r)
// {
//     alias It = Iterator!(Range);
//     static void assignIter(It a, It b) { move(*b, *a); }
//     return range(begin(r), partitionold!(not!(pred), ss, assignIter, Range)(r));
// }

// unittest
// {
//     int[] arr = [ 1, 2, 3, 4, 5 ];
// // eliminate even elements
//     auto r = eliminate!("(a & 1) == 0")(arr);
//     assert(find!("(a & 1) == 0")(r).empty);
// }

/* *
Reduces $(D r) by overwriting all elements $(D x) that satisfy $(D
pred(x, v)). Returns the reduced range.

Example:
----
int[] arr = [ 1, 2, 3, 2, 4, 5, 2 ];
// keep elements different from 2
auto r = eliminate(arr, 2);
assert(r == [ 1, 3, 4, 5 ]);
assert(arr == [ 1, 3, 4, 5, 4, 5, 2  ]);
----
*/
// Range eliminate(alias pred = "a == b",
//                 SwapStrategy ss = SwapStrategy.semistable,
//                 Range, Value)(Range r, Value v)
// {
//     alias It = Iterator!(Range);
//     bool comp(typeof(*It) a) { return !binaryFun!(pred)(a, v); }
//     static void assignIterB(It a, It b) { *a = *b; }
//     return range(begin(r),
//             partitionold!(comp,
//                     ss, assignIterB, Range)(r));
// }

// unittest
// {
//     int[] arr = [ 1, 2, 3, 2, 4, 5, 2 ];
// // keep elements different from 2
//     auto r = eliminate(arr, 2);
//     assert(r == [ 1, 3, 4, 5 ]);
//     assert(arr == [ 1, 3, 4, 5, 4, 5, 2  ]);
// }

/**
Specifies whether the output of certain algorithm is desired in sorted
format.
 */
enum SortOutput
{
    no,  /// Don't sort output
    yes, /// Sort output
}

void topNIndex(
    alias less = "a < b",
    SwapStrategy ss = SwapStrategy.unstable,
    Range, RangeIndex)(Range r, RangeIndex index, SortOutput sorted = SortOutput.no)
if (isIntegral!(ElementType!(RangeIndex)))
{
    import std.container : BinaryHeap;
    import std.exception : enforce;

    if (index.empty) return;
    enforce(ElementType!(RangeIndex).max >= index.length,
            "Index type too small");
    bool indirectLess(ElementType!(RangeIndex) a, ElementType!(RangeIndex) b)
    {
        return binaryFun!(less)(r[a], r[b]);
    }
    auto heap = BinaryHeap!(RangeIndex, indirectLess)(index, 0);
    foreach (i; 0 .. r.length)
    {
        heap.conditionalInsert(cast(ElementType!RangeIndex) i);
    }
    if (sorted == SortOutput.yes)
    {
        while (!heap.empty) heap.removeFront();
    }
}

void topNIndex(
    alias less = "a < b",
    SwapStrategy ss = SwapStrategy.unstable,
    Range, RangeIndex)(Range r, RangeIndex index,
            SortOutput sorted = SortOutput.no)
if (is(ElementType!(RangeIndex) == ElementType!(Range)*))
{
    import std.container : BinaryHeap;

    if (index.empty) return;
    static bool indirectLess(const ElementType!(RangeIndex) a,
            const ElementType!(RangeIndex) b)
    {
        return binaryFun!less(*a, *b);
    }
    auto heap = BinaryHeap!(RangeIndex, indirectLess)(index, 0);
    foreach (i; 0 .. r.length)
    {
        heap.conditionalInsert(&r[i]);
    }
    if (sorted == SortOutput.yes)
    {
        while (!heap.empty) heap.removeFront();
    }
}

unittest
{
    import std.conv : text;

    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");

    {
        int[] a = [ 10, 8, 9, 2, 4, 6, 7, 1, 3, 5 ];
        int*[] b = new int*[5];
        topNIndex!("a > b")(a, b, SortOutput.yes);
        //foreach (e; b) writeln(*e);
        assert(b == [ &a[0], &a[2], &a[1], &a[6], &a[5]]);
    }
    {
        int[] a = [ 10, 8, 9, 2, 4, 6, 7, 1, 3, 5 ];
        auto b = new ubyte[5];
        topNIndex!("a > b")(a, b, SortOutput.yes);
        //foreach (e; b) writeln(e, ":", a[e]);
        assert(b == [ cast(ubyte) 0, cast(ubyte)2, cast(ubyte)1, cast(ubyte)6, cast(ubyte)5], text(b));
    }
}
/+

// topNIndexImpl
// @@@BUG1904
/*private*/ void topNIndexImpl(
    alias less,
    bool sortAfter,
    SwapStrategy ss,
    SRange, TRange)(SRange source, TRange target)
{
    alias lessFun = binaryFun!(less);
    static assert(ss == SwapStrategy.unstable,
            "Stable indexing not yet implemented");
    alias SIter = Iterator!(SRange);
    alias TElem = std.iterator.ElementType!(TRange);
    enum usingInt = isIntegral!(TElem);

    static if (usingInt)
    {
        enforce(source.length <= TElem.max,
                "Numeric overflow at risk in computing topNIndexImpl");
    }

    // types and functions used within
    SIter index2iter(TElem a)
    {
        static if (!usingInt)
            return a;
        else
            return begin(source) + a;
    }
    bool indirectLess(TElem a, TElem b)
    {
        return lessFun(*index2iter(a), *index2iter(b));
    }
    void indirectCopy(SIter from, ref TElem to)
    {
        static if (!usingInt)
            to = from;
        else
            to = cast(TElem)(from - begin(source));
    }

    // copy beginning of collection into the target
    auto sb = begin(source), se = end(source),
        tb = begin(target), te = end(target);
    for (; sb != se; ++sb, ++tb)
    {
        if (tb == te) break;
        indirectCopy(sb, *tb);
    }

    // if the index's size is same as the source size, just quicksort it
    // otherwise, heap-insert stuff in it.
    if (sb == se)
    {
        // everything in source is now in target... just sort the thing
        static if (sortAfter) sort!(indirectLess, ss)(target);
    }
    else
    {
        // heap-insert
        te = tb;
        tb = begin(target);
        target = range(tb, te);
        makeHeap!(indirectLess)(target);
        // add stuff to heap
        for (; sb != se; ++sb)
        {
            if (!lessFun(*sb, *index2iter(*tb))) continue;
            // copy the source over the smallest
            indirectCopy(sb, *tb);
            heapify!(indirectLess)(target, tb);
        }
        static if (sortAfter) sortHeap!(indirectLess)(target);
    }
}

/**
topNIndex
*/
void topNIndex(
    alias less,
    SwapStrategy ss = SwapStrategy.unstable,
    SRange, TRange)(SRange source, TRange target)
{
    return .topNIndexImpl!(less, false, ss)(source, target);
}

/// Ditto
void topNIndex(
    string less,
    SwapStrategy ss = SwapStrategy.unstable,
    SRange, TRange)(SRange source, TRange target)
{
    return .topNIndexImpl!(binaryFun!(less), false, ss)(source, target);
}

// partialIndex
/**
Computes an index for $(D source) based on the comparison $(D less)
and deposits the result in $(D target). It is acceptable that $(D
target.length < source.length), in which case only the smallest $(D
target.length) elements in $(D source) get indexed. The target
provides a sorted "view" into $(D source). This technique is similar
to sorting and partial sorting, but it is more flexible because (1) it
allows "sorting" of immutable collections, (2) allows binary search
even if the original collection does not offer random access, (3)
allows multiple indexes, each on a different comparison criterion, (4)
may be faster when dealing with large objects. However, using an index
may also be slower under certain circumstances due to the extra
indirection, and is always larger than a sorting-based solution
because it needs space for the index in addition to the original
collection. The complexity is $(BIGOH source.length *
log(target.length)).

Two types of indexes are accepted. They are selected by simply passing
the appropriate $(D target) argument: $(OL $(LI Indexes of type $(D
Iterator!(Source)), in which case the index will be sorted with the
predicate $(D less(*a, *b));) $(LI Indexes of an integral type
(e.g. $(D size_t)), in which case the index will be sorted with the
predicate $(D less(source[a], source[b])).))

Example:

----
immutable arr = [ 2, 3, 1 ];
int* index[3];
partialIndex(arr, index);
assert(*index[0] == 1 && *index[1] == 2 && *index[2] == 3);
assert(isSorted!("*a < *b")(index));
----
*/
void partialIndex(
    alias less,
    SwapStrategy ss = SwapStrategy.unstable,
    SRange, TRange)(SRange source, TRange target)
{
    return .topNIndexImpl!(less, true, ss)(source, target);
}

unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    immutable arr = [ 2, 3, 1 ];
    auto index = new immutable(int)*[3];
    partialIndex!(binaryFun!("a < b"))(arr, index);
    assert(*index[0] == 1 && *index[1] == 2 && *index[2] == 3);
    assert(isSorted!("*a < *b")(index));
}

unittest
{
    debug(std_algorithm) scope(success)
        writeln("unittest @", __FILE__, ":", __LINE__, " done.");
    static bool less(int a, int b) { return a < b; }
    {
        string[] x = ([ "c", "a", "b", "d" ]).dup;
        // test with integrals
        auto index1 = new size_t[x.length];
        partialIndex!(q{a < b})(x, index1);
        assert(index1[0] == 1 && index1[1] == 2 && index1[2] == 0
               && index1[3] == 3);
        // half-sized
        index1 = new size_t[x.length / 2];
        partialIndex!(q{a < b})(x, index1);
        assert(index1[0] == 1 && index1[1] == 2);

        // and with iterators
        auto index = new string*[x.length];
        partialIndex!(q{a < b})(x, index);
        assert(isSorted!(q{*a < *b})(index));
        assert(*index[0] == "a" && *index[1] == "b" && *index[2] == "c"
               && *index[3] == "d");
    }

    {
        immutable arr = [ 2, 3, 1 ];
        auto index = new immutable(int)*[arr.length];
        partialIndex!(less)(arr, index);
        assert(*index[0] == 1 && *index[1] == 2 && *index[2] == 3);
        assert(isSorted!(q{*a < *b})(index));
    }

    // random data
    auto b = rndstuff!(string)();
    auto index = new string*[b.length];
    partialIndex!((a, b) => std.uni.toUpper(a) < std.uni.toUpper(b))(b, index);
    assert(isSorted!((a, b) => std.uni.toUpper(*a) < std.uni.toUpper(*b))(index));

    // random data with indexes
    auto index1 = new size_t[b.length];
    bool cmp(string x, string y) { return std.uni.toUpper(x) < std.uni.toUpper(y); }
    partialIndex!(cmp)(b, index1);
    bool check(size_t x, size_t y) { return std.uni.toUpper(b[x]) < std.uni.toUpper(b[y]); }
    assert(isSorted!(check)(index1));
}

// Commented out for now, needs reimplementation

// // schwartzMakeIndex
// /**
// Similar to $(D makeIndex) but using $(D schwartzSort) to sort the
// index.

// Example:

// ----
// string[] arr = [ "ab", "c", "Ab", "C" ];
// auto index = schwartzMakeIndex!(toUpper, less, SwapStrategy.stable)(arr);
// assert(*index[0] == "ab" && *index[1] == "Ab"
//     && *index[2] == "c" && *index[2] == "C");
// assert(isSorted!("toUpper(*a) < toUpper(*b)")(index));
// ----
// */
// Iterator!(Range)[] schwartzMakeIndex(
//     alias transform,
//     alias less,
//     SwapStrategy ss = SwapStrategy.unstable,
//     Range)(Range r)
// {
//     alias Iter = Iterator!(Range);
//     auto result = new Iter[r.length];
//     // assume collection already ordered
//     size_t i = 0;
//     foreach (it; begin(r) .. end(r))
//     {
//         result[i++] = it;
//     }
//     // sort the index
//     alias Transformed = typeof(transform(*result[0]));
//     static bool indirectLess(Transformed a, Transformed b)
//     {
//         return less(a, b);
//     }
//     static Transformed indirectTransform(Iter a)
//     {
//         return transform(*a);
//     }
//     schwartzSort!(indirectTransform, less, ss)(result);
//     return result;
// }

// /// Ditto
// Iterator!(Range)[] schwartzMakeIndex(
//     alias transform,
//     string less = q{a < b},
//     SwapStrategy ss = SwapStrategy.unstable,
//     Range)(Range r)
// {
//     return .schwartzMakeIndex!(
//         transform, binaryFun!(less), ss, Range)(r);
// }

// version (wyda) unittest
// {
//     string[] arr = [ "D", "ab", "c", "Ab", "C" ];
//     auto index = schwartzMakeIndex!(toUpper, "a < b",
//                                     SwapStrategy.stable)(arr);
//     assert(isSorted!(q{toUpper(*a) < toUpper(*b)})(index));
//     assert(*index[0] == "ab" && *index[1] == "Ab"
//            && *index[2] == "c" && *index[3] == "C");

//     // random data
//     auto b = rndstuff!(string)();
//     auto index1 = schwartzMakeIndex!(toUpper)(b);
//     assert(isSorted!("toUpper(*a) < toUpper(*b)")(index1));
// }

+/

// Internal random array generators
version(unittest)
{
    package enum size_t maxArraySize = 50;
    package enum size_t minArraySize = maxArraySize - 1;

    package string[] rndstuff(T : string)()
    {
        import std.random : Random, unpredictableSeed, uniform;

        static Random rnd;
        static bool first = true;
        if (first)
        {
            rnd = Random(unpredictableSeed);
            first = false;
        }
        string[] result =
            new string[uniform(minArraySize, maxArraySize, rnd)];
        string alpha = "abcdefghijABCDEFGHIJ";
        foreach (ref s; result)
        {
            foreach (i; 0 .. uniform(0u, 20u, rnd))
            {
                auto j = uniform(0, alpha.length - 1, rnd);
                s ~= alpha[j];
            }
        }
        return result;
    }

    package int[] rndstuff(T : int)()
    {
        import std.random : Random, unpredictableSeed, uniform;

        static Random rnd;
        static bool first = true;
        if (first)
        {
            rnd = Random(unpredictableSeed);
            first = false;
        }
        int[] result = new int[uniform(minArraySize, maxArraySize, rnd)];
        foreach (ref i; result)
        {
            i = uniform(-100, 100, rnd);
        }
        return result;
    }

    package double[] rndstuff(T : double)()
    {
        double[] result;
        foreach (i; rndstuff!(int)())
        {
            result ~= i / 50.0;
        }
        return result;
    }
}
