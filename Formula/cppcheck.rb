class Cppcheck < Formula
  desc "Static analysis of C and C++ code"
  homepage "https://sourceforge.net/projects/cppcheck/"
  url "https://github.com/danmar/cppcheck/archive/1.84.tar.gz"
  sha256 "aaa6293d91505fc6caa6982ca3cd2d949fa1aac603cabad072b705fdda017fc5"
  head "https://github.com/danmar/cppcheck.git"

  bottle do
    sha256 "f1a746cd9b65d7c4b69e14bf58e623caefc35d28c577306265a688cc2f2605c6" => :mojave
    sha256 "94fdbee6373e6a4f3102110b522be26e7b2b4a285f91115ba3a82a0d85643124" => :high_sierra
    sha256 "a6ced4322c5114c84999697cd1e07ebd50905a9ca9477398e46a359a6e0b7b8f" => :sierra
    sha256 "55c59fc078a4c2311ed7d4c1f048ae1114dbcf30956249441979e6bc91e7762b" => :el_capitan
  end

  depends_on "pcre"

  needs :cxx11

  def install
    ENV.cxx11

    system "make", "HAVE_RULES=yes", "CFGDIR=#{prefix}/cfg"

    # CFGDIR is relative to the prefix for install, don't add #{prefix}.
    system "make", "DESTDIR=#{prefix}", "BIN=#{bin}", "CFGDIR=/cfg", "install"

    # Move the python addons to the cppcheck pkgshare folder
    (pkgshare/"addons").install Dir.glob(bin/"*.py")
  end

  test do
    # Execution test with an input .cpp file
    test_cpp_file = testpath/"test.cpp"
    test_cpp_file.write <<~EOS
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << "Hello World!" << endl;
        return 0;
      }

      class Example
      {
        public:
          int GetNumber() const;
          explicit Example(int initialNumber);
        private:
          int number;
      };

      Example::Example(int initialNumber)
      {
        number = initialNumber;
      }
    EOS
    system "#{bin}/cppcheck", test_cpp_file

    # Test the "out of bounds" check
    test_cpp_file_check = testpath/"testcheck.cpp"
    test_cpp_file_check.write <<~EOS
      int main()
      {
      char a[10];
      a[10] = 0;
      return 0;
      }
    EOS
    output = shell_output("#{bin}/cppcheck #{test_cpp_file_check} 2>&1")
    assert_match "out of bounds", output

    # Test the addon functionality: sampleaddon.py imports the cppcheckdata python
    # module and uses it to parse a cppcheck dump into an OOP structure. We then
    # check the correct number of detected tokens and function names.
    addons_dir = pkgshare/"addons"
    cppcheck_module = "#{name}data"
    expect_token_count = 55
    expect_function_names = "main,GetNumber,Example"
    assert_parse_message = "Error: sampleaddon.py: failed: can't parse the #{name} dump."

    sample_addon_file = testpath/"sampleaddon.py"
    sample_addon_file.write <<~EOS
      #!/usr/bin/env python
      """A simple test addon for #{name}, prints function names and token count"""
      import sys
      import imp
      # Manually import the '#{cppcheck_module}' module
      CFILE, FNAME, CDATA = imp.find_module("#{cppcheck_module}", ["#{addons_dir}"])
      CPPCHECKDATA = imp.load_module("#{cppcheck_module}", CFILE, FNAME, CDATA)

      for arg in sys.argv[1:]:
          # Parse the dump file generated by #{name}
          configKlass = CPPCHECKDATA.parsedump(arg)
          if len(configKlass.configurations) == 0:
              sys.exit("#{assert_parse_message}") # Parse failure
          fConfig = configKlass.configurations[0]
          # Pick and join the function names in a string, separated by ','
          detected_functions = ','.join(fn.name for fn in fConfig.functions)
          detected_token_count = len(fConfig.tokenlist)
          # Print the function names on the first line and the token count on the second
          print "%s\\n%s" %(detected_functions, detected_token_count)
    EOS

    system "#{bin}/cppcheck", "--dump", test_cpp_file
    test_cpp_file_dump = "#{test_cpp_file}.dump"
    assert_predicate testpath/test_cpp_file_dump, :exist?
    output = shell_output("python #{sample_addon_file} #{test_cpp_file_dump}")
    assert_match "#{expect_function_names}\n#{expect_token_count}", output
  end
end
