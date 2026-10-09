# FitSync — Team Workflow

## Branches
- **main**: stable, integrated, demo-ready code.
- **feature/backend-db**: Member 1's working branch.
- **feature/frontend-ui**: Member 2's working branch.
- **feature/wellness-ai**: Member 3's working branch.

## Rules
1. Never commit directly to `main`.
2. Pull the latest `main` before starting new work.
3. Commit only files related to your assigned task.
4. Push your branch and open a pull request.
5. At least one teammate reviews each pull request.
6. Resolve merge conflicts with the relevant file owner.
7. Never commit API keys, `.env` files, or real user secrets.
8. Agree on shared types and API contracts before connecting features.
9. Test changes locally before requesting a merge.
10. Merge only working, reviewed changes into `main`.
