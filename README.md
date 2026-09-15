# EmbeddedVille SoC Course 2 lab workspace

This private starter repository contains three separate simulator sessions for enrolled learners. It contains independently written instructions, starter RTL, an open testbench, and evidence packaging tools. It does not contain source-course slides, extracted images, copied diagrams, solutions, hidden tests, credentials, or staff instructions.

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

Create your private repository from the approved private template under your own GitHub account. Your account owns the repository, Codespace, compute use, storage use, quota, and billing. Closing the browser tab does not immediately stop the Codespace. Stop it from GitHub when finished. A stopped Codespace can still consume storage. Commit and push before rebuild or deletion; deletion and retention expiry can remove unpushed work.

Useful commands:

```sh
./lab doctor
./lab serve
git status
```

`./lab serve` exposes the local evidence directory on private forwarded port 8000. Saving a file is not the same as committing it; committing is not the same as pushing it; stopping is not deletion; and rebuilding is not submission.

Use is governed by [LICENSE-COURSE-USE.md](LICENSE-COURSE-USE.md).
