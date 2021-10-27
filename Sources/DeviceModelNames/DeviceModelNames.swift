import Foundation

private func _modelToDevice(_ model: String) -> String {
  return deviceModelNames[model] ?? model
}

public func modelToDevice(_ model: String) -> String {
  #if targetEnvironment(simulator)
  if let model = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
    return _modelToDevice(model)
  }
  #endif
  return _modelToDevice(model)
}
