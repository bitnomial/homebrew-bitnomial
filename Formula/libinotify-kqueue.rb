class Libsecp256k1 < Formula
  desc "The inotify API on BSD family OSs"
  homepage "https://github.com/dmatveev/libinotify-kqueue"
  url "https://github.com/dmatveev/libinotify-kqueue.git",
    :revision => "64de19078c04456e787c9d8fba893b3a7724db73"

  option :universal
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    if build.universal?
      ENV.universal_binary
    end
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "make", "test"
  end
end
