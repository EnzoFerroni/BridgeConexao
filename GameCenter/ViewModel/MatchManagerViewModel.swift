//
//  MatchManagerViewModel.swift
//  POCNetWorkGameCenter
//
//  Created by Vinicius Marques on 11/02/26.
//

//Arquivo de conexão utilizado no jogo: Próxima-Estação

import SwiftUI
import Foundation
internal import Combine
import GameKit
import SpriteKit
import GameplayKit



@MainActor
class MatchManagerViewModel: NSObject, ObservableObject, GKMatchmakerViewControllerDelegate{
    
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var authenticationState = PlayerAuthState.authenticating
    @Published var score = 0
    @Published var remainingTime = maxTimeRemaining
    @Published var lastReceived = ""
    @Published var pastGuesses = ["",""]
    
    var match: GKMatch?
    var localPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var playerUUIDKey = UUID().uuidString
    
    var rootViewController: UIViewController?{
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }

    static let shared = MatchManagerViewModel()

    private override init() {
        super.init()
    }
    
    var playersIdList : [String] = []
    @Published var menu: Bool = true
    
    func receiveIDsList(id: String){
        playersIdList.append(id)
        if playersIdList.count == match!.players.count{
            menu = true
        }
    }
    
    func receivedString(_ message: String){
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else{ return }
        let parameter = String (messageSplit.last ?? "")
        
        switch messagePrefix{
        case "began":
            
            #if os(tvOS)
            receiveIDsList(id: parameter)
            #endif
            
            inGame = true
        case"position":
            
            #if os(tvOS)
            let parameterSplit = parameter.split(separator: "!")
            
            let playerId = parameterSplit[0]
            guard let positionX = Double(parameterSplit[1]) else { return }
            guard let positionY = Double(parameterSplit[2]) else { return }

            SceneManager.shared.currentScene.receiveInput(player: String(playerId), input: CGPoint(x: positionX, y: positionY))
            return
            #endif

            return
        default:
            break
        }
    }
    
    func startGame(newMatch: GKMatch){
        self.match = newMatch
        self.match?.delegate = self

        otherPlayer = match?.players.first
        SendString("began:\(playerUUIDKey)")
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        startGame(newMatch: match)
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: any Error) {
        viewController.dismiss(animated: true)
    }
    
    func startMatchMaking() {
        let request = GKMatchRequest()
        request.minPlayers = 3
        request.maxPlayers = 5
        let matchMakingVC = GKMatchmakerViewController(matchRequest: request)
        matchMakingVC?.matchmakerDelegate = self
        rootViewController?.present(matchMakingVC!, animated: true)
    }
    
    func authenticateUser(){
        GKLocalPlayer.local.authenticateHandler = { [self] vc, e in
            if let viewController = vc{
                rootViewController?.present(viewController, animated:  true)
                return
            }
            
            if let error = e{
                authenticationState = .error
                return
            }
            if localPlayer.isAuthenticated{
                if localPlayer.isMultiplayerGamingRestricted{
                    authenticationState = .restricted
                }else{
                    authenticationState = .authenticated
                }
            }else{
                authenticationState = .unauthenticated
            }
        }
    }
}


extension MatchManagerViewModel: GKMatchDelegate{
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        
        if content.starts(with: "strData:"){
            let message = content.replacing("strData:", with: "")
            receivedString(message)
        }else{
            do{
                lastReceived = content
            }catch{

            }
            
        }
    }
    
    func SendString(_ message: String){
        guard let enconded = "strData:\(message)".data(using: .utf8) else {return}
        sendData(enconded, mode: .reliable)
    }
    
    func sendData(_ data: Data, mode: GKMatch.SendDataMode){
        do{
            try match?.sendData(toAllPlayers: data, with: mode)
        }catch{
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        
    }
}

