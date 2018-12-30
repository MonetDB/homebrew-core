require "language/node"

class AtomistCli < Formula
  desc "The Atomist CLI"
  homepage "https://github.com/atomist/cli#readme"
  url "https://registry.npmjs.org/@atomist/cli/-/@atomist/cli-1.1.0.tgz"
  sha256 "bdc37fc2216745b1156f7038de66f755a355fc9328ee72ec53630d95c1b22be9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c9c870b32219f80331b4a5b88be890c65a7aa302491fb0152dfa53835b18ade" => :mojave
    sha256 "93b64aa4b2b1616431546d1390a73f23fcf9e2d882aa7d774de5a094c08d9b01" => :high_sierra
    sha256 "21c36da42409a22383703491f43ef4c6916ce156f7ca7fabfd4b51858f03e309" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install "#{libexec}/lib/node_modules/@atomist/cli/assets/bash_completion/atomist"
  end

  test do
    assert_predicate bin/"atomist", :exist?
    assert_predicate bin/"atomist", :executable?
    assert_predicate bin/"@atomist", :exist?
    assert_predicate bin/"@atomist", :executable?

    run_output = shell_output("#{bin}/atomist 2>&1")
    assert_match "Not enough non-option arguments", run_output
    assert_match "Specify --help for available options", run_output

    version_output = shell_output("#{bin}/atomist --version")
    assert_match "@atomist/cli", version_output
    assert_match "@atomist/sdm ", version_output
    assert_match "@atomist/sdm-core", version_output
    assert_match "@atomist/sdm-local", version_output

    skill_output = shell_output("#{bin}/atomist show skills")
    assert_match(/\d+ commands are available from \d+ connected SDMs/, skill_output)
  end
end
