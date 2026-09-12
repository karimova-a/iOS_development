import UIKit
//hard tasks
//1
var countries: [String: Int] = ["Kazakhstan": 20000000, "Russia": 143000000, "USA": 349000000]
countries["France"] = 69000000
print("Countries: \(countries)")

//2
var set1: Set<String> = ["cat", "dog"]
var set2: Set<String> = ["dog", "mouse"]
var union = set1.union(set2)
var substracted = union.subtracting(set2)
print("Final result: \(substracted)")

//3
var studentGrades: [String: Array] = ["Aigerim": [65,78,98], "Anna": [98,76,55], "Bob": [77,98,80]]
var secondGrade = studentGrades["Anna"]![1]
print("Anna's second grade: \(secondGrade)")
