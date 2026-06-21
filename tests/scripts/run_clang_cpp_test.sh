#!/bin/bash
# Copyright 2024 The Bazel Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Builds and runs //:clang_cpp_test against the default (modern) toolchain. This
# exercises the `@llvm_toolchain_llvm//:clang_cpp` target by compiling against
# the Clang/LLVM development headers and linking libclang-cpp.
#
# Built in `-c opt`: clang_cpp is expected to be consumed only in opt (or
# host-opt) configuration, so the test mirrors that.
#
# The target is tagged `manual` (libclang-cpp is not shipped by every LLVM
# distribution), so it is run explicitly here rather than via `//:all`. Only run
# on Ubuntu and macOS with the latest Bazel; older toolchains/distributions are
# not guaranteed to ship libclang-cpp.

set -euo pipefail

while getopts "h" opt; do
  case "${opt}" in
  "h")
    echo "Usage: No options"
    exit 2
    ;;
  *)
    echo "invalid option: -${OPTARG}"
    exit 1
    ;;
  esac
done

scripts_dir="$(dirname "${BASH_SOURCE[0]}")"
source "${scripts_dir}/bazel.sh"
"${bazel}" version

cd "${scripts_dir}"

set -x
"${bazel}" ${TEST_MIGRATION:+"--strict"} test \
  "${common_test_args[@]}" \
  --compilation_mode=opt \
  -- //:clang_cpp_test
