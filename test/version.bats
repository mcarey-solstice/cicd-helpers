#!/usr/bin/env bats

SCRIPT=./out/bin/version

load helpers/print/bprint

@test "It should bump patch version" {
  run $SCRIPT v1.0.0

  [ $status -eq 0 ]
  [[ "$output" == v1.0.1 ]]
}
