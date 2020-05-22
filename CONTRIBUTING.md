# Contributing to RDS-R

We would love for you to contribute to RDS-R and help make it even better than it is
today! As a contributor, here are the guidelines we would like you to follow:

- [Code of Conduct](#coc)
- [Question or Problem?](#question)
- [Gitflow](#gitflow)
- [Issues and Bugs](#issue)
- [Feature Requests](#feature)
- [Submission Guidelines](#submit)
- [Coding Rules](#rules)

## <a name="coc"></a> Code of Conduct

Help us keep RDS-R open and inclusive. Please read and follow our [Code of Conduct][coc].

## <a name="question"></a> Got a Question or Problem?

Do not open issues for general support questions as we want to keep GitHub issues for bug reports and feature requests. You've got much better chances of getting your question answered through our [help desk](https://mtnaus.atlassian.net/servicedesk/customer/portal/8).

## <a name="gitflow"></a> Gitflow

This repository follows the [Gitflow](https://datasift.github.io/gitflow/IntroducingGitFlow.html) workflow. We believe this will make the rds-r package easier to use in through `devtools::install_github("mtna/rds-r")` as master should always be the latest stable released version.

The main branches to be aware of are:

- Master - The latest stable release of this library, once a number of new features have been added to develop they will be merged into master as the next stable release.
- Develop - Integration branch where new features are added. As a contributing developer any pull requests should be made from a feature branch into develop. 
- Feature - Each new feature should be added as a feature branch created from develop. Once these are tested a pull request to develop can be created. 
- Release - Branches that contain the a released version of the project. 

## <a name="issue"></a> Found a Bug?

If you find a bug in the source code, you can help us by
[submitting an issue](#submit-issue) to our [GitHub Repository][github]. Even better, you can
[submit a Pull Request](#submit-pr) with a fix.

## <a name="feature"></a> Missing a Feature?

You can _request_ a new feature by [submitting an issue](#submit-issue) to our GitHub
Repository. If you would like to _implement_ a new feature, please submit an issue with
a proposal for your work first, to be sure that we can use it.
Please consider what kind of change it is:

- For a **Major Feature**, first open an issue and outline your proposal so that it can be
  discussed. This will also allow us to better coordinate our efforts, prevent duplication of work,
  and help you to craft the change so that it is successfully accepted into the project.
- **Small Features** can be crafted in a feature branch and directly [submitted as a Pull Request](#submit-pr).

## <a name="submit"></a> Submission Guidelines

### <a name="submit-issue"></a> Submitting an Issue

Before you submit an issue, please search the issue tracker, maybe an issue for your problem already exists and the discussion might inform you of workarounds readily available.

We want to fix all the issues as soon as possible, but before fixing a bug we need to reproduce and confirm it. In order to reproduce bugs, we will systematically ask you to provide a minimal reproduction. Having a minimal reproducible scenario gives us a wealth of important information without going back & forth to you with additional questions.

A minimal reproduction allows us to quickly confirm a bug (or point out a coding problem) as well as confirm that we are fixing the right problem.

We will be insisting on a minimal reproduction scenario in order to save maintainers time and ultimately be able to fix more bugs. Interestingly, from our experience, users often find coding problems themselves while preparing a minimal reproduction. We understand that sometimes it might be hard to extract essential bits of code from a larger codebase but we really need to isolate the problem before we can fix it.

Unfortunately, we are not able to investigate / fix bugs without a minimal reproduction, so if we don't hear back from you, we are going to close an issue that doesn't have enough info to be reproduced.

### <a name="submit-pr"></a> Submitting a Pull Request (PR)

Before you submit your Pull Request (PR) consider the following guidelines:

1. Search [GitHub](https://github.com/mtna/rds-r/pulls) for an open or closed PR
   that relates to your submission. You don't want to duplicate effort.
1. Be sure that an issue describes the problem you're fixing, or documents the design for the feature you'd like to add.
   Discussing the design up front helps to ensure that we're ready to accept your work.
1. Fork the mtna/rds-r repo.
1. Make your changes in a new feature branch:

   ```shell
   git checkout -b feature/my-new-feature develop
   ```

1. Write your code, **including appropriate test cases**.
1. Follow our [Coding Rules](#rules).
1. Commit your changes using a descriptive commit message.

   ```shell
   git commit -a
   ```

   Note: the optional commit `-a` command line option will automatically "add" and "rm" edited files.

1. Push your branch to GitHub:

   ```shell
   git push origin feature/my-new-feature
   ```

1. In GitHub, send a pull request to `rds-r:develop`.

- If we suggest changes then:

  - Make the required updates.
  - Rebase your branch and force push to your GitHub repository (this will update your Pull Request):

    ```shell
    git rebase develop -i
    git push -f
    ```

That's it! Thank you for your contribution!

#### After your pull request is merged

After your pull request is merged, you can safely delete your branch and pull the changes
from the main (upstream) repository:

- Delete the remote branch on GitHub either through the GitHub web UI or your local shell as follows:

  ```shell
  git push origin --delete feature/my-new-feature
  ```

- Check out the develop branch:

  ```shell
  git checkout develop -f
  ```

- Delete the local branch:

  ```shell
  git branch -D feature/my-new-feature
  ```

- Update your develop with the latest version:

  ```shell
  git pull --ff
  ```

## <a name="rules"></a> Coding Rules

To ensure consistency throughout the source code, keep these rules in mind as you are working:

- All branches **must be checked** in R (`devtools::check()`) and result in 0 errors, 0 warnings, and 0 notes.

[coc]: ./CODE_OF_CONDUCT.md
[github]: https://github.com/mtna/rds-r
