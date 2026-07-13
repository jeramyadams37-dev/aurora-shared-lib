## Quick Install

```bash
curl -sL https://raw.githubusercontent.com/jeramyadams37-dev/aurora-shared-lib/main/install.sh | bash -s -- all
```

Or install specific modules only: `gemini`, `ci`, `secrets`, `build`

# Aurora Shared Lib

Centralized, tested components pulled out of Harmony, Legacy Keeper, Atothei, aixoverlay,
and AIScreenReader — built to stop re-fixing the same bugs across every AuroraOS project.

## Contents

- `gemini/geminiClient.js` — Shared Gemini API wrapper. Fixes the recurring "no-content"
  payload bug from Harmony and Legacy Keeper by validating and assembling content in one
  place before the request fires.

- `.github/workflows/android.yml` — Standardized Android CI template. Fixes the stale/empty
  asset bug from Harmony and aixoverlay by adding an explicit `npm run build` step before
  `npx cap sync` and `gradlew assembleDebug`.

- `secrets/secrets_loader.py` — Secure secrets loader with panic-stop protection. Fixes the
  hardcoded credential pattern from Atothei (Neon) and Legacy Keeper (Gemini). Loads from
  `.env`, refuses to start the app if required keys are missing.

- `build-scripts/build_apk.sh` — Standardized Termux-native Android build pipeline. Automates
  the proven `aapt2 -> javac -> d8 -> zipalign -> apksigner` sequence from AIScreenReader.

## Usage

Pull any module into a project with curl, e.g.:

```bash
curl -o src/lib/geminiClient.js https://raw.githubusercontent.com/jeramyadams37-dev/aurora-shared-lib/main/gemini/geminiClient.js
```

## Status

- [x] Gemini wrapper — extracted
- [x] Android CI template — extracted
- [x] Secrets loader — extracted
- [x] Termux native build script — extracted
- [ ] Refactor Harmony to use shared modules
- [ ] Refactor Legacy Keeper to use shared modules
- [ ] Refactor Atothei to use shared modules
