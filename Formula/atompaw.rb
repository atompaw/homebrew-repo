class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.1.tar.gz"
  sha256 "d3476a5aa5f80f9430b81f28273c2c2a9b6e7d9c3d08c65544247bb76cd5a114"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any,                 monterey:      "7129bc21f1851443ea36655ffa83c49c82856b13b400b9e931982ff35c2821dd"
    sha256 cellar: :any,                 big_sur:       "d06669982c920c5c2c1b50608921087c585ca0c239613ad6d2407633ef70b0a5"
    sha256 cellar: :any,                 catalina:      "e83d13cd2b3b7cacd4c4a1600f36e13065ef0ea14b1f5bc47905715f9c423ce3"
    sha256 cellar: :any,                 mojave:        "d3b68d05997bad9925c8927a5b43a8e14f4f1c43e72ae73aeec37e1b99ce796e"
    sha256 cellar: :any,                 high_sierra:   "ec0979e8daf12ad4f587dea4c18d9a3b237f1430eec27d3faa1317364e6a33a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852b414bf11eab7c4b6ef34a047b77bd09a8d475b4094087348d1d672b30330f"
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
