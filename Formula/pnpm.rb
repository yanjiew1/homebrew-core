class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.1.6.tgz"
  sha256 "acc7eb2ae79b31d7e0af7511e87d5129a58ec3b65e6dbcb3c01b9928a2d67d28"

  bottle do
    cellar :any_skip_relocation
    sha256 "734306e3927b3c3cad8833a55462fe0644d3647a3080fbf14d71a2af0ca661dc" => :catalina
    sha256 "61a5fffde2dce6aefa678d51796de5cf0bad68437bb41037b594f357dd02f082" => :mojave
    sha256 "d74d061885b64635d177ae077e3ca4fe04b9ad74594596eaa6842d3224a91425" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
