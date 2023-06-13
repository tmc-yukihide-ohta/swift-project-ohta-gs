//
//  Functions.swift
//  swift-project-ohta-gs
//
//  Created by user on 2023/06/13.
//

import SwiftUI
import Foundation


// 入力されたテキストを改行区切りで、買物リストに追加する
// Bindingは、値の変更を監視し、変更が他の場所に伝えられる双方向の接続を提供する
// inputTextや、shoppingItemsに変更が加えられると、それが関連するビューに反映される
func addItemsToList(inputText: inout String, shoppingItems: inout [ShoppingItem]) {
    // 文字列を改行文字で分割してlinesに配列として格納
    // 文字列.split(separator: 区切り文字)
    //Binding型の変数は、その内部に値を保持しており、その値にアクセスするためにwrappedValueプロパティを使用
    let lines = inputText.split(separator: "\n")
    let newItems = lines.map { ShoppingItem(text: String($0))}
    // lines配列の各要素を、ShoppingItemのオブジェクトに変換し、それらのオブジェクトを、shoppingItems配列に追加
    // mapは与えられたクロージャーを各要素に適用し、新しい配列を生成
    // text: String($0) ・・・ ShoppingItemオブジェクトのtextは、現在処理しているlinesの要素String($0)を入れる
    shoppingItems.append(contentsOf: newItems)
    // 下記のコードと同じ動作をする、下の方がわかりやすい
    //        shoppingItems.append(contentsOf: lines.map { line in
    //            return ShoppingItem(text: String(line))
    //        })
    //        print("shoppingItems: \(shoppingItems)")
    inputText = ""
}

// タップされた要素を削除する
// inout修飾子は、関数内で引数の値を変更し、それが呼び出し元に反映されるようにするために使用し、関数内で引数の値を変更することが許可される、この場合、shoppingItemsは参照渡しとなり、関数内での変更が元の変数に反映される
func deleteItem(arg index: Int, from shoppingItems: inout [ShoppingItem]) {
    // indexの番号に該当する要素を削除して、後ろにある要素は前に詰まる
    shoppingItems.remove(at: index)
}

// タップしたらisTappedを反転させる
func toggleItemSelection(arg index: Int, from shoppingItems: inout [ShoppingItem]) {
    // 引数で渡された番号の配列の要素の、isTappedの値を反転させる
    shoppingItems[index].isTapped.toggle()
}

// shoppingItems 配列内の isTapped プロパティが true の要素をすべて削除
func removeAllSelectedItems(shoppingItems: inout [ShoppingItem]) {
    // removeALLメソッドは配列内の要素を順番に検査し、条件式が true を返す要素が見つかった場合、その要素が配列から削除
    // 配列.removeAll { 条件 }
    // removeAll(where:)は、指定した条件を満たす要素を削除
    shoppingItems.removeAll(where: { $0.isTapped })
    // 各要素(item)の、isTappedがtrueだったら削除
    //        shoppingItems.removeAll { item in
    //            return item.isTapped
    //        }
    }
