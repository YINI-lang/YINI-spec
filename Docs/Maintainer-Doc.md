# Maintainer Doc/Guide
Checklist and the release process for maintainer(s) of this repository.

## Release Process
Making a release into the branch `production`.

(Note: Some external websites might link directly to files in this branch `production`.)

1. **Merge develop into staging:** The env `develop` into `staging` (as staging as the base).
   - Hint/Note: Create a new branch (e.g. `mergein/develop-into-staging-20250520`) on staging.
  
2. **staging: Update with bumped version strings in staging:** Update and patch all version strings (e.g. from `v1.0.0 Beta 4 + Updates`) in all files, bumped to the correct and final version strings (e.g. to `v1.0.0 Beta 5`, note: leave out the part `+ Updates`).  
   - **2.A. First make sure everything on staging is up to date:**  
     - Update the version string in all files.
     - In spec doc, check that Changes is correct.
     - Check that CHANGELOG.md is up to date.
     - Do any commits directly on staging. 
   - **2.B. Then generate the new PDF:**  
     - In the terminal, go to the dir `Utils/Make-PDF-of-Spec/`
     - Then run: `npm i`
     - Then run: `npm start` to make the actual PDF
     - Then check the PDF is up-to-date with correct version string, etc
  
3. **When staging is OK, merge into production:** When staging is OK with correct string versions. Merge the env `staging` into `production` (as production as the base).
   - Note: There shall not be any commits needed in env production, they should be made in staging already.
  
4. **Create a New Release In GitHub:** In GitHub, create a new **Production**.
   - Create new tag to the new version string above: E.g. `v1.0.0-beta.4`.
   - Give a title in the form: `YINI Specification-v1.0.0 Beta 4`.
   - Fill rest of field, and then press Publish.

### Backmerge

1. **Backmerge staging into develop:** The env `staging` into `develop` (as develop as the base).
2. **Patch/mark verstring for new cycle:** Now on develop, patch all version strings (except in Changes and in CHANGELOG.md) with ` + Updates` after each verstring.
   - E.g. `v1.0.0 Beta 4` to `v1.0.0 Beta 4 + Updates`.

---

**^YINI ≡**  
> A simple, structured, and human-friendly configuration format.  

[yini-lang.org](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=doc_footer) · [YINI on GitHub](https://github.com/YINI-lang)  
