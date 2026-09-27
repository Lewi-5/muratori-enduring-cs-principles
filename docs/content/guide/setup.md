# Local setup

You have two separate jobs: display the course website and compile the C exercises. The website uses Node.js and VitePress. The exercises use the Linux toolchain specified by the course. Running the website successfully does not establish that your C environment is ready.

## Open a local checkout

Use the existing repository checkout, or clone it on your own machine. All paths in lessons are relative to its root. Keep your work in the `learner` folders; `instructor` contains reference answers.

For Windows, run the C commands in Ubuntu under WSL. Linux participants use their normal terminal. The reference target is x86-64 Linux with C11, GCC, Clang, make, Python 3, and GNU binutils. Native Windows compiler builds are not the exercise contract.

On Windows, a checkout inside the WSL Linux filesystem generally avoids the heavy filesystem overhead of repeatedly compiling through a OneDrive-backed `/mnt/c` directory. If you use a separate copy, name it clearly and remember which copy contains your edits. The website displays the checkout from which its development command runs.

## Prepare Ubuntu tools

In Ubuntu, install the course tools if they are missing:

```sh
sudo apt update
sudo apt install build-essential clang python3 binutils
```

These commands change the Ubuntu package installation and require administrative access. Normal exercise builds do not require `sudo`. Python orchestrates tests and fixtures; the substantial learner programs remain C.

Check the actual executables before proceeding:

```sh
uname -m
gcc --version
clang --version
make --version
python3 --version
nm --version
objdump --version
```

Record the versions in your notebook. `uname -m` should identify the course's x86-64 target. An ARM machine running a different environment may not satisfy the same ABI assumptions merely because a compiler is installed.

## Run the website

Use Node.js 20 or later with npm. From the repository root, in a terminal with Node installed:

```sh
npm ci
npm run docs:dev
```

On Windows PowerShell, use `npm.cmd` if script execution policy blocks `npm.ps1`. Open the local address printed by VitePress, normally `http://localhost:5176/`. The development server binds to the local loopback interface and is intended for this machine. Port 5176 keeps it separate from the networking course's usual development port. Press Ctrl+C in that terminal to stop it. If the port is already occupied, stop your earlier copy before restarting; the command deliberately does not silently choose another port.

To check and preview the production output:

```sh
npm run docs:build
npm run docs:preview
```

The first install needs access to the npm registry. The local course pages work after building without fetching an external search service. Videos and linked readings still require their respective sites; Computer, Enhance! requires a subscription.

## Confirm the learner scaffold

From the repository root in your Linux/WSL terminal:

```sh
cd week-01
make
make test
```

The first build should compile. Tests should fail because the starter functions are unfinished. That is expected behavioral failure, not a successful completed exercise. A missing compiler, syntax error, or broken harness is a different problem and should be resolved before implementing the work.

`CC=clang` selects the other compiler and `MODE=optimized` selects the package's optimized mode. Use each week's documented targets; not every package has exactly the same extra targets. Build output is separated from authored source. If you replace a compiler or change custom flags within a mode, follow the package's clean-build instructions.

## Common setup confusions

| What you see | First thing to establish |
| --- | --- |
| `make: command not found` | Are you in the Linux terminal with the tools installed? |
| A test reports TODO behavior | Did the scaffold compile, and have you implemented that function yet? |
| `objdump` rejects `i8086` | Does this binutils build support the architecture? Record a skipped cross-check honestly. |
| Fixture parsing fails on a carriage return | Was a byte-exact fixture re-saved with CRLF endings? |
| The site shows old source | Is the dev server using the same checkout you are editing? |
| The two compilers print different last digits | Check the documented numerical tolerance and environment before calling either result wrong. |

Do not repair a format test by rewriting its deliberately malformed fixture. A fixture can be designed to fail, just as an empty scaffold is designed to fail behavioral tests.
