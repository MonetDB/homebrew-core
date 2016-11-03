class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.03.tar.gz"
  sha256 "96b428d803eab6e2d9f630bce9ba7c8f553e335b6dbbed4b091e765392a57285"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bedd438beb1b7e2b2895ed977add733eb5c8d1d52a842dbeb8109acfd622b2aa" => :sierra
    sha256 "9eb05c6997159ac70a20a11cbd7385015e8e8ec47ff4c89c1071a0fb41573c94" => :el_capitan
    sha256 "e058d701aa83475f9d8654c4a3ecadbfe4d275cc37d6694cc77e9ddc7ebbc19d" => :yosemite
    sha256 "c1688beb968e70feac97b42beda44f7d2a9f0eaf4725920c8e9127daf3473c10" => :mavericks
  end

  def install
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msandbox", 1)
  end
end
