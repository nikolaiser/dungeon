//> using dep com.lihaoyi::cask::0.9.4
//> using dep com.lihaoyi::mainargs::0.7.5
//> using dep com.lihaoyi::os-lib::0.10.7
//> using dep com.lihaoyi::upickle-core::4.0.1

import io.undertow.Undertow
import io.undertow.server.handlers.BlockingHandler
import cask.*
import cask.main.*
import cask.router.*
import upickle.default.*

class ApiRoutes(hostConfigs: Map[String, String]) extends cask.Routes {

  @cask.get("/v1/boot/:mac")
  def get(mac: String) = {
    hostConfigs
      .get(mac)
      .fold(cask.Response("", statusCode = 404)) { config =>
        println(config)
        cask.Response(config)
      }
  }

  initialize()

}

object ApiMain {

  val executionContext = castor.Context.Simple.executionContext

  implicit val actorContext: castor.Context =
    new castor.Context.Simple(executionContext, log.exception)

  implicit def log: cask.util.Logger = new cask.util.Logger.Console()

  @mainargs.main
  def main(@mainargs.arg(short = 'f') hostsFile: String): Unit = {

    val hostConfigs = read[Map[String, String]](os.read(os.Path(hostsFile)))

    val allRoutes = List(new ApiRoutes(hostConfigs))

    val dispatchTrie = Main.prepareDispatchTrie(allRoutes)

    val handler = new BlockingHandler(
      new Main.DefaultHandler(
        dispatchTrie,
        Nil,
        true,
        Main.defaultHandleNotFound,
        Main.defaultHandleMethodNotAllowed,
        Main.defaultHandleError(_, _, _, true, _)
      )
    )

    val server = Undertow.builder
      .addHttpListener(8181, "localhost")
      .setHandler(handler)
      .build
    server.start()
  }

  def main(args: Array[String]): Unit =
    mainargs.ParserForMethods(this).runOrExit(args)

}
