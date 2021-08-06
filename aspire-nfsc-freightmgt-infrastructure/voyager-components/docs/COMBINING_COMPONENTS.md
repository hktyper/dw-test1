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

- [Terragrunt](#terragrunt)
- [Defining Dependancies](#defining-dependency)
- [Using Dependancies](#using-dependency)
- [Hooks](#hooks)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)

<!-- Terragrunt -->

## Terragrunt

Terragrunt is a wrapper around Terraform to provide some advanced workflows. We
have taken this an expanded on it to make the experience of building pipelines
more seamless across Sainsbury's Data Tech.

Terragrunt can build a dependency graph and allows you to pass variables from
one component to another to reduce duplication.

<!-- Defining Dependency -->

## Defining Dependency

You an define a dependency for a component by placing a configuration block at
the top level of the component configuration. The configuration block looks like
this:

```
    dependency:
      <component_key>: # The name of the component that is the dependency
        config_path: ../<component_key> # This is the name of that component which will live in the same directory as the current component
        mock_outputs:
          <output_of_dependency>: "<mock_value>" # Mock outputs can be defined for those dependencies. This is useful for plans
```

An example would be:

```
    dependency:
      ecr: # The name of the component that is the dependency
        config_path: ../ecr # This is the name of that component which will live in the same directory as the current component
        mock_outputs:
          ecr_url: "example.ecr.url" # Mock outputs can be defined for those dependencies. This is useful for plans
```

Under the dependency key, you can define an array of maps. The key that is used
for your component configuration must be unique amongst all components and so is
also used for the `config_path` and therefore can be used for the key here also.
Please see
[here](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency) for a reference.

<!-- Using Dependency -->

## Using Dependency

Once we have declared a dependency, we can pass through outputs to inputs. For
example:

```
      <input>: "${dependency.<dependency_name>.outputs.<output_name>}"
```

This would then look like:

```
      ecr_url: "${dependency.ecr.outputs.ecr_url}"
```

You can see how this can be powerful for keeping code DRY and then reusing
components and reducing duplication.

<!-- Hooks -->

## Hooks

### Reading Terraform outputs in hooks

We have the ability to use the hooks Terragrunt feature. Sometimes we might need
to inject a Terragrunt output into a hook. For example, we can create ECR with
one component and use a hook in another component to push an image to that ECR.

If you have a Terraform input defined in the downstream component, you can find
that input by reading the value of `TF_VAR_<variable_name`.

### Reading inputs and outputs in other ways

Terragrunt has the ability to run functions as part of its configuration. There
is a reference
[here](https://terragrunt.gruntwork.io/docs/reference/built-in-functions/). You
can use this functions to generate or consume data from any interface. For
example, you can output a value to a file from a script in one component and
then use `run_cmd` to read that value.

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
