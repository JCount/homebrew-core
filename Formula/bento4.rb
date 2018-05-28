class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.1-624.tar.gz"
  version "1.5.1-624"
  sha256 "eda725298e77df83e51793508a3a2640eabdfda1abc8aa841eca69983de83a4c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f68030a7f490546abf0f4f273ecb1e7572d3c7a6995cb20eb0325a3732b64fef" => :high_sierra
    sha256 "6fee15aab3d28b64d2894663363ca65911a557ed7678f11d2852e08a9ac51546" => :sierra
    sha256 "4950c6055e84b7e09524c954cfb2a55f0c493d82dca6994fb3f0bdfb21fab1d0" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :xcode => :build

  conflicts_with "gpac", :because => "both install `mp42ts` binaries"

  def install
    mkdir "build_dir" do
      system "cmake", "-G", "Xcode", "..", *std_cmake_args
      xcodebuild "-target", "ALL_BUILD", "-configuration", "Release"
      bin.install Dir["Release/*"].select { |f| File.executable?(f) }
    end
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
