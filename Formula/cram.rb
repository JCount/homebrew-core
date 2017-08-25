class Cram < Formula
  include Language::Python::Virtualenv

  desc "A simple testing framework for command line applications"
  homepage "https://bitheap.org/cram/"
  url "https://files.pythonhosted.org/packages/38/85/5a8a3397b2ccb2ffa3ba871f76a4d72c16531e43d0e58fc89a0f2983adbd/cram-0.7.tar.gz"
  sha256 "7da7445af2ce15b90aad5ec4792f857cef5786d71f14377e9eb994d8b8337f2f"

  depends_on :python

  resource "check-manifest" do
    url "https://files.pythonhosted.org/packages/10/f2/7f397f3f7d088b0720dc3e19cf5bde15baa489c9054a0d09793ededd2c07/check-manifest-0.35.tar.gz"
    sha256 "f9b7a3a6071f1991009bfa760f903b6d31f7b852a35d76a1cbbbcd1b22c9f44a"
  end

  resource "coverage" do
    url "https://files.pythonhosted.org/packages/36/db/690ee79312bb60f121c0da1c973856ddb751afe09cc10caec1452208eaf4/coverage-4.4.1.tar.gz"
    sha256 "7a9c44400ee0f3b4546066e0710e1250fd75831adc02ab99dda176ad8726f424"
  end

  resource "pep8" do
    url "https://files.pythonhosted.org/packages/3e/b5/1f717b85fbf5d43d81e3c603a7a2f64c9f1dabc69a1e7745bd394cc06404/pep8-1.7.0.tar.gz"
    sha256 "a113d5f5ad7a7abacef9df5ec3f2af23a20a28005921577b15dd584d099d5900"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/26/85/f6a315cd3c1aa597fb3a04cc7d7dbea5b3cc66ea6bd13dfa0478bf4876e6/pyflakes-1.6.0.tar.gz"
    sha256 "8d616a382f243dbf19b54743f280b80198be0bca3a5396f1d2e1fca6223e8805"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    false
  end
end
