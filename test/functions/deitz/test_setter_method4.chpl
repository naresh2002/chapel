class C {
  var x: [1..3] int;
  proc foo() ref {
    writeln(setter);
    return x;
  }
}

var c = new C();

c.foo() = 2;
writeln(c.foo());
delete c;
