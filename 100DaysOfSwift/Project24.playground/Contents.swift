import UIKit

var greeting = "Hello, playground"


let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

name[3]
name.isEmpty

let password = "12345"

password.hasPrefix("123")
password.hasSuffix("345")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {return self}
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self}
        return String(self.dropLast(suffix.count))
    }
}

password.deletingPrefix("123")
password.deletingSuffix("345")


let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else {return ""}
        return firstLetter.uppercased() + self.dropFirst()
    }
}

print(weather.capitalizedFirst)

let input = "Swift is like objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages)
languages.contains(where: input.contains)

let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)



let attributedString2 = NSMutableAttributedString(string: string)

attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))



let pet = "pet"
pet.withPrefix("pet")
pet.withPrefix("car")
pet.rangeOfCharacter(from: NSCharacterSet.decimalDigits)

extension String {
    func withPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {return prefix.appending(self)}
        return String(self)
    }
}
let num = "123"
let decimalnum = "1.23"
let numString = "hello 123"
let noNumString = "hello"

//extension String {
//    var isNumeric : Bool {
//        return Double(self) != nil
//    }
//}


extension String {

    var isNumeric : Bool { return CharacterSet(charactersIn: self).isSubset(of: CharacterSet.decimalDigits)
    }

    var isDigits : Bool {
        guard !self.isEmpty else { return false }
        let containsNonNumbers = self.contains { !$0.isNumber }
        return !containsNonNumbers
    }
}
num.isNumeric
numString.isNumeric
noNumString.isNumeric

numString.isDigits
numString.isNumeric


extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}
let linesOnString = "How\nmany\nlines\nare\nin\nthis\nstring?"
linesOnString.lines

extension String {
    var hasNum : Bool {
//        let regex = /[a-zA-Z]+/
        let regex = /[0-9]+/
        guard !self.isEmpty else { return false }
        if self.contains(regex) {
            return true
//        let containsNonNumbers = self.contains(regex)
//        if containsNonNumbers == true { return false} else {
//            return true
        } else { return false}
    }
}
num.hasNum
decimalnum.hasNum
numString.hasNum
noNumString.hasNum
