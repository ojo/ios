//
//  ArgoDecodableFuncs.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/5/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import Argo
import Runes

func either<T: Decodable>(_ j: JSON, _ field: String, _ alt: String) -> Decoded<T> where T == T.DecodedType {
    return j <| field <|> j <| alt
}

func eitherO<T: Decodable>(_ j: JSON, _ field: String, _ alt: String) -> Decoded<T?> where T == T.DecodedType {
    return  j <|? field <|> j <|? alt
}

func get<T: Decodable>(_ j: JSON, _ field: String) -> Decoded<T> where T == T.DecodedType {
    return  j <| field
}

func toInt(_ text: String) -> Decoded<Int> {
    return .fromOptional(Int(text))
}
