//
//  main.swift
//  assignment_1
//
//  Created by Aigerim Karimova on 05.09.2026.
//

import Foundation

var firstName: String = "Aigerim" ;
var lastName: String = "Karimova" ;
var age: Int = 19 ;
var birthYear: Int = 2007 ;
var isStudent: Bool = true ;
var height: Double = 1.68 ;
var yearOfStudy: Int = 3 ;
var favColor: String = "navy blue" ;

let currentYear: Int = 2026 ;
let calculatedAge = currentYear - birthYear ;

var hobby: String = "hicking" ;
var numerofHobbies: Int = 4 ;
var favouriteNumber: Int = 7 ;
var isHobbyCreative: Bool = false ;
var favouriteSport: String = "tennis" ;
var favouriteFood: String = "fries" ;

let lifeStory: String = """
    My name is \(firstName) \(lastName). I am \(age) years old and I was born in \(birthYear).
    In \(currentYear) I am \(calculatedAge). 
    I am currently a \(yearOfStudy) year student: \(isStudent).
    My height is \(height) cm. My favourite color is \(favColor).
    I enjoy \(hobby), which is not a creative hobby. I have \(numerofHobbies) in totall and my favourite number is \(favouriteNumber).
    My favourite sport to play is \(favouriteSport) and my favourite food is \(favouriteFood).
    """ ;

var futureGoals: String = "In the future I want to become a successful devoloper and travel the world." ;
var emoji = "⭐️" ;


var lifeStoryTwo = lifeStory ;
lifeStoryTwo.append(futureGoals) ;

print(lifeStory) ;

print(lifeStoryTwo) ;

