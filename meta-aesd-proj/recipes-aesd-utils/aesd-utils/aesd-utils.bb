SUMMARY = "Utility package for core-image-minimal"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit update-rc.d

SRC_URI =  "file://aesd-mount-drive \
           file://sync-script.sh \
           file://mount-hdd.sh"

S = "${WORKDIR}"

INITSCRIPT_PACKAGES="${PN}"
INITSCRIPT_NAME:${PN}="aesd-mount-drive"

do_install() {
    install -d ${D}${bindir}
	install -m 0755 ${S}/mount-hdd.sh ${D}${bindir}/
    install -m 0777 ${S}/sync-script.sh ${D}${bindir}/
    install -d ${D}${sysconfdir}/init.d
    install -m 755 ${S}/aesd-mount-drive ${D}${sysconfdir}/init.d/
}



