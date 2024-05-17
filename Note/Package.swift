// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Paw Note",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(/Users/matt/Library/Mobile Documents/iCloud~com~apple~Playgrounds/Documents/Paw Note.swiftpm/Package.swift
            name: "Paw Note",
            targets: ["AppModule"],
            bundleIdentifier: "com.MathewPurchase.Note",
            teamIdentifier: "JQKWKZ3Y7L",
            displayVersion: "1.1",
            bundleVersion: "13",
            appIcon: .asset("AppIcon"),
            accentColor: .asset("AccentColor"),
            supportedDeviceFamilies: [
                .pad,
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            appCategory: .productivity
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)