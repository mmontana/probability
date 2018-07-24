#!/usr/bin/env bash
# Copyright 2018 The TensorFlow Probability Authors.
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
# ==============================================================================
set -e
set -x

PLATFORM="$(uname -s | tr 'A-Z' 'a-z')"

if [[ $# -lt 1 ]] ; then
  echo "Usage:"
  echo "pip_pkg /path/to/destination/directory"
  exit 1
fi

# Create the destination directory, then do dirname on a non-existent file
# inside it to give us an absolute paths with tilde characters resolved to the
# destination directory. Readlink -f is a cleaner way of doing this but is not
# available on a fresh macOS install.
mkdir -p "$1"
DEST="$(dirname "${1}/does_not_exist")"

cd bazel-bin/pip_pkg.runfiles/tensorflow_probability
# Pass through remaining arguments (following the first argument, which
# specifies the output dir) to setup.py, e.g.,
#  ./pip_pkg /tmp/tensorflow_probability_pkg --gpu --release
# passes `--gpu --release` to setup.py.
python setup.py bdist_wheel --universal ${@:2} --dist-dir="$DEST" >/dev/null

set +x
echo -e "\nBuild complete. Wheel files are in $DEST"
