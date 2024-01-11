//
//  InfoView.swift
//  Snowise
//
//  Created by Marco Souza on 9/1/2024.
//
import SwiftUI
import CoreLocation
import MessageUI

class MessageDelegate: NSObject, ObservableObject, MFMessageComposeViewControllerDelegate {
    @Published var isShowingMessageComposeView = false

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Dismiss the message compose controller
        controller.dismiss(animated: true) {
            self.isShowingMessageComposeView = false

            // After sending the message, initiate a call to authorities (e.g., 112)
            if let url = URL(string: "tel://112"),
               UIApplication.shared.canOpenURL(url) {
                print("Calling authorities (e.g., 112)")
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Unable to initiate the call to authorities.")
            }
        }
    }
}

struct MessageComposeView: UIViewControllerRepresentable {
    let delegate: MessageDelegate

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        delegate.objectWillChange.send()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct EmergencyCallView: View {
    let phoneNumber: String?

    var body: some View {
        VStack {
            Text("Emergency Call")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if phoneNumber != nil {
                Text("Sending emergency message and calling authorities in progress...")
                    .padding()

                // Button to directly make a call to authorities
                Button(action: {
                    if let url = URL(string: "tel://112"),
                       UIApplication.shared.canOpenURL(url) {
                        print("Calling authorities (e.g., 112)")
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("Unable to initiate the call to authorities.")
                    }
                }) {
                    Text("Call Authorities")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
            } else {
                Text("Emergency phone number not available.")
                    .padding()
            }
        }
        .padding()
    }
}

struct InfoView: View {
    @ObservedObject var skiingViewModel = SkiingViewModel()
    @State private var currentCountry: String?
    @State private var emergencyPhoneNumber: String?
    @State private var friendPhoneNumberInput: String = ""
    @State private var isShowingEmergencyCallView = false
    @StateObject private var messageDelegate = MessageDelegate()

    var body: some View {
        VStack {
            Text("Emergency Call")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("In case of an emergency, press the button below to call emergency services.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            TextField("Enter friend's phone number", text: $friendPhoneNumberInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                self.skiingViewModel.requestLocationPermission()
                self.skiingViewModel.startUpdatingLocation()

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    guard let lastLocation = self.skiingViewModel.lastLocation else {
                        print("Unable to determine your current country.")
                        return
                    }

                    let geocoder = CLGeocoder()
                    let locale = Locale.current
                    geocoder.reverseGeocodeLocation(lastLocation, preferredLocale: locale) { (placemarks, error) in
                        if let error = error {
                            print("Reverse geocoding error: \(error.localizedDescription)")
                            return
                        }

                        guard let placemark = placemarks?.first else {
                            print("No placemarks found")
                            return
                        }

                        guard let country = placemark.country else {
                            print("No country information in the placemark")
                            return
                        }

                        self.currentCountry = country
                        
                        let phoneNumber = self.skiingViewModel.determineEmergencyNumber(for: country)
                      
                        self.emergencyPhoneNumber = phoneNumber

                        // Send a message to the friend with the entered phone number and location
                        self.sendMessageToFriend(phoneNumber: self.friendPhoneNumberInput, location: lastLocation)
                    }
                }
            }) {
                Text("Call Emergency and Notify Friend")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding()
            }

            if let country = currentCountry {
                Text("Current Country: \(country)")
                    .padding()
            }

            if let phoneNumber = emergencyPhoneNumber {
                Text("Emergency Phone Number: \(phoneNumber)")
                    .padding()
            }
        }
        .padding()
        .sheet(isPresented: $messageDelegate.isShowingMessageComposeView) {
            MessageComposeView(delegate: messageDelegate)
        }
        .sheet(isPresented: $isShowingEmergencyCallView) {
            EmergencyCallView(phoneNumber: emergencyPhoneNumber)
        }
    }

    func sendMessageToFriend(phoneNumber: String, location: CLLocation) {
        let messageBody = "Emergency! I need help. Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)"

        if MFMessageComposeViewController.canSendText() {
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.body = messageBody
            messageComposeViewController.recipients = [phoneNumber]
            messageComposeViewController.messageComposeDelegate = messageDelegate

            UIApplication.shared.windows.first?.rootViewController?.present(messageComposeViewController, animated: true, completion: nil)
        } else {
            print("The device cannot send messages.")
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}





