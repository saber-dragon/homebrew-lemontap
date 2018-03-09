class HomebrewLemon < Formula
  desc "C++ Library for Efficient Modeling and Optimization in Networks."
  homepage "https://lemon.cs.elte.hu/trac/lemon"
  url "http://lemon.cs.elte.hu/pub/sources/lemon-1.3.1.tar.gz"
  sha256 "71b7c725f4c0b4a8ccb92eb87b208701586cf7a96156ebd821ca3ed855bad3c8"

  depends_on "glpk"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DLEMON_ENABLE_GLPK=YES", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.cc").write <<~EOS
      #include <iostream>
      #include "lemon/list_graph.h"
      using namespace lemon;
      using namespace std;
      int main()
      {
        ListDigraph g;
        ListDigraph::Node u = g.addNode();
        ListDigraph::Node v = g.addNode();
        ListDigraph::Arc  a = g.addArc(u, v);

        cout << countNodes(g) 
             << " "
             << countArcs(g);
        return 0;
      }
    EOS
    system ENV.cc, "hello.cc", "-L#{lib}", "-I#{include}", "-llemon", "-o", "hello"
    assert_match "2 1", shell_output("./hello")
  end
end
