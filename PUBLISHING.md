- `git fetch`
- `git switch -c release/$VERSION origin/main`
- `npx elm bump`
- review `CHANGELOG.md`
- `npm run-script build-site`
- Stage the changes
- `git commit -m "Prepare $VERSION release"`
- `git push -u origin HEAD`
- Wait for CI, and approve the PR
- `git tag $VERSION`
- `git push origin $VERSION`
- `npx elm publish`
- `Merge the PR`
