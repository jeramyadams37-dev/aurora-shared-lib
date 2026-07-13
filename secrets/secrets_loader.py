"""
secrets_loader.py — Secure secrets loader with panic-stop protection.

Fixes the hardcoded-credential pattern seen in Atothei (Neon) and
Legacy Keeper (Gemini). Loads from a .env file, validates that all
required keys are present, and refuses to let the app start if any
critical key is missing.

Usage:
    from secrets_loader import load_secrets

    REQUIRED_KEYS = ["GEMINI_API_KEY", "NEON_DATABASE_URL"]
    secrets = load_secrets(REQUIRED_KEYS)

    gemini_key = secrets["GEMINI_API_KEY"]

Setup:
    pip install python-dotenv --break-system-packages
    Create a `.env` file (NEVER commit this — add it to .gitignore):
        GEMINI_API_KEY=your-key-here
        NEON_DATABASE_URL=your-url-here
"""

import os
import sys

try:
    from dotenv import load_dotenv
except ImportError:
    print("[secrets_loader] Missing dependency. Run: pip install python-dotenv --break-system-packages")
    sys.exit(1)


def load_secrets(required_keys, env_path=".env"):
    """
    Loads environment variables from .env and validates required_keys are present.
    Panic-stops (exits the process) if any required key is missing or empty.
    """
    if not os.path.exists(env_path):
        print(f"[secrets_loader] PANIC-STOP: no {env_path} file found. "
              f"Create one with your required keys before starting the app.")
        sys.exit(1)

    load_dotenv(env_path)

    secrets = {}
    missing = []

    for key in required_keys:
        value = os.environ.get(key)
        if not value or value.strip() == "":
            missing.append(key)
        else:
            secrets[key] = value

    if missing:
        print(f"[secrets_loader] PANIC-STOP: missing required secret(s): {', '.join(missing)}")
        print("[secrets_loader] App will not start until these are set in your .env file.")
        sys.exit(1)

    print(f"[secrets_loader] All {len(required_keys)} required secrets loaded successfully.")
    return secrets


if __name__ == "__main__":
    test_keys = ["GEMINI_API_KEY"]
    result = load_secrets(test_keys)
    print("Self-test passed:", list(result.keys()))
