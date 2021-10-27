// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "DeviceModelNames",
  products: [
    .library(
      name: "DeviceModelNames",
      targets: ["DeviceModelNames"]
    ),
  ],
  targets: [
    .target(
      name: "DeviceModelNames",
      dependencies: []
    ),
  ]
)
