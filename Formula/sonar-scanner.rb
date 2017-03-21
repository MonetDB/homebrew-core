class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner"
  url "https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-2.9.0.670.zip"
  sha256 "d10ca9009fde6ae6cc01b203e9995ce1f6efc90a02de46997ce27572eb4fb855"
  head "https://github.com/SonarSource/sonar-scanner-cli.git"

  bottle :unneeded

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/", :SONAR_SCANNER_HOME => libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
