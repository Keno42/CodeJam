extension String: CollectionType {} // for String.split()

// functions
func readInt() -> Int { return readLine().flatMap { Int($0) }! }
func readInts() -> [Int] { return readLine().flatMap { $0.split(" ").flatMap { Int($0)} }! }
func readDouble() -> Double { return readLine().flatMap { Double($0) }! }
func readDoubles() -> [Double] { return readLine().flatMap { $0.split(" ").flatMap { Double($0)} }! }
func readString() -> String { return readLine()! }
func readStrings() -> [String] { return readLine().flatMap { $0.split(" ") }! }

