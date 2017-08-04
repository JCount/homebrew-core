class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "http://www.fltk.org/"
  url "http://fltk.org/pub/fltk/1.3.4/fltk-1.3.4-source.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/fltk/fltk-1.3.4-source.tar.gz"
  mirror "https://fossies.org/linux/misc/fltk-1.3.4-source.tar.gz"
  sha256 "c8ab01c4e860d53e11d40dc28f98d2fe9c85aaf6dbb5af50fd6e66afec3dc58f"
  revision 1

  bottle do
    sha256 "145440139990f28366947502ac96c89ecea165dd6e328b30495291ea55b0bd17" => :sierra
    sha256 "8fc20e6d86ac3c9866b614365b25942cba95855ae748f284848224df9de7c90d" => :el_capitan
    sha256 "b30e0f6d843720c277f5e2c393abb2505d2fe69c8335c152f645ce87cc91d735" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "jpeg"

  def install
    #to enable OpenGL 3
    # new_include = <<-EOS
    #   #if defined(__APPLE__)
    #   #  include <OpenGL/gl3.h> // defines OpenGL 3.0+ functions
    #   #else
    #   #  if defined(WIN32)
    #   #    define GLEW_STATIC 1
    #   #  endif
    #   #  include <GL/glew.h>
    #   #endif
    # EOS
    # FL/gl2opengl.h

    # inreplace "FL/gl.h", "\#    include <OpenGL/gl.h>",
    #           "\#    include <OpenGL/gl3.h>\n\#    include <OpenGL/gl3ext.h>" 
    inreplace "src/Fl_Gl_Choice.H", "\#  include <OpenGL/gl.h>",
              "\#  include <OpenGL/gl3.h>\n\#  include <OpenGL/gl3ext.h>"
    inreplace %w[
      src/gl_start.cxx src/Fl_Gl_Window.cxx
      src/gl_draw.cxx test/CubeView.h test/cube.cxx test/fullscreen.cxx
      test/gl_overlay.cxx test/shape.cxx
    ].each do |s|
      s.gsub! "\#include <FL/gl.h>",
              "\#include <OpenGL/gl3.h>\n\#include <OpenGL/gl3ext.h>", false
      s.gsub! "\#  include <FL/gl.h>",
              "\#  include <OpenGL/gl3.h>\n\#  include <OpenGL/gl3ext.h>", false
    end

    # system "./configure", "--prefix=#{prefix}",
    #                       "--enable-threads",
    #                       "--enable-shared"
    # system "make", "install"
    args = std_cmake_args
    args << "-DOPTION_APPLE_X11=OFF"
    # args << "-DOPTION_BUILD_SHARED_LIBS=ON"
    args << "-DOPTION_USE_GL=ON"
    args << "-DOPTION_USE_THREADS=ON"
    # args << "-DFLTK_CONFIG_PATH=${FLTK_DATADIR}/fltk"
    args << "-DOPTION_BUILD_HTML_DOCUMENTATION=ON"
    args << "-DOPTION_INSTALL_HTML_DOCUMENTATION=ON"

    system "cmake", ".", *args

    ENV.deparallelize
    system "make"
    system "make", "html"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
