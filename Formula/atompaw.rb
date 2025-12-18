class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.5.tar.gz"
  sha256 "45c66e02629252ba1065aa245a277af9528ed5d560c2f11979452a7ec6e99ac8"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any,                 arm64_tahoe:    "fb7536253c5558220fea4887dc91823378776ab1d724ff15fa1a608c63cff3c8"
    sha256 cellar: :any,                 arm64_sequoia:  "07615f70412172ac8dbeb45735a8b960601fe0910c692ae51a0c1512f1be0ce3"
    sha256 cellar: :any,                 arm64_sonoma:   "32a78a0aced456fc452075e24fb6a03cf4b1c55b6c115ea93e435167c08eb2d0"
    sha256 cellar: :any,                 arm64_ventura:  "f085526c07b7d9da1c48f3e63f1277a6b5ad3491b3dfde045d1cee638776b174"
    sha256 cellar: :any,                 arm64_monterey: "d796ec01958587b5abc572b31a64b203e7991274476ff8b55ac90fbb91ab3b00"
    sha256 cellar: :any,                 tahoe:          "603dad6d80bfbda20d4f1297ed2dd7c2d55717f1a4cbebf719c69f44269ac9c7"
    sha256 cellar: :any,                 sequoia:        "88974f69544994b8d73352c0344e80f68888beb4baf55d498311b5879cfd4d9f"
    sha256 cellar: :any,                 sonoma:         "10085a64413dc1eac9cbac5cbb94d09bf802aba75b50165349b75b8305037561"
    sha256 cellar: :any,                 ventura:        "256ab20683613d80a6ea1b7b53b4d4a80fec8a77fc1b8b2fbf846ed4bcf16771"
    sha256 cellar: :any,                 monterey:       "c4dfa2ee3096ee91b1180a3e722d98920de26f58e04612bf9a20693bbf08f115"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "da98899c0c9b700a1c7f9fc3235abbff523e316c38bb9dd85790e6b3205a7f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c131540b845f2b6e66a11533564d23c89a9f5e4a1fe105d069ab34c7f759073"
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
