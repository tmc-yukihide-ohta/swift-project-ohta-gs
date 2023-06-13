//
//  ContentView.swift
//  swift-project-ohta-gs
//
//  Created by user on 2023/06/12.
//

import SwiftUI


struct ContentView: View {
    @State var inputText: String = ""
    @State var shoppingItems: [ShoppingItem] = []
    
    var body: some View {
        // 縦に並べて表示
        VStack {
            // タイトル
            Text("🛒お店にGo!!")
                .font(.largeTitle)
            // 横に並べて表示
            HStack {
                // 複数行の入力エリア
                TextEditor(text: $inputText)
                    // 隙間、高さ、枠線を設定
                    .padding()
                    .font(.title2)
                    .frame(height: 110.0)
                    .border(Color.gray)
                
                // ボタン
                // Button(action: { ボタンがタップされた時の処理 }) { ボタンの表示内容（テキスト、イメージなど）}
                Button(action: {
                    // ボタンを押した時に関数を呼び出す
                    // 関数を別ファイルに移動したため、引数名と引数を書く必要がある
                    addItemsToList(inputText: &inputText, shoppingItems: &shoppingItems)
                }) {
                    VStack(spacing: 10) {
                        // ボタンの名称
                        // システムのアイコン（四角とペン）を表示
                        Image(systemName: "square.and.pencil")
//                        Image(systemName: "cart.badge.plus")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("追加")
                            .font(.title3)
                            .fontWeight(.bold)
                        }
                        //  隙間、高さ、背景色、文字色、角の丸みを設定
                        .padding()
                        .frame(height: 110)
//                        .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: 5)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            // 下側に隙間
            .padding(.bottom, 10)

            HStack(spacing: 0) {
                Image(systemName: "list.bullet.clipboard")
                    .font(.title)
                // テキスト
                Text("買物リスト")
                // titleのフォントスタイルの設定
                    .font(.title)
                    .padding()
            }
            // スクロールできる範囲の設定
            ScrollView {
                // 縦に要素を並べて表示（要素は左づめ、要素間の隙間は1）
                VStack(alignment: .leading, spacing: 1) {
                    // ForEach(配列の範囲, id: 繰り返し要素の識別子) { 識別子を示す変数 in
                        // 繰り返し処理内容
                    //}
                    // ForEachは配列の繰り返し処理(indicesは配列のインデックスの範囲、\.selfはその要素自体という意味、indexは配列の番号が入る 0,1,2...)
                    ForEach(shoppingItems.indices, id: \.self) { index in
                        //　配列の要素を定数に代入（扱いやすいように）
                        let shoppingItem = shoppingItems[index]
                        // 視覚的な区切り線
                        Divider()
                        // 横に要素を並べて表示（要素間の隙間は0）
                        HStack(spacing: 0) {
                            // ボタン
                            Button(action: {
                                // デバッグ領域にプリントする（下記はJSのリテラルみたいな書き方をしている）
                                // print("表示文字 \(変数)")
                                print("shoppingItem: \(shoppingItem)")
                                print("index: \(index)")
                                // ボタンを押した時に関数を呼び出す
                                // 関数に引数を渡す場合、関数名（引数名：arg　値：index）となる、関数名は任意
                                // fromも引数名、&は参照渡しを行うため、関数内での変更が呼び出し元にも反映される
                                deleteItem(arg: index, from: &shoppingItems)
                            }) {
                                // システムのアイコン（ゴミ箱）を表示
                                Image(systemName: "trash")
                                    // 隙間とアイコンや文字の色を指定
                                    .font(.title)
                                    .padding()
                                    .foregroundColor(.red)
                                    // タップ領域を矩形領域に指定
                                    .contentShape(Rectangle())
                            }
                            Divider()
                            Text(shoppingItem.text)
                                .font(.title2)
                                .padding()
                                // 文字色の設定（条件演算子を利用：文字列をタップしたらtrue、Colorの色、それ以外flaseはblack）
                                // 色はprimaryでも設定可能・・・システムのプライマリーカラー）
                                .foregroundColor(shoppingItem.isTapped ? Color(red: 0.85, green: 0.85, blue: 0.85, opacity: 1.0) : .black)
                                // テキストに取消線を設定（shoppingItem.isTappedがtrueの時、取消線が入る、オプションで取消線の色も定義できる
                                // .strikethrough(ブーリアン, Color: Colorの設定）
                                .strikethrough(shoppingItem.isTapped)
                                // 左づめで横幅いっぱいに設定
                                .frame(maxWidth: .infinity ,alignment: .leading)
                                .contentShape(Rectangle())
                                // タップジェスチャー（タップイベント）を追加
                                .onTapGesture {
                                    // タップされたら関数を呼び出す
                                    toggleItemSelection(arg: index, from: &shoppingItems)
                                }
                        }
                    }
                    Divider()
                }
            }
            
            Button(action: {
                removeAllSelectedItems(shoppingItems: &shoppingItems)
            }) {
                HStack {
                    Image(systemName: "checkmark.square")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("選択した商品を買ったよ！")
                        .font(.title3)
                        .fontWeight(.bold)
                }
                .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

// ShoppingItem という名前の構造体を定義
// ShoppingItem は Identifiable プロトコルと Equatable プロトコルに準拠
// Identifiable プロトコルに準拠していることは、各 ShoppingItem インスタンスが一意の識別子 (id) を持つことを意味しid プロパティを持つ必要がある
// ShoppingItem が Equatable プロトコルに準拠していることは、ShoppingItem インスタンス同士を比較することができることを意味し、== 演算子の実装が必要
struct ShoppingItem: Identifiable {
    let id = UUID()
    var text: String
    var isTapped: Bool = false
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
