#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.6.1/192.168.21.254/g' package/base-files/files/bin/config_generate

# theme
rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Enable USB power for Cudy TR3000 by default
sed -i '/modem-power/,/};/{s/gpio-export,output = <1>;/gpio-export,output = <0>;/}' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1.dtsi

# 修改 分区大小，默认 mod 分区大小为 112MB：0x7000000。改为 114MB：0x7200000  version > 24.10.2
sed -i '/&ubi/ { n; s/reg = <0x5c0000 0x[0-9a-f]\+>;/reg = <0x5c0000 0x7200000>;/; }' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1-ubootmod.dts
sed -i 's/\(model = "Cudy TR3000 v1 ubi \)112M\(";\)/\1114M\2/' target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1-ubootmod.dts

echo "target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1-ubootmod.dts"
cat target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1-ubootmod.dts 

# 创建存储二进制文件的目录
BIN_DIR="$GITHUB_WORKSPACE/openwrt/bin/targets/mediatek/filogic/"
mkdir -p "$BIN_DIR"
