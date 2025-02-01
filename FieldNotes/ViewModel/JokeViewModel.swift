import Foundation

class JokeViewModel: ObservableObject {
   // Published properties for UI state
   @Published var currentJoke: String = ""
   @Published var isLoading = false
   
   // API configuration
   private let apiKey = "I0Ku0LhJEoLBDUXzbBzlJQ==20e0f1e56jFLeawI"
   
   // Fetch random dad joke from API
   func fetchRandomJoke() {
       print("Fetching joke...")
       isLoading = true
       
       // Configure API request
       let url = URL(string: "https://api.api-ninjas.com/v1/dadjokes")!
       var request = URLRequest(url: url)
       request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
       
       // Execute network request
       let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
           // Ensure loading state is cleared
           defer {
               DispatchQueue.main.async {
                   self?.isLoading = false
               }
           }
           
           // Handle network errors
           if let error = error {
               print("Network error: \(error.localizedDescription)")
               return
           }
           
           // Validate response data
           guard let data = data else {
               print("No data received")
               return
           }
           
           // Parse response and update UI
           do {
               let jokes = try JSONDecoder().decode([Joke].self, from: data)
               DispatchQueue.main.async {
                   if let joke = jokes.first {
                       self?.currentJoke = joke.joke
                       print("Successfully loaded joke: \(joke.joke)")
                   }
               }
           } catch {
               print("Decoding error: \(error)")
               // Debug raw response
               print("Raw response: \(String(data: data, encoding: .utf8) ?? "Unable to read response")")
           }
       }
       task.resume()
   }
}
