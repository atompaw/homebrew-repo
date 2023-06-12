class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.3.tar.gz"
  sha256 "9fd4f9b60e793eee10aead4296e89f0bd6e8612b729a15e2401bbd90e4e9dd2d"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any, arm64_ventura: "42586841f7d3e3914d4c1096007a4d366e9f632806b65678a2208f63abc8caba"
    sha256 cellar: :any, arm64_monterey: "0585916c5443fc4e029ddaf58269e67c1282c9ea5e7651e2fc2c3fd253819010"
    sha256 cellar: :any, ventura: "d22b1e6254bf1fab1ffa3f75876692e2f3f21a4ced7649d90631519e2cf31fac"
    sha256 cellar: :any, monterey: "795fe4077c2876cc152b9baab96d8592b28f4d98be048cf922ce3f6ed72b978d"
    sha256 cellar: :any, big_sur:  "13fb11ab2e7d079a049366eb5f6c36f7a581fc6b2df4184d4209eef4b00d33e2"
    sha256 cellar: :any, catalina: "0681e2d3a24afa6c38a6914738c989662af229bb7415d75e16d6d3e965dfad28"
    sha256 cellar: :any, mojave: "6bc9d6ff2aea395e1b8f2d8604b8db6452bd0f20dad1c48bb1aa37ef0022c2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cc6bc7c86d2f3f25d03903d086388ce1b265ca8b8f6aed322a7d9f2e9f088b44"
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
