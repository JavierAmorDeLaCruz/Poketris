//
//  ViewController.swift
//  Practica2_2
//
//  Created by Javier  Amor De La Cruz on 9/10/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,/* ScoreDelegate, */BoardDelegate, BoardViewDataSource, BlockViewDataSource {

    var board: Board!
    var gameInProgress = false
    var timer: Timer?
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var blockView: BlockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        board.delegate = self
        //score.delegate = self
        
        boardView.dataSource = self
        blockView.dataSource = self
        startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startNewGame() {
        //score.newGame()
        board.newGame()
        
        gameInProgress = true
        
        autoMoveDown()
    }
    
    func autoMoveDown() {
        guard gameInProgress else {
            return
        }
        board.moveDown(insertNewBlockIfNeeded: true)
        boardView.setNeedsDisplay()
        
        let interval = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector (autoMoveDown) , userInfo: nil, repeats: false)
        
        timer?.fire()
    }
    
    // MARK: - Implementación de métodos de Board Delegate
    func gameOver() {
        print("Partida Finalizada")
        gameInProgress = false
        // Crear UIAlertController
        let alert = UIAlertController(title: "Fin de la partida", message: "Pulsar OK para jugar de nuevo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK",
                                      style: .default){
                        aa in self.startNewGame()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func rowCompleted() {
        print("Fila Completada")
        
    }
    
    
    var imagesCache = [String:UIImage]()
    
    // MARK: - Data Source de tablero
    
    func numberOfRows(in boardView: BoardView) -> Int {
        return board.rowsCount
    }
    
    func numberOfColumns(in boardView: BoardView) -> Int {
        return board.columnsCount
    }
    
    func backgroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        
        if let texture = board.currentTexture(atRow: row, atColumn: column) {
            
            let imageName = texture.backgroundImageName()
            
            return cachedImage(name: imageName)
            
        }
        
        return nil
        
    }
    
    func foregroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        
        if  let texture = board.currentTexture(atRow: row, atColumn: column) {
            
            let imageName = texture.pokemonImageName()
            
            return cachedImage(name: imageName)
            
        }
        
        return nil
        
    }
    
    // MARK: - Data Source de NextBlock
    func BlockWidth(for blockView: BlockView) -> Int {
        return board.nextBlock?.width ?? 0
    }
    func BlockHeight(for blockView: BlockView) -> Int {
        return board.nextBlock?.height ?? 0
    }
    func backgroundImageName(for blockView: BlockView, atRow row: Int, atColumn column: Int) -> UIImage? {
      guard let block = board.nextBlock,
            block.isSolid(row: row, column: column)
      else {
            return nil
        }
        let imageName = block.texture.backgroundImageName()
        return cachedImage(name: imageName)
    }
    
    func foregroundImageName(for blockView: BlockView, atRow row: Int, atColumn column: Int) -> UIImage? {
      guard let block = board.nextBlock,
            block.isSolid(row: row, column: column)
      else {
                return nil
        }
        let imageName = block.texture.pokemonImageName()
        return cachedImage(name: imageName)
    }
    
    // Metodo auxiliar de Caché de imagenes
    private func cachedImage(name imageName: String) -> UIImage? {
        
        if let image = imagesCache[imageName] {
            
            return image
            
        } else if let image = UIImage(named: imageName) {
            
            imagesCache[imageName] = image
            
            return image
            
        }
        
        return nil
        
    }

}

