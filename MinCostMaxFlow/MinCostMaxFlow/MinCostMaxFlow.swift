//
//  MinCostMaxFlow.swift
//
//  Implementation of min cost max flow algorithm using adjacency
//  matrix (Edmonds and Karp 1972)
//
//  Created by Alexander Fedosov on 05.02.16.
//  Copyright © 2016 Alexander Fedosov. All rights reserved.
//

import Foundation

typealias IntArray = Array<Int>
typealias IntMatrix = Array<IntArray>

let INF = Int.max / 4

struct Pair<T, K>{
    var key: T?
    var value: K?
}

class MinCostMaxFlow {
    var found = Array<Bool>()
    var N: Int = 0
    
    var cap, flow, cost: IntMatrix
    var dist, pi, width: IntArray
    var dad = Array<Pair<Int, Int>>()
    
    init(){
        dist = IntArray()
        dad = Array<Pair<Int, Int>>()
        cap = IntMatrix()
        cost = IntMatrix()
        pi = IntArray()
        flow = IntMatrix()
        width = IntArray()
    }
    
    func Relax(s: Int, k: Int, cap: Int, cost: Int, dir: Int) {
        let val = dist[s] + pi[s] - pi[k] + cost
        if (cap > 0 && (val < dist[k])) {
            dist[k] = val;
            dad[k] = Pair<Int, Int>(key: s, value: dir)
            width[k] = min(cap, width[s]);
        }
    }
    
    func Dijkstra(var s:Int, t: Int) -> Int {
        found = Array<Bool>(count: N, repeatedValue: false)
        dist = [Int](count: N, repeatedValue: INF)
        width = [Int](count: N, repeatedValue: 0)
        
        dist[s] = 0;
        width[s] = INF;
        
        while (s != -1) {
            var best = -1;
            found[s] = true;
            for (var k = 0; k < N; k++) {
                if (found[k]) {
                    continue
                }
                Relax(s, k: k, cap: cap[s][k] - flow[s][k], cost: cost[s][k], dir: 1);
                Relax(s, k: k, cap: flow[k][s], cost: -cost[k][s], dir: -1);
                if (best == -1 || dist[k] < dist[best]) {
                    best = k;
                }
            }
            s = best;
        }
        
        for (var k = 0; k < N; k++){
            pi[k] = min(pi[k] + dist[k], INF);
        }
        
        return width[t];
    }
    
    func getMaxFlow(cap: IntMatrix, cost: IntMatrix, source: Int, sink: Int) -> (totalFlow: Int, totalCost: Int) {
        self.cap = cap
        self.cost = cost
        
        N = cap.count
        
        found = [Bool](count: N, repeatedValue: false)
        dist = [Int](count: N, repeatedValue: INF)
        width = [Int](count: N, repeatedValue: 0)
        dad = [Pair<Int, Int>](count: N, repeatedValue: Pair<Int,Int>(key: 0, value: 0))
        pi = [Int](count: N, repeatedValue: 0)
        flow = [[Int]](count: N, repeatedValue: [Int](count: N, repeatedValue: 0))
        
        var totalFlow = 0
        var totalCost = 0
        
        var amt = Dijkstra(source, t: sink)
        while (amt != 0) {
            totalFlow += amt;
            for (var x = sink; x != source; x = dad[x].key!) {
                if (dad[x].value == 1) {
                    flow[dad[x].key!][x] += amt;
                    totalCost += amt * cost[dad[x].key!][x];
                } else {
                    flow[x][dad[x].key!] -= amt;
                    totalCost -= amt * cost[x][dad[x].key!];
                }
            }
            amt = Dijkstra(source, t: sink)
        }
        
        return (totalFlow, totalCost)
    }
}