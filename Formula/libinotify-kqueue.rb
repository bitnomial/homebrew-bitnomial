class LibinotifyKqueue < Formula
  desc "The inotify API on BSD family OSs"
  homepage "https://github.com/libinotify-kqueue/libinotify-kqueue"
  url "https://github.com/libinotify-kqueue/libinotify-kqueue.git",
    :revision => "0de168e0a9363f6f261e59f93b9f976b57d4fab6"
  version "0de168e0a9363f6f261e59f93b9f976b57d4fab6"

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
