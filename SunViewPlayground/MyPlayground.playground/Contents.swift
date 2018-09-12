import UIKit
import PlaygroundSupport
import TinyConstraints

var str = "Hello, playground"

let otherView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
let view = UIView()
view.backgroundColor = .red

otherView.addSubview(view)

view.edges(to: otherView, insets: TinyEdgeInsets(top: 10, left: 10, bottom: -10, right: -10))

PlaygroundPage.current.liveView = otherView
