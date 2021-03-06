#!/bin/bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

kafka_home=

if [ -n "$KAFKA_HOME" ]
then
    echo "KAFKA_HOME is set to: $KAFKA_HOME, use it to locate kafka dependencies."
    kafka_home=$KAFKA_HOME
fi

if [ -z "$KAFKA_HOME" ]
then
    echo "Couldn't find kafka home. Please set KAFKA_HOME to the path which contains kafka dependencies."
    exit 1
fi

# works for kafka 9+
kafka_client=`find -L "$(dirname $kafka_home)" -name 'kafka-clients-[a-z0-9A-Z\.-]*.jar' ! -name '*doc*' ! -name '*test*' ! -name '*sources*' ''-printf '%p:' | sed 's/:$//'`
if [ -z "$kafka_client" ]
then
# works for kafka 8
    kafka_broker=`find -L "$(dirname $kafka_home)" -name 'kafka_[a-z0-9A-Z\.-]*.jar' ! -name '*doc*' ! -name '*test*' ! -name '*sources*' ''-printf '%p:' | sed 's/:$//'`
    if [ -z "$kafka_broker" ]
    then
        echo "kafka client lib not found"
        exit 1
    else
        echo "kafka dependency: $kafka_broker"
        export kafka_dependency
    fi
else
    echo "kafka dependency: $kafka_client"
    export kafka_dependency
fi
