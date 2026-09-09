# NDcell2mat License Audit

## Header Credit

Exact quote from NDcell2mat.m (lines 42-44):

```
%   Written by: Dominik Mattioli
%   Functionality revisions suggested by: Stephen Cobeldick
%   (https://www.mathworks.com/matlabcentral/profile/authors/3102170).
```

## Git History Findings

**Cobeldick-related commits identified:** 1

- **Commit:** `991d29d53ade50ac6aca48904013120060da7572`
  - **Date:** Tue Jan 23 10:39:34 2024 -0600
  - **Author:** Dominik Mattioli <35341510+domattioli@users.noreply.github.com>
  - **Subject:** Update NDcell2mat.m from old version
  - **Role:** This commit introduced the header credit line acknowledging Cobeldick's contribution as "Functionality revisions suggested by: Stephen Cobeldick". The commit was authored by Dominik Mattioli; Cobeldick is not a git committer/co-author.

**No co-authorship or authorship by Cobeldick** in any commits.

## License

GNU General Public License v2 (June 1991)

## Verdict: CLEAR

**Justification:** The NDcell2mat.m file properly credits Stephen Cobeldick for functionality revisions in the file header comments. The credit line explicitly attributes Cobeldick's contributions as "suggestions" rather than claiming full authorship. Git history shows all commits authored by Dominik Mattioli, with the credit line added in a single update commit that explicitly documents Cobeldick's role. The repository is licensed under GPLv2, which permits derivative works and modifications provided source is available and attribution is given — this requirement is satisfied. No rights conflicts or ambiguous attributions detected in the available repository data.

**Limitation:** This audit is based on the git repository history and file contents only. The MATLAB File Exchange (FEX) comment thread associated with the original submission is not accessible without a MATLAB/MathWorks login, so potential additional context or licensing discussions in those comments cannot be verified.
