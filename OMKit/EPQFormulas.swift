//
//  EPQFormulas.swift
//  OMKit
//
//  Created by Jonathan Kizer on 12/24/17.
//  Copyright © 2017 Kizer Co. All rights reserved.
//

import Foundation
import UIKit

func economicProductionQuantitySolve(R: Double, S: Double, H: Double, K: Double) -> Double {
    let epqPtOne = (2*R*S)/(H)
    let epqPtTwo = (K/(K-R))
    let epqSolution = Double(epqPtOne.squareRoot()*epqPtTwo.squareRoot())
    return epqSolution
}

func economicProductionQuantitySolveFormatted(R: Double, S: Double, H: Double, K: Double) -> String {
    let epqPtOne = (2*R*S)/(H)
    let epqPtTwo = (K/(K-R))
    let epqSolution = Double(epqPtOne.squareRoot()*epqPtTwo.squareRoot())
    return formatMathSolution(value: epqSolution)
}

func economicProductionQuantityHoldOrderSolveFormatted(epqSolution: Double, R: Double, S: Double, H: Double, K: Double) -> String {
    let epqHoldOrderCosts = ((H*(epqSolution/2))*(K-R)/K) + (S*(R/epqSolution))
    return formatCurrencyUSD(value: epqHoldOrderCosts)
}

func economicProductionQuantityTotalCostsFormatted(epqSolution: Double, R: Double, S: Double, H: Double, P: Double, K: Double) -> String {
    let epqTotalCosts = ((H*(epqSolution/2))*(K-R)/K) + (S*(R/epqSolution)) + (P*R)
    return formatCurrencyUSD(value: epqTotalCosts)
}

func setEPQFormulaRect() -> CGRect? {
    let deviceScreenType = getDeviceScreenType()
    if deviceScreenType == "iPhone4.7" {
        let formulaRect = CGRect(origin: CGPoint(x: 10, y: 237.5),
                                 size:CGSize(width:200, height:100))
        return formulaRect
    } else if deviceScreenType == "iPhone5.8" {
        let formulaRect = CGRect(origin: CGPoint(x: 10, y: 267.5),
                                 size:CGSize(width:200, height:100))
        return formulaRect
    } else if deviceScreenType == "iPhone4.0" {
        let formulaRect = CGRect(origin: CGPoint(x: 10, y: 237.5),
                                 size:CGSize(width:200, height:100))
        return formulaRect
    } else if deviceScreenType == "iPhone5.5" {
        let formulaRect = CGRect(origin: CGPoint(x: 10, y: 237.5),
                                 size:CGSize(width:200, height:100))
        return formulaRect
    }
    return nil
}
