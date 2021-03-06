//
//  ContentView.swift
//  WindowsConnect
//
//  Created by Kenny Langston on 3/4/21.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var server = Server();
    @State private var messageToSend = "";

    var body: some View {
        VStack {
            Button("Start Server") {
                server.start()
            }
            .padding(/*@START_MENU_TOKEN@*/.all, 8.0/*@END_MENU_TOKEN@*/)
            .buttonStyle(DefaultButtonStyle())
            .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
        
            HStack {
                Text("Server State:")
                Text(String(describing: server.listenerState) )
                    .foregroundColor(Color.yellow)
            }
            HStack {
                Text("Connection State:")
                Text(String(describing: server.connectionState))
                    .foregroundColor(Color.yellow)
            }
            HStack {
                Text("Last Message Rcvd:")
                Text(String(describing: server.lastReceivedMessage))
                    .foregroundColor(Color.yellow)
            }
        }
        VStack {
            if (server.connectionState == .ready) {
                TextField("message to send", text: $messageToSend)
                    .padding(/*@START_MENU_TOKEN@*/.horizontal, 10.0/*@END_MENU_TOKEN@*/)
                    .frame(width: 350, height: 30)
                    .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                Button("Send Message") {
                    server.sendMessage(messageString: messageToSend)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(/*@START_MENU_TOKEN@*/.all, 8.0/*@END_MENU_TOKEN@*/)
                .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            }
        }
        .padding(.top, 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
