//
//  RealmExtension.swift
//  InvestImmo
//
//  Created by Nicolas Lion on 29/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import RealmSwift

extension Realm {
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        }
        catch {
            fatalError("Un problème est survenu avec la base de données.")
        }
    }

    func safeWrite(_ block: () -> ()) {
        do {
            // Async safety, to prevent "Realm already in a write transaction" Exceptions
            if !isInWriteTransaction {
                try write(block)
            }
        } catch {
            fatalError("Un problème est survenu avec la base de données.")
        }
    }
}
