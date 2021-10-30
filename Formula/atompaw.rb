class Atompaw < Formula
  desc "Atomic datasets generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "https://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.1.1.0.tar.gz"
  sha256 "b1ee2b53720066655d98523ef337e54850cb1e68b3a2da04ff5a1576d3893891"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any, big_sur:     "83043c4fbbb55415f18c76b7019a9b6c05f5538b2f0e305d89fdab78a9d53ac1"
    sha256 cellar: :any, catalina:    "b0875f2681de8c25403e22ddba9f341e1d6dc7e2399052d756b5727cf7a979fa"
    sha256 cellar: :any, mojave:      "7c7b1d2bb768face4727eacdd595702a68f1ce6b07426e16f44df97817d75878"
    sha256 cellar: :any, high_sierra: "6f5cb71acc71451999fcb0b26e63251f9e2558dd8d6985d740ef6b2058c6c33c"
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
