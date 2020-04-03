import XCTest

import TensorFlow
import SwiftFusion

/// Asserts that `x` and `y` have the same shape and that their values have absolute difference
/// less than `accuracy`.
func assertEqual<T: TensorFlowFloatingPoint>(
  _ x: Tensor<T>, _ y: Tensor<T>, accuracy: T, file: StaticString = #file, line: UInt = #line
) {
  guard x.shape == y.shape else {
    XCTFail(
      "shape mismatch: \(x.shape) is not equal to \(y.shape)",
      file: file,
      line: line
    )
    return
  }
  XCTAssert(
    abs(x - y).max().scalarized() < accuracy,
    "value mismatch:\n\(x)\nis not equal to\n\(y)\nwith accuracy \(accuracy)",
    file: file,
    line: line
  )
}

class MatrixTests: XCTestCase {
    static var allTests = [
        ("test_concat", testConcat),
        ("test_log", test_log),
        ("test_neg", test_neg),
        ("test_squared", test_squared),
    ]

    //--------------------------------------------------------------------------
    // testConcat
    func testConcat() {
        let t1 = Tensor(shape: [2, 3], scalars: (1...6).map { Double($0) })
        let t2 = Tensor(shape: [2, 3], scalars: (7...12).map { Double($0) })
        let c1 = t1.concatenated(with: t2)
        let c1Expected = Tensor([
            1,  2,  3,
            4,  5,  6,
            7,  8,  9,
            10, 11, 12,
        ])
        
        XCTAssert(c1.flattened() == c1Expected)
        
        let c2 = t1.concatenated(with: t2, alongAxis: 1)
        let c2Expected = Tensor([
            1, 2, 3,  7,  8,  9,
            4, 5, 6, 10, 11, 12
        ])
        
        XCTAssert(c2.flattened() == c2Expected)
    }

    //--------------------------------------------------------------------------
    // test_log
    func test_log() {
        let range = 0..<6
        let matrix = Tensor(shape: [3, 2], scalars: (range).map { Double($0) })
        let values = log(matrix).flattened()
        let expected = Tensor(range.map { Foundation.log(Double($0)) })
        assertEqual(values, expected, accuracy: 1e-8)
    }
    
    //--------------------------------------------------------------------------
    // test_neg
    func test_neg() {
        let range = 0..<6
        let matrix = Tensor(shape: [3, 2], scalars: (range).map { Double($0) })
        let expected = Tensor(range.map { -Double($0) })

        let values = (-matrix).flattened()
        assertEqual(values, expected, accuracy: 1e-8)
    }
    
    //--------------------------------------------------------------------------
    // test_squared
    func test_squared() {
        let matrix = Tensor(shape: [3, 2], scalars: ([0, -1, 2, -3, 4, 5]).map { Double($0) })
        let values = matrix.squared().flattened()
        let expected = Tensor((0...5).map { Double ($0 * $0) })
        assertEqual(values, expected, accuracy: 1e-8)
    }
        
    //--------------------------------------------------------------------------
    // test_multiplication
    func test_multiplication() {
        let matrix = Tensor(shape: [3, 2], scalars: ([0, -1, 2, -3, 4, 5]).map { Double($0) })
        let values = (matrix * matrix).flattened()
        let expected = Tensor((0...5).map { Double($0 * $0) })
        assertEqual(values, expected, accuracy: 1e-8)
    }
}
