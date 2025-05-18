import Foundation

enum Day01Error : Error {
    case CannotGetInput, InputInvalid
}

func get_useful_input(file_path: String) throws -> ([Int],[Int]){
    let file_url = URL(filePath: file_path)
    guard let input = try? String(contentsOf: file_url, encoding: .utf8) else {
        throw Day01Error.CannotGetInput
    }
    var leftside : [Int] = []
    var rightside : [Int] = []
    for line in input.split(whereSeparator: \.isNewline){
        let substrings = line.split(whereSeparator: \.isWhitespace)
        guard let left_item = Int(substrings[0]) else { throw Day01Error.InputInvalid }
        guard let right_item: Int = Int(substrings[1]) else {throw Day01Error.InputInvalid}

        leftside.append(left_item)
        rightside.append(right_item) 
    }
    return (leftside, rightside)
}

func part1(file_path: String) {
    var leftside, rightside: [Int]
    do {
        (leftside, rightside) = try get_useful_input(file_path: file_path) 
    } catch {
        print("Something fucked up reading the file, idk")
        return
    }
    leftside.sort()
    rightside.sort()
    var totalDistance = 0
    for i in 0..<leftside.count {
        totalDistance += abs(leftside[i] - rightside[i])
    }
    print(totalDistance)
}

func part2(file_path: String) {
    let leftside, rightside: [Int]
    do {
        (leftside, rightside) = try get_useful_input(file_path: file_path)
    } catch {
        print("Ya something's fucked mate idk")
        return
    }
    var right_occurances : [Int: Int] = [:]
    var sum = 0
    for num in leftside {
        if !right_occurances.keys.contains(num) {
            var occurances = 0
            for num_r in rightside {
                if (num_r == num) { occurances+=1 }
            }
            right_occurances[num] = occurances
        }
        sum += num * right_occurances[num]!
    }
    print (sum)
}

func runit() {
    let test = "../input_test.txt"
    let prod = "../input_prod.txt"
    part1(file_path: test)
    part1(file_path: prod)
    part2(file_path: test)
    part2(file_path: prod)
}

runit()