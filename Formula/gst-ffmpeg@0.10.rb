class GstFfmpegAT010 < Formula
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2"
  sha256 "76fca05b08e00134e3cb92fa347507f42cbd48ddb08ed3343a912def187fbb62"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base@0.10"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-ffmpeg-extra-configure=--cc=#{ENV.cc}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer@0.10"].opt_bin}/gst-inspect-0.10", "ffmpeg"
  end
end
