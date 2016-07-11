#!/bin/bash -eu

function build_package {
    PACKAGE=$1
    TARBALL=$2
    echo "##teamcity[blockOpened name='$PACKAGE' description='Building package $PACKAGE']"
    if sh -eu $PACKAGE/pack.sh $TARBALL; then
        echo "##teamcity[blockClosed name='$PACKAGE']"
    else
        echo "##teamcity[buildProblem description='Failed to build package $PACKAGE']"
        exit
    fi
}

function run_test_on_container {
    DISTRIBUTION=$1
    RELEASE=$2
    DELAY=$3
    CONTAINER_NAME=$1.$2.$BUILD_NUMBER
    CONTAINER_ROOT=$HOME/.local/share/lxc/$CONTAINER_NAME/rootfs

    TEST_SUITE="$DISTRIBUTION.$RELEASE"

    echo "##teamcity[testSuiteStarted name='$TEST_SUITE']"

    echo "##teamcity[testStarted name='start' captureStandardOutput='true']"
    lxc-create -t download -n $CONTAINER_NAME -- --dist $DISTRIBUTION --release $RELEASE --arch amd64 --force-cache
    lxc-start -n $CONTAINER_NAME
    lxc-wait -n $CONTAINER_NAME -s RUNNING
    echo "Wait $DELAY seconds..."
    sleep $DELAY
    lxc-attach --clear-env -n $CONTAINER_NAME -- apt-get update
    lxc-attach --clear-env --set-var DEBIAN_FRONTEND=noninteractive -n $CONTAINER_NAME -- apt-get install -y wget
    echo "##teamcity[testFinished name='start']"

    cp qdb-api/*.deb $CONTAINER_ROOT/tmp/qdb-api.deb
    cp qdb-server/*.deb $CONTAINER_ROOT/tmp/qdb-server.deb
    cp qdb-utils/*.deb $CONTAINER_ROOT/tmp/qdb-utils.deb
    cp qdb-web-bridge/*.deb $CONTAINER_ROOT/tmp/qdb-web-bridge.deb

    echo "##teamcity[testStarted name='api.install' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- dpkg -i /tmp/qdb-api.deb || echo "##teamcity[testFailed name='api.install' message='Failed to install API']"
    echo "##teamcity[testFinished name='api.install']"

    echo "##teamcity[testStarted name='server.install' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- dpkg -i /tmp/qdb-server.deb || echo "##teamcity[testFailed name='server.install' message='Failed to install server']"
    echo "##teamcity[testFinished name='server.install']"

    echo "##teamcity[testStarted name='utils.install' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- dpkg -i /tmp/qdb-utils.deb || echo "##teamcity[testFailed name='utils.install' message='Failed to install utils']"
    echo "##teamcity[testFinished name='utils.install']"

    echo "##teamcity[testStarted name='web-bridge.install' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- dpkg -i /tmp/qdb-web-bridge.deb || echo "##teamcity[testFailed name='web-bridge.install' message='Failed to install web-bridge']"
    echo "##teamcity[testFinished name='web-bridge.install']"

    echo "##teamcity[testStarted name='qdbsh.put' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh -c "blob_put hello world" || echo "##teamcity[testFailed name='qdbsh.put' message='Failed to put blob']"
    echo "##teamcity[testFinished name='qdbsh.put']"

    echo "##teamcity[testStarted name='qdbsh.get' captureStandardOutput='true']"
    RESULT=$(lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh -c "blob_get hello") || echo "##teamcity[testFailed name='qdbsh.get' message='Failed to get blob']"
    [ "$RESULT" = "world" ] || echo "##teamcity[testFailed name='qdbsh.get' message='Invalid output from blob_get']"
    echo "##teamcity[testFinished name='qdbsh.get']"

    echo "##teamcity[testStarted name='web-bridge.wget' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- wget -qS http://127.0.0.1:8080 2>&1 || echo "##teamcity[testFailed name='web-bridge.wget' message='Failed to wget 127.0.0.1:8080']"
    echo "##teamcity[testFinished name='web-bridge.wget']"

    echo "##teamcity[testStarted name='reboot' captureStandardOutput='true']"
    echo "Stop container..."
    lxc-stop -n $CONTAINER_NAME
    lxc-wait -n $CONTAINER_NAME -s STOPPED
    echo "Start container..."
    lxc-start -n $CONTAINER_NAME
    lxc-wait -n $CONTAINER_NAME -s RUNNING
    echo "Wait $DELAY seconds..."
    sleep $DELAY
    echo "##teamcity[testFinished name='reboot']"

    echo "##teamcity[testStarted name='qdbsh.get.after-reboot' captureStandardOutput='true']"
    RESULT=$(lxc-attach --clear-env -n $CONTAINER_NAME -- qdbsh -c "blob_get hello") || echo "##teamcity[testFailed name='qdbsh.get.after-reboot' message='Failed to get blob']"
    [ "$RESULT" = "world" ] || echo "##teamcity[testFailed name='qdbsh.get' message='Invalid output from blob_get']"
    echo "##teamcity[testFinished name='qdbsh.get.after-reboot']"

    echo "##teamcity[testStarted name='web-bridge.wget.after-reboot' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- wget -qS http://127.0.0.1:8080 2>&1 || echo "##teamcity[testFailed name='web-bridge.wget.after-reboot' message='Failed to wget 127.0.0.1:8080']"
    echo "##teamcity[testFinished name='web-bridge.wget.after-reboot']"

    echo "##teamcity[testStarted name='api.uninstall' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- dpkg -r qdb-api || echo "##teamcity[testFailed name='api.uninstall' message='Failed to uninstall API']"
    echo "##teamcity[testFinished name='api.uninstall']"

    echo "##teamcity[testStarted name='server.uninstall' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- dpkg -r qdb-server || echo "##teamcity[testFailed name='server.uninstall' message='Failed to uninstall server']"
    echo "##teamcity[testFinished name='server.uninstall']"

    echo "##teamcity[testStarted name='utils.uninstall' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- dpkg -r qdb-utils || echo "##teamcity[testFailed name='utils.uninstall' message='Failed to uninstall utils']"
    echo "##teamcity[testFinished name='utils.uninstall']"

    echo "##teamcity[testStarted name='web-bridge.uninstall' captureStandardOutput='true']"
    lxc-attach --clear-env -n $CONTAINER_NAME -- dpkg -r qdb-web-bridge || echo "##teamcity[testFailed name='web-bridge.uninstall' message='Failed to uninstall web-bridge']"
    echo "##teamcity[testFinished name='web-bridge.uninstall']"

    echo "##teamcity[testStarted name='stop' captureStandardOutput='true']"
    lxc-destroy -f -n $CONTAINER_NAME
    echo "##teamcity[testFinished name='stop']"

    echo "##teamcity[testSuiteFinished name='$TEST_SUITE']"
}

set -e
build_package qdb-api *-api.tar.gz
build_package qdb-server *-server.tar.gz
build_package qdb-utils *-utils.tar.gz
build_package qdb-web-bridge *-web-bridge.tar.gz

set +e
run_test_on_container debian jessie 30
run_test_on_container debian sid 5
run_test_on_container debian stretch 5

run_test_on_container ubuntu precise 5
run_test_on_container ubuntu trusty 5
run_test_on_container ubuntu wily 5
run_test_on_container ubuntu xenial 5
run_test_on_container ubuntu yakkety 5
