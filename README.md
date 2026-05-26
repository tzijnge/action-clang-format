# action-clang-format

[![Test](https://github.com/tzijnge/action-clang-format/workflows/Test/badge.svg)](https://github.com/tzijnge/action-clang-format/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/tzijnge/action-clang-format/workflows/reviewdog/badge.svg)](https://github.com/tzijnge/action-clang-format/actions?query=workflow%3Areviewdog)
[![release](https://github.com/tzijnge/action-clang-format/workflows/release/badge.svg)](https://github.com/tzijnge/action-clang-format/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tzijnge/action-clang-format?logo=github&sort=semver)](https://github.com/tzijnge/action-clang-format/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

Run [clang-format](https://clang.llvm.org/docs/ClangFormat.html) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience.

## Prerequisites

A `.clang-format` configuration file must exist in the root of your repository. clang-format uses this file to determine the desired formatting style.

Example `.clang-format`:

```yaml
BasedOnStyle: Google
```

## Inputs

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  workdir:
    description: 'Working directory relative to the root directory.'
    default: '.'
  level:
    description: 'Report level for reviewdog [info,warning,error]'
    default: 'error'
  reporter:
    description: 'Reporter of reviewdog command [github-pr-check,github-check,github-pr-review].'
    default: 'github-pr-check'
  filter_mode:
    description: |
      Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
      Default is nofilter.
    default: 'nofilter'
  fail_level:
    description: |
      If set to `none`, always use exit code 0 for reviewdog. Otherwise, exit code 1 for reviewdog if it finds at least 1 issue with severity greater than or equal to the given level.
      Possible values: [none,any,info,warning,error]
      Default is `none`.
    default: 'none'
  reviewdog_flags:
    description: 'Additional reviewdog flags'
    default: ''
  clang_format_version:
    description: 'Version of clang-format to install (e.g. 14, 15, 16, 17, 18). Leave empty to use the default version available on the runner.'
    default: ''
  extensions:
    description: 'Comma-separated list of file extensions to check (without leading dot).'
    default: 'c,cpp,cc,cxx,h,hpp,hh,hxx'
  exclude:
    description: 'Comma-separated list of files or directories to exclude from formatting checks.'
    default: ''
```

## Usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  clang-format:
    name: runner / clang-format
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: tzijnge/action-clang-format@master
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          level: error
```

To pin a specific clang-format version:

```yaml
      - uses: tzijnge/action-clang-format@master
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          clang_format_version: '18'
```

## Development

### Release

#### [haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)

You can bump version on merging Pull Requests with specific labels (bump:major, bump:minor, bump:patch).
Pushing a tag manually also works.

#### [haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)

This action updates major/minor release tags on a tag push. e.g. Update v1 and v1.2 tag when releasing v1.2.3.

### Lint - reviewdog integration

This action itself is integrated with reviewdog to run lints.

Supported linters:

- [reviewdog/action-shellcheck](https://github.com/reviewdog/action-shellcheck)
- [reviewdog/action-misspell](https://github.com/reviewdog/action-misspell)
