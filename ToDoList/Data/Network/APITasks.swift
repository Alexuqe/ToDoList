

struct APITask: Decodable {
    let id: Int?
    let todo: String
    let completed: Bool
    let userId: Int?
}

struct APITasks: Decodable {
    let todos: [APITask]
    let total: Int?
    let skip: Int?
    let limit: Int?
}

struct APINameTaskStorage {

    static let shared = APINameTaskStorage()

    private init() {}

    let taskTitles = [
        "Do something", "Memorize poem", "Watch movie", "Watch documentary", "Invest cryptocurrency",
        "Contribute code", "Solve Rubik's", "Bake pastries", "See Broadway", "Write letter",
        "Invite friends", "Have scrimmage", "Text friend", "Organize pantry", "Buy decoration",
        "Plan vacation", "Clean car", "Draw Mandala", "Create cookbook", "Bake pie",
        "Create compost", "Take hike", "Take class", "Research topic", "Plan trip",
        "Improve typing", "Learn Express.js", "Learn calligraphy", "Have session", "Go gym"
    ]
}
