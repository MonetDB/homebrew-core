class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "http://bochs.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.6.8/bochs-2.6.8.tar.gz"
  sha256 "79700ef0914a0973f62d9908ff700ef7def62d4a28ed5de418ef61f3576585ce"

  option "with-gdb-stub", "Enable GDB Stub"

  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-sdl2
      --with-nogui
      --enable-disasm
      --disable-docbook
      --enable-x86-64
      --enable-pci
      --enable-all-optimizations
      --enable-plugins
      --enable-cdrom
      --enable-a20-pin
      --enable-fpu
      --enable-alignment-check
      --enable-large-ramfile
      --enable-debugger-gui
      --enable-readline
      --enable-iodebug
      --enable-xpm
      --enable-show-ips
      --enable-logging
      --enable-usb
      --enable-ne2000
      --enable-cpu-level=6
      --enable-clgd54xx
      --with-term
    ]

    if build.with? "gdb-stub"
      args << "--enable-gdb-stub"
    else
      args << "--enable-debugger"
    end

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    require "open3"

    (testpath/"bochsrc.txt").write <<-EOS.undent
        panic: action=fatal
        error: action=report
        info: action=ignore
        debug: action=ignore
      EOS

    expected = <<-ERR.undent
        Bochs is exiting with the following message:
        \[BIOS  \] No bootable device\.
      ERR

    command = "#{bin}/bochs -qf bochsrc.txt"
    if build.without? "gdb-stub"
      # When the debugger is enabled, bochs will stop on a breakpoint early
      # during boot. We can pass in a command file to continue when it is hit.
      (testpath/"debugger.txt").write("c\n")
      command << " -rc debugger.txt"
    end

    _, stderr, = Open3.capture3(command)
    assert_match(expected, stderr)
  end
end
