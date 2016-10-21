//
//  ViewController.swift
//  Practica2_2
//
//  Created by Javier  Amor De La Cruz on 9/10/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScoreDelegate, BoardDelegate, BoardViewDataSource, BlockViewDataSource {

    var board: Board! = Board()
    var score: Score! = Score()
    var gameInProgress = false
    var timer: Timer?
    var n=1
    var nPartidas = 0
    
    @IBOutlet weak var labelPartidas: UILabel!
    @IBOutlet weak var labelPuntuacion: UILabel!
    @IBOutlet weak var labelRecord: UILabel!
    
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var blockView: BlockView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        board.delegate = self
        score.delegate = self
        
        boardView.dataSource = self
        blockView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.ProcessTap(_:)))
        tap.numberOfTapsRequired = 1
        boardView.addGestureRecognizer(tap)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.Swipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        boardView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.Swipe(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        boardView.addGestureRecognizer(swipeLeft)
        
        let rotation = UIRotationGestureRecognizer(target: self, action:
            #selector(ViewController.rotation(_:)))
        boardView.addGestureRecognizer(rotation)
        
        startNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    
    
    private func startNewGame() {
        score.newGame()
        board.newGame()
        
        labelPartidas.text = "Partidas: \(nPartidas)"
        labelPuntuacion.text = String(score.puntuacion)
        labelRecord.text = String("Record: \(score.record)")
        
        gameInProgress = true
        
        autoMoveDown()
    }
    
    @IBAction func ProcessTap(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .recognized {
            
            timer?.invalidate()
            
            board.moveDown(insertNewBlockIfNeeded: true)
            boardView.setNeedsDisplay()
            
            let interval = 1.0
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector (autoMoveDown) , userInfo: nil, repeats: false)
        }
        
    }

    @IBAction func Swipe(_ gesture: UIGestureRecognizer) {
        
      if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        
        switch swipeGesture.direction {
            
        case UISwipeGestureRecognizerDirection.right:
            board.moveRight()
            boardView.setNeedsDisplay()
            
        case UISwipeGestureRecognizerDirection.left:
            board.moveLeft()
            boardView.setNeedsDisplay()
        
        default:
            return
        }
      }
    }
    
    @IBAction func moveLeft(_ sender: UIButton) {
        board.moveLeft()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func rotation(_ gesture: UIGestureRecognizer) {
        
        if let rotationGesture = gesture as? UIRotationGestureRecognizer {
          
          if (rotationGesture.state == UIGestureRecognizerState.ended){
            
            if rotationGesture.rotation < 0 {
                board.rotate(toRight: false)
                boardView.setNeedsDisplay()
            }
            else{
                board.rotate(toRight: true)
                boardView.setNeedsDisplay()
            }
           
        }
        }
    }
    
    
    @IBAction func RotateRight(_ sender: UIButton) {
        board.rotate(toRight: true)
        boardView.setNeedsDisplay()
    }
    
    @IBAction func RotateLeft(_ sender: UIButton) {
        board.rotate(toRight: false)
        boardView.setNeedsDisplay()
    }
    
    @IBAction func PressDown(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state != .began { return }
        board.dropDown()
        boardView.setNeedsDisplay()
    }
   
    @IBAction func dropDown(_ sender: UIButton) {
        board.dropDown()
        boardView.setNeedsDisplay()
    }
    

    
    @IBAction func moveRight(_ sender: UIButton) {
        board.moveRight()
        boardView.setNeedsDisplay()
    }
 
    
    
    
    
    
    func autoMoveDown() {
        guard gameInProgress else {
            return
        }
        print("Iteracion Automovedown \(n)")
        n+=1
        board.moveDown(insertNewBlockIfNeeded: true)
        boardView.setNeedsDisplay()
        blockView.setNeedsDisplay()
        
        let interval = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector (autoMoveDown) , userInfo: nil, repeats: false)
        
        //timer?.fire()
    }
    
    // MARK: - Implementación de métodos de Board Delegate
    func gameOver() {
        print("Partida Finalizada")
        gameInProgress = false
        nPartidas += 1
        // Crear UIAlertController
        let alert = UIAlertController(title: "Fin de la partida", message: "Pulsar OK para jugar de nuevo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"OK",
                                      style: .default){
                        aa in self.startNewGame()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func rowCompleted() {
        sumaPuntos()
        print("Fila Completada")
    }
    
    // MARK: - Implementación de métodos de ScoreDelegate
    func sumaPuntos() {
        score.puntuacion += 1
        score.newRecord()
        labelRecord.text = String("Record: \(score.record)")
        labelPuntuacion.text = String(score.puntuacion)
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

