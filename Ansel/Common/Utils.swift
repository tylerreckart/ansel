//
//  Utils.swift
//  Ansel
//
//  Created by Tyler Reckart on 8/17/22.
//

import Foundation

func logC(val: Double, forBase base: Double) -> Double {
    return log(val)/log(base)
}

func toNearestTen(_ value: Int) -> Float {
    return round(Float(value) / 10) * 10
}

struct Rational {
    let numerator : Int
    let denominator: Int

    init(numerator: Int, denominator: Int) {
        self.numerator = numerator
        self.denominator = denominator
    }

    init(approximating x0: Double, withPrecision eps: Double = 1.0E-6) {
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)

        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        self.init(numerator: h, denominator: k)
    }
}
