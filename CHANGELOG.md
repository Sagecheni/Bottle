# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [1.0.0] - 2024-08-27
### Added
- 计数，设置，清零以及翻页显示功能的主体实现完成。

### Waited
- 声音模块

## [2.0.0] - 2024-08-29
### Added
- 新增警报模块。

### Changed
- 优化了部分代码存在的问题，添加了部分注释。

### Waited
- 计数逻辑存在问题：到最大瓶数的时候计数器并没停止。
- 设置时对应位置的闪烁功能待实现。
- 警报模块无法发声。

## [3.0.0] - 2024-08-30 中期检查

### Changed
- 修复警报模块，可以正常发声。--- 推测问题为箱子引脚存在问题。

### Waited
- allFull信号发出后不能直接立即计数，会继续计数两个。--- 推测为Allfull信号在MOD_MAX、full、slice三个模块的传递存在延迟。

## [4.0.0] - 2024-08-31

### Added

- 新增“在清零的时候不会导致设置的药瓶数和药瓶容量被清零”逻辑。
- 新增部分信号相关的注释。
- 新增间隔计数功能。

### Removed

- 删除了Decoder_2to4这一模块，因为SET这个信号可以替代其作用。
- 删除了make_fre这一模块，因为它确实没什么用。

### Changed

- 为了使得全满信号得以同步，将MOD_MAX,full,all_slice三个模块于以合并，并修正部分计数错误逻辑。


## [5.0.0] - 2024-09-02

### Changed
- 修正了SET=1下无法清零计数的问题。