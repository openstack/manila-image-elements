# Defaults:

# Development options:
USE_OFFLINE_MODE=${USE_OFFLINE_MODE:-"yes"}
ENABLE_DEBUG_MODE=${ENABLE_DEBUG_MODE:-"no"}
DISABLE_IMG_COMPRESSION=${DISABLE_IMG_COMPRESSION:-"no"}

# Manila user settings
MANILA_USER=${MANILA_USER:-"manila"}
MANILA_PASSWORD=${MANILA_PASSWORD:-"manila"}
MANILA_USER_AUTHORIZED_KEYS=

# Manila image settings
MANILA_IMG_ARCH=${MANILA_IMG_ARCH:-"i386"}
MANILA_IMG_OS=${MANILA_IMG_OS:-"manila-ubuntu-core"}
MANILA_IMG_OS_VER=${MANILA_IMG_OS_VER:-"trusty"}
MANILA_IMG_NAME=${MANILA_IMG_NAME:-"ubuntu-manila-service-image.qcow2"}

# Manila features
MANILA_ENABLE_NFS_SUPPORT=${MANILA_ENABLE_NFS_SUPPORT:-"yes"}
MANILA_ENABLE_CIFS_SUPPORT=${MANILA_ENABLE_CIFS_SUPPORT:-"yes"}


# Verify configuration
# --------------------
REQUIRED_ELEMENTS="manila-ssh vm $MANILA_IMG_OS dhcp-all-interfaces devuser cleanup-kernel-initrd"
OPTIONAL_ELEMENTS=
OPTIONAL_DIB_ARGS=

if [ "$MANILA_ENABLE_CIFS_SUPPORT" != "yes" && "$MANILA_ENABLE_CIFS_SUPPORT" = "yes" ]; then
    echo "You should enable NFS or CIFS support for manila image."
fi

if [ "$MANILA_ENABLE_NFS_SUPPORT" = "yes" ]; then
    OPTIONAL_ELEMENTS="$OPTIONAL_ELEMENTS manila-nfs"
fi

if [ "$MANILA_ENABLE_CIFS_SUPPORT" = "yes" ]; then
    OPTIONAL_ELEMENTS="$OPTIONAL_ELEMENTS manila-cifs"
fi

if [ "$USE_OFFLINE_MODE" = "yes" ]; then
    OPTIONAL_DIB_ARGS="$OPTIONAL_DIB_ARGS -offline"
fi

if [ "$ENABLE_DEBUG_MODE" = "yes" ]; then
    OPTIONAL_DIB_ARGS="$OPTIONAL_DIB_ARGS -x"
    MANILA_USER_AUTHORIZED_KEYS=${MANILA_USER_AUTHORIZED_KEYS:-"$HOME/.ssh/id_rsa.pub"}
fi

if [ "$DISABLE_IMG_COMPRESSION" = "yes" ]; then
    OPTIONAL_DIB_ARGS="$OPTIONAL_DIB_ARGS -u"
fi

if [ "$MANILA_IMG_OS" = "manila-ubuntu-core" && "$MANILA_IMG_OS_VER" != "trusty" ]; then
    echo "manila-ubuntu-core doesn't support '$MANILA_IMG_OS_VER' release."
    echo "Change MANILA_IMG_OS to 'ubuntu' if you need another release."
fi

# Export diskimage-builder settings
# ---------------------------------
export ELEMENTS_PATH=`pwd`/elements
export DIB_DEFAULT_INSTALLTYPE=package
export DIB_RELEASE=$MANILA_IMG_OS_VER

# User settings
export DIB_DEV_USER_USERNAME=$MANILA_USER
export DIB_DEV_USER_PWDLESS_SUDO=yes
export DIB_DEV_USER_PASSWORD=$MANILA_PASSWORD
export DIB_DEV_USER_AUTHORIZED_KEYS=$MANILA_USER_AUTHORIZED_KEYS

# Build image
# -----------
disk-image-create -a $MANILA_IMG_ARCH $OPTIONAL_DIB_ARGS -o $MANILA_IMG_NAME\
    $OPTIONAL_ELEMENTS $REQUIRED_ELEMENTS