pkg_name=cadaver
pkg_origin=jarvus
pkg_version="0.23.3"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("GPL-2.0")

pkg_build_deps=(
    core/make
    core/gcc
    core/pkg-config
    core/libiconv
    core/gettext
    core/expat

    core/less
)

pkg_deps=(
    core/glibc
    core/ncurses
    core/zlib
    core/libxml2
    core/openssl
    core/readline
)


do_prepare() {
    localedef -i en_US -f UTF-8 en_US.UTF-8
    export LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
}

do_build() {
    ./configure --prefix="${pkg_prefix}" \
        --with-libiconv-prefix="$(pkg_path_for libiconv)" \
        --with-libintl-prefix="$(pkg_path_for gettext)/share/gettext/intl" \
        --with-ssl=openssl \
        --with-libxml2 | less

    attach

    make
}
# pkg_lib_dirs=(lib)
# pkg_include_dirs=(include)
# pkg_bin_dirs=(bin)
# pkg_pconfig_dirs=(lib/pconfig)
# pkg_svc_run="bin/haproxy -f $pkg_svc_config_path/haproxy.conf"
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )
# pkg_exposes=(port ssl-port)
# pkg_binds=(
#   [database]="port host"
# )
# pkg_binds_optional=(
#   [storage]="port host"
# )
# pkg_interpreters=(bin/bash)
# pkg_svc_user="hab"
# pkg_svc_group="$pkg_svc_user"
# pkg_description="Some description."
# pkg_upstream_url="http://example.com/project-name"
