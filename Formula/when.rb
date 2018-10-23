class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https:/deb.debian.org/debian/pool/main/w/when/when_1.1.38.orig.tar.gz"
  sha256 "139834945142f5e3ea6b20f43ba740d30b4a87b42ce5767026094e633dca999f"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "654603a2d0ab3dc849a4221a9d1c4d8638ebf56b41d539efde05e04c6791a5be" => :mojave
    sha256 "5f1858e4c42591c1c30c54f4bf1fecd1961b1fc2a6990f45289720ebc1ad4892" => :high_sierra
    sha256 "5f1858e4c42591c1c30c54f4bf1fecd1961b1fc2a6990f45289720ebc1ad4892" => :sierra
    sha256 "5f1858e4c42591c1c30c54f4bf1fecd1961b1fc2a6990f45289720ebc1ad4892" => :el_capitan
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
