class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.6.0/allure-2.6.0.zip"
  sha256 "d2600c93b2a7db748e11e6e158c0c32fe0e53e86881632f021e4a3c80b60ca14"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    # Remove all windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"allure-results/allure-result.json").write <<~EOS
      {
        "uuid": "allure",
        "name": "testReportGeneration",
        "fullName": "org.homebrew.AllureFormula.testReportGeneration",
        "status": "passed",
        "stage": "finished",
        "start": 1494857300486,
        "stop": 1494857300492,
        "labels": [
          {
            "name": "package",
            "value": "org.homebrew"
          },
          {
            "name": "testClass",
            "value": "AllureFormula"
          },
          {
            "name": "testMethod",
            "value": "testReportGeneration"
          }
        ]
      }
    EOS
    system "#{bin}/allure", "generate", "#{testpath}/allure-results", "-o", "#{testpath}/allure-report"
  end
end
