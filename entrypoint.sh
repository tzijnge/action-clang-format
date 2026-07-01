#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
  git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

# Build regex pattern from comma-separated extensions
PATTERN="\.($(echo "${INPUT_EXTENSIONS}" | tr ',' '|' | tr -d ' '))$"

# Build exclusion arguments from comma-separated files and directories
EXCLUDE_ARGS=""
if [ -n "${INPUT_EXCLUDE}" ]; then
  for entry in $(echo "${INPUT_EXCLUDE}" | tr ',' ' '); do
    EXCLUDE_ARGS="${EXCLUDE_ARGS} -not -path '*/${entry}' -not -path '*/${entry}/*'"
  done
fi

CLANG_FORMAT_BIN="${CLANG_FORMAT_BINARY:-clang-format}"

# shellcheck disable=SC2086
find . -type f -regextype posix-extended -regex ".*${PATTERN}" ${EXCLUDE_ARGS} -print0 \
  | xargs -0 -r "$CLANG_FORMAT_BIN" -i -style=file

git diff | reviewdog -f=diff \
    -name="clang-format" \
    -reporter="${INPUT_REPORTER:-github-pr-check}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-level="${INPUT_FAIL_LEVEL}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS}
