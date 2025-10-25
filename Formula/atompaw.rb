class Atompaw < Formula
  desc "Atomic dataset generator for DFT calculations based on the PAW method"
  homepage "https://users.wfu.edu/natalie/papers/pwpaw"
  url "http://users.wfu.edu/natalie/papers/pwpaw/atompaw-4.2.0.4.tar.gz"
  sha256 "09a7976f79b8a27b9a9618ddffb7efa132cdc46cbae428c053c1089817c35c73"

  bottle do
    root_url "http://forge.abinit.org/homebrew"
    sha256 cellar: :any, arm64_tahoe: "ee3a7133c7c83c5d5f91d91469adc6155097a1b24f7b64a8e8acfec3be365d1a"
    sha256 cellar: :any, arm64_sequoia: "fc245fbb230f499cf8db8e30781e3ada747bdd38e5ee812d4ac82f9edebf66a0"
    sha256 cellar: :any, arm64_sonoma: "782ae3f1d2b865f45eca5aee9dbdd95cb09376908447e0bfc09c00595baf05d7"
    sha256 cellar: :any, arm64_ventura: "9fca664bddcc722baf239f5ef7844baadb95f522b3c293732e84130d697b9bc6"
    sha256 cellar: :any, arm64_monterey: "bcced76de307fbb5b97b51656854e86d22eeb0769b2fe09b5e2a05bdba67c717"
    sha256 cellar: :any, tahoe: "732276d71a62124261b4cf1782400bbbda1ab7b515b9e1cdb8466b6d9a440bba"
    sha256 cellar: :any, sequoia: "f0f681a41b26965a864d5b86e7828e365b1e39c17055c09fd633b7bcd1bb7a93"
    sha256 cellar: :any, sonoma: "732922efcd5ee77ddf9d8d4efcb1d493fe4053a155685140935b2b67ddab105c"
    sha256 cellar: :any, ventura: "81bde15c36c31ccb43acce87f288b8fde51c611f781f4c851c2adc149cd71715"
    sha256 cellar: :any, monterey: "76f9a9050c4eb83063d971eaa0908566e2cfdee7b4f6402f2e9280f9c9c8b4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1fbc6121de3c71b75765b12c3b846fdccffe9d1a64e00ce6d6fa4fe0879734b9"
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
