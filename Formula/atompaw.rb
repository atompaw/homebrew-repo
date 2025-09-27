class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.3.tar.gz"
  sha256 "9fd4f9b60e793eee10aead4296e89f0bd6e8612b729a15e2401bbd90e4e9dd2d"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any, arm64_tahoe: "c54851fcdf50c0f710fab79cd54995f704af480da1d8b20b51ed7d0bdb73e715"
    sha256 cellar: :any, arm64_sequoia: "760881c5da140eac3b4fb7f7c8956023f6d76428d97c828551e09f54543f0642"
    sha256 cellar: :any, arm64_sonoma: "def8cf9c6bc06680a97ba79317597ea9a74438d94cb37ef55840929e7d8fda51"
    sha256 cellar: :any, arm64_ventura: "b7629823cfaec65bb34f7d9bff519c14f78b69743907c3186765f62a7325083f"
    sha256 cellar: :any, arm64_monterey: "a937aa3c791ff1c709725363cb14b5fb5a81fa9f89f30299db97c73d1dfe57bf"
    sha256 cellar: :any, tahoe: "0f1588e0daa10d66ef4b08103b189e0328e44099a6d764f8e5bea5ee4501db97"
    sha256 cellar: :any, sequoia: "2a9dbdd526530a9bde006c3f89e7225177afa17d62cf3b9b4a9f27f6d7c1a8b9"
    sha256 cellar: :any, sonoma: "f44e23f06dada9563a2cdab280719aa00c7b0d888127daf5f1d88c604af675d1"
    sha256 cellar: :any, ventura: "6c44e339cd40c664c2c5e95020e8dd56803201d38cba8b6cc1a00ff14a9ef9dd"
    sha256 cellar: :any, monterey: "cb1f6307c80ec293ce3db0646b0948f3fa7ab787990ea6a853ee24a3f440acec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bb0b8859c41420d974b523ce619fd16d05a772e90b06f37d5a2347ea7a2e2671"
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
