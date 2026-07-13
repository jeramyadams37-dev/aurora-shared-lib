# Changelog

## 1.0.0 — 2026-07-13
### Added
- `gemini/geminiClient.js` — shared, tested Gemini API wrapper (fixes no-content payload bug)
- `.github/workflows/android.yml` — standardized Capacitor + Gradle CI template (fixes stale asset bug)
- `secrets/secrets_loader.py` — secrets loader with panic-stop protection (fixes hardcoded key exposure)
- `build-scripts/build_apk.sh` — Termux-native Android build pipeline (standardizes AIScreenReader's manual process)
- `install.sh` — one-command installer to pull any module into any project
- `manifest.json` — version tracking across all modules and consuming projects
