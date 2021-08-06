<!--
*** Thanks for checking out this README Template. If you have a suggestion that would
*** make this better, please fork the repo and create a pull request or simply open
*** an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
***
***
*** To avoid retyping too much info. Do a search and replace for the following:
*** JSainsburyPLC, voyager-components
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/JSainsburyPLC/voyager-components">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Voyager</h3>

  <p align="center">
    Voyager Components - Your one stop shop for Voyager framework feature set
    <br />
    <a href="https://github.com/JSainsburyPLC/voyager-components"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://web.microsoftstream.com/video/662ea071-e4c2-415b-9c6a-17b934e1ad36">Voyager Quickstart Video</a>
    ·
    <a href="https://github.com/JSainsburyPLC/voyager-components/issues">Report Bug</a>
    ·
    <a href="https://github.com/JSainsburyPLC/voyager-components/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->

## Table of Contents

- [Using Components](#using-components)
- [Repository Structure](#repository-structure)
- [Configuration](#configuration)
- [Running the Development Environment](#development-environment)
- [Security Scans](#security-scans)
- [Useful References](#useful-references)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)

<!-- Components -->

### Using Components

Components are designed to be used by an external repository with custom
configuration defined by your squad and the implementation of these components.
This workflow is built on
[Terragrunt](https://github.com/gruntwork-io/terragrunt) and is orchestrated by
the [Voyager
CLI](../voyager_cli/README.md).
With these two pieces of code, we are able to orchestrate components whilst
providng nice interfaces for authentication, development environments and many
other advanced features.

<!-- Repository Structure -->

### Repository Structure

The main repository that is required is your own squad repository that is used
by you and your team. The structure will be as follows:

```
.
├── Makefile
├── configuration
│   └── dev
└── voyager-components
    ├── ...
```

1. Configuration

This directory contains all of the configuration objects for components. These
configuration objects are blocks of yaml and must live under environment
subdirected as depicted above.

The environment directories can be called anything you like but the
configuration directory must be called `configuration`. You may adjust your
configuration in any way you see fit within those directories. All objects will
be processed at the same time with no prioritisation as a dependency graph is
built between components to identify order.

The only consideration you may need is that you are able to direct the Voyager
CLI to only act on a single file. This is useful for development purposes but
has little effect in CI/CD pipelines.

2. Voyager-components

The `voyager-components` directory refers to this repository. You can include it
in anyway you wish but we recommend you either clone it to this directory in an
ad-hoc fashion or use git submodules.

Collecting for components for use is done by other means, but this repository
must be cloned in order to gain access to the Voyager CLI and the docker image
for the development environment.

3. Makefile

The Makefile is used to orchestrate common functions such as building and
running the dev environment. An example can be found
[here](https://github.com/JSainsburyPLC/voyager-poc-squads/blob/master/Makefile).

<!-- Configuration -->

### Configuration

There are two places to refer to for configuration:

1. Voyager CLI README - This will contain the latest object supported by the
   Voyager CLI but the fields will need to be populated appropriately.
1. Component Examples - Each component will have an example configuration in the
   `examples` directory within each component. This can be copied and updated
   for your use case.

Place the component configuration within your `configuration/<env>/<file>.yaml`
file and use the dev environment to test its functionality.

<!-- To update a component -->

### Development Environment

Using the example Makefile in a bare directory, follow these steps:

1. Run `make init`

This will initialise git, add the submodule for voyager-components and build the
docker image for the development environment. The image is based off the one for
Codepipeline to maintain similarity to the CI/CD environment.

2. Create your configuration file examples as instructed above
3. Run `make dev`

This will launch you into a container where a number of files and objects are
mounted in such as:

- Your `~/.aws/config` directory
- Your `~/.ssh` directory
- The current directory
- Your docker socket

4. Run `voyager deploy --env <env> --stage plan`

This command will create ephemeral copies of all components and generate
configuration for them using your configuration. This will be done for all
configuration objects in the specified environment. It will then subsequently
run a `terraform plan` against all of those components.o

You can run `voyager` with `--help` to see all available options for interacting
with the voyager components.

<!-- Security Scans -->

### Security Scans

[TFSec](https://tfsec.dev/) is used to run security focused static code analysis
on Voyager components and its downstream dependent modules. This is done
automatically as part of the pull request process. The code for this is part of
the `.titan` directory.

#### Running TFSec

TFSec will be run as part of PRs and branches, so you can check on their status.
They can also be run from the voyager-components repository by running `make tfsec`.

#### TFSec exclusions

If you'd like to exclude your component becaue it's not able to be run with
TFSec, you can add a `.tfsec-exclude` file to the component and it will be
ignored. Please put the reason within that file.

If there is a particular check you'd like to exclude, you can add a
comment to the line as such `#tfsec:ignore:<check_reference>`. For example:

```
resource "aws_sns_topic" "codepipline_notification" { #tfsec:ignore:AWS016
```

#### TFSec Custom Checks

TFSec supports custom checks. The documentation for that feature can be found
[here](https://tfsec.dev/docs/custom_checks/). The `.tfsec` directory should be
placed in the root of the component as that is the context of where tfsec is
executed.

<!-- Useful References -->

### Useful References

- [Voyager CLI
  Docs](../voyager_cli/README.md)
- [voyager-poc-squads](https://github.com/JSainsburyPLC/voyager-poc-squads/blob/master/README.md)
- [Codepipeline](../codepipeline/README.md)

<!-- CONTACT -->

## Contact

Slack - #data-voyager

Project Link: [https://github.com/JSainsburyPLC/voyager-components](https://github.com/JSainsburyPLC/voyager-components)

<!-- ACKNOWLEDGEMENTS -->

## Acknowledgements

- [GDP_PEAR]()
- [GDP_STRAWBERRY]()
- [GDP_APPLE]()
- [GDP_PAPAYA]()
- [GDP_ORANGE]()
- [GDP_LIME]()
- [GDP_AVACADO]()
