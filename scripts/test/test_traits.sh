#!/usr/bin/env bash
set -euo pipefail

# Small test harness for traits.sh
# Creates a temporary hosts file and a fake `hostname` binary so traits.sh
# initializes against a predictable host.

tmpd=$(mktemp -d)
cleanup() { rm -rf "$tmpd"; }
trap cleanup EXIT

# Fake hostname binary that returns the name used in our test hosts
cat > "$tmpd/hostname" <<'EOF'
#!/usr/bin/env bash
# Always return the short hostname 'testnode' used in the test hosts file
echo testnode
EOF
chmod +x "$tmpd/hostname"

# Test hosts mapping
cat > "$tmpd/hosts.sh" <<'EOF'
#!/usr/bin/env bash
declare -A HOSTS
HOSTS["testnode"]='private client internal'
HOSTS["othernode"]='server external'
EOF

# Point the library at our test hosts file and ensure our fake hostname is used
export HOSTS_FILE="$tmpd/hosts.sh"
export PATH="$tmpd:$PATH"
export VERBOSE=0

# Source the library under test
# shellcheck disable=SC1090
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../lib/traits.sh"

fail_count=0

assert_pass() {
  set +e
  "$@"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]]; then
    echo "FAIL: expected pass: $*"
    fail_count=$((fail_count+1))
  fi
}

assert_fail() {
  set +e
  "$@"
  rc=$?
  set -e
  if [[ $rc -eq 0 ]]; then
    echo "FAIL: expected fail: $*"
    fail_count=$((fail_count+1))
  fi
}

# Basic has_trait checks
assert_pass has_trait private
assert_pass has_trait client
assert_fail has_trait missingtrait

# has_all_traits
assert_pass has_all_traits private client
assert_fail has_all_traits private missingtrait

# has_any_trait
assert_pass has_any_trait private missingtrait
assert_fail has_any_trait missing1 missing2

# require_all_traits should fail and print message when requirement not met
set +e
out=$(require_all_traits "private missingtrait" "need both" 2>&1)
rc=$?
set -e
if [[ $rc -eq 0 ]]; then
  echo "FAIL: require_all_traits unexpectedly succeeded"
  fail_count=$((fail_count+1))
fi
if [[ "$out" != *"need both"* ]]; then
  echo "FAIL: require_all_traits did not print expected message"
  echo "  got: $out"
  fail_count=$((fail_count+1))
fi

# require_any_trait should succeed when at least one trait present
set +e
out=$(require_any_trait "missing1 client" "should not show" 2>&1)
rc=$?
set -e
if [[ $rc -ne 0 ]]; then
  echo "FAIL: require_any_trait unexpectedly failed"
  fail_count=$((fail_count+1))
fi
if [[ -n "$out" ]]; then
  echo "FAIL: require_any_trait printed output when it should not: $out"
  fail_count=$((fail_count+1))
fi

# Print result
if [[ $fail_count -ne 0 ]]; then
  echo "$fail_count tests failed"
  exit 1
else
  echo "All tests passed"
  exit 0
fi
