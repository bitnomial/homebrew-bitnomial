class LibinotifyKqueue < Formula
  desc "The inotify API on BSD family OSs"
  homepage "https://github.com/libinotify-kqueue/libinotify-kqueue"
  url "https://github.com/libinotify-kqueue/libinotify-kqueue.git",
    :revision => "a822c8f1d75404fe3132f695a898dcd42fe8afbc"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "make", "test"
  end
end
