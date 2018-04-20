`class Maude < Formula
  desc "reflective language for equational and rewriting logic specification"
  homepage "http://maude.cs.illinois.edu"
  url "http://maude.cs.uiuc.edu/download/current/Maude-2.6.tar.gz"
  sha256 "a5ba79bf3d30565c874e80b3531b51a7e835b600e86cac82508a6eb9e15f4aa0"
  revision 1

  keg_only :versioned_formula

  depends_on "gmp"
  depends_on "libbuddy"
  depends_on "libsigsegv"
  depends_on "libtecla"
  depends_on "flex" unless OS.mac?
  depends_on "bison" unless OS.mac?

  fails_with :clang do
    cause "Depends on rope/ext which is so old clang won't support it"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--without-cvc4",
			  "CC=gcc-7",
			  "CXX=g++-7"
    system "make"
    (bin/"maude").write_env_script libexec/"bin/maude", :MAUDE_LIB => libexec/"share"
  end

  test do
    input = <<~EOS
      set show stats off .
      set show timing off .
      set show command off .
      reduce in STRING : "hello" + " " + "world" .
    EOS
    expect = %Q(Maude> result String: "hello world"\nMaude> Bye.\n)
    output = pipe_output("#{bin/"maude"} -no-banner", input)
    assert_equal expect, output
  end
end
