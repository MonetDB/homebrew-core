class JujuWait < Formula
  include Language::Python::Virtualenv

  desc "Juju plugin for waiting for deployments to settle"
  homepage "https://launchpad.net/juju-wait"
  url "https://files.pythonhosted.org/packages/3d/c2/8cce9ec8386be418a76566fcd2e7dcbaa7138a92b0b9b463306d9191cfd7/juju-wait-2.6.2.tar.gz"
  sha256 "86622804896e80f26a3ed15dff979584952ba484ccb5258d8bab6589e26dd46d"
  revision 4

  bottle do
    cellar :any
    sha256 "51906945fb39ed28fa33b92a98a81d47a3fd49637010679bcad42422d3098c34" => :high_sierra
    sha256 "3e1fb2315eb92e4e53bc2877bf69fce7305b0080c777776ecf86aaa24f95bfe1" => :sierra
    sha256 "1b27054cb556c62bbaf505dd42a8c1df01e6aaf269a2bc9ca72fa8394c0d8c4c" => :el_capitan
  end

  depends_on "python"
  depends_on "libyaml"
  depends_on "juju"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/bd/da/0a49c1a31c60634b93fd1376b3b7966c4f81f2da8263f389cad5b6bbd6e8/PyYAML-4.2b1.tar.gz"
    sha256 "ef3a0d5a5e950747f4a39ed7b204e036b37f9bddc7551c1a813b8727515a832e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Note: Testing this plugin requires a Juju environment that's in the
    # process of deploying big software. This plugin relies on those application
    # statuses to determine if an environment is completely deployed or not.
    system "#{bin}/juju-wait", "--version"
  end
end
