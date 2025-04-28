# Maintainer Doc
Checklist for maintainer(s) of this repository.

## Making a Release

1. **Merge develop into staging:** The env `develop` into `staging` (as staging as the base).
2. **Update with bumbed verstrings in staging:** Update and patch all version strings (e.g. from `v1.0.0.0 Beta 4 + Updates`) in all files, bumbed to the correct and final version strings (e.g. from `v1.0.0.0 Beta 5`).
   - Update the version string in all files.
   - In spec doc, check that Changes is correct.
   - Check that CHANGELOG.md is up to date.
   - Do any commits directly on staging. 
3. **When staging is OK, merge into release:** When staging is OK with correct string versions. Merge the env `staging` into `release` (as release as the base).
   - Note: There shall not be any commits needed in env release, they should be made in staging already.
4. **Create a New Relase In GitHub:** In GitHub, create a new **Release**.
   - Create new tag to the new verson string above: E.g. `v1.0.0-beta.4`.
   - Give a title in the form: `YINI Specification-v1.0.0 Beta 4`.
   - Fill rest of field, and the press Publish.

### Backmerge

1. **Backmerge staging into develop:** The env `staging` into `develop` (as develop as the base).
2. **Patch/mark verstring for new cycle:** Now on develop, patch all version strings (except in Changes and in CHANGELOG.md) with ` + Updates` after each verstring.
