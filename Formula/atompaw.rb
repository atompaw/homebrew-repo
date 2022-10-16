class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.2.tar.gz"
  sha256 "9b6de2d8b614890a42ce3d158870612510818f5365c2d8054f4dab3e40f40264"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    #    sha256 cellar: :any,                 arm64_monterey: "d9272b3c1d60ceff03b0ecb8681aefa31b6ba3a73527c51067b726c01c9875bf"
    sha256 cellar: :any,                 monterey:     "d232264bb62659d4fc227ae98ef4fa4b6ee18182ba22407c096e9dbf461b1900"
    sha256 cellar: :any,                 big_sur:      "478382037d1d534d0b73144db53f276758d60728e34372b65d7c8dba76e83a93"
    sha256 cellar: :any,                 catalina:     "7d6c5fa07a727da24654db1c55f6b2921f9edf2fe51a374d898cedbc474c995b"
    sha256 cellar: :any,                 mojave:       "23978543a36d200e4f234e4ee828f7b4d5b606401f62e7a47bf281b84ef69cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b95b1160c6272e6d2214f2521b3cdddd9f2ecec0000e079a940fcaa872279e76"
  end

  depends_on "gcc" if OS.mac? # for gfortran
  if OS.mac?
    depends_on "veclibfort"
  else
    depends_on "lapack"
  end
  depends_on "libxc" => :recommended

  def install
    args = %W[--prefix=#{prefix}
              --disable-shared]
    args << if OS.mac?
      "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    else
      "--with-linalg-libs=-L#{Formula["lapack"].opt_lib} -lblas -llapack"
    end
    if build.with? "libxc"
      args << "--enable-libxc"
      args << "--with-libxc-incs=-I#{Formula["libxc"].opt_include}"
      args << "--with-libxc-libs=-L#{Formula["libxc"].opt_lib} -lxc"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    atompaw_tests = %W[#{doc}/example/F/lda/F.input
                       #{doc}/example/Li/lda/Li.input
                       #{doc}/example/Li/hf/Li.input]
    atompaw_tests.each do |atompaw_input|
      system "#{bin}/atompaw < #{atompaw_input} > atompaw.log"
    end
  end
end
