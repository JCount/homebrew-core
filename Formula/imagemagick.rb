class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick-7.0.6-6.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-7.0.6-6.tar.xz"
  sha256 "2c20d4d2d822fdafc6312af95a8ae0ec2256f35316efdde217522e9668c397f0"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "5eb6ea9191dccb530c3b8f2eccf6d99b13e5b826da90d22fd2a843740be05fc1" => :sierra
    sha256 "364408540c02bf5a2cc2690f8a32c17ba2f23e91c5c67186af12d285a625d8b0" => :el_capitan
    sha256 "cf1e0c9150a315602170cab69bf5b8b6ed8356b02386947cc2ff73b61bfe568e" => :yosemite
  end

  option "with-fftw", "Compile with FFTW support"
  option "with-libraw", "Compile with RAW support"
  option "with-opencl", "Compile with OpenCL support"
  option "with-openmp", "Compile with OpenMP support"
  option "with-perl", "Compile with PerlMagick"
  option "without-hdri", "Disable HDRI support"
  option "without-magick-plus-plus", "Disable build/install of Magick++"
  option "without-modules", "Disable support for dynamically loadable modules"
  option "without-threads", "Disable threads support"
  option "with-zero-configuration", "Disables depending on XML configuration files"

  deprecated_option "with-jp2" => "with-openjpeg"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "xz"

  depends_on "freetype" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  depends_on "fftw" => :optional
  depends_on "fontconfig" => :optional
  depends_on "ghostscript" => :optional
  depends_on "liblqr" => :optional
  depends_on "libraw" => :optional
  depends_on "librsvg" => :optional
  depends_on "libwmf" => :optional
  depends_on "little-cms" => :optional
  depends_on "little-cms2" => :optional
  depends_on "openexr" => :optional
  depends_on "openjpeg" => :optional
  depends_on "pango" => :optional
  depends_on "webp" => :optional

  depends_on :perl => ["5.5", :optional]
  depends_on :x11 => :optional

  needs :openmp if build.with? "openmp"

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
      --enable-static
    ]

    if build.without? "hdri"
      args << "--disable-hdri"
    else
      args << "--enable-hdri"
    end

    if build.without? "modules"
      args << "--without-modules"
    else
      args << "--with-modules"
    end

    if build.with? "opencl"
      args << "--enable-opencl"
    else
      args << "--disable-opencl"
    end

    if build.with? "openjpeg"
      args << "--with-openjp2"
    else
      args << "--without-openjp2"
    end

    if build.with? "openmp"
      args << "--enable-openmp"
    else
      args << "--disable-openmp"
    end

    if build.with? "webp"
      args << "--with-webp=yes"
    else
      args << "--without-webp"
    end

    args << "--without-fftw" if build.without? "fftw"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--with-freetype=yes" if build.with? "freetype"
    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--without-raw" if build.without? "libraw"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-wmf" if build.without? "libwmf"
    args << "--without-magick-plus-plus" if build.without? "magick-plus-plus"
    args << "--without-pango" if build.without? "pango"
    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--without-threads" if build.without? "threads"
    args << "--without-x" if build.without? "x11"
    args << "--enable-zero-configuration" if build.with? "zero-configuration"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    s = <<-EOS.undent
      For full Perl support you may need to adjust your PERL5LIB variable:
        export PERL5LIB="#{HOMEBREW_PREFIX}/lib/perl5/site_perl":$PERL5LIB
    EOS
    s if build.with? "perl"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
