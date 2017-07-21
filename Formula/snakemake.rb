class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.bitbucket.io/"
  url "https://files.pythonhosted.org/packages/source/s/snakemake/snakemake-3.13.3.tar.gz"
  sha256 "ad5c2544adfb25704b85b0bec46fbf1d904586969cb03ff9d414924c485a3dda"
  revision 1

  head "https://bitbucket.org/snakemake/snakemake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad532e40982efc14cde6c84149faef58ef42b94f69a73d988e0c121c082f5eb4" => :sierra
    sha256 "c38f907d7da1155f37a391c9216b07ee8617f5082e832b6841e8a8815c96b9ad" => :el_capitan
    sha256 "eec67e92f4d5f808c13e149e7f24e94de8b86e46c8e83c1a71407b1f5a565c03" => :yosemite
  end

  depends_on :python3

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/source/c/certifi/certifi-2017.4.17.tar.gz"
    sha256 "f7527ebf7461582ce95f7a9e03dd141ce810d40590834f4ec20cddd54234c10a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/source/c/chardet/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/source/i/idna/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/source/r/requests/requests-2.18.1.tar.gz"
    sha256 "c6f3bdf4a4323ac7b45d01e04a6f6c20e32a052cd04de81e05103abc049ad9b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/source/u/urllib3/urllib3-1.21.1.tar.gz"
    sha256 "b14486978518ca0901a76ba973d7821047409d7f726f22156b24e83fd71382a5"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/source/w/wrapt/wrapt-1.10.10.tar.gz"
    sha256 "42160c91b77f1bc64a955890038e02f2f72986c01d462d53cb6cb039b995cdd9"
  end

  def install
  virtualenv_create(libexec, "python3")
  virtualenv_install_with_resources
  end

  test do
    (testpath/"Snakefile").write <<-EOS.undent
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    system "#{bin}/snakemake"
  end
end
