#!/bin/bash

# # Relative paths assume the script is being run from repo root
IMAGE_BASENAME="Orangepi5plus_1.2.0_debian_bookworm_server_linux6.1.43.img"
IMAGE_SOURCE=$(realpath "images/${1:-$IMAGE_BASENAME}")

echo "Copy ${IMAGE_SOURCE} to build/..."
# mkdir -p build
# rsync -P ${IMAGE_SOURCE} build
IMAGE_FILENAME="$(realpath build/${IMAGE_BASENAME})"

echo "Mounting ${IMAGE_FILENAME}..."
mkdir -p /tmp/img_mountpoint && TMP=$(realpath /tmp/img_mountpoint)
LOOP=$(sudo losetup --show -fP "${IMAGE_FILENAME}")
sudo mount ${LOOP}p2 $TMP
sudo mount ${LOOP}p1 $TMP/boot/
echo "Root mounted to ${TMP}"
echo "Boot mounted to ${TMP}/boot/"

echo "Checking mount..."
losetup -l |grep ${IMAGE_BASENAME}
mount | grep img_mountpoint

echo "Enable ARM emulation..."
sudo cp /usr/bin/qemu-arm64 ${TMP}/usr/bin/

echo "Run Ansible playbook (you must be passwordless SUDOER, ick)..."
ansible-playbook scripts/main.yml --extra-vars "env=${ENVIRONMENT}"
succeeded=$?
echo "Ansible playbook done, return status code: $succeeded."

undo=$(
cat<<EOF
sudo umount ${TMP}/boot;
sudo umount ${TMP};
sudo losetup -D ${LOOP};
sudo rmdir ${TMP}
EOF
)

if [ "$succeeded" -eq 0 ]; then
    echo "Unmounting image and cleaning up host OS..."
    $undo
    
    echo "Image ready at build/$IMAGE_BASENAME"
else
    echo "Failed run results are at build/$IMAGE_BASENAME"
    echo "Mounts still active! Clean them up with this sequence:"
    echo $undo
fi

