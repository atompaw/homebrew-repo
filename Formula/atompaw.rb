class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.0.tar.gz"
  sha256 "dde5bc216544180a44e0bbd77668feb741621fd3fb0a14bd98df721363710c62"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any,                 arm64_monterey: "5165a20f0811e5fc42e8a0f0bffda2eb07914f4b5c4b95115e5bed9783ebf061"
    # sha256 cellar: :any, arm64_big_sur:  "5165a20f0811e5fc42e8a0f0bffda2eb07914f4b5c4b95115e5bed9783ebf061"
    sha256 cellar: :any,                 monterey:       "3c9abf66159762a0145477ee2d6ea8854ad955de1db15753b27d587ec7bc9b27"
    sha256 cellar: :any,                 big_sur:        "9c6908c96ab57e372840fceb42abc5714c0dbe5742822cc3d6d10fbeb21dd6c6"
    sha256 cellar: :any,                 catalina:       "c7ab9b82174578646918e4b88dcd7185ca4a1c4aca8c455de370b0e2399b07a2"
    sha256 cellar: :any,                 mojave:         "a8915bb2088705730fe7ef8ae87294c7c59f24e2dd0afc3228204de900cf5145"
    sha256 cellar: :any,                 high_sierra:    "a29dd8d1f8d9b8348ceb0a68b23e491e3cb1a201bbefde2bd2eacdcfab43ac18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "460d95df91ab449fc8014c1f2ebac3a7f4fdb00ab12475cf2127ef977022821f"
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
