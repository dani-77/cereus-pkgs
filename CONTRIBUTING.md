# Contributing to cereus-pkgs

cereus-pkgs is the backbone of the Cereus Linux distribution. It contains all the definitions to build packages from source.

This document describes how you, as a contributor, can help with adding packages, correcting bugs and adding features to cereus-pkgs.

## Package Requirements

To be included in the Cereus repository, software must meet at least one of the following requirements.
Exceptions to the list are possible, and might be accepted, but are extremely unlikely.
If you believe you have an exception, start a PR and make an argument for why that particular piece of software,
while not meeting any of the following requirements, is a good candidate for the Cereus packages system.

1. **System**: The software should be installed system-wide, not per-user.

1. **Compiled**: The software needs to be compiled before being used, even if it is software that is not needed by the whole system.

1. **Required**: Another package either within the repository or pending inclusion requires the package.

In particular, new themes with too many variants are unlikely to be accepted.
Simple shell scripts are unlikely to be accepted unless they provide considerable value to a broad user base.
Packages related to cryptocurrencies (wallets, miners, nodes, etc) are not accepted.

Complex or heavy to build packages (like Chromium or Firefox based browsers) are preferred to use precompiled binaries. This also applies for Electron-based packages since some depend in a Electron version that is not available in Void repository (and it is unlikely that we maintain newer versions). Otherwise, it is likely it won't be accepted. However, if you're willing to take care of it, chances it get accepted will be higher. 

An external template or binary repository may be added, as submodule in this repository or as a drop-in repository file(see [ungoogled-chromium-repo](https://codeberg.org/cereus-linux/cereus-pkgs/src/branch/master/srcpkgs/ungoogled-chromium-repo/template)) respectively, after proper review.

Preferrably and when available, use software in their stable releases. Betas, templates using tip of development branch and releases created by the package maintainer may be accepted if the package is not available in a stable release or it does provides a considerable value that is not available on stable releases.

For obvious reasons, packages already available in Void repository are highly unlikely to be accepted unless it needs to be adapted for Cereus or there's a patch or fork that provides functionality not present in the Void package. A good example for this is `grub-cereus`: it was patched so Cereus have control over its default configuration and patches from `grub-btrfs` were added.

## Creating, updating, and modifying packages in Cereus by yourself

If you really want to get a new package or package update into Cereus Linux, we recommend you contribute it yourself.

We provide a [comprehensive Manual](./Manual.md) on how to create new packages.
There's also a [manual for xbps-src](./README.md), which is used to build package files from templates.

For this guide, we assume you have basic knowledge about [git](http://git-scm.org), as well as a [Codeberg Account](http://codeberg.org) with [SSH set up](https://docs.codeberg.org/security/ssh-key/).

You should also [set the email](https://docs.codeberg.org/git/configuring-git/) on your Codeberg account and in git so your commits are associated with your Codeberg account properly.

To get started, [fork](https://docs.codeberg.org/collaborating/pull-requests-and-git-flow/) the `cereus-pkgs` git repository on GitHub and clone it:

    $ git clone git@codeberg.org:cereus-linux/cereus-pkgs.git
To keep your forked repository up to date, setup the `upstream` remote to pull in new changes:

    $ git remote add upstream https://codeberg.org/cereus-linux/cereus-pkgs.git
    $ git pull --rebase upstream master

This can also be done with the [*codeberg-cli*](https://codeberg.org/Aviac/codeberg-cli) tool:

    $ berg repo fork cereus-linux/cereus-pkgs

This automatically sets up the `upstream` remote, so `git pull --rebase upstream master` can still be used to keep your fork up-to-date.

Using the Codeberg web editor for making changes is strongly discouraged, because you will need to clone the repo anyways to edit and test your changes.

Using the `master` branch of your fork for contributing is also strongly discouraged.
It can cause many issues with updating your pull request (also called a PR), and having multiple PRs open at once.
To create a new branch:

    $ git checkout master -b <a-descriptive-name>

### Creating a new template

You can use the helper tool `xnew`, from the [xtools](https://github.com/leahneukirchen/xtools) package, to create new templates:

    $ xnew pkgname subpkg1 subpkg2 ...

Templates must have the name `cereus-pkgs/srcpkgs/<pkgname>/template`, where `pkgname` is the same as the `pkgname` variable in the template.

For deeper insights on the contents of template files, please read the [manual](./Manual.md), and be sure to browse the existing template files in the `srcpkgs` directory of this repository for concrete examples.

### Updating a template

At minimum, a template update will consist of changing `version` and `checksum`, if there was an upstream version change, and/or `revision`, if a template-specific change (e.g. patch, correction, etc.) is needed.
Other changes to the template may be needed depending on what changes the upstream has made.

The checksum can be updated automatically with the `xgensum` helper from the [xtools](https://github.com/leahneukirchen/xtools) package:

    $ xgensum -i <pkgname>

### Adopting a template

If a template is orphaned or the current `maintainer` has not contributed to
Cereus in a long time, template maintainership can be adopted by someone else. To ensure a template gets the care it needs,
template adopters should be familiar with the package and have an established history of contributions to Void.
Those who have contributed several updates, especially for the template in question, are good candidates for template
maintainership.

It is best to adopt a template when making another change to it. When adopting the template, add your name or username
and email to the `maintainer` field in the template, and mention the adoption in your commit message, for example:

    libfoo: update to 1.2.3, adopt.

### Orphaning a template

If you no longer wish to maintain a template, you can remove yourself as maintainer by setting the `maintainer` field in
the template to `Orphaned <orphan@voidlinux.org>`. The commit message should mention this, for example:

    libfoo: orphan.

It is not necessary to make other changes to the template when orphaning, and incrementing the revision (triggering a
rebuild) is not necessary either.

### Committing your changes

After making your changes, please check that the package builds successfully. From the top level directory of your local copy of the `cereus-pkgs` repository, run:

    $ ./xbps-src pkg <pkgname>

Your package should build successfully for at least `x86_64`, unless it is specific to either `x86_64-musl` or `i686` (like `musl-locales`)

When building for `x86_64*` or `i686`, building with the `-Q` flag or with `XBPS_CHECK_PKGS=yes` set in `etc/conf` (to run the check phase) is strongly encouraged.
Also, new packages and updates will not be accepted unless they have been runtime tested by installing and running the package.

When you've finished working on the template file, please check it with `xlint` helper from the [xtools](https://github.com/leahneukirchen/xtools) package:

    $ xlint template

If `xlint` reports any issues, resolve them before committing.

Once you have made and verified your changes to the package template and/or other files, make one commit per package (including all changes to its sub-packages). Each commit message should have one of the following formats:

* for new packages, use `New package: <pkgname>-<version>` ([example](https://github.com/void-linux/void-packages/commit/8ed8d41c40bf6a82cf006c7e207e05942c15bff8)).

* for package updates, use `<pkgname>: update to <version>.` ([example](https://github.com/void-linux/void-packages/commit/c92203f1d6f33026ae89f3e4c1012fb6450bbac1)).

* for template modifications without a version change, use `<pkgname>: <reason>` ([example](https://github.com/void-linux/void-packages/commit/ff39c912d412717d17232de9564f659b037e95b5)).

* for package removals, use `<pkgname>: remove package` and include the removal reason in the commit body ([example](https://github.com/void-linux/void-packages/commit/4322f923bdf5d4e0eb36738d4f4717d72d0a0ca4)).

* for changes to any other file, use `<filename>: <reason>` ([example](https://github.com/void-linux/void-packages/commit/e00bea014c36a70d60acfa1758514b0c7cb0627d),
  [example](https://github.com/void-linux/void-packages/commit/93bf159ce10d8e474da5296e5bc98350d00c6c82), [example](https://github.com/void-linux/void-packages/commit/dc62938c67b66a7ff295eab541dc37b92fb9fb78), [example](https://github.com/void-linux/void-packages/commit/e52317e939d41090562cf8f8131a68772245bdde))

If you want to describe your changes in more detail, explain in the commit body (separated from the first line with a blank line) ([example](https://github.com/void-linux/void-packages/commit/f1c45a502086ba1952f23ace9084a870ce437bc6)).

`xbump`, available in the [xtools](https://github.com/leahneukirchen/xtools) package, can be used to commit a new or updated package:

    $ xbump <pkgname> <git commit options>

`xrevbump`, also available in the [xtools](https://github.com/leahneukirchen/xtools) package, can be used to commit a template modification for a package:

    $ xrevbump '<message>' <pkgnames...>

`xbump` and `xrevbump` will use `git commit` to commit the changes with the appropriate commit message. For more fine-grained control over the commit, specific options can be passed to `git commit` by adding them after the package name.

### Starting a pull request

Once you have successfully built the package, you can [create a pull request](https://docs.codeberg.org/collaborating/pull-requests-and-git-flow/). Pull requests are also known as PRs.

Most pull requests should only contain a single package and dependencies which are not part of cereus-pkgs yet.

If you make updates to packages containing a soname bump, you also need to update `common/shlibs` and revbump all packages that are dependant.
There should be a commit for each package revbump, and those commits should be part of the same pull request.

When you make changes to your pull request, please *do not close and reopen your pull request*. Instead, just [forcibly git push](#review), overwriting any old commits. Closing and opening your pull requests repeatedly spams the Cereus maintainers

#### Review

It's possible (and common) that a pull request will contain mistakes or reviewers will ask for additional tweaks.
Reviewers will comment on your pull request and point out which changes are needed before the pull request can be merged.

Most PRs will have a single commit, as seen [above](#committing-your-changes), so if you need to make changes to the commit and already have a pull request open, you can use the following commands:

    $ git add <file>
    $ git commit --amend
    $ git push -f

A more powerful way of modifying commits than using `git commit --amend` is with [git-rebase](https://git-scm.com/docs/git-rebase#_interactive_mode), which allows you to join, reorder, change description of past commits and more.

Alternatively, if there are issues with your git history, you can make another branch and push it to the existing PR:

    $ git checkout master -b <attempt2>
    $ # do changes anew
    $ git push -f <fork> <attempt2>:<branch-of-pr>

#### Closing the pull request

Once you have applied all requested changes, the reviewers will merge your request.

If the pull request becomes inactive for some days, the reviewers may or may not warn you when they are about to close it.
If it stays inactive further, it will be closed.

Please abstain from temporarily closing a pull request while revising the templates. Instead, leave a comment on the PR describing what still needs work, mark it as a draft, or add "[WIP]" to the PR title. Only close your pull request if you're sure you don't want your changes to be included.

#### Publishing the package

Since, unlike Void, we lack a build server, once the reviewers have merged the pull request, our binary repository maintainers will locally build all packages in the pull request for all supported architechtures, sign them and submit to all our mirrors. Upon completion, the packages are available to all Cereus Linux users.

## Testing Pull Requests

While it is the responsibility of the PR creator to test changes before sending it, one person can't test all configuration options, usecases, hardware, etc.
Testing new package submissions and updates is always helpful, and is a great way to get started with contributing.
First, [clone the repository](https://codeberg.org/cereus-linux/cereus-pkgs#quick-start) if you haven't done so already.
Then check out the pull request:

If your local cereus-pkgs repository is cloned from your fork, you may need to add the main repository as a remote first:

    $ git remote add upstream https://codeberg.org/cereus-linux/cereus-pkgs.git

Then fetch and check out the PR (replacing `<remote>` with either `origin` or `upstream`):

    $ git fetch <remote> pull/<number>/head:<branch-name>
    $ git checkout <branch-name>

Then [build and install](https://codeberg.org/cereus-linux/cereus-pkgs#building-packages) the package and test its functionality.
