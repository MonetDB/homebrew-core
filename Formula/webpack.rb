require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-3.6.0.tgz"
  sha256 "d130fa4812e4fcc967d9108c3e7fabb8f2b95d1b84358b809d82623b55a274e5"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "c2d8fbdb827440a0cd084b10ca67aeda9b150544e79216eb6609d0ee10d85b77" => :sierra
    sha256 "c4c488b1061a1ba404510270f4b586ed88f6a8bf7b24c22e89b2854eea200e1d" => :el_capitan
    sha256 "f83f977d862e39c4370055bf63cc5cbb506c48365dea55602e3882c052ee0941" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"index.js").write <<-EOS.undent
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "bundle.js"
    assert File.exist?("bundle.js"), "bundle.js was not generated"
  end
end
