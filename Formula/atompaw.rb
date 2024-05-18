class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.3.tar.gz"
  sha256 "9fd4f9b60e793eee10aead4296e89f0bd6e8612b729a15e2401bbd90e4e9dd2d"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any, arm64_sonoma: "d486ddfaf087919ed375eecc9cceaf15dd5b0c62b772dfcf446d45209d7a9cde"
    sha256 cellar: :any, arm64_monterey: "06da2abd0142f301e08496871b5b4ba4ba5ac56dde6f3114bc8c02622f460939"
    sha256 cellar: :any, arm64_ventura: "0f3f2334a2760214311b3dae6226ac6818317b7b1d6cf81a49275057fcabebac"
    sha256 cellar: :any, sonoma: "9494ba0abdcfa19b6a6c53315ece45b0ed79d1b047b6a0157e5207527fa59ffc"
    sha256 cellar: :any, monterey: "ccc60942b922eabb9f8e5bb8f4e42aaac3da03fe0f393542df40dca245701f21"
    sha256 cellar: :any, ventura: "4602c2f56a5c5769dd49038710b7878005656ea43ce2db370d9cc22c088595b9"
    sha256 cellar: :any, big_sur: "97a76c199308c3b62033396b6d3834993afb9d104c7de31b9787c1053ecc066e"
    sha256 cellar: :any, catalina: "b0bb60502179da5dd32ad3ac728f5216058659cb6a04894f774186fff98921c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8f5a8699b71295ffe276c200c9bf2bb56ef338f8eb28d11926eb43eeb3a11fcd"
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
