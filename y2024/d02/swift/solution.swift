import Foundation

func get_useful_input(path filePath: String) throws -> [[Int]]{
    let fileURL = URL(filePath: filePath)
    let input = try String(contentsOf: fileURL, encoding: .utf8)
    var result: [[Int]] = []
    for line in input.split(whereSeparator: \.isNewline) {
        result.append(line.split(whereSeparator: \.isWhitespace).map { substring in
            Int(substring)! 
        })
    }
    return result
}

func part1(path filePath:String) {
    var numOfSafeReports = 0
    guard let input = try? get_useful_input(path: filePath) else {
        print("Couldn't get useful input")
        return
    }
    all_reports: for report in input {
        let mod = if(report[0] < report[1]) { 1 } else { -1 }
        for i in 0..<(report.count - 1) {
            let diff = (report[i + 1] - report[i]) * mod
            if diff < 1 || diff > 3 {
                continue all_reports
            }
        }
        numOfSafeReports+=1
    }

    print(numOfSafeReports)
}

func validateReport(report: [Int], canDampen: Bool) -> Bool {
    var mod = if report[0] < report[1] { 1 } else { -1 }
    var candidateIndex : Set<Int> = []
    for i in 0..<report.count - 1 {
        let diff = (report[i + 1] - report[i]) * mod
        let valid = diff > 0 && diff < 4
        if !valid{
            if(!canDampen) { return false }
            if(diff < 0) { 
                mod *= -1
                if (i == 1) { candidateIndex.insert(0) }
            }
            candidateIndex.insert(i)
            candidateIndex.insert(i+1)
        }
    }
    if !candidateIndex.isEmpty {
        for i in candidateIndex {
            var modifiedReport = report
            modifiedReport.remove(at: i)
            if validateReport(report: modifiedReport, canDampen: false) { return true }
        }
        return false
    } else {
        return true
    }
}

func part2(path filePath:String){
    var numOfSafeReports = 0
    guard let input = try? get_useful_input(path: filePath) else {
        print("Couldn't get useful input")
        return
    }
    for report in input {
        if validateReport(report: report, canDampen: true) {
            numOfSafeReports+=1
        }
    }

    print(numOfSafeReports)
}

let test = "../input_test.txt"
let prod = "../input_prod.txt"

part1(path: test)
part1(path: prod)
part2(path: test)
part2(path: prod)