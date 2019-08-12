class Atompaw < Formula
  desc "AtomPAW generates atomic datasets needed for performing electronic structure calculations based on the projector augmented-wave (PAW) method."
  homepage "http://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.1.0.6.tar.gz"
  sha256 "42a46c0569367c0b971fbc3dcaf5eaec7020bdff111022b6f320de9f11c41c2c"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    cellar :any
    sha256 "d51eb6968bc1d5070102c4473bdb750ce1088dd324f0d960481ce45d7a5ca002" => :mojave
  end

  depends_on "gcc" if OS.mac? # for gfortran
  depends_on "libxc" => :recommended
  if OS.mac?
    depends_on "veclibfort"
  end

  def install
    #ENV.deparallelize
    args = %W[--prefix=#{prefix}
              --disable-shared]
    args << "--with-linalg-incs=-I#{Formula["veclibfort"].opt_include}"
    args << "--with-linalg-libs=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"

    if build.with? "libxc"
      args << "--enable-libxc"
      args << "--with-libxc-incs=-I#{Formula["libxc"].opt_include}"
      args << "--with-libxc-libs=-L#{Formula["libxc"].opt_lib} -lxc -lxcf90"
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
