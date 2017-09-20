class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.12/gtk-gnutella-1.1.12.tar.bz2"
  sha256 "ca65f9c56a5e17e6cb84246d5e2db453f1c73863ef937b8a1772ff4572d562ff"

  bottle do
    sha256 "4030e1d058db3dccf7e956d59bc5ad04dc793c50308dc51a0b8800cd34c8cb28" => :high_sierra
    sha256 "57b55568dad77dcef085784e3a1da5e3d61131ecf0fa192edcc6945765dbfa26" => :sierra
    sha256 "995fc6e0bd1aa6d1dbae1664f666a41846fba9cb5c3024cfbe257109a5848d4e" => :el_capitan
    sha256 "6bcadba84c5244c0f0620ee7bd92c971559fd4a5b0bdfbe54b8a43495961a4b4" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    if MacOS.version == :el_capitan && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "Configure", "ret = clock_gettime(CLOCK_REALTIME, &tp);",
                             "ret = undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end
