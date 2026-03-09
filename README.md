# Comparando Eficiência e Persnalização de Funções de Pareamento em Swift no Contexto de Jogos (Game Center x Network)

![Plataformas]( https://img.shields.io/badge/Platformas-iOS%20|%20tvOS-blue?logo=swift)

No Challenge passado, dois tipos de conexão foram utilizados em projetos diferentes. Vamos comparar a dificuldade de aplicação e adaptação de cada um, além de analisar o número de packet traces.

## Funções Utilizadas

### Essa função é resposável por mandar os pacotes para o servidor
```swift
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
    
```

### Essa função é resposável por receber os pacotes do servidor
```swift
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
```

**Onde está implementado:** `GameCenter/ViewModel/MatchManagerViewModel.swift`

# Comparação de trafégo de pacotes

<img width="2648" height="1562" alt="Imagem 09-03-2026 às 17 46" src="https://github.com/user-attachments/assets/96eab7a0-a58f-4976-8f5b-016b2b2999ed" />
<img width="2544" height="853" alt="Image 09-03-26 at 17 48" src="https://github.com/user-attachments/assets/c478f00b-2ee9-4ce8-b435-2a7651b88b9a" />


## Repositórios de Referência 

[Narebatalha](https://github.com/PedroTessaro/SlingFighters)

[Próxima Estação](https://github.com/hyauss/ProjectAraraAzul)

## Autores

Enzo Ferroni

Pedro Tessaro

Vinicius Marques
