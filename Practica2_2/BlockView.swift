//
//  BlockView.swift
//  Practica2_2
//
//  Created by Javier  Amor De La Cruz on 9/10/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

protocol BlockViewDataSource: class {
    
    /// Preguntar al Data Source cual es el ancho de la ficha
    func BlockWidth(for blockView: BlockView) -> Int
    
    
    /// Preguntar al Data Source cual es el alto de la ficha
    func BlockHeight(for blockView: BlockView) -> Int
    
    
    /// Preguntar al Data Source que imagen hay que poner en primer plano en una posicion de la ficha.
    
    func backgroundImageName(for blockView: BlockView, atRow row: Int, atColumn column: Int) -> UIImage?
    
    func foregroundImageName(for blockView: BlockView, atRow row: Int, atColumn column: Int) -> UIImage?
}

class BlockView: UIView {

    weak var dataSource: BlockViewDataSource!
    
    override func draw(_ rect: CGRect) {
        updateBoxSize()
        drawBlock()
        
    }
    // Pinta el bloque siguiente
    private func drawBlock() {
        let width = dataSource.BlockWidth(for: self)
        let heigth = dataSource.BlockHeight(for: self)
        
        for r in 0..<heigth {
            for c in 0..<width {
                drawBox(row: r, column:c)
            }
        }
    }
    
    // Dibuja un cuadrado en la pos. indicada
    private func drawBox(row: Int, column: Int){
        
        if let bgImg = dataSource.backgroundImageName(for: self, atRow: row, atColumn: column),
            let fgImg = dataSource.foregroundImageName(for: self, atRow: row, atColumn: column) {
            
            let x = box2Point(column)
            let y = box2Point(row)
            let width = box2Point(1)
            let height = box2Point(1)
            
            let rect = CGRect(x: x, y: y, width: width, height: height)
            
            bgImg.draw(in: rect)
            fgImg.draw(in: rect)
        }
    }
    
    // Calcula el tamaño actual de la box ????
    private func updateBoxSize() {
        // Tamaño del tablero
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        
        // Tamaño en puntos de la zona de la zona de la View donde voy a dibujar
        let width = bounds.size.width
        let height = bounds.size.height
        
        // Tamaño de un cuadrado en puntos
        let boxWidth = width / CGFloat(columns)
        let boxHeight = height / CGFloat(rows)
        
        boxSize = min(boxWidth, boxHeight)
    }
    
    // Transforma una coordenada box a puntos. ???
    private func box2Point(_ box: Int) -> CGFloat {
        return CGFloat(box) = boxSize
    }
    
    
    

}
