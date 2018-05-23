#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Script which embeds a piece of raw data into a C++ source file. Functionally
# the same as xxd -i, but inserts custom namespace and variable names.

set -e
IN_FILE=$1
OUT_FILE=$2

echo "// header generated by build-support/generate_precompiled_xxd.sh" > $OUT_FILE
echo "namespace kudu {" >> $OUT_FILE
echo "namespace codegen {" >> $OUT_FILE

echo "extern const char precompiled_ll_data[] = {" >> $OUT_FILE
xxd -i - < $IN_FILE >> $OUT_FILE
# LLVM requires the binary to be null terminated.
echo ", 0x00" >> $OUT_FILE
echo "};" >> $OUT_FILE

LEN=$(wc -c $IN_FILE | awk '{print $1}')
echo "extern const unsigned int precompiled_ll_len = ${LEN};" >> $OUT_FILE

echo "} // namespace codegen" >> $OUT_FILE
echo "} // namespace kudu" >> $OUT_FILE
