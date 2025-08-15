//  Created by Adir Burke on 15/8/2025.
//

import Vapor
import SQLKit
import Fluent

struct HealthResponse: Content {
    let status: String
    let service: String
    let version: String
}

public extension Application {
    func addhealth() {
        
        let healthPath = Environment.get("HEALTH_PATH") ?? "/health"
        let serviceName = Environment.get("APP_NAME") ?? "unknown"
        let version = Environment.get("VERSION") ?? "unknown"
        let failure = HealthResponse(status: "degraded", service: serviceName, version: version)
        let ok = HealthResponse(status: "ok", service: serviceName, version: version)
        
        
        self.get("\(healthPath)") { req async throws -> HealthResponse in
            do {
                if let sql = (req.db as? SQLDatabase) {
                    try await sql.raw("SELECT 1").run()
                }
                return ok
            } catch {
                return failure
            }
        }
    }
}
