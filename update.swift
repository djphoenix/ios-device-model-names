// Run `swift update.swift > Sources/DeviceModelNames/ModelList.swift`

import Foundation

func download() async throws -> Data {
  let endpoint = URL(string: "https://api.ipsw.me/v4/devices")!
  let (data, resp) = try await URLSession.shared.data(from: endpoint)
  guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
  return data
}

struct Device: Decodable, Comparable {
  let identifier: String
  let name: String
  var isIdentity: Bool { return identifier == name }
  var parts: (String, Int, Int) {
    let scanner = Scanner(string: identifier)
    let idiom = scanner.scanCharacters(from: .letters)!
    let d1 = scanner.scanInt()!
    _ = scanner.scanString(",")!
    let d2 = scanner.scanInt()!
    return (idiom, d1, d2)
  }
  public static func < (lhs: Self, rhs: Self) -> Bool {
    let lp = lhs.parts, rp = rhs.parts
    if lp.0 != rp.0 { return lp.0 < rp.0 }
    if lp.1 != rp.1 { return lp.1 < rp.1 }
    return lp.2 < rp.2
  }
}

func parse(_ data: Data) throws -> [Device] {
  return try JSONDecoder().decode([Device].self, from: data).filter({ !$0.isIdentity }).sorted()
}

let wg = DispatchGroup()
wg.enter()
Task {
  let data = try! await download()
  let devs = try! parse(data)
  print("internal let deviceModelNames: [String:String] = [")
  for d in devs {
    print("  \"\(d.identifier)\": \"\(d.name)\",")
  }
  print("]")
  wg.leave()
}
wg.wait()
