class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "8feaf56fc3f583a51a59afcab1676f4ccd39c1d16ece08d849f8dc5c1e5bff55"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a105317a3aa8b9453984bf87013c8e8cc209343f81d5d07865606732bf2d6fae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a105317a3aa8b9453984bf87013c8e8cc209343f81d5d07865606732bf2d6fae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a105317a3aa8b9453984bf87013c8e8cc209343f81d5d07865606732bf2d6fae"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d38adce07d5afe624d91765fcbe734806ec98ae6097da30bf10b658edafdc24"
    sha256 cellar: :any_skip_relocation, ventura:        "8d38adce07d5afe624d91765fcbe734806ec98ae6097da30bf10b658edafdc24"
    sha256 cellar: :any_skip_relocation, monterey:       "8d38adce07d5afe624d91765fcbe734806ec98ae6097da30bf10b658edafdc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e0eb0295ff9bb00f71c79fc208090d89f4a9b597c63425a879919ba7460570b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frps", "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
