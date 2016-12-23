//  Copyright © 2016年 Kenichi Ueno. All rights reserved.

import Foundation

// http://qiita.com/y_mazun/items/dc2a0cad8da1c0e88a40
extension String: Collection {} // to enable String.split()

struct Reader {
    static var dataFromFile: [String]?
    static var dataIndex = -1
    public static func setFile(name: String, type: String) {
        dataIndex = -1
        if let filePath = Bundle.main.path(forResource: name, ofType: type) {
            print("Reading data from \(name).\(type)")
            dataFromFile = try? String.init(contentsOfFile: filePath, encoding: .utf8).components(separatedBy: "\n")
        }
    }
    
    // can read from either input file or standard input
    public static func read() -> String? {
        if let autoInput = dataFromFile, autoInput.count > (dataIndex + 1) {
            dataIndex += 1
            return autoInput[dataIndex]
        } else {
            return readLine()
        }
    }
}

// to read input
func readInt() -> Int { return Reader.read().flatMap { Int($0) }! }
func readInts() -> [Int] { return Reader.read().flatMap { $0.split(separator: " ").flatMap { Int($0)} }! }
func readDouble() -> Double { return Reader.read().flatMap { Double($0) }! }
func readDoubles() -> [Double] { return Reader.read().flatMap { $0.split(separator: " ").flatMap { Double($0)} }! }
func readString() -> String { return Reader.read()! }
func readStrings() -> [String] { return Reader.read().flatMap { $0.split(separator: " ") }! }

// add a method isOne() to return if a character is "1"
extension Character {
    static let one = Character("1")
    func isOne() -> Bool {
        return self == Character.one
    }
}

// add init(bitPatternString:) to convert "001011..." to Int64 and bitCount to count the number of 1
extension Int64 {
    // return Int64 using a string consists of "1" and "0"
    init(bitPatternString: String) {
        var value: Int64 = 0
        for c: Character in bitPatternString.prefix(64).characters {
            value = (value << 1) + (c.isOne() ? 1 : 0)
        }
        self = value
    }
    
    public var bitPatternString: String {
        var value = self
        var string = value == 0 ? "0" : ""
        while value > 0 {
            string.insert(.init(value & 1 == 1 ? "1" : "0"), at: string.startIndex)
            value >>= 1
        }
        return string
    }
    
    // return how many "1" it contains
    public var bitCount: Int {
        var value = self
        var count = 0
        while value > 0 {
            count += Int(value & 1)
            value >>= 1
        }
        return count
    }
}

struct Tree {
    static var memo : [String : Int] = [:]
    static var nodes : [Int:[Int]] = [:]
    init(edgeInts: [[Int]]) {
        Tree.memo = [:]
        Tree.nodes = [:]
        
        _ = edgeInts.map { edge in
            Tree.nodes[edge[0]-1] = (Tree.nodes[edge[0]-1] ?? []) + [edge[1]-1]
            Tree.nodes[edge[1]-1] = (Tree.nodes[edge[1]-1] ?? []) + [edge[0]-1]
        }
    }
    
    // get the most number of nodes those which form a binary tree
    func binaryCount(index: Int, parentIndex: Int? = nil) -> Int {
        let memoKey = ("\(parentIndex)_\(index)")
        if let result = Tree.memo[memoKey] {
            return result
        } else {
            let result: Int
            let childNodeIndice = Tree.nodes[index]!
                .filter { $0 != parentIndex }
                .sorted { (index1, index2) -> Bool in
                return self.binaryCount(index: index1, parentIndex: index) >= self.binaryCount(index: index2, parentIndex: index)
            }
            if childNodeIndice.count < 2 {
                result = 1
            } else {
                result = childNodeIndice.prefix(2).reduce(1) { return $0.0 + self.binaryCount(index: $0.1, parentIndex: index) }
            }
            
            Tree.memo[memoKey] = result
            return result
        }
    }
}

if false {
    // solver for GCJ 2014 Round 1C
    func solve(_ N:Int, _ p:[Int]) -> String {
        var count = 0
        for i in 0..<N {
            count += p[i] > i ? 1 : 0
        }
        return count > 518 ? "BAD" : "GOOD"
    }
    
    // main loop for GCJ 2014 Round 1C
    let T = readInt()
    for t in 1...T {
        let N = readInt()
        let p = readInts()
        print("Case #\(t): \(solve(N, p))")
    }
}


if false {
    // solver for GCJ 2014 Round 1B
    func solve(_ N:Int, _ edgeInts:[[Int]]) -> String {
        let tree = Tree(edgeInts: edgeInts)
        return "\(N - Tree.nodes.keys.reduce(0) { max($0.0, tree.binaryCount(index: $0.1)) })"
    }
    
    // for debug
    Reader.setFile(name:"GCJ2014Round1Bsample", type:"in")

    // main loop for GCJ 2014 Round 1B
    let T = readInt()
    for t in 1...T {
        let N = readInt()
        var edges : [[Int]] = []
        for i in 1..<N {
            edges.append(readInts())
        }
        let result = solve(N, edges)
        print("Case #\(t): \(result)")
    }
}

if false {
    // solver for GCJ 2014 Round 1A
    func solve(_ outletStrings:[String], _ deviceStrings:[String]) -> String {
        let outlets = outletStrings.flatMap(Int64.init(bitPatternString:))
        let devices = deviceStrings.flatMap(Int64.init(bitPatternString:))
        
        let minResult = devices.flatMap { device in
            let bits = outlets[0] ^ device
            let newOutlets = outlets.map { $0 ^ bits }
            
            return Set.init(newOutlets).subtracting(.init(devices)).isEmpty ? bits.bitCount : 999
        }.reduce(999, min)
        
        return minResult == 999 ? "NOT POSSIBLE" : "\(minResult)"
    }

    // for debug
    Reader.setFile(name:"GCJ2014Round1Asample", type:"in")
    // test large case
    var patterns : [Int64] = []
    for i in 1...150 {
        patterns.append(Int64(arc4random()) * (Int64(Int32.max) + 1) + Int64(i))
    }

    print("Case #(0): \(solve(patterns.flatMap{$0.bitPatternString}, patterns.flatMap{$0.bitPatternString}))")
    print("Case #(1): \(solve(patterns.flatMap{($0 ^ 1).bitPatternString}, patterns.flatMap{$0.bitPatternString}))")
    print("Case #(Impossible): \(solve(patterns.flatMap{($0 + 1).bitPatternString}, patterns.flatMap{$0.bitPatternString}))")

    // main loop for GCJ 2014 Round 1A
    let T = readInt()
    for t in 1...T {
        _ = readInts()
        let outlets = readStrings()
        let devices = readStrings()
        let result = solve(outlets, devices)
        print("Case #\(t): \(result)")
    }
}
