class AppMap < Formula
  desc "Clickable UML map of a mobile app's code, kept current by your AI coding agent"
  homepage "https://github.com/yonivav/app-map"
  url "https://github.com/yonivav/app-map/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "35fb8f2af23c53271a87433d1f3373eb6af80960cfc066ebd507e6b2bc9d9a64"
  license "MIT"
  head "https://github.com/yonivav/app-map.git", branch: "main"

  depends_on "python@3.13"

  def install
    libexec.install "install.sh", "skills", "LICENSE"
    # The installer copies or links the skill from where it sits; through opt_libexec the
    # links (`app-map install --link`) keep working after `brew upgrade`.
    (bin/"app-map").write <<~SH
      #!/bin/bash
      # app-map: `app-map install [...]` adds the skill to your agents; every other command
      # goes to the skill's own CLI (build, verify, changes, sync, shots, crop…).
      export PATH="#{formula_opt_libexec("python@3.13")}/bin:$PATH"
      if [ "${1:-}" = "install" ]; then
        shift
        exec "#{opt_libexec}/install.sh" "$@"
      fi
      exec "#{opt_libexec}/skills/app-map/scripts/app-map" "$@"
    SH
  end

  def caveats
    <<~EOS
      In your app's repo, add the skill for your AI coding agents:
        app-map install --auto
      Then ask your agent: "Build an app map of this repo".
    EOS
  end

  test do
    assert_match "app-map build", shell_output("#{bin}/app-map 2>&1", 2)
    system "git", "init", "-q", testpath/"app"
    system bin/"app-map", "install", "--repo", testpath/"app"
    assert_path_exists testpath/"app/.agents/skills/app-map/SKILL.md"
    assert_path_exists testpath/"app/.claude/skills/app-map"
  end
end
