class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.2.tar.gz"
  sha256 "c16648611f5798b8e1781fb2229854c54fa63f085bd11440fdc4ecacbf0ad93e"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any, arm64_ventura: "dd163b4c81ef91059e3ff4d49ed7541fd932656f8ee9c7d85c669aa5e827067a"
    sha256 cellar: :any, arm64_monterey: "55b56211f19afdd2ee71a3fb2fe11e74aca0035d8d22b1726ff7bb171d539919"
    sha256 cellar: :any, ventura: "1f49678812a8bcca0bfb58b725588945c07ca17ce0b6d4104d75c33ffaa32450"
    sha256 cellar: :any, monterey: "8faad12a405dfe7209b102b6d1e37e68bff8732fc473190e938ffe0e7a5d4629"
    sha256 cellar: :any, big_sur:  "c1a99a6139c67de4209ed9ec928fcf214fd3a7d9acd22c9373f3ddaf69ed8428"
    sha256 cellar: :any, catalina: "1b92fe1aef0849d371d0b78d225d4cb219a8179ce9334a542df760992558f394"
    sha256 cellar: :any, mojave: "7f0e006781c6681dddcb1bf66f6580bdd09e72cb3ac328145bf4e19ebcfeae46"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1924baca26fa31b6b8074e5f2834552f76ce83a921d8fa2ec55fd2faafd616fd"
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
