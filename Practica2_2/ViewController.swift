//
//  ViewController.swift
//  Practica2_2
//
//  Created by Javier  Amor De La Cruz on 9/10/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScoreDelegate, BoardDelegate, BoardViewDataSource, BlockViewDataSource {

    var board: Board!
    
    @IBOutlet weak var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var imagesCache = [String:UIImage]()
    
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

