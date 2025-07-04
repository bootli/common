#!/bin/bash
# https://github.com/bootli/build-actions
# common Module by 28677160
# matrix.target=${FOLDER_NAME}

ACTIONS_VERSION="1.0.7"

function TIME() {
Compte=$(date +%Y年%m月%d号%H时%M分)
  [[ -z "$1" ]] && {
    echo -ne " "
    } || {
    case $1 in
    r) export Color="\e[31m";;
    g) export Color="\e[32m";;
    b) export Color="\e[34m";;
    y) export Color="\e[33m";;
    z) export Color="\e[35m";;
    l) export Color="\e[36m";;
    esac
      [[ $# -lt 2 ]] && echo -e "\e[36m\e[0m ${1}" || {
        echo -e "\e[36m\e[0m ${Color}${2}\e[0m"
      }
    }
}

function settings_variable() {
cd ${GITHUB_WORKSPACE}
bash <(curl -fsSL https://raw.githubusercontent.com/bootli/common/main/custom/first.sh)
}

function Diy_variable() {
# 读取变量
if [[ -n "${BENDI_VERSION}" ]]; then
  export start_path="${GITHUB_WORKSPACE}/operates/${FOLDER_NAME}/relevance/settings.ini"
else
  export start_path="${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/relevance/settings.ini"
fi

if [[ -n "${INPUTS_REPO_BRANCH}" ]]; then
  SOURCE_CODE="${SOURCE_CODE}"
  REPO_BRANCH="${INPUTS_REPO_BRANCH}"
  CONFIG_FILE="$(echo "${INPUTS_CONFIG_FILE}" |cut -d"/" -f2)"
  CPU_SELECTION="${INPUTS_CPU_SELECTION}"
  INFORMATION_NOTICE="${INPUTS_INFORMATION_NOTICE}"
  UPLOAD_FIRMWARE="${INPUTS_UPLOAD_FIRMWARE}"
  UPLOAD_RELEASE="${INPUTS_UPLOAD_RELEASE}"
  CACHEWRTBUILD_SWITCH="${INPUTS_CACHEWRTBUILD_SWITCH}"
  UPDATE_FIRMWARE_ONLINE="${INPUTS_UPDATE_FIRMWARE_ONLINE}"
  COMPILATION_INFORMATION="${INPUTS_COMPILATION_INFORMATION}"
  RETAIN_MINUTE="${RETAIN_MINUTE}"
  KEEP_LATEST="${KEEP_LATEST}"
  echo "SSH_ACTION=${INPUTS_SSH_ACTION}" >> ${GITHUB_ENV}
  WAREHOUSE_MAN="${GIT_REPOSITORY##*/}"
else
  SOURCE_CODE="${SOURCE_CODE}"
  REPO_BRANCH="${REPO_BRANCH}"
  CONFIG_FILE="$(echo "${CONFIG_FILE}" |cut -d"/" -f2)"
  CPU_SELECTION="${CPU_SELECTION}"
  INFORMATION_NOTICE="${INFORMATION_NOTICE}"
  UPLOAD_FIRMWARE="${UPLOAD_FIRMWARE}"
  UPLOAD_RELEASE="${UPLOAD_RELEASE}"
  CACHEWRTBUILD_SWITCH="${CACHEWRTBUILD_SWITCH}"
  UPDATE_FIRMWARE_ONLINE="${UPDATE_FIRMWARE_ONLINE}"
  COMPILATION_INFORMATION="${COMPILATION_INFORMATION}"
  RETAIN_MINUTE="${RETAIN_MINUTE}"
  KEEP_LATEST="${KEEP_LATEST}"
  WAREHOUSE_MAN="${GIT_REPOSITORY##*/}"
fi

if [[ -n "$(echo "${CPU_SELECTION}" |grep -i 'E5\|默认\|false')" ]]; then
  CPU_SELECTION="false"
elif [[ -n "$(echo "${CPU_SELECTION}" |grep '8370')" ]]; then
  CPU_SELECTION="8370"
elif [[ -n "$(echo "${CPU_SELECTION}" |grep '8272')" ]]; then
  CPU_SELECTION="8272"
elif [[ -n "$(echo "${CPU_SELECTION}" |grep '8171')" ]]; then
  CPU_SELECTION="8171"
else
  CPU_SELECTION="false"
fi

if [[ "${INFORMATION_NOTICE}" =~ (关闭|false) ]]; then
  INFORMATION_NOTICE="false"
elif [[ -n "$(echo "${INFORMATION_NOTICE}" |grep -i 'TG\|telegram')" ]]; then
  INFORMATION_NOTICE="TG"
elif [[ -n "$(echo "${INFORMATION_NOTICE}" |grep -i 'PUSH\|pushplus')" ]]; then
  INFORMATION_NOTICE="PUSH"
else
  INFORMATION_NOTICE="false"
fi
  
cat >"${start_path}" <<-EOF
SOURCE_CODE="${SOURCE_CODE}"
REPO_BRANCH="${REPO_BRANCH}"
CONFIG_FILE="seed/${CONFIG_FILE}"
CPU_SELECTION="${CPU_SELECTION}"
INFORMATION_NOTICE="${INFORMATION_NOTICE}"
UPLOAD_FIRMWARE="${UPLOAD_FIRMWARE}"
UPLOAD_RELEASE="${UPLOAD_RELEASE}"
CACHEWRTBUILD_SWITCH="${CACHEWRTBUILD_SWITCH}"
UPDATE_FIRMWARE_ONLINE="${UPDATE_FIRMWARE_ONLINE}"
COMPILATION_INFORMATION="${COMPILATION_INFORMATION}"
RETAIN_MINUTE="${RETAIN_MINUTE}"
KEEP_LATEST="${KEEP_LATEST}"
EOF

if [[ -n "${BENDI_VERSION}" ]]; then
  echo "PACKAGING_FIRMWARE_BENDI=${PACKAGING_FIRMWARE}" >> "${start_path}"
  echo "MODIFY_CONFIGURATION=${MODIFY_CONFIGURATION}" >> "${start_path}"
  echo "WSL_ROUTEPATH=${WSL_ROUTEPATH}" >> "${start_path}"
fi

chmod -R +x ${start_path} && source ${start_path}

case "${SOURCE_CODE}" in
COOLSNOWWOLF)
  export REPO_URL="https://github.com/coolsnowwolf/lede"
  export SOURCE="Lede"
  export SOURCE_OWNER="Lean's"
  export LUCI_EDITION="18.06"
  export DIY_WORK="${FOLDER_NAME}master"
;;
LIENOL)
  export REPO_URL="https://github.com/Lienol/openwrt"
  export SOURCE="Lienol"
  export SOURCE_OWNER="Lienol's"
  export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  export DIY_WORK="${FOLDER_NAME}$(echo "${LUCI_EDITION}" |sed "s/\.//g" |sed "s/\-//g")"
;;
IMMORTALWRT)
  export REPO_URL="https://github.com/immortalwrt/immortalwrt"
  export SOURCE="Immortalwrt"
  export SOURCE_OWNER="ctcgfw's"
  export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  export DIY_WORK="${FOLDER_NAME}$(echo "${LUCI_EDITION}" |sed "s/\.//g" |sed "s/\-//g")"
;;
XWRT)
  export REPO_URL="https://github.com/x-wrt/x-wrt"
  export SOURCE="Xwrt"
  export SOURCE_OWNER="ptpt52's"
  export LUCI_EDITION="${REPO_BRANCH}"
  export DIY_WORK="${FOLDER_NAME}$(echo "${LUCI_EDITION}" |sed "s/\.//g" |sed "s/\-//g")"
;;
OFFICIAL)
  export REPO_URL="https://github.com/openwrt/openwrt"
  export SOURCE="Official"
  export SOURCE_OWNER="openwrt's"
  export LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  export DIY_WORK="${FOLDER_NAME}$(echo "${LUCI_EDITION}" |sed "s/\.//g" |sed "s/\-//g")"
;;
*)
  TIME r "不支持${SOURCE_CODE}此源码，当前只支持COOLSNOWWOLF、LIENOL、IMMORTALWRT、XWRT、OFFICIAL"
  exit 1
;;
esac

export DIY_PART_SH="diy-part.sh"
echo "DIY_PART_SH=${DIY_PART_SH}" >> ${GITHUB_ENV}
echo "HOME_PATH=${GITHUB_WORKSPACE}/openwrt" >> ${GITHUB_ENV}
echo "SOURCE_CODE=${SOURCE_CODE}" >> ${GITHUB_ENV}
echo "REPO_URL=${REPO_URL}" >> ${GITHUB_ENV}
echo "REPO_BRANCH=${REPO_BRANCH}" >> ${GITHUB_ENV}
echo "CONFIG_FILE=${CONFIG_FILE}" >> ${GITHUB_ENV}
echo "CPU_SELECTION=${CPU_SELECTION}" >> ${GITHUB_ENV}
echo "INFORMATION_NOTICE=${INFORMATION_NOTICE}" >> ${GITHUB_ENV}
echo "UPLOAD_FIRMWARE=${UPLOAD_FIRMWARE}" >> ${GITHUB_ENV}
echo "UPLOAD_RELEASE=${UPLOAD_RELEASE}" >> ${GITHUB_ENV}
echo "CACHEWRTBUILD_SWITCH=${CACHEWRTBUILD_SWITCH}" >> ${GITHUB_ENV}
echo "UPDATE_FIRMWARE_ONLINE=${UPDATE_FIRMWARE_ONLINE}" >> ${GITHUB_ENV}
echo "COMPILATION_INFORMATION=${COMPILATION_INFORMATION}" >> ${GITHUB_ENV}
echo "RETAIN_MINUTE=${RETAIN_MINUTE}" >> ${GITHUB_ENV}
echo "KEEP_LATEST=${KEEP_LATEST}" >> ${GITHUB_ENV}
echo "WAREHOUSE_MAN=${WAREHOUSE_MAN}" >> ${GITHUB_ENV}
echo "SOURCE=${SOURCE}" >> ${GITHUB_ENV}
echo "LUCI_EDITION=${LUCI_EDITION}" >> ${GITHUB_ENV}
echo "SOURCE_OWNER=${SOURCE_OWNER}" >> ${GITHUB_ENV}
echo "DIY_WORK=${DIY_WORK}" >> ${GITHUB_ENV}
echo "BUILD_PATH=${GITHUB_WORKSPACE}/openwrt/build/${FOLDER_NAME}" >> ${GITHUB_ENV}
echo "FILES_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files" >> ${GITHUB_ENV}
echo "REPAIR_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/etc/openwrt_release" >> ${GITHUB_ENV}
echo "DELETE=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/etc/deletefile" >> ${GITHUB_ENV}
echo "DEFAULT_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/etc/default-setting" >> ${GITHUB_ENV}
echo "KEEPD_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/lib/upgrade/keep.d/base-files-essential" >> ${GITHUB_ENV}
echo "GENE_PATH=${GITHUB_WORKSPACE}/openwrt/package/base-files/files/bin/config_generate" >> ${GITHUB_ENV}
echo "CLEAR_PATH=${GITHUB_WORKSPACE}/openwrt/Clear" >> ${GITHUB_ENV}
echo "Upgrade_Date=`date -d "$(date +'%Y-%m-%d %H:%M:%S')" +%s`" >> ${GITHUB_ENV}
echo "Firmware_Date=$(date +%Y-%m%d-%H%M)" >> ${GITHUB_ENV}
echo "Compte_Date=$(date +%Y年%m月%d号%H时%M分)" >> ${GITHUB_ENV}
echo "Tongzhi_Date=$(date +%Y年%m月%d日)" >> ${GITHUB_ENV}
echo "Gujian_Date=$(date +%m.%d)" >> ${GITHUB_ENV}
if [[ -n "${BENDI_VERSION}" ]]; then
  echo "PACKAGING_FIRMWARE_BENDI=${PACKAGING_FIRMWARE}" >> ${GITHUB_ENV}
  echo "MODIFY_CONFIGURATION=${MODIFY_CONFIGURATION}" >> ${GITHUB_ENV}
  echo "WSL_ROUTEPATH=${WSL_ROUTEPATH}" >> ${GITHUB_ENV}
fi

# 修改本地文件变量
if [[ -n "${BENDI_VERSION}" ]]; then
  GIT_BUILD="operates/${FOLDER_NAME}"
  sed -i 's?=?=\"?g' "${GITHUB_ENV}"
  sed -i '/=/ s/$/&\"/' "${GITHUB_ENV}"
  source ${GITHUB_ENV}
  # 升级gcc
  if [[ `gcc --version |grep -c "buntu 13"` -eq '0' ]]; then
    echo "安装使用gcc13版本,如若提示enter,请按回车键继续"
    sleep 5
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test
    sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa
    sudo apt-get install -y gcc-13
    sudo apt-get install -y g++-13
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 60 --slave /usr/bin/g++ g++ /usr/bin/g++-13
    gcc --version
  fi
else
  GIT_BUILD="build/${FOLDER_NAME}"
fi

# 检查自定义文件是否存在
if [ -z "$(ls -A "${GITHUB_WORKSPACE}/${GIT_BUILD}/${CONFIG_FILE}" 2>/dev/null)" ]; then
  TIME r "错误提示：编译脚本的[${FOLDER_NAME}文件夹内缺少${CONFIG_FILE}名称的配置文件],请在[${FOLDER_NAME}/seed]文件夹内补齐"
  echo
  exit 1
fi
if [ -z "$(ls -A "${GITHUB_WORKSPACE}/${GIT_BUILD}/${DIY_PART_SH}" 2>/dev/null)" ]; then
  TIME r "错误提示：编译脚本的[${FOLDER_NAME}文件夹内缺少${DIY_PART_SH}名称的自定义设置文件],请在[${FOLDER_NAME}]文件夹内补齐"
  echo
  exit 1
fi
}


function Diy_update() {
bash <(curl -fsSL https://raw.githubusercontent.com/bootli/common/main/custom/ubuntu.sh)
if [[ $? -ne 0 ]];then
  TIME r "依赖安装失败，请检测网络后再次尝试!"
  exit 1
else
  sudo sh -c 'echo openwrt > /etc/oprelyon'
  TIME b "全部依赖安装完毕"
fi
if [[ `gcc --version |grep -c "buntu 13"` -eq '0' ]]; then
  sudo add-apt-repository ppa:ubuntu-toolchain-r/test
  sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa
  sudo apt-get install -y gcc-13
  sudo apt-get install -y g++-13
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 60 --slave /usr/bin/g++ g++ /usr/bin/g++-13
  gcc --version
fi
}


function svn_co() {
if [[ $# -lt 3 ]]; then
  echo "Syntax error: [$#] [$*]"
  return 0
fi
branch="$1" curl="$2" target_dir="$3" && shift 3
localdir="${HOME_PATH}/${target_dir}"
[ -d "${localdir}" ] || mkdir -p "${localdir}"
tmpdir="$(mktemp -d)" || exit 1
trap 'rm -rf "${tmpdir}"' EXIT
packages="${tmpdir}/localpackages"
git clone -b "${branch}" --depth 1 --filter=blob:none --sparse "${curl}" "${tmpdir}"
[[ $? -ne 0 ]] && echo "文件下载失败,请检查网络,或查看仓库链接或者分支的正确性"
cd "${tmpdir}" && mkdir -p "${packages}"
git sparse-checkout init --cone
git sparse-checkout set "$@"
for i in "$@"; do
  cp -Rf "${i}" "${packages}"
done
for X in $(ls -1 ${packages}); do
  find "${localdir}" -type d -name "${X}" |xargs -i rm -rf {}
  cp -Rf "${packages}/${X}" "${localdir}"
done
cd "${HOME_PATH}" && sudo rm -rf "${tmpdir}"
}


function Diy_checkout() {
# 下载源码后，进行源码微调和增加插件源
cd ${HOME_PATH}
[[ -d "${HOME_PATH}/doc" ]] && rm -rf ${HOME_PATH}/doc
[[ ! -d "${HOME_PATH}/LICENSES/doc" ]] && mkdir -p "${HOME_PATH}/LICENSES/doc"
[[ ! -d "${HOME_PATH}/build_logo" ]] && mkdir -p "${HOME_PATH}/build_logo"

LUCI_CHECKUT="$(git tag -l |grep '^V\|^v' |awk 'END {print}')"
if [[ -n "${LUCI_CHECKUT}" ]]; then
  git checkout ${LUCI_CHECKUT}
  git switch -c ${LUCI_CHECKUT}
fi
git pull

sed -i '/bootli/d; /helloworld/d; /passwall/d; /OpenClash/d' "feeds.conf.default"
cat feeds.conf.default|awk '!/^#/'|awk '!/^$/'|awk '!a[$1" "$2]++{print}' >uniq.conf
mv -f uniq.conf feeds.conf.default

# 这里增加了源,要对应的删除/etc/opkg/distfeeds.conf插件源
cat >>"feeds.conf.default" <<-EOF
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git small https://github.com/kenzok8/small
EOF
./scripts/feeds update -a



cp -Rf ${HOME_PATH}/feeds.conf.default ${HOME_PATH}/LICENSES/doc/uniq.conf
}



function Diy_Wenjian() {
cp -Rf ${HOME_PATH}/LICENSES/doc/uniq.conf ${HOME_PATH}/feeds.conf.default

# 增加中文语言包
if [[ -f "${HOME_PATH}/feeds/luci/modules/luci-mod-system/root/usr/share/luci/menu.d/luci-mod-system.json" ]]; then
  LUCI_BANBEN="2"
  echo "LUCI_BANBEN=${LUCI_BANBEN}" >> $GITHUB_ENV
else
  LUCI_BANBEN="1"
  echo "LUCI_BANBEN=${LUCI_BANBEN}" >> $GITHUB_ENV
fi

Settings_path="$(find "${HOME_PATH}/package" -type d -name "default-settings")"
if [[ -z "${Settings_path}" ]] && [[ "${LUCI_BANBEN}" == "2" ]]; then
  cp -Rf ${HOME_PATH}/build/common/Share/default-settings2 ${HOME_PATH}/package/default-settings
  [[ ! -d "${HOME_PATH}/feeds/luci/libs/luci-lib-base" ]] && sed -i "s/+luci-lib-base //g" ${HOME_PATH}/package/default-settings/Makefile
elif [[ -z "${Settings_path}" ]] && [[ "${LUCI_BANBEN}" == "1" ]]; then
  cp -Rf ${HOME_PATH}/build/common/Share/default-settings1 ${HOME_PATH}/package/default-settings
fi

ZZZ_PATH="$(find "${HOME_PATH}/package" -type f -name "*-default-settings" |grep files)"
if [[ -n "${ZZZ_PATH}" ]]; then  
  echo "ZZZ_PATH=${ZZZ_PATH}" >> ${GITHUB_ENV}
  sed -i '/exit 0$/d' "${ZZZ_PATH}"

  if [[ -f "${HOME_PATH}/LICENSES/doc/default-settings" ]]; then
    cp -Rf ${HOME_PATH}/LICENSES/doc/default-settings "${ZZZ_PATH}"
  else
    cp -Rf "${ZZZ_PATH}" ${HOME_PATH}/LICENSES/doc/default-settings
  fi

  if [[ -f "${HOME_PATH}/LICENSES/doc/config_generates" ]]; then
    cp -Rf ${HOME_PATH}/LICENSES/doc/config_generates "${GENE_PATH}"
  else
    cp -Rf "${GENE_PATH}" ${HOME_PATH}/LICENSES/doc/config_generates
  fi
  sed -i "s?main.lang=.*?main.lang='zh_cn'?g" "${ZZZ_PATH}"
  [[ -n "$(grep "openwrt_banner" "${ZZZ_PATH}")" ]] && sed -i '/openwrt_banner/d' "${ZZZ_PATH}"

cat >> "${ZZZ_PATH}" <<-EOF
sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
echo "DISTRIB_DESCRIPTION='OpenWrt '" >> /etc/openwrt_release
sed -i '/luciversion/d' /usr/lib/lua/luci/version.lua
echo "luciversion    = \"${LUCI_EDITION}\"" >> /usr/lib/lua/luci/version.lua
sed -i '/luciname/d' /usr/lib/lua/luci/version.lua
echo "luciname    = \"${SOURCE}\"" >> /usr/lib/lua/luci/version.lua
EOF
fi

# 增加一些应用
cp -Rf ${HOME_PATH}/build/common/custom/default-setting "${DEFAULT_PATH}"
sudo chmod +x "${DEFAULT_PATH}"
sed -i '/exit 0$/d' "${DEFAULT_PATH}"
sed -i "s?112233?${SOURCE} - ${LUCI_EDITION}?g" "${DEFAULT_PATH}" > /dev/null 2>&1
sed -i 's/root:.*/root::0:0:99999:7:::/g' ${FILES_PATH}/etc/shadow
sed -i 's/luci.git;openwrt-23.05/luci/g' feeds.conf.default


#添加
rm -rf ${HOME_PATH}/feeds
cd ${HOME_PATH}
./scripts/feeds update -a
./scripts/feeds install -a
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-argon-config
rm -rf ${HOME_PATH}/feeds/luci/themes/luci-theme-argon
rm -rf ${HOME_PATH}/feeds/kenzo/luci-theme-argon
rm -rf ${HOME_PATH}/feeds/kenzo/luci-theme-argone
rm -rf ${HOME_PATH}/feeds/kenzo/luci-app-argon-config
rm -rf ${HOME_PATH}/feeds/kenzo/luci-app-argone-config
rm -rf ${HOME_PATH}/package/lean/luci-theme-argon
rm -rf ${HOME_PATH}/package/lean/luci-app-argon-config
rm -rf ${HOME_PATH}/feeds/kenzo/luci-app-adguardhome
rm -rf ${HOME_PATH}/feeds/kenzo/adguardhome
rm -rf ${HOME_PATH}/feeds/packages/net/adguardhome
rm -rf ${HOME_PATH}/feeds/kenzo/diy/.packages/luci-app-adguardhome
rm -rf ${HOME_PATH}/feeds/kenzo/diy/.packages/adguardhome
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-ikoolproxy
rm -rf ${HOME_PATH}/feeds/kenzo/luci-app-ikoolproxy
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-v2ray-server
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-socat
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-aliyundrive-fuse
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-aliyundrive-webdav
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-netdata
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-samba4
rm -rf ${HOME_PATH}/feeds/luci/applications/luci-app-samba
rm -rf ${HOME_PATH}/feeds/packages/multimedia/aliyundrive-webdav
rm -rf ${HOME_PATH}/feedspackages/net/speedtest-cli 
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon ${HOME_PATH}/package/lean/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config ${HOME_PATH}/package/lean/luci-app-argon-config
git clone https://github.com/bootli/luci-app-v2ray-server ${HOME_PATH}/feeds/luci/applications/luci-app-v2ray-server
git clone https://github.com/bootli/luci-app-samba4 ${HOME_PATH}/feeds/luci/applications/luci-app-samba4
git clone https://github.com/bootli/libuild ${HOME_PATH}/package/libuild
git clone https://github.com/sirpdboy/luci-app-ddns-go ${HOME_PATH}/package/ddns-go
git clone https://github.com/messense/aliyundrive-webdav ${HOME_PATH}/package/li
git clone https://github.com/destan19/OpenAppFilter ${HOME_PATH}/package/oaf
git clone https://github.com/sirpdboy/luci-app-netspeedtest ${HOME_PATH}/package/netspeedtest

# 更换golang版本
#rm -rf ${HOME_PATH}/feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 24.x ${HOME_PATH}/feeds/packages/lang/golang


if [[ `grep -Eoc "admin:.*" ${FILES_PATH}/etc/shadow` -eq '1' ]]; then
  sed -i 's/admin:.*/admin::0:0:99999:7:::/g' ${FILES_PATH}/etc/shadow
fi

cp -Rf ${HOME_PATH}/build/common/custom/Postapplication "${FILES_PATH}/etc/init.d/Postapplication"
sudo chmod +x "${FILES_PATH}/etc/init.d/Postapplication"

cp -Rf ${HOME_PATH}/build/common/custom/networkdetection "${FILES_PATH}/etc/networkdetection"
sudo chmod +x "${FILES_PATH}/etc/networkdetection"

[[ ! -d "${FILES_PATH}/usr/bin" ]] && mkdir -p ${FILES_PATH}/usr/bin
cp -Rf ${HOME_PATH}/build/common/custom/openwrt.sh "${FILES_PATH}/usr/bin/openwrt"
sudo chmod +x "${FILES_PATH}/usr/bin/openwrt"

echo '#!/bin/bash' > "${DELETE}"
sudo chmod +x "${DELETE}"

if [[ -d "${HOME_PATH}/target/linux/armsr" ]]; then
  features_file="${HOME_PATH}/target/linux/armsr/Makefile"
elif [[ -d "${HOME_PATH}/target/linux/armvirt" ]]; then
  features_file="${HOME_PATH}/target/linux/armvirt/Makefile"
fi
[[ -n "${features_file}" ]] && sed -i "s?FEATURES+=.*?FEATURES+=targz?g" "${features_file}"
sed -i '/DISTRIB_SOURCECODE/d' "${REPAIR_PATH}"
echo -e "\nDISTRIB_SOURCECODE='${SOURCE}_${LUCI_EDITION}'" >> "${REPAIR_PATH}" && sed -i '/^\s*$/d' "${REPAIR_PATH}"

# 给固件保留配置更新固件的保留项目
if [[ -z "$(grep "background" ${KEEPD_PATH})" ]]; then
cat >>"${KEEPD_PATH}" <<-EOF
/etc/config/AdGuardHome.yaml
/www/luci-static/argon/background/
/etc/smartdns/custom.conf
EOF
fi

# 修改一些依赖
case "${SOURCE_CODE}" in
XWRT|OFFICIAL)
  if [[ -n "$(grep "libustream-wolfssl" ${HOME_PATH}/include/target.mk)" ]]; then
    sed -i 's?libustream-wolfssl?libustream-openssl?g' "${HOME_PATH}/include/target.mk"
  elif [[ -z "$(grep "libustream-openssl" ${HOME_PATH}/include/target.mk)" ]]; then
    sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=libustream-openssl ?g' "${HOME_PATH}/include/target.mk"
  fi

  if [[ -n "$(grep "dnsmasq" ${HOME_PATH}/include/target.mk)" ]] && [[ -z "$(grep "dnsmasq-full" ${HOME_PATH}/include/target.mk)" ]]; then
    sed -i 's?dnsmasq?dnsmasq-full luci luci-newapi luci-lib-fs?g' "${HOME_PATH}/include/target.mk"
  fi

  if [[ -z "$(grep "ca-bundle" ${HOME_PATH}/include/target.mk)" ]]; then
    sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=ca-bundle ?g' "${HOME_PATH}/include/target.mk"
  fi

  if [[ -z "$(grep "luci" ${HOME_PATH}/include/target.mk)" ]]; then
    sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=luci luci-newapi luci-lib-fs ?g' "${HOME_PATH}/include/target.mk"
  fi
;;
*)
  if [[ -d "${HOME_PATH}/package/emortal" ]]; then
    if [[ -z "$(grep "default-settings-chn" ${HOME_PATH}/include/target.mk)" ]]; then
      sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=default-settings-chn ?g' "${HOME_PATH}/include/target.mk"
    fi
  else
    if [[ -z "$(grep "default-settings" ${HOME_PATH}/include/target.mk)" ]]; then
      sed -i 's?DEFAULT_PACKAGES:=?DEFAULT_PACKAGES:=default-settings ?g' "${HOME_PATH}/include/target.mk"
    fi
  fi
;;
esac

# 修正连接数
if [[ `grep -c "net.netfilter.nf_conntrack_max" ${HOME_PATH}/package/kernel/linux/files/sysctl-nf-conntrack.conf` -eq '0' ]]; then
  echo -e "\nnet.netfilter.nf_conntrack_max=165535" >> ${HOME_PATH}/package/kernel/linux/files/sysctl-nf-conntrack.conf
else
  sed -i 's/net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=165535/g' ${HOME_PATH}/package/kernel/linux/files/sysctl-nf-conntrack.conf
fi
if [[ `grep -c "min-cache-ttl=" ${HOME_PATH}/package/network/services/dnsmasq/files/dnsmasq.conf` -eq '0' ]]; then
  echo -e "#max-ttl=600\nneg-ttl=600\nmin-cache-ttl=3600" >> ${HOME_PATH}/package/network/services/dnsmasq/files/dnsmasq.conf
fi

source ${HOME_PATH}/build/common/Share/19.07/netsupport.sh

[[ -d "${HOME_PATH}/build/common/Share/luci-app-samba4" ]] && rm -rf ${HOME_PATH}/build/common/Share/luci-app-samba4
amba4="$(find . -type d -name 'luci-app-samba4')"
autosam="$(find . -type d -name 'autosamba')"
if [[ -z "${amba4}" ]] && [[ -n "${autosam}" ]]; then
  for X in "$(find . -type d -name 'autosamba')/Makefile"; do sed -i "s?+luci-app-samba4?+luci-app-samba?g" "$X"; done
else
  for X in "$(find . -type d -name 'autosamba')/Makefile"; do
    if [[ `grep -c "+luci-app-samba4" $X` -eq '0' ]]; then
      sed -i "s?+luci-app-samba?+luci-app-samba4?g" "$X"
    fi
  done
fi

# files大法，设置固件无烦恼
if [ -n "$(ls -A "${BUILD_PATH}/patches" 2>/dev/null)" ]; then
  find "${BUILD_PATH}/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d './' -p1 --forward --no-backup-if-mismatch"
fi
if [ -n "$(ls -A "${BUILD_PATH}/diy" 2>/dev/null)" ]; then
  cp -Rf ${BUILD_PATH}/diy/* ${HOME_PATH}
fi
if [ -n "$(ls -A "${BUILD_PATH}/files" 2>/dev/null)" ]; then
  [[ -d "${HOME_PATH}/files" ]] && rm -rf ${HOME_PATH}/files
  cp -Rf ${BUILD_PATH}/files ${HOME_PATH}/files
fi

# 定时更新固件的插件包
if [[ "${UPDATE_FIRMWARE_ONLINE}" == "true" ]]; then
  source ${BUILD_PATH}/upgrade.sh && Diy_Part1
else
  find . -type d -name "luci-app-autoupdate" |xargs -i rm -rf {}
  if [[ -n "$(grep "luci-app-autoupdate" ${HOME_PATH}/include/target.mk)" ]]; then
    sed -i 's?luci-app-autoupdate??g' ${HOME_PATH}/include/target.mk
  fi
fi
}


function Diy_Notice() {
TIME r ""
TIME y "第一次用我仓库的，请不要拉取任何插件，先SSH进入固件配置那里看过我脚本实在是没有你要的插件才再拉取"
TIME y "拉取插件应该单独拉取某一个你需要的插件，别一下子就拉取别人一个插件包，这样容易增加编译失败概率"
if [[ "${UPDATE_FIRMWARE_ONLINE}" == "true" ]]; then
  TIME r "SSH连接固件输入命令'openwrt'可进行修改后台IP、清空密码、还原出厂设置和在线更新固件操作"
else
  TIME r "SSH连接固件输入命令'openwrt'可进行修改后台IP，清空密码和还原出厂设置操作"
fi
TIME r ""
TIME g "CPU性能：8370C > 8272CL > 8171M > E5系列"
TIME r ""
}


function Diy_COOLSNOWWOLF() {
cd ${HOME_PATH}
# 降低aliyundrive-webdav版本,新版本编译不成功
if [[ -f "${HOME_PATH}/feeds/packages/multimedia/aliyundrive-webdav/Makefile" ]]; then
  curl -fsSL https://raw.githubusercontent.com/messense/aliyundrive-webdav/main/openwrt/aliyundrive-webdav/Makefile  -o ${HOME_PATH}/feeds/packages/multimedia/aliyundrive-webdav/Makefile
fi
}


function Diy_LIENOL() {
cd ${HOME_PATH}
# 修改v2raya的kmod-nft-tproxy依赖
if [[ "${REPO_BRANCH}" =~ (19.07|21.02) ]]; then
  if [[ -d "${HOME_PATH}/build/common/Share/v2raya" ]]; then
    rm -rf ${HOME_PATH}/feeds/helloworld/v2raya
    cp -Rf ${HOME_PATH}/build/common/Share/v2raya ${HOME_PATH}/feeds/helloworld/v2raya
  fi
fi
# 取消shadowsocksr-libev的libopenssl-legacy依赖
if [[ "${REPO_BRANCH}" =~ (19.07|21.02|22.03) ]]; then
  if [[ -d "${HOME_PATH}/feeds/passwall3/shadowsocksr-libev" ]]; then
    curl -o ${HOME_PATH}/feeds/passwall3/shadowsocksr-libev/Makefile https://raw.githubusercontent.com/bootli/common/main/Share/shadowsocksr-libev/Makefile
  fi
  # 降低shadowsocks-rust版本,最新版本编译不成功
  if [[ -d "${HOME_PATH}/feeds/passwall3/shadowsocks-rust" ]]; then
    curl -o ${HOME_PATH}/feeds/passwall3/shadowsocks-rust/Makefile https://raw.githubusercontent.com/bootli/common/main/Share/shadowsocks-rust/Makefile
  fi
fi
}


function Diy_IMMORTALWRT() {
cd ${HOME_PATH}
if [[ "${REPO_BRANCH}" =~ (openwrt-18.06|openwrt-18.06-k5.4|openwrt-21.02) ]]; then
  if [[ -d "${HOME_PATH}/build/common/Share/v2raya" ]]; then
    rm -rf ${HOME_PATH}/feeds/helloworld/v2raya
    cp -Rf ${HOME_PATH}/build/common/Share/v2raya ${HOME_PATH}/feeds/helloworld/v2raya
  fi
  # 降低shadowsocks-rust版本,最新版本编译不成功
  if [[ -d "${HOME_PATH}/feeds/passwall3/shadowsocks-rust" ]]; then
    curl -o ${HOME_PATH}/feeds/passwall3/shadowsocks-rust/Makefile https://raw.githubusercontent.com/bootli/common/main/Share/shadowsocks-rust/Makefile

  fi
fi
}


function Diy_XWRT() {
cd ${HOME_PATH}
}


function Diy_OFFICIAL() {
cd ${HOME_PATH}
if [[ "${REPO_BRANCH}" =~ (openwrt-19.07|openwrt-21.02) ]]; then
  if [[ -d "${HOME_PATH}/build/common/Share/v2raya" ]]; then
    rm -rf ${HOME_PATH}/feeds/helloworld/v2raya
    cp -Rf ${HOME_PATH}/build/common/Share/v2raya ${HOME_PATH}/feeds/helloworld/v2raya
  fi
fi
  #if [[ "${REPO_BRANCH}" =~ (openwrt-19.07|openwrt-21.02|openwrt-22.03) ]]; then
  # if [[ -d "${HOME_PATH}/feeds/passwall3/shadowsocksr-libev" ]]; then
  #    curl -o ${HOME_PATH}/feeds/passwall3/shadowsocksr-libev/Makefile https://raw.githubusercontent.com/bootli/common/main/Share/shadowsocksr-libev/Makefile
  #  fi
  # 降低shadowsocks-rust版本,最新版本编译不成功
  #  if [[ -d "${HOME_PATH}/feeds/passwall3/shadowsocks-rust" ]]; then
  #    curl -o ${HOME_PATH}/feeds/passwall3/shadowsocks-rust/Makefile https://raw.githubusercontent.com/bootli/common/main/Share/shadowsocks-rust/Makefile
  #  fi
  #fi
}


function Diy_zdypartsh() {
cd ${HOME_PATH}
source $BUILD_PATH/$DIY_PART_SH
cd ${HOME_PATH}

# passwall
find . -type d -name '*luci-app-passwall*' -o -name 'passwall1' -o -name 'passwall2' | xargs -i rm -rf {}
sed -i '/passwall.git\;luci/d; /passwall2/d' "feeds.conf.default"
if [[ "${PassWall_luci_branch}" == "1" ]]; then
  echo "src-git passwall1 https://github.com/xiaorouji/openwrt-passwall.git;luci-smartdns-dev" >> "feeds.conf.default"
  echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
else
  echo "src-git passwall1 https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
  echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
fi

# openclash
find . -type d -name '*luci-app-openclash*' -o -name '*OpenClash*' | xargs -i rm -rf {}
sed -i '/OpenClash/d' "feeds.conf.default"
if [[ "${OpenClash_branch}" == "1" ]]; then
  echo "src-git OpenClash https://github.com/vernesong/OpenClash.git;dev" >> "feeds.conf.default"
  echo "OpenClash_branch=dev" >> ${GITHUB_ENV}
else
  echo "src-git OpenClash https://github.com/vernesong/OpenClash.git;master" >> "feeds.conf.default"
  echo "OpenClash_branch=master" >> ${GITHUB_ENV}
fi

cat feeds.conf.default|awk '!/^#/'|awk '!/^$/'|awk '!a[$1" "$2]++{print}' >uniq.conf
mv -f uniq.conf feeds.conf.default
sed -i 's@.*danshui*@#&@g' "feeds.conf.default"
sed -i 's@.*src-git lienol*@#&@g' "feeds.conf.default"
sed -i 's@.*src-git other*@#&@g' "feeds.conf.default"
./scripts/feeds update -a
sed -i 's/^#\(.*danshui\)/\1/' "feeds.conf.default"
sed -i 's/^#\(.*src-git lienol\)/\1/' "feeds.conf.default"
sed -i 's/^#\(.*src-git other\)/\1/' "feeds.conf.default"

# 正在执行插件语言修改
if [[ "${LUCI_BANBEN}" == "2" ]]; then
  cp -Rf ${HOME_PATH}/build/common/language/zh_Hans.sh ${HOME_PATH}/zh_Hans.sh
  /bin/bash zh_Hans.sh && rm -rf zh_Hans.sh
else
  cp -Rf ${HOME_PATH}/build/common/language/zh-cn.sh ${HOME_PATH}/zh-cn.sh
  /bin/bash zh-cn.sh && rm -rf zh-cn.sh
fi
./scripts/feeds install -a > /dev/null 2>&1
# 使用自定义配置文件
[[ -f ${BUILD_PATH}/$CONFIG_FILE ]] && mv ${BUILD_PATH}/$CONFIG_FILE .config
}


function Diy_Publicarea() {
cd ${HOME_PATH}
# Diy_zdypartsh的延伸
rm -rf ${HOME_PATH}/CHONGTU && touch ${HOME_PATH}/CHONGTU
lan="/set network.\$1.netmask/a"
ipadd="$(grep "ipaddr:-" "${GENE_PATH}" |grep -v 'addr_offset' |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
netmas="$(grep "netmask:-" "${GENE_PATH}" |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
opname="$(grep "hostname=" "${GENE_PATH}" |grep -v '\$hostname' |cut -d "'" -f2)"
if [[ -n "$(grep "set network.\${1}6.device" "${GENE_PATH}")" ]]; then
  ifnamee="uci set network.ipv6.device='@lan'"
  set_add="uci add_list firewall.@zone[0].network='ipv6'"
else
  ifnamee="uci set network.ipv6.ifname='@lan'"
  set_add="uci set firewall.@zone[0].network='lan ipv6'"
fi

if [[ "${SOURCE_CODE}" == "OFFICIAL" ]] && [[ "${REPO_BRANCH}" == "openwrt-19.07" ]]; then
  devicee="uci set network.ipv6.device='@lan'"
fi

# AdGuardHome内核
if [[ "${AdGuardHome_Core}" == "1" ]]; then
  echo "AdGuardHome_Core=1" >> ${GITHUB_ENV}
else
  [[ -f "${HOME_PATH}/files/usr/bin/AdGuardHome" ]] && rm -rf ${HOME_PATH}/files/usr/bin/AdGuardHome
  echo "AdGuardHome_Core=0" >> ${GITHUB_ENV}
fi

# openclash内核
if [[ "${OpenClash_Core}" == "1" ]]; then
  echo "OpenClash_Core=1" >> ${GITHUB_ENV}
elif [[ "${OpenClash_Core}" == "2" ]]; then
  echo "OpenClash_Core=2" >> ${GITHUB_ENV}
else
  echo "OpenClash_Core=0" >> ${GITHUB_ENV}
  [[ -d "${HOME_PATH}/files/etc/openclash/core" ]] && rm -rf ${HOME_PATH}/files/etc/openclash/core
fi
luci_path="$({ find "${HOME_PATH}/feeds" |grep 'luci-openclash' |grep 'root'; } 2>"/dev/null")"
if [[ -f "${luci_path}" ]] && [[ `grep -c "uci get openclash.config.enable" "${luci_path}"` -eq '0' ]]; then
  sed -i '/uci -q set openclash.config.enable=0/i\if [[ "\$(uci get openclash.config.enable)" == "0" ]] || [[ -z "\$(uci get openclash.config.enable)" ]]; then' "${luci_path}"
  sed -i '/uci -q commit openclash/a\fi' "${luci_path}"
fi

if [[ "${Enable_IPV6_function}" == "1" ]]; then
  echo "固件加入IPV6功能"
  export Create_Ipv6_Lan="0"
  export Enable_IPV4_function="0"
  echo "Create_Ipv6_Lan=0" >> ${GITHUB_ENV}
  echo "Enable_IPV4_function=0" >> ${GITHUB_ENV}
  echo "Enable_IPV6_function=1" >> ${GITHUB_ENV}
  echo "
    uci set network.lan.ip6assign='64'
    uci commit network
    uci set dhcp.lan.ra='server'
    uci set dhcp.lan.dhcpv6='server'
    uci set dhcp.lan.ra_management='1'
    uci set dhcp.lan.ra_default='1'
    uci set dhcp.@dnsmasq[0].localservice=0
    uci set dhcp.@dnsmasq[0].nonwildcard=0
    uci set dhcp.@dnsmasq[0].filter_aaaa='0'
    uci commit dhcp
  " >> "${DEFAULT_PATH}"
fi

if [[ "${Create_Ipv6_Lan}" == "1" ]]; then
  echo "爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息"
  export Enable_IPV4_function="0"
  echo "Create_Ipv6_Lan=1" >> ${GITHUB_ENV}
  echo "Enable_IPV4_function=0" >> ${GITHUB_ENV}
  echo "Enable_IPV6_function=0" >> ${GITHUB_ENV}
  echo "
    uci delete network.lan.ip6assign
    uci set network.lan.delegate='0'
    uci commit network
    uci delete dhcp.lan.ra
    uci delete dhcp.lan.ra_management
    uci delete dhcp.lan.ra_default
    uci delete dhcp.lan.dhcpv6
    uci delete dhcp.lan.ndp
    uci set dhcp.@dnsmasq[0].filter_aaaa='0'
    uci commit dhcp
    uci set network.ipv6=interface
    uci set network.ipv6.proto='dhcpv6'
    ${devicee}
    ${ifnamee}
    uci set network.ipv6.reqaddress='try'
    uci set network.ipv6.reqprefix='auto'
    uci commit network
    ${set_add}
    uci commit firewall
  " >> "${DEFAULT_PATH}"
fi

if [[ "${Enable_IPV4_function}" == "1" ]]; then
  echo "Enable_IPV4_function=1" >> ${GITHUB_ENV}
  echo "Enable_IPV6_function=0" >> ${GITHUB_ENV}
  echo "Create_Ipv6_Lan=0" >> ${GITHUB_ENV}
  echo "固件加入IPV4功能"
  echo "
    uci delete network.globals.ula_prefix
    uci delete network.lan.ip6assign
    uci delete network.wan6
    uci set network.lan.delegate='0' 
    uci commit network
    uci delete dhcp.lan.ra
    uci delete dhcp.lan.ra_management
    uci delete dhcp.lan.ra_default
    uci delete dhcp.lan.dhcpv6
    uci delete dhcp.lan.ndp
    uci set dhcp.@dnsmasq[0].filter_aaaa='1'
    uci commit dhcp
  " >> "${DEFAULT_PATH}"
fi

if [[ "${Default_theme}" == "0" ]] || [[ -z "${Default_theme}" ]]; then
  echo "Default_theme=0" >> ${GITHUB_ENV}
  echo "不进行,默认主题设置"
elif [[ -n "${Default_theme}" ]]; then
  echo "Default_theme=${Default_theme}" >> ${GITHUB_ENV}
fi

if [[ "${Customized_Information}" == "0" ]] || [[ -z "${Customized_Information}" ]]; then
  echo "不进行,个性签名设置"
elif [[ -n "${Customized_Information}" ]]; then
  sed -i "s?DESCRIPTION=.*?DESCRIPTION='OpenWrt '\" >> /etc/openwrt_release?g" "${ZZZ_PATH}"
  sed -i "s?OpenWrt ?${Customized_Information} OpenWrt Li [2025] Compiled by Li OpenWrt ?g" "${ZZZ_PATH}"
  echo "个性签名[${Customized_Information}]增加完成"
fi

if [[ -n "${Kernel_partition_size}" ]] && [[ "${Kernel_partition_size}" != "0" ]]; then
  echo "CONFIG_TARGET_KERNEL_PARTSIZE=${Kernel_partition_size}" >> ${HOME_PATH}/.config
  echo "内核分区设置完成，大小为：${Kernel_partition_size}MB"
else
  echo "不进行,内核分区大小设置"
fi

if [[ -n "${Rootfs_partition_size}" ]] && [[ "${Rootfs_partition_size}" != "0" ]]; then
  echo "CONFIG_TARGET_ROOTFS_PARTSIZE=${Rootfs_partition_size}" >> ${HOME_PATH}/.config
  echo "系统分区设置完成，大小为：${Rootfs_partition_size}MB"
else
  echo "不进行,系统分区大小设置"
fi

if [[ "${Delete_unnecessary_items}" == "1" ]]; then
   echo "Delete_unnecessary_items=${Delete_unnecessary_items}" >> ${GITHUB_ENV}
fi

if [[ "${Replace_Kernel}" == "0" ]] || [[ -z "${Replace_Kernel}" ]]; then
  echo "Replace_Kernel=0" >> ${GITHUB_ENV}
  echo "使用默认内核"
elif [[ -n "${Replace_Kernel}" ]]; then
  Replace_nel="$(echo ${Replace_Kernel} |grep -Eo "[0-9]+\.[0-9]+")"
  if [[ -n "${Replace_nel}" ]]; then
    echo "Replace_Kernel=${Replace_Kernel}" >> ${GITHUB_ENV}
    echo "修改源码默认内核为：${Replace_Kernel}"
  else
    echo "Replace_Kernel=0" >> ${GITHUB_ENV}
    echo "填写的内核格式错误,使用源码默认内核编译"
  fi
fi

if [[ "${Ipv4_ipaddr}" == "0" ]] || [[ -z "${Ipv4_ipaddr}" ]]; then
  echo "使用源码默认后台IP"
elif [[ -n "${Ipv4_ipaddr}" ]]; then
  Kernel_Pat="$(echo ${Ipv4_ipaddr} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  ipadd_Pat="$(echo ${ipadd} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${Kernel_Pat}" ]] && [[ -n "${ipadd_Pat}" ]]; then
     sed -i "s/${ipadd}/${Ipv4_ipaddr}/g" "${GENE_PATH}"
     echo "openwrt后台IP[${Ipv4_ipaddr}]修改完成"
   else
     echo "TIME r \"因IP获取有错误，后台IP更换不成功，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了\"" >> ${HOME_PATH}/CHONGTU
   fi
fi

if [[ "${Netmask_netm}" == "0" ]] || [[ -z "${Netmask_netm}" ]]; then
  echo "使用默认子网掩码"
elif [[ -n "${Netmask_netm}" ]]; then
  Kernel_netm="$(echo ${Netmask_netm} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  ipadd_mas="$(echo ${netmas} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${Kernel_netm}" ]] && [[ -n "${ipadd_mas}" ]]; then
     sed -i "s/${netmas}/${Netmask_netm}/g" "${GENE_PATH}"
     echo "子网掩码[${Netmask_netm}]修改完成"
   else
     echo "TIME r \"因子网掩码获取有错误，子网掩码设置失败，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了\"" >> ${HOME_PATH}/CHONGTU
  fi
fi

if [[ "${Op_name}" == "0" ]] || [[ -z "${Op_name}" ]]; then
  echo "使用源码默认主机名"
elif [[ -n "${Op_name}" ]] && [[ -n "${opname}" ]]; then
  sed -i "s/${opname}/${Op_name}/g" "${GENE_PATH}"
  echo "主机名[${Op_name}]修改完成"
fi

if [[ "${Gateway_Settings}" == "0" ]] || [[ -z "${Gateway_Settings}" ]]; then
  echo "不进行,网关设置"
elif [[ -n "${Gateway_Settings}" ]]; then
  Router_gat="$(echo ${Gateway_Settings} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${Router_gat}" ]]; then
    sed -i "$lan\set network.lan.gateway='${Gateway_Settings}'" "${GENE_PATH}"
    echo "网关[${Gateway_Settings}]修改完成"
  else
    echo "TIME r \"因子网关IP获取有错误，网关IP设置失败，请检查IP是否填写正确，如果填写正确，那就是获取不了源码内的IP了\"" >> ${HOME_PATH}/CHONGTU
  fi
fi

if [[ "${DNS_Settings}" == "0" ]] || [[ -z "${DNS_Settings}" ]]; then
  echo "不进行,DNS设置"
elif [[ -n "${DNS_Settings}" ]]; then
  ipa_dns="$(echo ${DNS_Settings} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${ipa_dns}" ]]; then
     sed -i "$lan\set network.lan.dns='${DNS_Settings}'" "${GENE_PATH}"
     echo "DNS[${DNS_Settings}]设置完成"
  else
    echo "TIME r \"因DNS获取有错误，DNS设置失败，请检查DNS是否填写正确\"" >> ${HOME_PATH}/CHONGTU
  fi
fi

if [[ "${Broadcast_Ipv4}" == "0" ]] || [[ -z "${Broadcast_Ipv4}" ]]; then
  echo "不进行,广播IP设置"
elif [[ -n "${Broadcast_Ipv4}" ]]; then
  IPv4_Bro="$(echo ${Broadcast_Ipv4} |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")"
  if [[ -n "${IPv4_Bro}" ]]; then
    sed -i "$lan\set network.lan.broadcast='${Broadcast_Ipv4}'" "${GENE_PATH}"
    echo "广播IP[${Broadcast_Ipv4}]设置完成"
  else
    echo "TIME r \"因IPv4 广播IP获取有错误，IPv4广播IP设置失败，请检查IPv4广播IP是否填写正确\"" >> ${HOME_PATH}/CHONGTU
  fi
fi

if [[ "${Disable_DHCP}" == "1" ]]; then
   sed -i "$lan\set dhcp.lan.ignore='1'" "${GENE_PATH}"
   echo "关闭DHCP设置完成"
fi

if [[ "${Disable_Bridge}" == "1" ]]; then
   sed -i "$lan\delete network.lan.type" "${GENE_PATH}"
   echo "去掉桥接设置完成"
fi

if [[ "${Ttyd_account_free_login}" == "1" ]]; then
   sed -i "$lan\set ttyd.@ttyd[0].command='/bin/login -f root'" "${GENE_PATH}"
   echo "TTYD免账户登录完成"
fi

if [[ "${Password_free_login}" == "1" ]]; then
   sed -i '/CYXluq4wUazHjmCDBCqXF/d' "${ZZZ_PATH}"
   echo "固件免密登录设置完成"
fi

if [[ "${Disable_53_redirection}" == "1" ]]; then
   sed -i '/to-ports 53/d' "${ZZZ_PATH}"
   echo "删除DNS重定向53端口完成"
fi

if [[ "${Cancel_running}" == "1" ]]; then
   echo "sed -i '/coremark/d' /etc/crontabs/root" >> "${DEFAULT_PATH}"
   echo "删除每天跑分任务完成"
fi

if [[ "${Disable_NaiveProxy}" == "1" ]]; then
  echo "Disable_NaiveProxy=1" >> ${GITHUB_ENV}
fi

if [[ "${Disable_autosamba}" == "1" ]]; then
  echo "Disable_autosamba=1" >> ${GITHUB_ENV}
fi

# 晶晨CPU机型自定义机型,内核,分区
echo "amlogic_model=${amlogic_model}" >> ${GITHUB_ENV}
echo "amlogic_kernel=${amlogic_kernel}" >> ${GITHUB_ENV}
echo "auto_kernel=${auto_kernel}" >> ${GITHUB_ENV}
echo "rootfs_size=${rootfs_size}" >> ${GITHUB_ENV}
echo "kernel_repo=ophub/kernel" >> ${GITHUB_ENV}
echo "kernel_usage=${kernel_usage}" >> ${GITHUB_ENV}
[[ -f "${GITHUB_ENV}" ]] && source ${GITHUB_ENV}


if [[ "${Mandatory_theme}" == "0" ]] || [[ -z "${Mandatory_theme}" ]]; then
  echo "不进行,替换bootstrap主题设置"
elif [[ -n "${Mandatory_theme}" ]]; then
  zt_theme="luci-theme-${Mandatory_theme}"
  if [[ `find . -type d -name "${zt_theme}" |grep -v 'dir' |grep -c "${zt_theme}"` -ge "1" ]]; then
    if [[ -f "${HOME_PATH}/extra/luci/collections/luci/Makefile" ]]; then
      zt2_theme="$(grep -Eo "luci-theme.*" "${HOME_PATH}/extra/luci/collections/luci/Makefile" |cut -d ' ' -f1)"
      [[ -n "${zt2_theme}" ]] && sed -i "s?${zt2_theme}?${zt_theme}?g" "${HOME_PATH}/extra/luci/collections/luci/Makefile"
    fi
    if [[ -f "${HOME_PATH}/feeds/luci/collections/luci/Makefile" ]]; then
      zt2_theme="$(grep -Eo "luci-theme.*" "${HOME_PATH}/feeds/luci/collections/luci/Makefile" |cut -d ' ' -f1)"
      [[ -n "${zt2_theme}" ]] && sed -i "s?${zt2_theme}?${zt_theme}?g" "${HOME_PATH}/feeds/luci/collections/luci/Makefile"
    fi
    if [[ -f "${HOME_PATH}/feeds/luci/collections/luci-light/Makefile" ]]; then
      zt2_theme="$(grep -Eo "luci-theme.*" "${HOME_PATH}/feeds/luci/collections/luci-light/Makefile" |cut -d ' ' -f1)"
      [[ -n "${zt2_theme}" ]] && sed -i "s?${zt2_theme}?${zt_theme}?g" "${HOME_PATH}/feeds/luci/collections/luci-light/Makefile"
    fi
    echo "替换必须主题完成,您现在的必选主题为：${zt_theme}"
  else
    echo "TIME r \"源码内没发现${zt_theme}此主题存在,不进行替换bootstrap主题操作\"" >> ${HOME_PATH}/CHONGTU
  fi
fi
}


function Diy_feeds() {
echo "正在执行：安装feeds,请耐心等待..."
cd ${HOME_PATH}
./scripts/feeds install -a

if [[ ! -f "${HOME_PATH}/staging_dir/host/bin/upx" ]]; then
  cp -Rf /usr/bin/upx ${HOME_PATH}/staging_dir/host/bin/upx
  cp -Rf /usr/bin/upx-ucl ${HOME_PATH}/staging_dir/host/bin/upx-ucl
fi
}


function Diy_IPv6helper() {
cd ${HOME_PATH}
if [[ "${Enable_IPV6_function}" == "1" ]] || [[ "${Create_Ipv6_Lan}" == "1" ]]; then
echo '
CONFIG_PACKAGE_ipv6helper=y
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
CONFIG_IPV6=y
CONFIG_PACKAGE_6rd=y
CONFIG_PACKAGE_6to4=y
' >> ${HOME_PATH}/.config
fi

if [[ "${Enable_IPV4_function}" == "1" ]]; then
echo '
# CONFIG_PACKAGE_ipv6helper is not set
# CONFIG_PACKAGE_ip6tables is not set
# CONFIG_PACKAGE_dnsmasq_full_dhcpv6 is not set
# CONFIG_PACKAGE_odhcp6c is not set
# CONFIG_PACKAGE_odhcpd-ipv6only is not set
# CONFIG_IPV6 is not set
# CONFIG_PACKAGE_6rd is not set
# CONFIG_PACKAGE_6to4 is not set
' >> ${HOME_PATH}/.config
fi

#if [[ "${Disable_NaiveProxy}" == "1" ]]; then
#sed -i '/NaiveProxy/d; /naiveproxy/d' ${HOME_PATH}/.config
#fi

if [[ "${Automatic_Mount_Settings}" == "1" ]]; then
echo '
CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_fdisk=y
CONFIG_PACKAGE_usbutils=y
CONFIG_PACKAGE_badblocks=y
CONFIG_PACKAGE_ntfs-3g=y
CONFIG_PACKAGE_kmod-scsi-core=y
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb-ohci=y
CONFIG_PACKAGE_kmod-usb-uhci=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-storage-extras=y
CONFIG_PACKAGE_kmod-usb2=y
CONFIG_PACKAGE_kmod-usb3=y
CONFIG_PACKAGE_kmod-fs-ext4=y
CONFIG_PACKAGE_kmod-fs-vfat=y
CONFIG_PACKAGE_kmod-fuse=y
# CONFIG_PACKAGE_kmod-fs-ntfs is not set
' >> ${HOME_PATH}/.config
mkdir -p ${HOME_PATH}/files/etc/hotplug.d/block
cp -Rf ${HOME_PATH}/build/common/custom/10-mount ${HOME_PATH}/files/etc/hotplug.d/block/10-mount
fi

if [[ "${Disable_autosamba}" == "1" ]]; then
sed -i '/luci-i18n-samba/d; /PACKAGE_samba/d; /SAMBA_MAX/d; /SAMBA4_SERVER/d' "${HOME_PATH}/.config"
echo '
# CONFIG_PACKAGE_autosamba is not set
# CONFIG_PACKAGE_luci-app-samba is not set
# CONFIG_PACKAGE_luci-app-samba4 is not set
# CONFIG_PACKAGE_samba36-server is not set
# CONFIG_PACKAGE_samba4-libs is not set
# CONFIG_PACKAGE_samba4-server is not set
' >> ${HOME_PATH}/.config
else
sed -i '/luci-app-samba/d; /CONFIG_PACKAGE_samba/d' "${HOME_PATH}/.config"
echo "CONFIG_PACKAGE_autosamba=y" >> ${HOME_PATH}/.config
fi

cat >> "${HOME_PATH}/.config" <<-EOF
CONFIG_PACKAGE_luci=y
CONFIG_PACKAGE_default-settings=y
CONFIG_PACKAGE_default-settings-chn=y
EOF
}


function Diy_prevent() {
cd ${HOME_PATH}
Diy_IPv6helper
echo "正在执行：判断插件有否冲突减少编译错误"
make defconfig > /dev/null 2>&1
if [[ `grep -c "CONFIG_PACKAGE_luci-app-ipsec-server=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-ipsec-vpnd=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-ipsec-vpnd=y/# CONFIG_PACKAGE_luci-app-ipsec-vpnd is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-ipsec-vpnd和luci-app-ipsec-server，插件有冲突，相同功能插件只能二选一，已删除luci-app-ipsec-vpnd\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-docker=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-dockerman=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-docker=y/# CONFIG_PACKAGE_luci-app-docker is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-docker-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-docker-zh-cn is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-docker和luci-app-dockerman，插件有冲突，相同功能插件只能二选一，已删除luci-app-docker\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-qbittorrent=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-qbittorrent-simple=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-qbittorrent-simple=y/# CONFIG_PACKAGE_luci-app-qbittorrent-simple is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-qbittorrent-simple-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-qbittorrent-simple-zh-cn is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_qbittorrent=y/# CONFIG_PACKAGE_qbittorrent is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-qbittorrent和luci-app-qbittorrent-simple，插件有冲突，相同功能插件只能二选一，已删除luci-app-qbittorrent-simple\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-advanced=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-fileassistant=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-fileassistant=y/# CONFIG_PACKAGE_luci-app-fileassistant is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-advanced和luci-app-fileassistant，luci-app-advanced已附带luci-app-fileassistant，所以删除了luci-app-fileassistant\"" >>CHONGTU
    echo "" >>CHONGTU
   fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-adblock-plus=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-adblock=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-adblock=y/# CONFIG_PACKAGE_luci-app-adblock is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_adblock=y/# CONFIG_PACKAGE_adblock is not set/g' ${HOME_PATH}/.config
    sed -i '/luci-i18n-adblock/d' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-adblock-plus和luci-app-adblock，插件有依赖冲突，只能二选一，已删除luci-app-adblock\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-kodexplorer=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-vnstat=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-vnstat=y/# CONFIG_PACKAGE_luci-app-vnstat is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_vnstat=y/# CONFIG_PACKAGE_vnstat is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_vnstati=y/# CONFIG_PACKAGE_vnstati is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_libgd=y/# CONFIG_PACKAGE_libgd is not set/g' ${HOME_PATH}/.config
    sed -i '/luci-i18n-vnstat/d' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-kodexplorer和luci-app-vnstat，插件有依赖冲突，只能二选一，已删除luci-app-vnstat\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

#if [[ `grep -c "CONFIG_PACKAGE_luci-app-ssr-plus=y" ${HOME_PATH}/.config` -ge '1' ]]; then
#  if [[ `grep -c "CONFIG_PACKAGE_luci-app-cshark=y" ${HOME_PATH}/.config` -eq '1' ]]; then
#    sed -i 's/CONFIG_PACKAGE_luci-app-cshark=y/# CONFIG_PACKAGE_luci-app-cshark is not set/g' ${HOME_PATH}/.config
#    sed -i 's/CONFIG_PACKAGE_cshark=y/# CONFIG_PACKAGE_cshark is not set/g' ${HOME_PATH}/.config
#    sed -i 's/CONFIG_PACKAGE_libustream-mbedtls=y/# CONFIG_PACKAGE_libustream-mbedtls is not set/g' ${HOME_PATH}/.config
#    echo "TIME r \"您同时选择luci-app-ssr-plus和luci-app-cshark，插件有依赖冲突，只能二选一，已删除luci-app-cshark\"" >>CHONGTU
#    echo "" >>CHONGTU
#  fi
#fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE_CM=y" ${HOME_PATH}/.config` -ge '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE=y/# CONFIG_PACKAGE_luci-app-turboacc_INCLUDE_SHORTCUT_FE is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_kmod-fast-classifier=y/# CONFIG_PACKAGE_kmod-fast-classifier is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"luci-app-turboacc同时选择Include Shortcut-FE CM和Include Shortcut-FE，有冲突，只能二选一，已删除Include Shortcut-FE\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_wpad-openssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_wpad=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_wpad=y/# CONFIG_PACKAGE_wpad is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_antfs-mount=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_ntfs3-mount=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_antfs-mount=y/# CONFIG_PACKAGE_antfs-mount is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_dnsmasq-full=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_dnsmasq=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_PACKAGE_dnsmasq-dhcpv6=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_dnsmasq=y/# CONFIG_PACKAGE_dnsmasq is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_dnsmasq-dhcpv6=y/# CONFIG_PACKAGE_dnsmasq-dhcpv6 is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-samba4=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-samba=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_autosamba=y/# CONFIG_PACKAGE_autosamba is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-samba=y/# CONFIG_PACKAGE_luci-app-samba is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-samba-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-samba-zh-cn is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_samba36-server=y/# CONFIG_PACKAGE_samba36-server is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-app-samba和luci-app-samba4，插件有冲突，相同功能插件只能二选一，已删除luci-app-samba\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
elif [[ `grep -c "CONFIG_PACKAGE_samba4-server=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo "# CONFIG_PACKAGE_samba4-admin is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_samba4-client is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_samba4-libs is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_samba4-server is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_samba4-utils is not set" >> ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-dockerman=y" ${HOME_PATH}/.config` -eq '0' ]] || [[ `grep -c "CONFIG_PACKAGE_luci-app-docker=y" ${HOME_PATH}/.config` -eq '0' ]]; then
  echo "# CONFIG_PACKAGE_luci-lib-docker is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_docker is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_dockerd is not set" >> ${HOME_PATH}/.config
  echo "# CONFIG_PACKAGE_runc is not set" >> ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  pmg="$(echo "$(date +%M)" | sed 's/^.//g')"
  mkdir -p ${HOME_PATH}/files/www/luci-static/argon/background
  curl -fsSL https://raw.githubusercontent.com/bootli/image/main/jpg/jpg/1.jpg -o ${HOME_PATH}/files/www/luci-static/argon/background/argon.jpg
  if [[ $? -ne 0 ]]; then
    echo "拉取文件错误,请检测网络"
    exit 1
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argon_new=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-theme-argon_new=y/# CONFIG_PACKAGE_luci-theme-argon_new is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-theme-argon和luci-theme-argon_new，插件有冲突，相同功能插件只能二选一，已删除luci-theme-argon_new\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-theme-argonne=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-theme-argonne=y/# CONFIG_PACKAGE_luci-theme-argonne is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您同时选择luci-theme-argon和luci-theme-argonne，插件有冲突，相同功能插件只能二选一，已删除luci-theme-argonne\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-sfe=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-flowoffload=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_DEFAULT_luci-app-flowoffload=y/# CONFIG_DEFAULT_luci-app-flowoffload is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-flowoffload=y/# CONFIG_PACKAGE_luci-app-flowoffload is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-i18n-flowoffload-zh-cn=y/# CONFIG_PACKAGE_luci-i18n-flowoffload-zh-cn is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"提示：您同时选择了luci-app-sfe和luci-app-flowoffload，两个ACC网络加速，已删除luci-app-flowoffload\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_libustream-wolfssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_libustream-openssl=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_libustream-wolfssl=y/# CONFIG_PACKAGE_libustream-wolfssl is not set/g' ${HOME_PATH}/.config
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockneteasemusic=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockneteasemusic-go=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-unblockneteasemusic-go=y/# CONFIG_PACKAGE_luci-app-unblockneteasemusic-go is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您选择了luci-app-unblockneteasemusic-go，会和luci-app-unblockneteasemusic冲突导致编译错误，已删除luci-app-unblockneteasemusic-go\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-unblockmusic=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_luci-app-unblockmusic=y/# CONFIG_PACKAGE_luci-app-unblockmusic is not set/g' ${HOME_PATH}/.config
    echo "TIME r \"您选择了luci-app-unblockmusic，会和luci-app-unblockneteasemusic冲突导致编译错误，已删除luci-app-unblockmusic\"" >>CHONGTU
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_TARGET_armvirt=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_armsr=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo -e "\nCONFIG_TARGET_ROOTFS_TARGZ=y" >> "${HOME_PATH}/.config"
  sed -i 's/CONFIG_PACKAGE_luci-app-autoupdate=y/# CONFIG_PACKAGE_luci-app-autoupdate is not set/g' ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_TARGET_x86=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_rockchip=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_bcm27xx=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo -e "\nCONFIG_PACKAGE_snmpd=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_TARGET_IMAGES_GZIP=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_PACKAGE_openssh-sftp-server=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_GRUB_IMAGES=y" >> "${HOME_PATH}/.config"
  if [[ `grep -c "CONFIG_TARGET_ROOTFS_PARTSIZE=" ${HOME_PATH}/.config` -eq '1' ]]; then
    PARTSIZE="$(grep -Eo "CONFIG_TARGET_ROOTFS_PARTSIZE=[0-9]+" ${HOME_PATH}/.config |cut -f2 -d=)"
    if [[ "${PARTSIZE}" -lt "400" ]];then
      sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${HOME_PATH}/.config
      echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=400" >> ${HOME_PATH}/.config
    fi
  fi
fi
if [[ `grep -c "CONFIG_TARGET_mxs=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_sunxi=y" ${HOME_PATH}/.config` -eq '1' ]] || [[ `grep -c "CONFIG_TARGET_zynq=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  echo -e "\nCONFIG_TARGET_IMAGES_GZIP=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_PACKAGE_openssh-sftp-server=y" >> "${HOME_PATH}/.config"
  echo -e "\nCONFIG_GRUB_IMAGES=y" >> "${HOME_PATH}/.config"
  if [[ `grep -c "CONFIG_TARGET_ROOTFS_PARTSIZE=" ${HOME_PATH}/.config` -eq '1' ]]; then
    PARTSIZE="$(grep -Eo "CONFIG_TARGET_ROOTFS_PARTSIZE=[0-9]+" ${HOME_PATH}/.config |cut -f2 -d=)"
    if [[ "${PARTSIZE}" -lt "400" ]];then
      sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${HOME_PATH}/.config
      echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=400" >> ${HOME_PATH}/.config
    fi
  fi
fi

if [[ `grep -c "CONFIG_PACKAGE_odhcp6c=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  sed -i '/CONFIG_PACKAGE_odhcpd=y/d' "${HOME_PATH}/.config"
  sed -i '/CONFIG_PACKAGE_odhcpd_full_ext_cer_id=0/d' "${HOME_PATH}/.config"
fi

if [[ "${AdGuardHome_Core}" == "1" ]]; then
  echo -e "\nCONFIG_PACKAGE_luci-app-adguardhome=y" >> ${HOME_PATH}/.config
fi

if [[ `grep -c "CONFIG_PACKAGE_dnsmasq_full_nftset=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  if [[ `grep -c "CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy=y" ${HOME_PATH}/.config` -eq '1' ]]; then
    sed -i 's/CONFIG_PACKAGE_dnsmasq_full_nftset=y/# CONFIG_PACKAGE_dnsmasq_full_nftset is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy=y/# CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy is not set/g' ${HOME_PATH}/.config
    sed -i 's/CONFIG_PACKAGE_nftables-json=y/# CONFIG_PACKAGE_nftables-json is not set/g' ${HOME_PATH}/.config
    echo "" >>CHONGTU
  fi
fi

if [[ `grep -c "CONFIG_TARGET_ROOTFS_EXT4FS=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  PARTSIZE="$(grep -Eo "CONFIG_TARGET_ROOTFS_PARTSIZE=[0-9]+" ${HOME_PATH}/.config |cut -f2 -d=)"
  if [[ "${PARTSIZE}" -lt "950" ]];then
    sed -i '/CONFIG_TARGET_ROOTFS_PARTSIZE/d' ${HOME_PATH}/.config
    echo -e "\nCONFIG_TARGET_ROOTFS_PARTSIZE=950" >> ${HOME_PATH}/.config
    echo "TIME r \"EXT4提示：请注意，您选择了ext4安装的固件格式,而检测到您的分配的固件系统分区过小\"" >> ${HOME_PATH}/CHONGTU
    echo "TIME y \"为避免编译出错,已自动帮您修改成950M\"" >> ${HOME_PATH}/CHONGTU
    echo "" >> ${HOME_PATH}/CHONGTU
  fi
fi

cd ${HOME_PATH}
make defconfig > /dev/null 2>&1
[[ ! -d "${HOME_PATH}/build_logo" ]] && mkdir -p ${HOME_PATH}/build_logo
./scripts/diffconfig.sh > ${HOME_PATH}/build_logo/config.txt

d="CONFIG_CGROUPFS_MOUNT_KERNEL_CGROUPS=y,CONFIG_DOCKER_CGROUP_OPTIONS=y,CONFIG_DOCKER_NET_MACVLAN=y,CONFIG_DOCKER_STO_EXT4=y, \
CONFIG_KERNEL_CGROUP_DEVICE=y,CONFIG_KERNEL_CGROUP_FREEZER=y,CONFIG_KERNEL_CGROUP_NET_PRIO=y,CONFIG_KERNEL_EXT4_FS_POSIX_ACL=y,CONFIG_KERNEL_EXT4_FS_SECURITY=y, \
CONFIG_KERNEL_FS_POSIX_ACL=y,CONFIG_KERNEL_NET_CLS_CGROUP=y,CONFIG_PACKAGE_btrfs-progs=y,CONFIG_PACKAGE_cgroupfs-mount=y, \
CONFIG_PACKAGE_containerd=y,CONFIG_PACKAGE_docker=y,CONFIG_PACKAGE_dockerd=y,CONFIG_PACKAGE_fdisk=y,CONFIG_PACKAGE_kmod-asn1-encoder=y,CONFIG_PACKAGE_kmod-br-netfilter=y, \
CONFIG_PACKAGE_kmod-crypto-rng=y,CONFIG_PACKAGE_kmod-crypto-sha256=y,CONFIG_PACKAGE_kmod-dax=y,CONFIG_PACKAGE_kmod-dm=y,CONFIG_PACKAGE_kmod-dummy=y,CONFIG_PACKAGE_kmod-fs-btrfs=y, \
CONFIG_PACKAGE_kmod-ikconfig=y,CONFIG_PACKAGE_kmod-keys-encrypted=y,CONFIG_PACKAGE_kmod-keys-trusted=y,CONFIG_PACKAGE_kmod-lib-raid6=y,CONFIG_PACKAGE_kmod-lib-xor=y, \
CONFIG_PACKAGE_kmod-lib-zstd=y,CONFIG_PACKAGE_kmod-nf-ipvs=y,CONFIG_PACKAGE_kmod-oid-registry=y,CONFIG_PACKAGE_kmod-random-core=y,CONFIG_PACKAGE_kmod-tpm=y, \
CONFIG_PACKAGE_kmod-veth=y,CONFIG_PACKAGE_libdevmapper=y,CONFIG_PACKAGE_liblzo=y,CONFIG_PACKAGE_libnetwork=y,CONFIG_PACKAGE_libseccomp=y,CONFIG_PACKAGE_luci-i18n-docker-zh-cn=y, \
CONFIG_PACKAGE_luci-i18n-dockerman-zh-cn=y,CONFIG_PACKAGE_luci-lib-docker=y,CONFIG_PACKAGE_mount-utils=y,CONFIG_PACKAGE_runc=y,CONFIG_PACKAGE_tini=y,CONFIG_PACKAGE_naiveproxy=y, \
CONFIG_PACKAGE_samba36-server=y,CONFIG_PACKAGE_samba4-libs=y,CONFIG_PACKAGE_samba4-server=y"
k=(${d//,/ })
for x in ${k[@]}; do \
  sed -i "/${x}/d" "${HOME_PATH}/build_logo/config.txt"; \
done
sed -i '/^$/d' "${HOME_PATH}/build_logo/config.txt"
}


function Make_defconfig() {
cd ${HOME_PATH}
echo "正在执行：识别源码编译为何机型"
export TARGET_BOARD="$(awk -F '[="]+' '/TARGET_BOARD/{print $2}' ${HOME_PATH}/.config)"
export TARGET_SUBTARGET="$(awk -F '[="]+' '/TARGET_SUBTARGET/{print $2}' ${HOME_PATH}/.config)"
export TARGET_PROFILE_DG="$(awk -F '[="]+' '/TARGET_PROFILE/{print $2}' ${HOME_PATH}/.config)"
if [[ -n "$(grep -Eo 'CONFIG_TARGET.*x86.*64.*=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="x86-64"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*x86.*=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="x86-32"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*armsr.*armv8.*=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="Armvirt_64"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*armvirt.*64.*=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="Armvirt_64"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*DEVICE.*=y' ${HOME_PATH}/.config)" ]]; then
  export TARGET_PROFILE="$(grep -Eo "CONFIG_TARGET.*DEVICE.*=y" ${HOME_PATH}/.config | sed -r 's/.*DEVICE_(.*)=y/\1/')"
else
  export TARGET_PROFILE="${TARGET_PROFILE_DG}"
fi
export FIRMWARE_PATH=${HOME_PATH}/bin/targets/${TARGET_BOARD}/${TARGET_SUBTARGET}
export TARGET_OPENWRT=openwrt/bin/targets/${TARGET_BOARD}/${TARGET_SUBTARGET}
echo "正在编译：${TARGET_PROFILE}"

if [[ "${SOURCE_CODE}" == "AMLOGIC" && "${PACKAGING_FIRMWARE}" == "true" ]]; then
  echo "PROMPT_TING=${amlogic_model}" >> ${GITHUB_ENV}
else
  echo "PROMPT_TING=${LUCI_EDITION}-${TARGET_PROFILE}" >> ${GITHUB_ENV}
fi

echo "TARGET_BOARD=${TARGET_BOARD}" >> ${GITHUB_ENV}
echo "TARGET_SUBTARGET=${TARGET_SUBTARGET}" >> ${GITHUB_ENV}
echo "TARGET_PROFILE=${TARGET_PROFILE}" >> ${GITHUB_ENV}
echo "FIRMWARE_PATH=${FIRMWARE_PATH}" >> ${GITHUB_ENV}
}



function Diy_upgrade2() {
cd ${HOME_PATH}
sed -i 's/^[ ]*//g' "${DEFAULT_PATH}"
sed -i '$a\exit 0' "${DEFAULT_PATH}"
sed -i 's/^[ ]*//g' "${ZZZ_PATH}"
sed -i '$a\exit 0' "${ZZZ_PATH}" 
[[ -d "${HOME_PATH}/files" ]] && sudo chmod +x ${HOME_PATH}/files
rm -rf ${HOME_PATH}/files/{LICENSE,.*README}
if [[ "${UPDATE_FIRMWARE_ONLINE}" == "true" ]]; then
  source ${BUILD_PATH}/upgrade.sh && Diy_Part2
fi
}


function openwrt_armvirt() {
cd ${GITHUB_WORKSPACE}
export FOLDER_NAME2="${GITHUB_WORKSPACE}/REPOSITORY"
export RELEVANCE="${FOLDER_NAME2}/build/${FOLDER_NAME}/relevance"

git clone -b main https://github.com/${GIT_REPOSITORY}.git ${FOLDER_NAME2}
if [[ ! -d "${RELEVANCE}" ]]; then
  mkdir -p "${RELEVANCE}"
fi

export YML_PATH="${FOLDER_NAME2}/.github/workflows/packaging.yml"
cp -Rf ${GITHUB_WORKSPACE}/.github/workflows/packaging.yml ${YML_PATH}
export PATHS1="$(grep -A 5 'paths:' "${YML_PATH}" |sed 's/^[ ]*//g' |grep -v "^#" |grep -Eo "\- '.*'" |cut -d"'" -f2 |awk 'NR==1')"
export PATHS2="build/${FOLDER_NAME}/relevance/armsrstart"
export SOURCE_NAME1="$(grep 'SOURCE:' "${YML_PATH}"|sed 's/^[ ]*//g' |grep -v "^#" |awk 'NR==1')"
export SOURCE_NAME2="SOURCE: ${SOURCE}"
export ER_NAME1="$(grep 'FOLDER_NAME:' "${YML_PATH}"|sed 's/^[ ]*//g' |grep -v "^#" |awk 'NR==1')"
export ER_NAME2="FOLDER_NAME: ${FOLDER_NAME}"


if [[ -n "${PATHS1}" ]] && [[ -n "${ER_NAME1}" ]] && [[ -n "${SOURCE_NAME1}" ]]; then
  sed -i "s?${PATHS1}?${PATHS2}?g" "${YML_PATH}"
  sed -i "s?${ER_NAME1}?${ER_NAME2}?g" "${YML_PATH}"
  sed -i "s?${SOURCE_NAME1}?${SOURCE_NAME2}?g" "${YML_PATH}"
else
  echo "获取变量失败,请勿胡乱修改pack_armvirt.yml文件"
  exit 1
fi

cat >"${RELEVANCE}/armsrstart" <<-EOF
Trigger packaging ${FOLDER_NAME} program-$(date +%Y%m%d%H%M%S)
EOF

cat >"${RELEVANCE}/${SOURCE}.ini" <<-EOF
amlogic_model="${amlogic_model}"
amlogic_kernel="${amlogic_kernel}"
auto_kernel="${auto_kernel}"
rootfs_size="${rootfs_size}"
kernel_repo="${kernel_repo}"
kernel_usage="${kernel_usage}"
FOLDER_NAME="${FOLDER_NAME}"
SOURCE="${SOURCE}"
UPLOAD_FIRMWARE="${UPLOAD_FIRMWARE}"
UPLOAD_RELEASE="${UPLOAD_RELEASE}"
UPLOAD_WETRANSFER="${UPLOAD_WETRANSFER}"
EOF

chmod -R +x ${FOLDER_NAME2}
cd ${FOLDER_NAME2}
git add .
git commit -m "启动打包Amlogic/Rockchip固件(${SOURCE}-${LUCI_EDITION})"
git push --force "https://${REPO_TOKEN}@github.com/${GIT_REPOSITORY}" HEAD:main
}

function firmware_jiance() {
if [[ "${TARGET_PROFILE}" == "Armvirt_64" ]] && [[ `ls -1 "${FIRMWARE_PATH}" |grep -c ".*.tar.gz"` -eq '1' ]] && [[ "${PACKAGING_FIRMWARE}" == "true" ]]; then
  mkdir -p "${HOME_PATH}/targz"
  cp -rf ${FIRMWARE_PATH}/*.tar.gz ${HOME_PATH}/targz/${SOURCE}-armvirt-64-default-rootfs.tar.gz
elif [[ "${TARGET_PROFILE}" == "Armvirt_64" ]] && [[ `ls -1 "${FIRMWARE_PATH}" |grep -c ".*.tar.gz"` -eq '0' ]] && [[ "${PACKAGING_FIRMWARE}" == "true" ]]; then
  echo "PACKAGING_FIRMWARE=false" >> ${GITHUB_ENV}
  TIME r "没发现armvirt-64-default-rootfs.tar.gz包存在，关闭自动打包操作"
fi
}

function Package_amlogic() {
echo "正在执行：打包Amlogic_Rockchip系列固件"
# 下载上游仓库
cd ${GITHUB_WORKSPACE}
[[ -d "${GITHUB_WORKSPACE}/amlogic" ]] && sudo rm -rf ${GITHUB_WORKSPACE}/amlogic
[[ ! -d "${HOME_PATH}/bin/targets/armvirt/64" ]] && mkdir -p "${HOME_PATH}/bin/targets/armvirt/64"
export FIRMWARE_PATH="${HOME_PATH}/bin/targets/armvirt/64"
[[ -z "${amlogic_model}" ]] && export amlogic_model="s905d"
[[ -z "${auto_kernel}" ]] && export auto_kernel="true"
[[ -z "${rootfs_size}" ]] && export rootfs_size="2560"
export kernel_repo="ophub/kernel"
[[ -z "${kernel_usage}" ]] && export kernel_usage="stable"
[[ -z "${UPLOAD_WETRANSFER}" ]] && export UPLOAD_WETRANSFER="true"
if [[ -z "${amlogic_kernel}" ]]; then
  curl -fsSL https://github.com/bootli/common/releases/download/API/${kernel_usage}.api -o ${HOME_PATH}/${kernel_usage}.api
  export amlogic_kernel="$(grep -Eo '"name": "[0-9]+\.[0-9]+\.[0-9]+\.tar.gz"' ${HOME_PATH}/${kernel_usage}.api |grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" |awk 'END {print}' |sed s/[[:space:]]//g)"
  [[ -z "${amlogic_kernel}" ]] && export amlogic_kernel="5.10.170"
fi
export gh_token="${REPO_TOKEN}"

echo "芯片型号：${amlogic_model}"
echo "使用内核：${amlogic_kernel}"
echo "自动检测：${auto_kernel}"
echo "rootfs大小：${rootfs_size}"
echo "内核仓库：${kernel_usage}"

git clone --depth 1 https://github.com/ophub/amlogic-s9xxx-openwrt.git ${GITHUB_WORKSPACE}/amlogic
[ ! -d ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt ] && mkdir -p ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt
if [[ `ls -1 "${FIRMWARE_PATH}" |grep -c ".*.tar.gz"` -eq '1' ]]; then
  cp -Rf ${FIRMWARE_PATH}/*.tar.gz ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt/openwrt-armvirt-64-default-rootfs.tar.gz && sync
else
  curl -H "Authorization: Bearer ${REPO_TOKEN}" https://api.github.com/repos/${GIT_REPOSITORY}/releases/tags/targz -o targz.api
  if [[ $? -ne 0 ]];then
    TIME r "下载api失败"
    exit 1
  fi
  if [[ `grep -c "${SOURCE}-armvirt-64-default-rootfs.tar.gz" "targz.api"` -eq '0' ]]; then
    TIME r "该链接 https://github.com/${GIT_REPOSITORY}/releases/tag/targz"
    TIME r "不存在 ${SOURCE}-armvirt-64-default-rootfs.tar.gz 包"
    exit 1
  else
    wget -q https://github.com/${GIT_REPOSITORY}/releases/download/targz/${SOURCE}-armvirt-64-default-rootfs.tar.gz -O ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt/openwrt-armvirt-64-default-rootfs.tar.gz
  fi
  if [[ $? -ne 0 ]];then
    TIME r "下载rootfs.tar.gz包失败,请检查网络"
    exit 1
  fi
fi

if [[ `ls -1 "${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt" |grep -c ".*default-rootfs.tar.gz"` -eq '1' ]]; then
  mkdir -p ${GITHUB_WORKSPACE}/amlogic/temp_dir
  cp -Rf ${GITHUB_WORKSPACE}/amlogic/openwrt-armvirt/*default-rootfs.tar.gz ${GITHUB_WORKSPACE}/amlogic/temp_dir/openwrt-armvirt-64-default-rootfs.tar.gz && sync
  tar -xzf ${GITHUB_WORKSPACE}/amlogic/temp_dir/openwrt-armvirt-64-default-rootfs.tar.gz -C amlogic/temp_dir/
  if [[ `grep -c "DISTRIB_SOURCECODE" ${GITHUB_WORKSPACE}/amlogic/temp_dir/etc/openwrt_release` -eq '1' ]]; then
    source_codename="$(cat "${GITHUB_WORKSPACE}/amlogic/temp_dir/etc/openwrt_release" 2>/dev/null | grep -oE "^DISTRIB_SOURCECODE=.*" | head -n 1 | cut -d"'" -f2)"
    echo "source_codename=${source_codename}" >> ${GITHUB_ENV}
    sudo rm -rf ${GITHUB_WORKSPACE}/amlogic/temp_dir
  else
    source_codename="armvirt"
    echo "source_codename=${source_codename}" >> ${GITHUB_ENV}
    sudo rm -rf ${GITHUB_WORKSPACE}/amlogic/temp_dir
  fi
else
  TIME r "没发现openwrt-armvirt-64-default-rootfs.tar.gz固件存在"
  exit 1
fi

echo "开始打包"
cd ${GITHUB_WORKSPACE}/amlogic
sudo chmod +x make
if [[ -z "${gh_token}" ]]; then
  sudo ./make -b ${amlogic_model} -k ${amlogic_kernel} -a ${auto_kernel} -s ${rootfs_size} -r ${kernel_repo} -u ${kernel_usage}
else
  sudo ./make -b ${amlogic_model} -k ${amlogic_kernel} -a ${auto_kernel} -s ${rootfs_size} -r ${kernel_repo} -u ${kernel_usage}
fi
if [[ 0 -eq $? ]]; then
  sudo mv -f ${GITHUB_WORKSPACE}/amlogic/openwrt/out/* ${FIRMWARE_PATH}/ && sync
  sudo rm -rf ${GITHUB_WORKSPACE}/amlogic
  echo "FIRMWARE_PATH=${FIRMWARE_PATH}" >> ${GITHUB_ENV}
  echo
  TIME l "[OK] 固件打包完成,已将固件存入[openwrt/bin/targets/armvirt/64]文件夹内"
else
  TIME r "固件打包失败"
fi
}


function Diy_upgrade3() {
if [ "${UPDATE_FIRMWARE_ONLINE}" == "true" ]; then
  cd ${HOME_PATH}
  source ${BUILD_PATH}/upgrade.sh && Diy_Part3
fi
}


function Diy_organize() {
cd ${FIRMWARE_PATH}
if [[ -d "${PACKAGED_OUTPUTPATH}" ]]; then
  sudo mv -f ${PACKAGED_OUTPUTPATH}/* ${FIRMWARE_PATH}/ && sync
fi
mkdir -p ipk
cp -rf $(find ${HOME_PATH}/bin/packages/ -type f -name "*.ipk") ipk/ && sync
sudo tar -czf ipk.tar.gz ipk && sync && sudo rm -rf ipk
if [[ `ls -1 | grep -c "immortalwrt"` -ge '1' ]]; then
  rename -v "s/^immortalwrt/openwrt/" *
  sed -i 's/immortalwrt/openwrt/g' `egrep "immortalwrt" -rl ./`
fi

for X in $(cat ${CLEAR_PATH} |sed "s/.*${TARGET_BOARD}//g"); do
  rm -rf *"$X"*
done

if [[ `ls -1 | grep -c "armvirt"` -eq '0' ]]; then
  rename -v "s/^openwrt/${Gujian_Date}-${SOURCE}-${LUCI_EDITION}-${LINUX_KERNEL}/" *
fi
sudo rm -rf "${CLEAR_PATH}"
}


function Diy_firmware() {
echo "正在执行：整理固件,您不想要啥就删啥,删删删"
echo "需要配合${DIY_PART_SH}文件设置使用"
echo
if [[ "${PACKAGING_FIRMWARE}" == "true" ]] && [[ -z "${BENDI_VERSION}" ]]; then
  # 打包固件转换仓库
  openwrt_armvirt
fi
Diy_upgrade3
Diy_organize
}


function build_openwrt() {
# 触发compile.yml文件启动
cd ${GITHUB_WORKSPACE}
start_path="${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/relevance/settings.ini"
chmod -R +x ${start_path} && source ${start_path}
if [[ "${CPU_SELECTION}" =~ (E5|false) ]]; then
  kaisbianyixx="弃用E5-编译"
else
  kaisbianyixx="使用${CPU_SELECTION}-编译"
fi
git clone https://user:${REPO_TOKEN}@github.com/${GIT_REPOSITORY}.git UPLOAD
mkdir -p "UPLOAD/build/${FOLDER_NAME}/relevance"
mv ${start_path} UPLOAD/build/${FOLDER_NAME}/relevance/settings.ini
export YML_PATH="UPLOAD/.github/workflows/compile.yml"
cp -Rf ${GITHUB_WORKSPACE}/.github/workflows/compile.yml ${YML_PATH}
export TARGET1="$(grep 'target: \[' "${YML_PATH}" |sed 's/^[ ]*//g' |grep -v '^#' |sed 's/\[/\\&/' |sed 's/\]/\\&/')"
export TARGET2="target: \\[${FOLDER_NAME}\\]"
export PATHS1="$(grep -Eo "\- '.*'" "${YML_PATH}" |sed 's/^[ ]*//g' |grep -v "^#" |awk 'NR==1')"
export PATHS2="- 'build/${FOLDER_NAME}/relevance/start'"
if [[ -n "${PATHS1}" ]] && [[ -n "${TARGET1}" ]]; then
  sed -i "s?${PATHS1}?${PATHS2}?g" "${YML_PATH}"
  sed -i "s?${TARGET1}?${TARGET2}?g" "${YML_PATH}"
else
  echo "获取变量失败,请勿胡乱修改compile.yml文件"
  exit 1
fi
cp -Rf ${HOME_PATH}/build_logo/config.txt UPLOAD/build/${FOLDER_NAME}/${CONFIG_FILE}
echo "${SOURCE}-${REPO_BRANCH}-${CONFIG_FILE}-$(date +%Y年%m月%d号%H时%M分%S秒)" > UPLOAD/build/${FOLDER_NAME}/relevance/start

cd UPLOAD
BRANCH_HEAD="$(git rev-parse --abbrev-ref HEAD)"
git add .
git commit -m "${kaisbianyixx}-${FOLDER_NAME}-${LUCI_EDITION}-${TARGET_PROFILE}固件"
git push --force "https://${REPO_TOKEN}@github.com/${GIT_REPOSITORY}" HEAD:${BRANCH_HEAD}
}


function CPU_Priority() {
# 检测CPU型号,不是所选型号就重新触发启动
export TARGET_BOARD="$(awk -F '[="]+' '/TARGET_BOARD/{print $2}' build/${FOLDER_NAME}/${CONFIG_FILE})"
export TARGET_SUBTARGET="$(awk -F '[="]+' '/TARGET_SUBTARGET/{print $2}' build/${FOLDER_NAME}/${CONFIG_FILE})"
if [[ -n "$(grep -Eo 'CONFIG_TARGET.*x86.*64.*=y' build/${FOLDER_NAME}/${CONFIG_FILE})" ]]; then
  export TARGET_PROFILE="x86-64"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*x86.*=y' build/${FOLDER_NAME}/${CONFIG_FILE})" ]]; then
  export TARGET_PROFILE="x86-32"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*armsr.*armv8.*=y' build/${FOLDER_NAME}/${CONFIG_FILE})" ]]; then
  export TARGET_PROFILE="Armvirt_64"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*armvirt.*64.*=y' build/${FOLDER_NAME}/${CONFIG_FILE})" ]]; then
  export TARGET_PROFILE="Armvirt_64"
elif [[ -n "$(grep -Eo 'CONFIG_TARGET.*DEVICE.*=y' build/${FOLDER_NAME}/${CONFIG_FILE})" ]]; then
  export TARGET_PROFILE="$(grep -Eo "CONFIG_TARGET.*DEVICE.*=y" build/${FOLDER_NAME}/${CONFIG_FILE} | sed -r 's/.*DEVICE_(.*)=y/\1/')"
else
  export TARGET_PROFILE="$(cat "build/${FOLDER_NAME}/${CONFIG_FILE}" |grep "CONFIG_TARGET_.*=y" |awk 'END {print}'|sed "s/CONFIG_TARGET_//g"|sed "s/=y//g")"
fi

cpu_model=`cat /proc/cpuinfo  |grep 'model name' |gawk -F : '{print $2}' | uniq -c  | sed 's/^ \+[0-9]\+ //g'`
TIME y "正在使用CPU型号：${cpu_model}"

start_path="${GITHUB_WORKSPACE}/build/${FOLDER_NAME}/relevance/settings.ini"
chmod -R +x ${start_path} && source ${start_path}

case "${CPU_SELECTION}" in
false)
  if [[ `echo "${cpu_model}" |grep -ic "E5"` -eq '1' ]]; then
    export chonglaixx="E5-重新编译"
    export chonglaiss="是E5的CPU"
    export Continue_selecting="1"
  else
    TIME g " 恭喜,不是E5系列的CPU啦"
    export Continue_selecting="0"
  fi
;;
8370|8272|8171)
  if [[ `echo "${cpu_model}" |grep -ic "${CPU_SELECTION}"` -eq '0' ]]; then
    export chonglaixx="非${CPU_SELECTION}-重新编译"
    export chonglaiss="并非是您选择的${CPU_SELECTION}CPU"
    export Continue_selecting="1"
  else
    TIME g " 恭喜,正是您想要的${CPU_SELECTION}CPU"
    export Continue_selecting="0"
  fi
;;
*)
  echo "${CPU_SELECTION},变量检测有错误"
  export Continue_selecting="0"
;;
esac

if [[ "${Continue_selecting}" == "1" ]]; then
  cd ${GITHUB_WORKSPACE}
  git clone https://github.com/${GIT_REPOSITORY}.git UPLOADCPU
  mkdir -p "UPLOADCPU/build/${FOLDER_NAME}/relevance"
  rm -rf UPLOADCPU/build/${FOLDER_NAME}
  cp -Rf build/${FOLDER_NAME} UPLOADCPU/build/${FOLDER_NAME}
  rm -rf UPLOADCPU/build/${FOLDER_NAME}/*.sh
  cp -Rf build/${FOLDER_NAME}/${DIY_PART_SH} UPLOADCPU/build/${FOLDER_NAME}/${DIY_PART_SH}
  rm -rf UPLOADCPU/.github/workflows
  cp -Rf .github/workflows UPLOADCPU/.github/workflows
  echo "${SOURCE}-${REPO_BRANCH}-${CONFIG_FILE}-$(date +%Y年%m月%d号%H时%M分%S秒)" > UPLOADCPU/build/${FOLDER_NAME}/relevance/start
  echo "DEVICE_NUMBER=${RUN_NUMBER}" > UPLOADCPU/build/${FOLDER_NAME}/relevance/run_number
  echo "chonglaiss=${chonglaiss}" >> UPLOADCPU/build/${FOLDER_NAME}/relevance/run_number
  
  cd UPLOADCPU
  BRANCH_HEAD="$(git rev-parse --abbrev-ref HEAD)"
  git add .
  git commit -m "${chonglaixx}-${FOLDER_NAME}-${LUCI_EDITION}-${TARGET_PROFILE}固件"
  git push --force "https://${REPO_TOKEN}@github.com/${GIT_REPOSITORY}" HEAD:${BRANCH_HEAD}
  exit 1
fi
}

function Diy_delruns() {
cd ${GITHUB_WORKSPACE}
sudo apt-get -qq update && sudo apt-get -qq install -y jq curl
if [[ -f "build/${FOLDER_NAME}/relevance/run_number" ]]; then
  DEVICE_NUMBER="$(grep "DEVICE_NUMBER" build/${FOLDER_NAME}/relevance/run_number |cut -d"=" -f2)"
  chonglaiss="$(grep "chonglaiss" build/${FOLDER_NAME}/relevance/run_number |cut -d"=" -f2)"
  DIY_DELRUN="YES"
else
  DIY_DELRUN="NO"
fi
case "${DIY_DELRUN}" in
YES)
all_workflows_list="josn_api_workflows"
curl -s \
-H "Accept: application/vnd.github+json" \
-H "Authorization: Bearer ${REPO_TOKEN}" \
https://api.github.com/repos/${GIT_REPOSITORY}/actions/runs |
jq -c '.workflow_runs[] | select(.conclusion == "failure") | {date: .updated_at, id: .id, name: .name, run_number: .run_number}' \
>${all_workflows_list}
if [[ -n "$(cat "${all_workflows_list}" |grep "${DEVICE_NUMBER}")" ]]; then
  cat ${all_workflows_list} |grep "${DEVICE_NUMBER}" > josn_api
fi
if [[ -f "josn_api" && -n "$(cat josn_api | jq -r .id)" ]]; then
  cat josn_api | jq -r .id | while read run_id; do
    {
      curl -s \
      -X DELETE \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${REPO_TOKEN}" \
      https://api.github.com/repos/${GIT_REPOSITORY}/actions/runs/${run_id}
    }
  done
  TIME y "已清理因筛选服务器CPU而停止的工作流程(编号:${DEVICE_NUMBER})，因为这${chonglaiss}"
fi
;;
NO)
  echo
;;
*)
  echo
;;
esac
}


function Diy_xinxi() {
# 信息
Plug_in1="$(grep -Eo "CONFIG_PACKAGE_luci-app-.*=y|CONFIG_PACKAGE_luci-theme-.*=y" .config |grep -v 'INCLUDE\|_Proxy\|_static\|_dynamic' |sed 's/=y//' |sed 's/CONFIG_PACKAGE_//g')"
Plug_in2="$(echo "${Plug_in1}" |sed 's/^/、/g' |sed 's/$/\"/g' |awk '$0=NR$0' |sed 's/^/TIME g \"       /g')"
echo "${Plug_in2}" >Plug-in

if [[ `grep -c "CONFIG_GRUB_EFI_IMAGES=y" ${HOME_PATH}/.config` -eq '1' ]]; then
  export EFI_NO="1"
else
  export EFI_NO="0"
fi

echo
TIME b "编译源码: ${SOURCE}"
TIME b "源码链接: ${REPO_URL}"
TIME b "源码分支: ${REPO_BRANCH}"
TIME b "源码作者: ${SOURCE_OWNER}"
TIME b "Luci版本: ${LUCI_EDITION}"
if [[ "${AMLOGIC_CODE}" == "AMLOGIC" ]]; then
  TIME b "编译机型: 晶晨系列"
  if [[ "${PACKAGING_FIRMWARE}" == "true" ]]; then
     TIME g "打包机型: ${amlogic_model}"
     TIME g "打包内核: ${amlogic_kernel}"
     TIME g "分区大小: ${rootfs_size}"
     if [[ "${auto_kernel}" == "true" ]]; then
       TIME g "自动检测最新内核: 是"
     else
       TIME g "自动检测最新内核: 不是"
     fi
  else
     TIME b "内核版本: ${LINUX_KERNEL}"
     TIME r "自动打包: 没开启自动打包设置"
  fi
else
  TIME b "内核版本: ${LINUX_KERNEL}"
  TIME b "编译机型: ${TARGET_PROFILE}"
fi
TIME b "固件作者: ${GIT_ACTOR}"
TIME b "仓库地址: ${GITHUB_LINK}"
TIME b "启动编号: #${RUN_NUMBER}（${WAREHOUSE_MAN}仓库第${RUN_NUMBER}次启动[${RUN_WORKFLOW}]工作流程）"
TIME b "编译时间: ${Compte_Date}"
if [[ "${SOURCE_CODE}" == "AMLOGIC" && "${PACKAGING_FIRMWARE}" == "true" ]]; then
  TIME g "友情提示：您当前使用【${FOLDER_NAME}】文件夹编译【${amlogic_model}】固件"
else
  TIME g "友情提示：您当前使用【${FOLDER_NAME}】文件夹编译【${TARGET_PROFILE}】固件"
fi
echo
echo
if [[ ${INFORMATION_NOTICE} == "TG" ]] || [[ ${INFORMATION_NOTICE} == "PUSH" ]]; then
  TIME y "pushplus/Telegram通知: 开启"
else
  TIME r "pushplus/Telegram通知: 关闭"
fi
if [[ ${UPLOAD_FIRMWARE} == "true" ]]; then
  TIME y "上传固件在github actions: 开启"
else
  TIME r "上传固件在github actions: 关闭"
fi
if [[ ${UPLOAD_RELEAS} == "true" ]]; then
  TIME y "发布固件(Releases): 开启"
else
  TIME r "发布固件(Releases): 关闭"
fi
if [[ ${CACHEWRTBUILD_SWITCH} == "true" ]]; then
  TIME y "是否开启缓存加速: 开启"
else
  TIME r "是否开启缓存加速: 关闭"
fi
if [[ ${COMPILATION_INFORMATION} == "true" ]]; then
  TIME y "编译信息显示: 开启"
fi
if [[ ${AMLOGIC_CODE} == "AMLOGIC" ]]; then
  if [[ ${PACKAGING_FIRMWARE} == "true" ]]; then
    TIME y "N1和晶晨系列固件自动打包成 .img 固件: 开启"
  else
    TIME r "N1和晶晨系列固件自动打包成 .img 固件: 关闭"
  fi
else
  if [[ ${UPDATE_FIRMWARE_ONLINE} == "true" ]]; then
    TIME y "把定时自动更新插件编译进固件: 开启"
  else
    TIME r "把定时自动更新插件编译进固件: 关闭"
  fi
fi
if [[ "${UPDATE_FIRMWARE_ONLINE}" == "true" ]] && [[ -z "${REPO_TOKEN}" ]]; then
  echo
  echo
  TIME r "您虽然开启了编译在线更新固件操作,但是您的[REPO_TOKEN]密匙为空,"
  TIME r "无法将固件发布至云端,已为您自动关闭了编译在线更新固件"
  echo
elif [[ "${UPDATE_FIRMWARE_ONLINE}" == "true" ]] && [[ -n "${REPO_TOKEN}" ]]; then
  echo
  TIME l "定时自动更新信息"
  TIME z "插件版本: ${AutoUpdate_Version}"
  if [[ ${TARGET_BOARD} == "x86" ]]; then
    TIME b "传统固件: ${AutoBuild_Legacy}${Firmware_SFX}"
    [[ "${EFI_NO}" == "1" ]] && TIME b "UEFI固件: ${AutoBuild_Uefi}${Firmware_SFX}"
  else
    TIME b "固件名称: ${AutoBuild_Firmware}${Firmware_SFX}"
  fi
  TIME b "固件后缀: ${Firmware_SFX}"
  TIME b "固件版本: ${Openwrt_Version}"
  TIME b "云端路径: ${Github_Release}"
  TIME g "《编译成功后，会自动把固件发布到指定地址，然后才会生成云端路径》"
  TIME g "《普通的那个发布固件跟云端的发布路径是两码事，如果你不需要普通发布的可以不用打开发布功能》"
  TIME g "修改IP、DNS、网关或者在线更新，请输入命令：openwrt"
  echo
else
  echo
fi
echo
TIME z " 系统空间      类型   总数  已用  可用 使用率"
df -hT $PWD
echo
echo

if [[ -s "${HOME_PATH}/CHONGTU" ]]; then
  echo
  echo
  TIME b "			错误信息"
  echo
  chmod -R +x ${HOME_PATH}/CHONGTU
  source ${HOME_PATH}/CHONGTU
fi
rm -rf ${HOME_PATH}/CHONGTU
if [ -n "$(ls -A "${HOME_PATH}/Plug-in" 2>/dev/null)" ]; then
  echo
  echo
  TIME r "	      已选插件列表"
  chmod -R +x ${HOME_PATH}/Plug-in
  source ${HOME_PATH}/Plug-in
  rm -rf ${HOME_PATH}/{Plug-in,Plug-2}
  echo
fi
}

function Diy_menu6() {
Diy_prevent
Make_defconfig
Diy_upgrade2
}

function Diy_menu5() {
Diy_feeds
Diy_IPv6helper
}

function Diy_menu4() {
Diy_zdypartsh
Diy_Publicarea
}

function Diy_menu3() {
Diy_checkout
Diy_Wenjian
Diy_${SOURCE_CODE}
}

function Diy_menu2() {
Diy_Notice
}

function Diy_menu1() {
Diy_variable
}
