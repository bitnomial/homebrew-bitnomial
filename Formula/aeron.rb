class Aeron < Formula
  desc "Efficient reliable UDP unicast, UDP multicast, and IPC message transport"
  homepage "https://github.com/aeron-io/aeron"
  url "https://github.com/aeron-io/aeron.git",
    :revision => "584b7c6fb2c997abd9f9f2554a634c83959b7f94"
  version "1.44.6"

  depends_on "cmake" => :build

  def install
    # Build without Java dependency
    args = %W[
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DBUILD_AERON_ARCHIVE_API=OFF
      -DAERON_TESTS=OFF
      -DAERON_SYSTEM_TESTS=OFF
      -DAERON_BUILD_SAMPLES=OFF
      -DCMAKE_MACOSX_RPATH=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end

    # Create aeron subdirectory for headers
    (include/"aeron").mkpath

    # Install C API headers
    (include/"aeron").install Dir["aeron-client/src/main/c/*.h"]

    # Install C API subdirectories
    ["collections", "command", "concurrent", "protocol", "reports", "status", "uri", "util"].each do |dir|
      if Dir.exist?("aeron-client/src/main/c/#{dir}")
        (include/"aeron"/dir).mkpath
        (include/"aeron"/dir).install Dir["aeron-client/src/main/c/#{dir}/*.h"]
      end
    end

    # Install libraries
    lib.install Dir["build/lib/*"]

    # Install binaries
    bin.install Dir["build/binaries/*"]

    # Fix binary rpaths
    bin.find do |path|
      if path.file? && path.executable?
        system "install_name_tool", "-add_rpath", lib, path
      end
    end

    # Generate and install pkg-config file
    mkdir_p "#{lib}/pkgconfig"
    File.open("#{lib}/pkgconfig/aeron-client.pc", "w") do |f|
      f.puts "Name: aeron-client"
      f.puts "Description: Efficient reliable UDP unicast, UDP multicast, and IPC message transport"
      f.puts "Version: #{version}"
      f.puts "Cflags: -I#{include}"
      f.puts "Libs: -L#{lib} -laeron -laeron_client_shared"
      f.puts "Requires:"
      f.puts "Requires.private:"
    end
  end

  test do
    # Create simplified test that doesn't rely on internal headers
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <aeron/aeronc.h>

      int main() {
        printf("Aeron version: %d.%d.%d\\n",
          AERON_VERSION_MAJOR,
          AERON_VERSION_MINOR,
          AERON_VERSION_PATCH);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laeron", "-o", "test"
    system "./test"
  end
end
