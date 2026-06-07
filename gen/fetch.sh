#!/usr/bin/env bash
set -euo pipefail

# Fetch the PINNED upstream Heroicons SVGs into gen/vendor/heroicons/.
#
# Heroicons ships four variants in the npm tarball, keyed by size + style:
#   package/24/outline/*.svg  → our `outline` variant (24×24, the default)
#   package/24/solid/*.svg    → our `solid`   variant (24×24)
#   package/20/solid/*.svg    → our `mini`    variant (20×20)
#   package/16/solid/*.svg    → our `micro`   variant (16×16)
# We rename the size-keyed dirs to the variant names the set exposes.
#
# Vendored upstream is fetched, never committed (see .gitignore) — only the
# generated .gleam shards + icons.json are committed. Re-run after bumping the
# pinned version below, then `cd gen && gleam run` to regenerate.

# ── Pinned upstream version ────────────────────────────────────────────────
HEROICONS_VERSION="2.2.0"
TARBALL_URL="https://registry.npmjs.org/heroicons/-/heroicons-${HEROICONS_VERSION}.tgz"

# Resolve paths relative to this script so it works from any cwd.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENDOR_DIR="${SCRIPT_DIR}/vendor/heroicons"
OUTLINE_DIR="${VENDOR_DIR}/outline"
SOLID_DIR="${VENDOR_DIR}/solid"
MINI_DIR="${VENDOR_DIR}/mini"
MICRO_DIR="${VENDOR_DIR}/micro"

echo "Fetching heroicons v${HEROICONS_VERSION}"
echo "  ${TARBALL_URL}"

# Idempotent: wipe the vendor dir so a re-run gives a clean snapshot.
rm -rf "${VENDOR_DIR}"
mkdir -p "${OUTLINE_DIR}" "${SOLID_DIR}" "${MINI_DIR}" "${MICRO_DIR}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

TARBALL="${TMP_DIR}/heroicons.tgz"
curl -fsSL "${TARBALL_URL}" -o "${TARBALL}"

# Extract each size/style dir, stripping the package/<size>/<style>/ prefix
# (--strip-components=3) so files land flat in the variant dir. The pattern is
# matched natively by both GNU tar and BSD tar (macOS), so no --wildcards flag
# (BSD tar rejects it).
tar -xzf "${TARBALL}" -C "${OUTLINE_DIR}" --strip-components=3 'package/24/outline/*.svg'
tar -xzf "${TARBALL}" -C "${SOLID_DIR}"   --strip-components=3 'package/24/solid/*.svg'
tar -xzf "${TARBALL}" -C "${MINI_DIR}"    --strip-components=3 'package/20/solid/*.svg'
tar -xzf "${TARBALL}" -C "${MICRO_DIR}"   --strip-components=3 'package/16/solid/*.svg'

OUTLINE_COUNT="$(find "${OUTLINE_DIR}" -name '*.svg' | wc -l | tr -d ' ')"
SOLID_COUNT="$(find "${SOLID_DIR}" -name '*.svg' | wc -l | tr -d ' ')"
MINI_COUNT="$(find "${MINI_DIR}" -name '*.svg' | wc -l | tr -d ' ')"
MICRO_COUNT="$(find "${MICRO_DIR}" -name '*.svg' | wc -l | tr -d ' ')"
echo "Extracted ${OUTLINE_COUNT} outline + ${SOLID_COUNT} solid + ${MINI_COUNT} mini + ${MICRO_COUNT} micro SVGs into ${VENDOR_DIR}"
