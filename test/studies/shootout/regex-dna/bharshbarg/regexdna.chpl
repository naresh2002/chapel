/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * contributed by Ben Harshbarger
 * based on C++ RE2 implementation by Alexey Zolotov
 */

proc main() {
  var variants = [
    "agggtaaa|tttaccct",
    "[cgt]gggtaaa|tttaccc[acg]",
    "a[act]ggtaaa|tttacc[agt]t",
    "ag[act]gtaaa|tttac[agt]ct",
    "agg[act]taaa|ttta[agt]cct",
    "aggg[acg]aaa|ttt[cgt]ccct",
    "agggt[cgt]aa|tt[acg]accct",
    "agggta[cgt]a|t[acg]taccct",
    "agggtaa[cgt]|[acg]ttaccct"
  ];

  var subst = [
    ("B", "(c|g|t)"), ("D", "(a|g|t)"), ("H", "(a|c|t)"), ("K", "(g|t)"),
    ("M", "(a|c)"), ("N", "(a|c|g|t)"), ("R", "(a|g)"), ("S", "(c|g)"),
    ("V", "(a|c|g)"), ("W", "(a|t)"), ("Y", "(c|t)")
  ];

  var total, copy : string;
  stdin.readstring(total); // reads the entire file in
  const initLen = total.length;

  // remove newlines
  var noLines = compile(">.*\n|\n");
  total = noLines.sub("", total);
  const noLineLen = total.length; 

  copy = total; // grab a copy so we can replace in parallel

  var results : [variants.domain] int;

  var isDone : sync bool;

  // fire off a thread to do replacing
  begin ref(copy) {
    for (f, r) in subst {
      const re = compile(f);
      copy = re.sub(r, copy);
    }
    isDone = true; // set the 'full' state
  }

  // count patterns
  forall (pattern, result) in zip(variants, results) {
    var re = compile(pattern);
    for m in re.matches(total) do result += 1;
  }

  isDone; // waits for the 'full' state

  // print results
  for (p,r) in zip(variants, results) do writeln(p, " ", r);

  writeln("\n", initLen);
  writeln(noLineLen);
  writeln(copy.length);
}
