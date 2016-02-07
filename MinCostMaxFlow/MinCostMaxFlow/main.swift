//
//  main.swift
//  MinCostMaxFlow
//
//  Created by Alexander Fedosov on 07.02.16.
//  Copyright © 2016 Alexander Fedosov. All rights reserved.
//

import Foundation

// vertext count
let N = 6

// init capacity and cost matrix
var capacity = [[Int]](count: N, repeatedValue: [Int](count: N, repeatedValue: 0))
var cost = [[Int]](count: N, repeatedValue: [Int](count: N, repeatedValue: 0))

// connect edges
capacity[0][1] = 1
capacity[0][2] = 1
capacity[0][5] = 1
capacity[2][3] = 1
capacity[3][4] = 1
capacity[1][5] = 1
capacity[5][4] = 1

// add edge with hight cost
cost[0][5] = 1

let flow = MinCostMaxFlow()
let (totalFlow, totalCost) = flow.getMaxFlow(capacity, cost: cost, source: 0, sink: 4)

print("total flow: \(totalFlow), total cost: \(totalCost)")