package timing

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class TimingSimulation extends Simulation {
  val httpConfiguration = http.baseURL("http://localhost:8888")
  val duration = 8 seconds
  val action = http("index").post("/")
  val default_scenario = scenario("Default request")
      .during(duration) {
        exec(action)
      }
  val extended_scenario = scenario("Extended request")
      .during(duration) {
        exec(action.body(StringBody("""{"now": "2016-10-13T16:08:48.570Z"}""")).asJSON)
      }
  val scenarios = default_scenario.exec(extended_scenario)

  setUp(scenarios.inject(atOnceUsers(8))).protocols(httpConfiguration)
}

