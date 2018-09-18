class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gstreamer-editing-services-1.14.3.tar.xz"
  sha256 "bdb6be75acfaaac3528d30ad47e77eb443d6c55ddabd597c154cd9e88c9a37de"

  bottle do
    sha256 "d1b9af46b7633a7656501687c594b2d7741ae898d2319a0d6da57cb249581655" => :mojave
    sha256 "831ffe600c209b6cf5de232ec88d855766c266ddc583a72552c06c8c1070d5cb" => :high_sierra
    sha256 "2165a0043372021c8c264fcb5a388fc5b01ed1b54f7afcef17cc5ba19a2051fd" => :sierra
    sha256 "58a5e50c51b8db69d11a1e2d4e7f92f87f53deadc68606bc307766b246df4d8f" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gtk-doc",
                          "--disable-docbook"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
