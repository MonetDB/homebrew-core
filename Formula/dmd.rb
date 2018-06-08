class Dmd < Formula
  desc "D programming language compiler for macOS"
  homepage "https://dlang.org/"

  stable do
    url "https://github.com/dlang/dmd/archive/v2.080.1.tar.gz"
    sha256 "50f38e3bd1ac2ce05442e2ab061c6544e0c346eb6d03eb95204238b963ee25a0"

    resource "druntime" do
      url "https://github.com/dlang/druntime/archive/v2.080.1.tar.gz"
      sha256 "ca075552c3358682937ea8e3412877bfc7c9eddb928575916eabbe9abff58671"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos/archive/v2.080.1.tar.gz"
      sha256 "57b7c7ab18879acffe50dfff0a7f988d6e4d0ba9341a4ee1ab6eeecca180d6c0"
    end

    resource "tools" do
      url "https://github.com/dlang/tools/archive/v2.080.1.tar.gz"
      sha256 "d8fe0af45ba0e19a95ad3e1bbb19c005176346bb264c8ddd8272e9195304b625"
    end
  end

  bottle do
    sha256 "79c618dbcf2c252ee60ba8c33c5f1ab7a9ec410a6b12b825cddaf72028644f3d" => :high_sierra
    sha256 "063a291a26c1a277ebd6a3fa18ead76971708bff3156c28e830ac9414d8c908b" => :sierra
    sha256 "75496127e9ea51049752d858d217bff35043fa5c1daeedd755948ba89a0e3c7c" => :el_capitan
  end

  head do
    url "https://github.com/dlang/dmd.git"

    resource "druntime" do
      url "https://github.com/dlang/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/dlang/phobos.git"
    end

    resource "tools" do
      url "https://github.com/dlang/tools.git"
    end
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    make_args.unshift "DMD_DIR=#{buildpath}", "DRUNTIME_PATH=#{buildpath}/druntime", "PHOBOS_PATH=#{buildpath}/phobos"

    (buildpath/"druntime").install resource("druntime")
    system "make", "-C", "druntime", *make_args

    (buildpath/"phobos").install resource("phobos")
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end

    bin.install "generated/osx/release/64/dmd"
    pkgshare.install "samples"
    man.install Dir["docs/man/*"]

    (include/"dlang/dmd").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"dlang/dmd"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    (buildpath/"dmd.conf").write <<~EOS
      [Environment]
      DFLAGS=-I#{opt_include}/dlang/dmd -L-L#{opt_lib}
    EOS
    etc.install "dmd.conf"
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", pkgshare/"samples/hello.d"
    system "./hello"
  end
end
