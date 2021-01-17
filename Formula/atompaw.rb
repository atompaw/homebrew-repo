class Atompaw < Formula
  desc "Atomic datasets generator for DFT calculations based on the PAW method"
  homepage "http://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.1.1.0.tar.gz"
  sha256 "b1ee2b53720066655d98523ef337e54850cb1e68b3a2da04ff5a1576d3893891"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    cellar :any
    sha256 "ad462a8365445cad334ee8a74d6d0694683d5d44b7ca9bcf8a1a7ef19217d728" => :big_sur
    sha256 "b16f9b5b0011a6acf7eae4a3712516f4ed2dfdfc16a788108693a626967c5b89" => :catalina
    sha256 "bdfb1a99063b939e58abb0ed9ed880fcd951a4a6c6e1a8d8c32051f18999b08d" => :mojave
    sha256 "d721e7e69948d949a26db5dc5a4cfaa09f609633c27be90df6e9d7bf60d4e89f" => :high_sierra
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
