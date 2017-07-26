class Tclreadline < Formula
  desc "Makes the GNU Readline library available for interactive tcl shells"
  homepage "https://tclreadline.sourceforge.io"
  url "https://github.com/flightaware/tclreadline/archive/v2.2.0.tar.gz"
  sha256 "6ca811ff8fbb3a9c8c400a8f7a3c2819a232c7b8e216cc10c4b47aef6a07d507"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "readline"

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}",
                           "--with-tcl=/System/Library/Frameworks/Tcl.framework",
                           "--with-tcl-includes=/System/Library/Frameworks/Tcl.framework/Headers",
                           "--with-readline-includes=#{Formula["readline"].opt_include}",
                           "--with-readline-library=#{Formula["readline"].opt_lib} -lreadline"

    system "make", "install"
  end

  def caveats
    <<-EOS.undent
    To enable readline completion in tclsh put something like this in your ~/.tclshrc

    if {$tcl_interactive} {
      set auto_path [linsert $auto_path 0 #{lib}]
      package require tclreadline
      set tclreadline::historyLength 200
      tclreadline::Loop
    }

    See https://sourceforge.net/p/tclreadline/git/ci/master/tree/sample.tclshrc
    EOS
  end

  test do
    (testpath/"test.tcl").write <<-EOS.undent
      set auto_path [linsert $auto_path 0 #{lib}]
      package require tclreadline
      set ret [::tclreadline::readline complete "set a [expr {(5 + -3) * 4}]"]
      if { $ret == 1 } then {
        exit 0
      }
      exit 1
    EOS
    shell_output("/usr/bin/tclsh test.tcl", 0)
  end
end
