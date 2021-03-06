#!/bin/bash
# Script to download / check and upload scikit_image wheels for release
RACKSPACE_URL=http://wheels.scikit-image.org
if [ "`which twine`" == "" ]; then
    echo "twine not on path; need to pip install twine?"
    exit 1
fi
SK_VERSION=`git describe --tags`
if [ "${SK_VERSION:0:1}" != 'v' ]; then
    echo "scikit image version $SK_VERSION does not start with 'v'"
    exit 1
fi
WHEEL_HEAD="scikit_image-${SK_VERSION:1}"
WHEEL_TAIL="macosx_10_6_intel.macosx_10_9_intel.macosx_10_9_x86_64.whl"
mkdir -p wheels
cd wheels
rm -rf *.whl
for py_tag in cp27-none cp33-cp33m cp34-cp34m
do
    wheel_name="$WHEEL_HEAD-$py_tag-$WHEEL_TAIL"
    wheel_url="${RACKSPACE_URL}/${wheel_name}"
    echo "Fetching $wheel_url"
    curl -O $wheel_url
    if [ "$?" != "0" ]; then
        echo "Failed downloading $wheel_url; check travis build?"
        exit $?
    fi
done
cd ..
twine upload wheels/*.whl
