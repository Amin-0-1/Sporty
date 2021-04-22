//
//  WebService.swift
//  SportsApp
//
//  Created by Amin on 20/04/2021.
//

import Foundation
import Alamofire
import SwiftyJSON



class WebService {
    
    
    public func getUpcoming(bySeason:String,id:String,compilation: @escaping ([Team])->Void){
        let url = "\(URLs.upcomingEvents)\(id)&s=\(bySeason)"
        AF.request(url)
        .validate()
        .responseDecodable(of: AllTeams.self) { (response) in
            switch response.result {
            
            case .success( _):
                print("sucess")
                guard let arrayOfTeams = response.value?.teams else { return }
                compilation(arrayOfTeams)
                
            case .failure(let error):
                print(error.localizedDescription)
                compilation([])
            }
        }
    }
    
    public func getAllTeamsInLeagueByLeagueId(id:String,compilation: @escaping ([Team])->Void){
        let url = "\(URLs.allTeamsInLeague)\(id)"
        AF.request(url)
        .validate()
        .responseDecodable(of: AllTeams.self) { (response) in
            switch response.result {
            
            case .success( _):
                print("sucess")
                guard let arrayOfTeams = response.value?.teams else { return }
                compilation(arrayOfTeams)
                
            case .failure(let error):
                print(error.localizedDescription)
                compilation([])
            }
        }
    }
    public func getLatestInLeagueById(id:String,compilation: @escaping ([Event])->Void) {
        let url = "\(URLs.eventUrl)\(id)"
        AF.request(url)
        .validate()
        .responseDecodable(of: Response.self) { (response) in
            switch response.result {
            
            case .success( _):
                print("sucess")
                guard let arrayOfEvents = response.value?.events else { return }
                compilation(arrayOfEvents)
                
            case .failure(let error):
                print(error.localizedDescription)
                compilation([])
            }
        }
    }
    public func callSportsAPI(compilation: @escaping ([Sport])->Void) {
        AF.request(URLs.allSports)
        .validate()
        .responseDecodable(of: AllSports.self) { (response) in
            switch response.result {
            
            case .success( _):
                print("sucess")
                guard let arrayOfSports = response.value?.sports else { return }
                compilation(arrayOfSports)
                
            case .failure(let error):
                print(error.localizedDescription)
                compilation([])
            }
        }
    }
}


