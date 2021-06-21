# Mac OS 配置

## 其他

```bash
# 清除系统 DNS 缓存
sudo killall -HUP mDNSResponder

# 清除 Chrome 浏览器缓存
chrome://net-internals/#dnsChrome


```

### SSH登陆超时后自动断开

```bash
# sudo vim /etc/ssh/ssh_config
# Host * 
#   ServerAliveInterval 60  表示每分钟发送一次, 然后服务端响应, 从而保持长连接
#   ServerAliveCountMax 5   请求后服务端没有响应的次数达到5次, 就自动断开
ServerAliveInterval 60  
ServerAliveCountMax 5
```

### V2rayU 闪退处理

> 项目地址： https://github.com/yanue/V2rayU/tree/master
>> Subscribe： https://proxypoolss.tk

问题描述： 在配置完订阅链接后出现闪退并无法再次打开的情况
参考解决方案： https://github.com/yanue/V2rayU/tree/master#%E7%9B%B8%E5%85%B3%E9%97%AE%E9%A2%98
执行 `rm ~/Library/Preferences/net.yanue.V2rayU.plist` 后可以重新运行



## 系统项优化

```bash
# 将当前目录路径显示在 Finder 窗口标题
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# 按名称排序时，将文件夹放在最前面
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# 搜索时默认搜索当前文件夹的内容
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# 更改文件扩展名时禁用警告
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# 避免在 网络位置 和 USB 设备上创建 .DS_Store 文件
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# 接入外部存储设备后自动打开新的 Finder 窗口
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

＃ 在清空垃圾箱之前禁用警告
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# 自动隐藏和显示Dock
defaults write com.apple.dock autohide -bool true

＃ 不要在Dock中显示最近的应用程序
defaults write com.apple.dock show-recents -bool false

＃ 请勿将搜索查询发送给 Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# 在 Safari 显示完整的 URL
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

＃ 在 Safari 中启用“开发”菜单和Web检查器
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# 邮件地址拷贝优化
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

＃ 显示活动监视器中的所有进程
defaults write com.apple.ActivityMonitor ShowCategory -int 0

＃ 在 Mac App Store 中启用 WebKit开发人员工具
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

＃ 防止在插入设备后自动打开照片
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

＃ 禁用连续拼写检查
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

＃ 在 Chrome 中使用系统本地预览
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

＃ 设置计算机名称
sudo scutil --set ComputerName "hui"
sudo scutil --set HostName "hui"
sudo scutil --set LocalHostName "hui"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "hui"

＃ 禁用 “确定要打开此应用程序吗？” 对话
defaults write com.apple.LaunchServices LSQuarantine -bool false

＃ 禁用自动更正
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

```


