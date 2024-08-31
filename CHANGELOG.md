# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [1.0.0] - 2024-08-26





## [4.0.0] - 2024-08-31---14：02

### Added

- 新增“在清零的时候不会导致设置的药瓶数和药瓶容量被清零”逻辑。
- 新增部分信号相关的注释。

### Remove

- 删除了Decoder_2to4这一模块，因为SET这个信号可以替代其作用。
- 删除了make_fre这一模块，因为它确实没什么用。

### Changed

- 为了使得全满信号得以同步，将MOD_MAX,full,all_slice三个模块于以合并，并修正部分计数错误逻辑。



## [4.0.1] - 2024-08-31---14：02

### Added
- 新增间隔计数功能。