class Gwyddion < Formula
  desc "Scanning Probe Microscopy visualization and analysis tool"
  homepage "http://gwyddion.net/"
  url "http://gwyddion.net/download/2.47/gwyddion-2.47.tar.gz"
  sha256 "7b440e082f7fbfa38ad0355bafb1576c52eb4b35c4b97c3ac525a4cec879ddf2"
  revision 1

  bottle do
    sha256 "6ddc06a1388396662d2be33a7efec97f54b35d61bccbfeaee49aa3fd2959d726" => :sierra
    sha256 "5b254bffa7e6088a5c5fd8297ea2a57e3ecc5d3cbaa3b20cd4365ebc3b60f668" => :el_capitan
    sha256 "325036fd27f4c51d1a8cfa7ae1a9c1e522683eef624e886fd052c74e2fde8f1e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-sed" => :build
  depends_on "fftw"
  depends_on "gtk+"
  depends_on "gtk-mac-integration"
  depends_on "gtkglext"
  depends_on "libxml2"
  depends_on "minizip"

  depends_on :python => :optional
  depends_on "pygtk" if build.with? "python"
  depends_on "gtksourceview" if build.with? "python"

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-desktop-file-update",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{doc}"
    system "make", "install"
  end

  test do
    system "#{bin}/gwyddion", "--version"
    (testpath/"test.c").write <<-EOS.undent
      #include <libgwyddion/gwyddion.h>

      int main(int argc, char *argv[]) {
        const gchar *string = gwy_version_string();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fftw = Formula["fftw"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    gtkglext = Formula["gtkglext"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fftw.opt_include}
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkglext.opt_include}/gtkglext-1.0
      -I#{gtkglext.opt_lib}/gtkglext-1.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gwyddion
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gwyddion/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{fftw.opt_lib}
      -L#{fontconfig.opt_lib}
      -L#{freetype.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkglext.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lfftw3
      -lfontconfig
      -lfreetype
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgdkglext-quartz-1.0
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lgtkglext-quartz-1.0
      -lgwyapp2
      -lgwyddion2
      -lgwydgets2
      -lgwydraw2
      -lgwymodule2
      -lgwyprocess2
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lpangoft2-1.0
      -framework AppKit
      -framework OpenGL
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
