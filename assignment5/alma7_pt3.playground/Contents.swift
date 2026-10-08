// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part3_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Power Cell

// Why a class and not a struct here?  -> because struct will be copied
final class PowerCell {
    private var charge: Int
    
       init(charge: Int) {
           if charge < 0 {
               self.charge = 0
           } else if charge > 100 {
               self.charge = 100
           } else {
               self.charge = charge
           }
       }
    
       func level() -> Int {
           return charge
       }
    
       func spend(_ amount: Int) -> Bool {
           guard amount > 0, amount <= charge else { return false }
           charge -= amount
           return true
       }
    
       func recharge(by amount: Int) {
           guard amount > 0 else { return }
           charge += amount
           if charge > 100 { charge = 100 }
       }
}

// Encapsulation proof (leave this commented, with the compiler error):
// cell.charge = 100
// error:


// MARK: Level 2 · The Fleet

// 2.1  What does `final` on runOnce() buy you?  -> blocks override
class Drone {
    let id: String
    let cell: PowerCell
     
    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }
    
    var powerCost: Int { 10 }
    
    var statusLine: String {
        let level = cell.level()
        return "\(id): \(level)% \(level.powerBar)"
    }
     
    func performTask() -> Int { 0 }
     
    final func runOnce() -> Int {
        guard cell.spend(powerCost) else { return 0 }
        return performTask()
    }
}

// 2.2
final class WelderDrone: Drone {
    override var powerCost: Int { 25 }
    override func performTask() -> Int { 40 }
    func weldSeam() -> String { "\(id) welds a seam" }
}
class ScannerDrone: Drone {
    override var powerCost: Int { 10 }
    override func performTask() -> Int { 15 }
    override var statusLine: String { super.statusLine + " [scanner]" }
}
final class CargoDrone: Drone {
    override var powerCost: Int { 20 }
    override func performTask() -> Int { 25 }
}

// 2.3
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    switch kind {
    case "welder":  return WelderDrone(id: id, cell: cell)
    case "scanner": return ScannerDrone(id: id, cell: cell)
    case "cargo":   return CargoDrone(id: id, cell: cell)
    default:        return nil
    }
}
var fleet: [Drone] = []
for record in fleetData {
    if let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) {
        fleet.append(drone)
    } else {
        print("⚠️ Skipped \(record.id): unknown drone kind '\(record.kind)'")
    }
}


// MARK: Level 3 · The Shift

// func runShift(_ fleet: [Drone], rounds: Int) -> Int { }

// let A = ...
// let B = ...
// let C = ...


// MARK: Level 4 · Diagnostics

// 4.1
// protocol Diagnosable { }

// 4.2
// protocol Rechargeable { }
// Why does Drone implement recharge(by:) without `mutating`?  ->
// struct SensorModule: Diagnosable, Rechargeable { }

// 4.3
// Why could [Drone] never have held the sensors?  ->
// func diagnosticsReport(_ components: [Diagnosable]) -> String { }


// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + the single home of the Health Rule
// extension Diagnosable { }

// 5.2 · the beacon you cannot edit
// extension LegacyBeacon: Diagnosable { }

// let D = ...

// 5.3
// extension Int { }


// MARK: Level 6 · Incident Reports
// Two of these do not compile. Two compile and lie.
// For each: expectation, actual behaviour, the language rule, the fix.

/*
// Report 1
class PatchDrone: Drone {
    func performTask() -> Int {
        return 30
    }
}

// Report 2
final class HeavyWelder: WelderDrone {
    override func runOnce() -> Int {
        return 999
    }
}

// Report 3
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
print(first.weldSeam())

// Report 4
protocol Labelled {
    var componentID: String { get }
}

extension Labelled {
    func label() -> String { "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())
*/


// MARK: Finale · Mission Code

// let missionCode = "\(A)-\(B)-\(C)-\(D)"
// print("MISSION CODE: \(missionCode)")


// MARK: Bonus

// Two ways to forbid using Drone directly; a protocol-based redesign;
// two or three sentences comparing them.


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a `mutating` protocol requirement without the
    keyword, while a struct must write it?

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:
    Inheritance shares stored properties and a concrete implementation with state (Drone's id/cell and
     its runOnce ritual). Protocols let unrelated types, including structs and types you can't edit
     (LegacyBeacon), share one interface; a class can only have one superclass.
 3. What does `final` prevent, and what did it protect in runOnce()?
    It prevents subclassing (on a class) or overriding (on a method/property). On runOnce() it protects
    the shift ritual (spend powerCost, return 0 on failure, else do the task) from being replaced by a
    subclass, as Report 2 tried (999 work without paying any power).
 4. In Report 4, why did the protocol extension's method win?

*/

