import UIKit

var greeting = "Hello, playground"

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}
extension Int {
    func times(_ closure: () -> Void){
        guard self > 0 else {return}
        
        for _ in 0 ..< self {
            closure()
        }
    }
}

let num: Int = 5
num.times {
    print("Hello!")
}


extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let location = self.firstIndex(of: item){
            self.remove(at: location)
        }
    }
}
let view = UIView()
view.bounceOut(duration: 3)

5.times { print("Hello") }

var numbers = [1, 2, 3, 4, 5]
numbers.remove(item: 3)
