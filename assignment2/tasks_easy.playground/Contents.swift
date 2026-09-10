import UIKit

//easy tasks
//1
var fruits = ["Apple", "Banana", "Orange", "Pineapple", "Kiwi"]
print("Third item is: \(fruits[2])")

//2
var favouriteNumbers: Set<Int> = [7,13,8,1,31,2,3]
favouriteNumbers.insert(4)
print("Set with 4 added:")
print(favouriteNumbers)
for number in favouriteNumbers{
    print(number)
}

//3
var programminLanguages: [String: Int] = ["Python": 1991, "Java": 1995, "Swift": 2014, "C++": 1995]
print("Release year of Swift: \(programminLanguages["Swift"]!)")

//4
var colors = ["red", "green", "blue", "yellow"]
colors[1] = "pink"
print("Updated array: ")
for color in colors{
    print(color)
}

