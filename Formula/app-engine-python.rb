class AppEnginePython < Formula
  desc "Google App Engine"
  homepage "https://cloud.google.com/appengine/docs"
  url "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.40.zip"
  sha256 "6a3c0dfbc403f13f13c803f15ec975a6a31827910f58f2ef233b3908d96d5935"

  bottle :unneeded

  conflicts_with "app-engine-go-32",
    because: "both install the same binaries"
  conflicts_with "app-engine-go-64",
    because: "both install the same binaries"

  def install
    pkgshare.install Dir["*"]
    %w[
      _python_runtime.py
      _php_runtime.py
      api_server.py
      appcfg.py
      backends_conversion.py
      bulkload_client.py
      bulkloader.py
      dev_appserver.py
      download_appstats.py
      endpointscfg.py
      gen_protorpc.py
      google_sql.py
      php_cli.py
      remote_api_shell.py
      run_tests.py
      wrapper_util.py
    ].each do |fn|
      bin.install_symlink share/name/fn
    end
  end
end
