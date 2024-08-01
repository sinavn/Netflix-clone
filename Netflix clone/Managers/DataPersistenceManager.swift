//
//  DataPersistenceManager.swift
//  Netflix clone
//
//  Created by Sina Vosough Nia on 5/10/1403 AP.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith (model:Movie , completion:@escaping (Result<Void, Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id)
        item.backdropPath = model.backdropPath
        item.originalName = model.originalName
        item.originalTitle = model.originalTitle
        item.overview = model.overview
        item.posterPath = model.posterPath
        item.title = model.title
        
        do {
            try context.save()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchData (completion : @escaping (Result<[TitleItem], Error>)->Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        
//        let request : NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
         
        do {
            let titles = try context.fetch(TitleItem.fetchRequest())
            completion(.success(titles))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteData (item:TitleItem ,completion:@escaping (Result<Void, Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(item)
        do {
            try context.save()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
}
