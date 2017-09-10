class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      :tag => "v0.7.2",
      :revision => "b40e7e22a2baf91924cdc8eec1a34892c30585d2"
  head "https://github.com/hashicorp/envconsul.git"
  
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = arch
    dir = buildpath/"src/github.com/hashicorp/envconsul"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      project = "github.com/hashicorp/envconsul"
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp
      ldflags = "-X #{project}/version.Name=envconsul " \
                "-X #{project}/version.GitCommit=#{commit}"
      system "go", "build", "-o", bin/"envconsul", "-ldflags",
             ldflags.to_s
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/envconsul", "-log-level", "info", "-consul-addr", "demo.consul.io",
           "-prefix", "redis/config", "-exec", "ruby -e 'puts \"envconsul\"'"
  end
end
