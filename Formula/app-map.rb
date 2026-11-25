class AppMap < Formula
  desc "Clickable UML map of a mobile app's code, kept current by your AI coding agent"
  homepage "https://github.com/yonivav/app-map"
  url "https://github.com/yonivav/app-map/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "526cb3c6646cdb2d1fc42ba08c1725e83950cad8122247e81c3544834a243547"
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
