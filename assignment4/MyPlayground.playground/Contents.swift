// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge, lab, cargo, medbay, engine
    
    var evacuationPriority: Int {
        switch self{
        case .bridge: return 1
        case .medbay: return 2
        case .lab: return 3
        case .engine: return 4
        case .cargo: return 5
        }
    }
}

for deck in Deck.allCases {
    print("\(deck.rawValue) -> priority \(deck.evacuationPriority)")
}

// 1.2
enum AlarmLevel: Int {
    case green = 0
    case yellow
    case orange
    case red
    
    static func level(forTotalMass mass:Int) -> AlarmLevel{
        let steps = min(mass / 500, 3)
        return AlarmLevel(rawValue: steps) ?? .green
    }
    
}

print(AlarmLevel.level(forTotalMass: 0))
print(AlarmLevel.level(forTotalMass: 940))
print(AlarmLevel.level(forTotalMass: 4000))



// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

// 2.2
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)
    let tag = parts[0]
    
    if tag == "crate" && parts.count == 3 {
        if let id = Int(parts[1]), let mass = Int(parts[2]) {
            return .crate(id: id, massKg: mass)
        }
    } else if tag == "container" && parts.count == 3 {
        if let mass = Int(parts[2]) {
            return .container(code: parts[1], massKg: mass)
        }
    } else if tag == "livestock" && parts.count == 4 {
        if let count = Int(parts[2]), let unit = Int(parts[3]) {
            return .livestock(species: parts[1], count: count, massPerUnitKg: unit)
        }
    }
    return .unknown(raw: line)
}

// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}

var totalManifestMass = 0
var unknownCount = 0
for line in rawManifest {
    let entry = parseEntry(line)
    totalManifestMass += mass(of: entry)
    if case .unknown = entry {
        unknownCount += 1
    }
}
print("Total manifest mass: \(totalManifestMass) kg")
print("Unknown lines: \(unknownCount)")

let A = totalManifestMass



// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(_ amount: Int) {
        oxygen -= amount
        if oxygen < 0 {
            oxygen = 0
        }
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

// 3.2
var crewRoster: [CrewSnapshot] = []
for record in crewData {
    if let deck = Deck(rawValue: record.deck) {
        crewRoster.append(CrewSnapshot(name: record.name, deck: deck, oxygen: record.oxygen))
    } else {
        print("WARNING: \(record.name) is on unknown deck '\(record.deck)', skipped")
    }
}

for member in crewRoster {
    print("\(member.name) on \(member.deck) with oxygen \(member.oxygen)")
}

// 3.3 · Value-semantics demonstration (copy / plain parameter / inout)
func drainPlain(_ snapshot: CrewSnapshot) {
    var local = snapshot          // the function only has its own copy
    local.breathe(30)
    print("  inside drainPlain, the copy has oxygen \(local.oxygen)")
}

func drainInout(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(30)          // this changes the caller's variable
}


// 1. copy
let original = CrewSnapshot.rookie(named: "Dana")
var copy = original
copy.breathe(50)
print("1. BEFORE: original oxygen = \(original.oxygen)")
print("1. AFTER copy.breathe(50): copy = \(copy.oxygen), original = \(original.oxygen)")

// 2. plain function
var subject = CrewSnapshot.rookie(named: "Timur")
print("2. BEFORE drainPlain: subject oxygen = \(subject.oxygen)")
drainPlain(subject)
print("2. AFTER drainPlain: subject oxygen = \(subject.oxygen)  (unchanged)")

// 3. inout
print("3. BEFORE drainInout: subject oxygen = \(subject.oxygen)")
drainInout(&subject)
print("3. AFTER drainInout: subject oxygen = \(subject.oxygen)  (changed)")


// MARK: Level 4 · The Teleport Pod

// 4.1
final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        if occupant != nil || chargeLevel < 20 {
            return false
        }
        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let passenger = occupant else {
            return nil
        }
        chargeLevel -= 20
        occupant = nil
        return passenger
    }

}

// 4.2 · Charge ledger: load+fire three times, then fire an empty pod
let pod = TeleportPod(id: "P-1", chargeLevel: 100)

// Step 1: Timur
let loadedTimur = pod.load(crewRoster[0])
let firedTimur = pod.fire()
print("Step 1: loaded \(loadedTimur), fired \(firedTimur?.name ?? "nobody"), charge = \(pod.chargeLevel)")

// Step 2: Dana
let loadedDana = pod.load(crewRoster[1])
let firedDana = pod.fire()
print("Step 2: loaded \(loadedDana), fired \(firedDana?.name ?? "nobody"), charge = \(pod.chargeLevel)")

// Step 3: Nurlan (the roster order is Timur, Dana, Aigerim, Nurlan)
let loadedNurlan = pod.load(crewRoster[3])
let firedNurlan = pod.fire()
print("Step 3: loaded \(loadedNurlan), fired \(firedNurlan?.name ?? "nobody"), charge = \(pod.chargeLevel)")

// Step 4: empty pod
let firedEmpty = pod.fire()
print("Step 4: fired \(firedEmpty?.name ?? "nobody"), charge = \(pod.chargeLevel)")

let C = pod.chargeLevel

// 4.3 · Reference-semantics demonstration
let samePodVariable = pod
samePodVariable.chargeLevel = 5
print("pod.chargeLevel = \(pod.chargeLevel), samePodVariable.chargeLevel = \(samePodVariable.chargeLevel)")

let crewOne = CrewSnapshot.rookie(named: "Nurlan")
var crewTwo = crewOne
crewTwo.oxygen = 5
print("crewOne.oxygen = \(crewOne.oxygen), crewTwo.oxygen = \(crewTwo.oxygen)")

// MARK: Level 5 · Station Systems

// 5.1
final class Station {
    
}

// let B = ...

// 5.2 · The clamp trap: 130, then -40, then 55


// MARK: Level 6 · Incident Reports
// Three of these compile and are wrong. One does not compile.
// For each: expectation, actual behaviour, the language rule, the fix.

/*
// Report 1
var roster = crewRoster
for var member in roster {
    member.oxygen -= 10
}
print(roster[0].oxygen)   // author expected the crew to have lost oxygen - compiles

// Report 2
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = podA
podB.chargeLevel = 0
print(podA.chargeLevel)   // author expected 100 -

// Report 3
struct Logbook {
    var entries: [String] = []
    func add(_ entry: String) {
        entries.append(entry)
    }
}

// Report 4
let snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let pod = TeleportPod(id: "B", chargeLevel: 50)
pod.chargeLevel = 10
*/

/*
 error: MyPlayground.playground:293:19: ambiguous use of 'pod'
let loadedTimur = pod.load(crewRoster[0])
                  ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:294:18: ambiguous use of 'pod'
let firedTimur = pod.fire()
                 ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:298:18: ambiguous use of 'pod'
let loadedDana = pod.load(crewRoster[1])
                 ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:299:17: ambiguous use of 'pod'
let firedDana = pod.fire()
                ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:303:20: ambiguous use of 'pod'
let loadedNurlan = pod.load(crewRoster[3])
                   ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:304:19: ambiguous use of 'pod'
let firedNurlan = pod.fire()
                  ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:308:18: ambiguous use of 'pod'
let firedEmpty = pod.fire()
                 ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:311:9: ambiguous use of 'pod'
let C = pod.chargeLevel
        ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:314:23: ambiguous use of 'pod'
let samePodVariable = pod
                      ^

MyPlayground.playground:290:5: found this candidate
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

MyPlayground.playground:365:5: found this candidate
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

error: MyPlayground.playground:316:1: failed to produce diagnostic for expression; please submit a bug report (https://swift.org/contributing/#reporting-bugs)
print("pod.chargeLevel = \(pod.chargeLevel), samePodVariable.chargeLevel = \(samePodVariable.chargeLevel)")
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

error: MyPlayground.playground:363:10: cannot assign to property: 'snapshot' is a 'let' constant
snapshot.oxygen = 40
~~~~~~~~ ^

MyPlayground.playground:362:1: change 'let' to 'var' to make it mutable
let snapshot = CrewSnapshot.rookie(named: "Dana")
^~~
var

error: MyPlayground.playground:365:5: invalid redeclaration of 'pod'
let pod = TeleportPod(id: "B", chargeLevel: 50)
    ^

MyPlayground.playground:290:5: 'pod' previously declared here
let pod = TeleportPod(id: "P-1", chargeLevel: 100)
    ^

error: MyPlayground.playground:357:17: cannot use mutating member on immutable value: 'self' is immutable
        entries.append(entry)
        ~~~~~~~ ^

MyPlayground.playground:356:5: mark method 'mutating' to make 'self' mutable
    func add(_ entry: String) {
    ^
    mutating
*/

// MARK: Level 7 · Sealing the Black Box

// The leaky original:
//
// class FlightRecorder {
//     var entries: [String] = []
//     var isSealed = false
// }
//
// Your sealed version below. One comment per access keyword.

// final class FlightRecorder { }

// A free function elsewhere in the file that uses your fileprivate helper:
// func auditTranscript(of recorder: FlightRecorder) -> String { }


// MARK: Finale · Integrity Code

// let D = ...
// let integrityCode = "\(A)-\(B)-\(C)-\(D)"
// print("INTEGRITY CODE: \(integrityCode)")


// MARK: Bonus

// deinit in TeleportPod, a do-block lifetime experiment, and === identity


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?
    A struct gets a free "memberwise" initializer with one parameter per stored
     property. A class does not, because classes are built for inheritance and
     shared identity, so Swift makes you write init yourself (and TeleportPod
     also has to set occupant to nil).
 
 2. What does `mutating` do to self, and why do classes never need it?
    A struct method can't change self by default, because self is a constant
     inside it. `mutating` makes self changeable (the method gets to replace the
     caller's value, which is why reviveInMedbay can write self = ...). A class
     instance is shared through a reference, so its methods can already change
     its properties. No mutating needed.

 3. In Report 4 both values are `let`. What exactly does `let` freeze for a
    struct, and what does it freeze for a class?
    For a struct, `let` freezes the entire value: no property can change, which
     is why `snapshot.oxygen = 40` fails. For a class, `let` only freezes the
     reference (the variable can't point to another object); the object's `var`
     properties can still change, so `pod.chargeLevel = 10` works.


 4. Why must a lazy property be var? When does lazy change behaviour, not
    just performance?
    A lazy property is only computed the first time it is read, which means it
     starts with no value and gets one later. That is a change after creation,
     so it must be var. Behaviour changes, not just speed, when the work has a
     side effect or depends on state: fullDiagnostics prints "Running full
     scan..." and uses the hull value at the time of the first read. If it never
     gets read, the scan never happens.


 5. private vs fileprivate: where in your FlightRecorder would private be
    too strict?
    In FlightRecorder, rawEntries() is fileprivate because the free function
     auditTranscript(of:) lives outside the class (but in the same file) and
     needs it. If it were private, only code inside FlightRecorder could call it,
     and auditTranscript would fail to compile.


 Bonus. On which line does deinit fire, and why can't === be used on
 CrewSnapshot?

*/
