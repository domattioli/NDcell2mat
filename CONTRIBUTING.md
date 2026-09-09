# Contributing to NDcell2mat

`NDcell2mat` converts a ragged cell array of numeric contents into one dense, padded matrix. It does not, and will not, handle non-numeric cell contents, nested cells, or an algorithmic redesign of how the output dimension is chosen; a change to that scope belongs in a new issue, discussed before a pull request, not inside one.

## Before opening a pull request

1. Run the test suite: `runtests( 'tests' )` from the repository root. All cases must pass.
2. Any change to the filler-value contract, the output-shape rule, or an error/warning path must update the function's docstring in the same commit. The docstring is the canonical statement of that contract; the README quotes it rather than restating it separately, so a docstring change without a matching README update leaves the two out of sync.
3. State the minimum MATLAB release your change requires, if it raises the current floor (checked by CI against the release matrix in `.github/workflows/ci.yml`).

## Reporting a defect

Two defects are known and tracked rather than silently accepted: an empty cell array (`C = {}`) currently errors, and a non-double numeric filler value forces an integer-typed, saturating output. A report that reproduces either is useful; a fix for either is a separate, scoped pull request, not a side effect of an unrelated change.

## License

Contributions are accepted under the repository's BSD-3-Clause license (see [`LICENSE`](LICENSE)). By submitting a pull request, you agree your contribution is licensed under those terms.
