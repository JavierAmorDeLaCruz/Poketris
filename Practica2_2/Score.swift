//
//  Score.swift
//  Practica2_2
//
//  Created by Carlos  on 16/10/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import Foundation

protocol ScoreDelegate: class {
    func sumaPuntos()
}

class Score {
    
    weak var delegate: ScoreDelegate?
    
    var puntuacion: Int
    var record: Int
    
    init() {
        puntuacion = 0
        record = 0
    }
    
    func newGame() {
        puntuacion = 0
    }
    
    func newRecord() {
        record = (record > puntuacion) ? record : puntuacion
    }
}
