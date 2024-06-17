#!/bin/bash

# Get cargo version code (format like "1.2.3").
package_version=$(
  cargo metadata --format-version 1 | jq -r '.packages[0].version'
)
