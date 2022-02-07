#!/usr/bin/env swift
//
// trash.swift
//
// AGPLv3 License
// Created by github.com/aerobounce on 2022/1/27.
// Copyright © 2022-present aerobounce. All rights reserved.
//
import Foundation

let isTERM: Bool = ProcessInfo.processInfo.environment["TERM"] != nil
let e: String = isTERM ? "\u{001B}[1;31m" : "" // Red Bold (for Error)
let r: String = isTERM ? "\u{001B}[0m" : "" // Reset

func stdout(_ message: String) { fputs("\(message)\n", stdout) }
func stderr(_ message: String) { fputs("\(e)\(message)\(r)\n", stderr) }
func advise(_ message: String) -> Never { stderr(message); exit(EXIT_FAILURE) }

func moveToTrash(fileURLs: [URL]) {
    for fileURL in fileURLs {
        do {
            try _ = fileURL.checkResourceIsReachable()
        } catch {
            stderr(error.localizedDescription)
        }
    }
    let target: NSAppleEventDescriptor = .init(bundleIdentifier: "com.apple.finder")
    let event: NSAppleEventDescriptor = .init(eventClass: kAECoreSuite,
                                              eventID: AEEventID(kAEDelete),
                                              targetDescriptor: target,
                                              returnID: AEReturnID(kAutoGenerateReturnID),
                                              transactionID: AETransactionID(kAnyTransactionID))
    let fileList: NSAppleEventDescriptor = fileURLs.enumerated().reduce(into: .init(listDescriptor: ())) {
        (result: inout NSAppleEventDescriptor, element: (index: Int, fileURL: URL)) in
            /// UTF-8 encoded full path with native path separators
            if let nativePath: NSAppleEventDescriptor = .init(
                descriptorType: typeFileURL,
                data: element.fileURL.absoluteString.data(using: .utf8)
            ) {
                result.insert(nativePath, at: element.index)
            }
    }
    event.setParam(fileList, forKeyword: keyDirectObject)

    /// Seems it doesn't throw error even if a URL doesn't exist,
    /// hence 'checkResourceIsReachable' at the beginning.
    do {
        try event.sendEvent(options: .noReply, timeout: TimeInterval(kAEDefaultTimeout))
    } catch let error as NSError {
        if case -600 = error.code {
            advise("Finder is not running.")
        } else {
            stderr(error.description) // .localizedDescription gives much less information.
        }
    }
}

let arguments: [String] = CommandLine.arguments.dropFirst().map { $0 }
var stdinFileURLs: [URL] {
    var components: [String] = []
    while let line: String = readLine() {
        guard !line.isEmpty, line != " " else { continue }
        components.append(line)
    }
    if components.isEmpty {
        advise("Failed to read stdin.")
    }
    return components.map(URL.init(fileURLWithPath:))
}

moveToTrash(fileURLs: arguments.isEmpty
    ? stdinFileURLs
    : arguments.map(URL.init(fileURLWithPath:)))
