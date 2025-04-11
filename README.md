# zipline-grouping-exercise

Grouping Exercise

## Installation

```
bundle install
```

## Usage

```
Usage: ruby group_people.rb <input_file.csv> <matching_type>
```

`matching_type` should be one of the following, `email`, `phone`, `email_or_phone`

## Running tests

```
rspec
```

# Programming Exercise - Grouping

The goal of this exercise is to identify rows in a CSV file that
**may** represent the **same person** based on a provided **Matching Type** (definition below).

The resulting program should allow us to test at least three matching types:

- one that matches records with the same email address
- one that matches records with the same phone number
- one that matches records with the same email address OR the same phone number

## Guidelines

- **Please DO NOT fork this repository with your solution**
- You should use Ruby to complete this assignment.
- Only use code that you have license to use
- Your submission should be complete, including the kinds of tests, documentation and other artifacts you'd normally provide as part of a pull request or finished solution.
- Bear in mind that our interviewers will need to run your code to evaluate it, so consider dependencies carefully.
- Don't hesitate to ask us any questions to clarify the project

## Resources

### CSV Files

Three sample input files are included. All files should be successfully
processed by the resulting code.

### Matching Type

A matching type is a declaration of what logic should be used to compare the rows.

For example: A matching type named same_email might make use of an algorithm that
matches rows based on email columns.

## Interface

At a high level, the program should take two parameters. The input file
and the matching type.

## Output

The expected output is a copy of the original CSV file with the unique
identifier of the person each row represents prepended to the row.
