# 🗑 trash

[![][swift-versions]][swiftpackageindex]
[![][platforms]][swiftpackageindex]
[![][tag]][repo]

Pure Swift CLI to move objects to the trash in the same manner as the Finder.\
You can `Undo` or `⌘+Z` to put back.

## Build

1. Clone this repository
2. Inside the root of the local copy, `swift build -c release`
3. Binary is located at `.build/release/approle`

## Usage

```sh
> trash <Object-Path>...
```

```sh
> STDOUT | trash
```


[repo]: https://github.com/aerobounce/trash.swift
[swiftpackageindex]: https://swiftpackageindex.com/aerobounce/trash.swift

[swift-versions]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Faerobounce%2Ftrash.swift%2Fbadge%3Ftype%3Dswift-versions
[platforms]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Faerobounce%2Ftrash.swift%2Fbadge%3Ftype%3Dplatforms
[tag]: https://img.shields.io/github/v/tag/aerobounce/trash.swift?display_name=tag
