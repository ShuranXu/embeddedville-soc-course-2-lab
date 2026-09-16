# EmbeddedVille SoC Course 2 lab workspace

This public template contains three separate simulator sessions for EmbeddedVille SoC Course 2. It contains independently written instructions, starter RTL, an open testbench, and evidence packaging tools. It does not contain source-course slides, extracted images, copied diagrams, solutions, hidden tests, credentials, or staff instructions.

## Launch in your own GitHub account

Use **Open in a codespace** from this template, or use the direct launch button on the matching EmbeddedVille lab page. GitHub creates an unpublished Codespace in the account you are signed in with, so no template-access request or administrator approval is required.

The Codespace pulls a verified, digest-pinned toolchain image instead of compiling Verilator and downloading every tool during startup. A fresh session may still spend a short time pulling the image and installing the editor extensions. If the lower-left status remains on **Opening Remote**, select the **Building codespace** notification to inspect GitHub's creation log. An older Codespace created before this optimization keeps its original container until you preserve your work and rebuild or create a new session.

Your work is initially saved in the Codespace rather than in a GitHub repository. Before course submission, use the VS Code Source Control view to commit your changes and choose **Publish Branch**, then publish to a **private** repository in your own GitHub account. Register that private `owner/repository` on the matching EmbeddedVille lab page.

## Start a session

Run exactly one activity at a time:

```sh
./lab test --scenario ahb-transfer
./lab test --scenario vga-framebuffer
./lab test --scenario uart-loopback
```

The starter is intentionally incomplete. Read [docs/activities.md](docs/activities.md), edit `rtl/course2_soc.sv`, and rerun the matching command. Verilator is the execution authority for all three activities. The framebuffer activity also emits a real PPM frame; the UART activity emits a real serial log. GNU Arm and Renode are pinned in the development container for course-compatible firmware extensions, but neither is claimed as evidence for these three RTL activities.

After a passing run, commit and push your work, then package the matching evidence:

```sh
git add rtl/course2_soc.sv
git commit -m "Complete Course 2 activity"
git push
./lab package --scenario ahb-transfer
```

The ZIP manifest records the activity, starter version, private repository slug, branch/ref, commit SHA, tool versions, source digest, and test result. Upload that ZIP on the matching EmbeddedVille lab page. Staff acceptance is recorded separately; a local pass does not issue completion.

## Codespaces ownership and billing

The GitHub account that launches the Codespace supplies its quota and is the billing owner unless GitHub explicitly shows a sponsoring organization. Codespaces is not universally free. Closing the browser tab does not immediately stop compute. Stop the Codespace from GitHub when finished; a stopped Codespace can still consume storage. Commit and publish to a private repository before rebuild or deletion because deletion and retention expiry can remove unpushed work.

Useful commands:

```sh
./lab doctor
./lab serve
git status
```

`./lab serve` exposes the local evidence directory on private forwarded port 8000. Saving a file is not the same as committing it; committing is not the same as pushing it; stopping is not deletion; and rebuilding is not submission.

Use is governed by [LICENSE-COURSE-USE.md](LICENSE-COURSE-USE.md).
