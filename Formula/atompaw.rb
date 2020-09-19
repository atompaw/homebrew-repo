class Atompaw < Formula
  desc "Atomic datasets generator for DFT calculations based on the PAW method"
  homepage "http://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.1.0.6.tar.gz"
  sha256 "42a46c0569367c0b971fbc3dcaf5eaec7020bdff111022b6f320de9f11c41c2c"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    cellar :any
    sha256 "5d582c2d83030625490ee0dd27fac50b7bc23314c3bf9838140624e1f79ed84e" => :catalina
    sha256 "c8a2356f5b2cd2f31f75253e48b9cb480bb84ef427216a03e9f45168b59434dc" => :mojave
    sha256 "83cb08331fc315fed818ced34b81fe68ebd61d712e0bf2813873ca67c4f54815" => :high_sierra
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
    if OS.mac?
      args << "--with-linalg-incs=-I#{Formula["veclibfort"].opt_include}"
      args << "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    else
      args << "--with-linalg-incs=-I#{Formula["lapack"].opt_include}"
      args << "--with-linalg-libs=-L#{Formula["lapack"].opt_lib} -lblas -llapack"
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
