//
//  BoardView.swift
//  Practica2_2
//
//  Created by Javier  Amor De La Cruz on 9/10/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit


protocol BoardViewDataSource: class {
    
    /// Preguntar al Data Source cuantas filas tiene el tablero a pintar.
    
    func numberOfRows(in boardView: BoardView) -> Int
    
    
    
    /// Preguntar al Data Source cuantas columnas tiene el tablero a pintar.
    
    func numberOfColumns(in boardView: BoardView) -> Int
    
    
    
    /// Preguntar al Data Source que imagen hay que poner como fondo en una posicion del tablero.
    
    func backgroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage?
    
    
    
    /// Preguntar al Data Source que imagen hay que poner en primer plano en una posicion del tablero.
    
    func foregroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage?
    
}


//@IBDesignable
class BoardView: UIView {
    
    // Data-Source para obtener los datos del tablero a pintar
    weak var dataSource: BoardViewDataSource!
    
    
    var boxSize: CGFloat!
    
    @IBInspectable
    var bgColor: UIColor! = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        updateBoxSize()
        drawBackground()
        drawBlocks()
        
    }
    
    
    // Pinta los bloques añadidos/Congelados en el tablero
    private func drawBlocks(){
        // Tamaño del tablero
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        
        for r in 0..<rows {
            for c in 0..<columns {
                drawBox(row: r, column: c)
            }
        }
    }
    // Pinta el fondo
    private func drawBackground(){
        // Tamaño del tablero
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        let x = (bounds.size.width - box2Point(columns)) / 2
        
        let rect = CGRect(x: x, y:0, width: box2Point(columns), height: box2Point(rows))
        let path = UIBezierPath(rect: rect)
        
        bgColor.setFill()
        UIColor.blue.setStroke()
        path.lineWidth = 2
        path.stroke()
        path.fill()
    }
    
    
    // Dibuja un cuadrado en la pos. indicada
    private func drawBox(row: Int, column: Int){
        let columns = dataSource.numberOfColumns(in: self)
        let x = box2Point(column) + (bounds.size.width - box2Point(columns)) / 2
        let y = box2Point(row)
        let width = box2Point(1)
        let height = box2Point(1)
        
        let rect = CGRect(x: x,
                          y: y,
                          width: width,
                          height: height)
        if let bgImg = dataSource.backgroundImageName(in: self, atRow: row, atColumn: column) {
            bgImg.draw(in: rect)
        }
        
        
        if let fgImg = dataSource.foregroundImageName(in: self, atRow: row, atColumn: column) {
            fgImg.draw(in:rect)
        }
    }
    
    // Calcula el tamaño actual de la box
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
    
    // Transforma una coordenada box a puntos.
    private func box2Point(_ box: Int) -> CGFloat {
        
        return CGFloat(box) * boxSize
      
    }



}
