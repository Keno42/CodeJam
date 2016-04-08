// http://qiita.com/y_mazun/items/dc2a0cad8da1c0e88a40
extension String: CollectionType {} // to enable String.split()

// functions
func readInt() -> Int { return readLine().flatMap { Int($0) }! }
func readInts() -> [Int] { return readLine().flatMap { $0.split(" ").flatMap { Int($0)} }! }
func readDouble() -> Double { return readLine().flatMap { Double($0) }! }
func readDoubles() -> [Double] { return readLine().flatMap { $0.split(" ").flatMap { Double($0)} }! }
func readString() -> String { return readLine()! }
func readStrings() -> [String] { return readLine().flatMap { $0.split(" ") }! }

// http://stackoverflow.com/questions/34968470/calculate-all-permutations-of-a-string-in-swift
func permutations(n:Int, inout _ a:Array<Character>) {
    if n == 1 {print(a); return}
    for i in 0..<n-1 {
        permutations(n-1,&a)
        swap(&a[n-1], &a[(n%2 == 1) ? 0 : i])
    }
    permutations(n-1,&a)
}