//
//  ViewController.swift
//  getJson
//
//  Created by YoNa on 2020/12/11.
//


import UIKit

class ViewController: UIViewController,XMLParserDelegate,UITableViewDelegate,UITableViewDataSource, UITabBarDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var titles:[String]=[]
    var links:[String]=[]
    var pubDate:[String]=[]
    var productList : [(maker:String , name:String , link:String ,image:String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate=self
        searchBar.placeholder="キーワードを入力してください"
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    
    //入力したキーワードをエンコード
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true) //ソフトキーボードを隠す
        print(searchBar.text!)
        if let searchWord = searchBar.text {
            searchProduct(keyword: searchWord) //自作関数
        }
    }
    
    // URLを作成する
    func searchProduct(keyword:String){
        self.productList.removeAll()
        let keyword_encode  = keyword.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let URL = NSURL(string:"http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode!)&max=10&oeder=r")
        let urlRequest = URLRequest(url: URL! as URL)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration,delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: urlRequest,completionHandler: {(data, response, error) -> Void in
            
            do{
                let json:Dictionary = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                
                if let items = json["item"] as? [[String:Any]]{
                    for item in items{
                        guard let maker = item["maker"] as? String
                        else{
                            continue
                        }
                        guard let name = item["name"] as? String
                        else{
                            continue
                        }
                        guard let link = item["url"] as? String
                        else{
                            continue
                        }
                        guard let image = item["image"] as? String
                        else{
                            continue
                        }
                        let product = (maker,name,link,image)
                        self.productList.append(product)
                        self.tableView.reloadData()
                    }
                }
            }catch {
                print("エラーが発生しました")
            }
        })
        task.resume()
        
    }
    
    
    // セルの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    // セルの内容を変更
    func tableView(_ tableView: UITableView, cellForRowAt
                    indexPath: IndexPath) -> UITableViewCell {
        let cell : MyCustomTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "ProductCell", for:
                                            indexPath) as! MyCustomTableViewCell
        cell.makerLabel.text = productList[indexPath.row].maker
        let url = URL(string: productList[indexPath.row].image)
        if let image_data = try? Data(contentsOf: url!){
            cell.productImage?.image = UIImage(data: image_data)
        }
        cell.productNameLabel.text = productList[indexPath.row].name
        return cell
    }
    
    //セルをタップすると動くメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(String(indexPath.row))
        if let url = URL(string: productList[indexPath.row].link){
            UIApplication.shared.open(url)
        }
    }
    
}
