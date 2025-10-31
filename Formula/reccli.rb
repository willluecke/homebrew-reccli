class Reccli < Formula
  desc "Dead-simple terminal recorder with a floating button"
  homepage "https://github.com/willluecke/reccli"
  url "https://github.com/willluecke/reccli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "" # Will be filled in when you create the release
  license "MIT"
  version "1.0.0"

  depends_on "python@3.11"

  # Runtime Python dependencies
  resource "asciinema" do
    url "https://files.pythonhosted.org/packages/67/ca/91ca243836f650a8585c916c13c6e3dbc1ffe841924af0c3ae2d5fd9eacb/asciinema-2.4.0.tar.gz"
    sha256 "af4dad5adfff3e606c2cb5f7b0e9d4a25bc0c9c1c2c85d5ea4fbb56cb4c0fbf0"
  end

  def install
    # Install Python dependencies
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources

    # Install the main script and supporting files
    libexec.install "reccli.py"
    libexec.install "com.reccli.watcher.plist"
    libexec.install "requirements.txt"

    # Create wrapper script in bin
    (bin/"reccli").write_env_script(libexec/"reccli.py", PATH: "#{libexec}/bin:$PATH")

    # Create ~/.reccli directory
    (var/"reccli").mkpath
  end

  def post_install
    puts ""
    puts "🚀 RecCli installed successfully!"
    puts ""
    puts "To set up the auto-launch watcher:"
    puts "  1. Copy the LaunchAgent plist:"
    puts "     cp #{libexec}/com.reccli.watcher.plist ~/Library/LaunchAgents/"
    puts ""
    puts "  2. Edit the plist file to update paths:"
    puts "     - Replace /path/to/python3 with: #{HOMEBREW_PREFIX}/bin/python3.11"
    puts "     - Replace /path/to/reccli.py with: #{libexec}/reccli.py"
    puts ""
    puts "  3. Load the LaunchAgent:"
    puts "     launchctl load ~/Library/LaunchAgents/com.reccli.watcher.plist"
    puts ""
    puts "Or run manually:"
    puts "  reccli watch     - Start background watcher"
    puts "  reccli launch    - Launch popup for current terminals"
    puts "  reccli status    - View recording stats"
    puts "  reccli gui       - Single popup mode"
    puts ""
    puts "📂 Recordings will be saved to: ~/.reccli/recordings"
    puts ""
  end

  test do
    system "#{bin}/reccli", "--help"
  end
end
