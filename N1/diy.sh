#!/bin/bash

# Add packages
git clone https://github.com/ophub/luci-app-amlogic --depth=1 clone/amlogic
#git clone https://github.com/xiaorouji/openwrt-passwall --depth=1 clone/passwall

# Update packages
#rm -rf feeds/luci/applications/luci-app-passwall
cp -rf clone/amlogic/luci-app-amlogic feeds/luci/applications/

# add luci-app-mosdns
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
rm -rf feeds/packages/net/v2ray-geodata
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# => OpenClash
rm -rf feeds/luci/applications/luci-app-openclash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/OpenClash
#merge_package https://github.com/vernesong/OpenClash OpenClash/luci-app-openclash

# => Open-nikki
git clone https://github.com/nikkinikki-org/OpenWrt-nikki -b main package/nikki
echo "CONFIG_PACKAGE_luci-app-nikki=y" >> .config
echo "CONFIG_PACKAGE_luci-i18n-nikki-zh-cn=y" >> .config
./scripts/feeds update -a
./scripts/feeds install luci-app-nikki

# 修改默认IP
sed -i 's/192.168.1.1/192.168.2.8/g' package/base-files/files/bin/config_generate

#修改默认时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")

# 修改主机名
sed -i 's/ImmortalWrt/N1/g' package/base-files/files/bin/config_generate


# Clean packages
rm -rf clone
