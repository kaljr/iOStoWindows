//
//  Connection.swift
//  WindowsConnect
//
//  Created by Kenny Langston on 3/4/21.
//

import Foundation
import Network

class Server: ObservableObject {
    let listener: NWListener;
    var connection: NWConnection?;

    @Published var listenerState: NWListener.State = .setup;
    @Published var connectionState: NWConnection.State = .setup;
    @Published var lastReceivedMessage: String = "";
    
    init() {
        self.listener = try! NWListener(using: .tcp, on: 12345)
    }

    func start() {
        self.listener.stateUpdateHandler = self.listenerStateDidChange(to:)
        self.listener.newConnectionHandler = self.startNewConnection(nwConnection:)
        self.listener.start(queue: .main)
    }
    
    func listenerStateDidChange(to newState: NWListener.State) {
        self.listenerState = newState;
    }
    
    func startNewConnection(nwConnection: NWConnection) {
        self.connection = nwConnection;
        self.connection!.stateUpdateHandler = self.connectionStateDidChange;
        self.connection!.receive(minimumIncompleteLength: 0, maximumLength: 1024, completion: self.connectionReceivedMessage);
        self.connection!.start(queue: .main);
        self.sendMessage(messageString: "iOS connected")
    }
    
    func connectionStateDidChange(to newState: NWConnection.State) {
        self.connectionState = newState
    }
    
    func connectionReceivedMessage(data: Data?, contentContext: NWConnection.ContentContext?, flag: Bool, error: NWError?) {
        let dataString = String(decoding: data!, as: UTF8.self);
        self.lastReceivedMessage = dataString;
    }
    
    func sendMessage(messageString: String) {
        let messageData = messageString.data(using: .utf8)!;
        
        self.connection!.send(content: Data(messageData),
             completion: .contentProcessed({ error in
                if let error = error {
                    self.connectionDidFail(error: error)
                    return
                }
             }));
    }
    
    func connectionDidFail(error: Error) {
        self.connectionState = NWConnection.State.cancelled;
    }
}
