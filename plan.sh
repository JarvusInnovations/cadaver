pkg_name=cadaver
pkg_origin=jarvus
pkg_version="0.23.3"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("GPL-2.0")

pkg_bin_dirs=(bin)

pkg_build_deps=(
    core/make
    core/gcc
    core/pkg-config
    core/libiconv
    core/gettext
    core/expat
)

pkg_deps=(
    core/glibc
    core/ncurses
    core/zlib
    core/libxml2
    core/openssl
    core/readline

    # required by added cadaver-put-recursive script
    core/bash
    core/findutils
    core/coreutils
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
        --with-libxml2

    make
}

do_install() {
    do_default_install

    build_line "Adding cadaver-put-recursive command"
    cat > "$pkg_prefix/bin/cadaver-put-recursive" <<- EOM
#!$(pkg_path_for bash)/bin/sh

usage () { echo "\$0 <src> <cadaver-args>*" >/dev/stderr; }
error () { echo "\$1" >/dev/stderr; usage; exit 1; }

test \$# '<' 3 || \
    error "Source and cadaver arguments expected!";

src="\$1"; shift;
test -r "\$src" || \
    error "Source argument should be a readable file or directory!";

cd "\$($(pkg_path_for coreutils)/bin/dirname "\$src")";
src="\$($(pkg_path_for coreutils)/bin/basename "\$src")";
root="\$($(pkg_path_for coreutils)/bin/pwd)";
rc="\$($(pkg_path_for coreutils)/bin/mktemp)";
{
    $(pkg_path_for findutils)/bin/find "\$src" '(' -type d -a -readable ')' \
    -printf 'mkcol "%p"\n';
    $(pkg_path_for findutils)/bin/find "\$src" '(' -type f -a -readable ')' \
    -printf 'cd "%h"\nlcd "%h"\n'            \
    -printf 'mput "%f"\n'                    \
    -printf 'cd -\nlcd "'"\$root"'"\n';
    echo "quit";
} > "\$rc";

${pkg_prefix}/bin/cadaver -r "\$rc" "\$@";
rm -f "\$rc";
EOM

    chmod +x "$pkg_prefix/bin/cadaver-put-recursive"
}
