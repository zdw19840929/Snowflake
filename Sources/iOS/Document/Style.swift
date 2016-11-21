import Foundation

class Style {
  var strokeColor: UIColor?
  let strokeWidth: CGFloat
  var fillColor: UIColor?
  let opacity: CGFloat
  var fillRule: String?
  
  init(attributes: JSONDictionary) {
    var attributes = attributes
    
    if let string = attributes.string(key: "style") {
      attributes = attributes.merge(another: Style.parse(string: string))
    }
    
    self.strokeWidth = attributes.number(key: "stroke-width") ?? 1
    self.fillColor = attributes.color(key: "fill")
    self.strokeColor = attributes.color(key: "stroke") ?? .black
    self.opacity = attributes.number(key: "opacity") ?? 1
    self.fillRule = Style.parse(fillRule: attributes.string(key: "fill-rule"))
  }
  
  static func parse(string: String) -> JSONDictionary {
    var attributes: JSONDictionary = JSONDictionary()
    
    string.components(separatedBy: ";").map {
      return $0.replacingOccurrences(of: " ", with: "")
    }.forEach {
      let components: [String] = $0.components(separatedBy: ":")
      if components.count == 2 {
        attributes[components[0]] = components[1]
      }
    }
    
    return attributes
  }
  
  // MARK: - Helper
  
  static func parse(fillRule: String?) -> String? {
    guard let fillRule = fillRule else { return nil }
    
    let mapping: [String: String] = [
      "nonzero": kCAFillRuleNonZero,
      "evenodd": kCAFillRuleEvenOdd
    ]
    
    return mapping[fillRule]
  }
}