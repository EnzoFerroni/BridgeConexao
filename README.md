# BridgeConexao

[![iOS | tvOS](https://img.shields.io/badge/iOS%20%7C%20tvOS-000000?logo=apple)](https://developer.apple.com/)
[![Swift](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)](https://swift.org)
[![GameKit](https://img.shields.io/badge/GameKit-Game%20Center-34C759)](https://developer.apple.com/documentation/gamekit)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

A short study comparing Game Center (GameKit) and a custom network layer for real-time iPhone-to-Apple TV multiplayer in Swift.

## Table of Contents

- [About](#about)
- [Game Center Implementation](#game-center-implementation)
- [Packet Traffic Comparison](#packet-traffic-comparison)
- [Reference Projects](#reference-projects)
- [Team](#team)
- [License](#license)

## About

In a previous Apple Developer Academy challenge, two teams built party games where
iPhones act as controllers for a game running on Apple TV. One used **Game Center**
matchmaking, the other a **custom network connection**. This repository compares both
approaches on two axes: how hard each one is to implement and adapt, and how much
packet traffic each one generates.

## Game Center Implementation

The Game Center side lives in
[`GameCenter/ViewModel/MatchManagerViewModel.swift`](GameCenter/ViewModel/MatchManagerViewModel.swift).
Messages are plain strings with a command prefix, sent through `GKMatch`
(simplified excerpt):

```swift
func sendString(_ message: String) {
    guard let encoded = "strData:\(message)".data(using: .utf8) else { return }
    sendData(encoded, mode: .reliable)
}

func sendData(_ data: Data, mode: GKMatch.SendDataMode) {
    try? match?.sendData(toAllPlayers: data, with: mode)
}
```

On tvOS, incoming commands such as `position` are parsed and forwarded to the current
scene, so each iPhone moves its own player on the TV.

## Packet Traffic Comparison

Packet traces captured during gameplay:

<img width="100%" alt="Packet trace comparison" src="https://github.com/user-attachments/assets/96eab7a0-a58f-4976-8f5b-016b2b2999ed" />
<img width="100%" alt="Packet trace detail" src="https://github.com/user-attachments/assets/c478f00b-2ee9-4ce8-b435-2a7651b88b9a" />

## Reference Projects

The two games compared:

- [SlingFighters](https://github.com/PedroTessaro/SlingFighters) (Narebatalha)
- [ProjectAraraAzul](https://github.com/hyauss/ProjectAraraAzul) (Próxima Estação)

## Team

<div align="center">
  <table>
    <tr>
      <td align="center" width="33%">
        <a href="https://github.com/EnzoFerroni"><img src="https://github.com/EnzoFerroni.png" width="90" alt="Enzo Ferroni"/></a>
        <br/><sub><b>Enzo Ferroni</b></sub><br/><br/>
        <a href="https://github.com/EnzoFerroni"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
        <a href="https://www.linkedin.com/in/enzoferroni/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
      </td>
      <td align="center" width="33%">
        <a href="https://github.com/PedroTessaro"><img src="https://github.com/PedroTessaro.png" width="90" alt="Pedro Tessaro"/></a>
        <br/><sub><b>Pedro Tessaro</b></sub><br/><br/>
        <a href="https://github.com/PedroTessaro"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
        <a href="https://www.linkedin.com/in/pedrotessaro/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
      </td>
      <td align="center" width="33%">
        <a href="https://github.com/hyauss"><img src="https://github.com/hyauss.png" width="90" alt="Vinicius Marques"/></a>
        <br/><sub><b>Vinicius Marques</b></sub><br/><br/>
        <a href="https://github.com/hyauss"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
        <a href="https://www.linkedin.com/in/vinicius-marques-966918274/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
      </td>
    </tr>
  </table>
</div>

## License

Released under the [MIT License](LICENSE). Copyright (c) 2026 Enzo Ferroni, Pedro
Tessaro and Vinicius Marques.
