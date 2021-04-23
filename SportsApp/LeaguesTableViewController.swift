//
//  LeaguesTableViewController.swift
//  SportsApp
//
//  Created by Ayman Omara on 20/04/2021.
//

import UIKit
import Alamofire
import SDWebImage
class LeaguesTableViewController: UITableViewController,UISearchResultsUpdating {
    
    
    
    let webService = WebService();
    var array:[LeaguesDataClass] = [LeaguesDataClass]();
    var arrayLeagues:[LeagueById] = [LeagueById]()
    var strSport = "Soccer" ;
    var leageArrar:[LeaguesDataClass] = [LeaguesDataClass]();
    
    @IBOutlet var leaguesTableOutlet: UITableView!
    let searchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //search bar attributes
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        leaguesTableOutlet.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        webService.allLeaguesAPI(compilation: { (allLeagues) in
            if allLeagues.count == 0{
                print("show alert")
            }else{
                                
                for iteam in allLeagues{
                    if iteam.strSport.rawValue == self.strSport {
                        self.array.append(iteam)
                    }
                }
                DispatchQueue.main.async {
                    self.leaguesTableOutlet.reloadData()
                }
                var x = 0
                for i in self.array{
                    
                    self.webService.lookUpLeagueById(id: i.idLeague) { (LeagueById) in
                        if LeagueById.count == 0{
                            print("show alert")
                        }
                        else{
                            x = x + 1
                            print(x)
                            self.arrayLeagues.append(LeagueById[0])
                            DispatchQueue.main.async {
                                self.leaguesTableOutlet.reloadData()
                            }
                        }
                        
                    }
                }
                

            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeaguesTableViewCell;
        
       
        cell.leagueTitleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.leagueTitleImage.sd_imageIndicator?.startAnimatingIndicator()
        cell.leageNameOutlet.text = array[indexPath.row].strLeague
        
        if arrayLeagues.count == array.count {
            
            for item in arrayLeagues {
                if item.idLeague == array[indexPath.row].idLeague{
                    cell.leagueTitleImage.sd_setImage(with: URL(string: item.strBadge!), completed: {(image,error,cach,url)in
                        cell.leagueTitleImage.sd_imageIndicator?.stopAnimatingIndicator()
                    })
                    cell.youtubeBtn.accessibilityValue = arrayLeagues[indexPath.row].strYoutube
                    
                    if arrayLeagues[indexPath.row].strYoutube == ""{
                        cell.youtubeBtn.isEnabled = false
                    }else{
                        cell.youtubeBtn.isEnabled = true
                    }
                    cell.youtubeBtn.isHidden = false
                    cell.youtubeBtn.addTarget(self, action: #selector(self.youtubeTapped), for: .touchUpInside)
                    break
                }
            }
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVc = self.storyboard?.instantiateViewController(identifier: "LeaguesDetailsVC") as! LeaguesDetailsVC
        
        for i in arrayLeagues{
            if i.idLeague == array[indexPath.row].idLeague{
                detailsVc.leagueData = i
                break
            }
        }
        
        present(detailsVc, animated: true, completion: nil)
    }
    
    @objc func youtubeTapped(sender:UIButton){
        print(sender.accessibilityValue!)
        let application = UIApplication.shared
        let url = sender.accessibilityValue!
        
        if application.canOpenURL(URL(string: url)!) {
             application.open(URL(string: url)!)
         }else {
             // if Youtube app is not installed, open URL inside Safari
            application.open(URL(string: "https://\(url)")!)
         }
    }
    
    
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        
        
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    
    
    
    
    
}
