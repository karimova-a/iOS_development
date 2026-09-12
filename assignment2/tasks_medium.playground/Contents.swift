import UIKit

//medium tasks
//1
var set1: Set<Int> = [1, 2, 3, 4]
var set2: Set<Int> = [3, 4, 5, 6]
var intersection = set1.intersection(set2)
print("Intersecction: \(intersection)")

//2
var studentScores: [String: Int] = ["Aigerim": 89, "Aleksei": 90, "Daria": 8]
studentScores["Daria"]  = 78
print("Updated scores: \(studentScores)")

//3
var array1 = ["apple", "bananaa"]
var array2 = ["cherry", "date"]
array1.append(contentsOf: array2)
print("Merged  array: \(array1)")
