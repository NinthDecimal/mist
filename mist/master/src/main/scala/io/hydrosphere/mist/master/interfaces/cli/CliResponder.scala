package io.hydrosphere.mist.master.interfaces.cli

import akka.pattern.pipe
import akka.actor.{Actor, ActorRef, Props}
import akka.util.Timeout
import io.hydrosphere.mist.master.{JobDetails, MainService}
import io.hydrosphere.mist.master.Messages.StatusMessages.RunningJobs
import io.hydrosphere.mist.master.Messages.{ListRoutes, RunJobCli}
import io.hydrosphere.mist.master.models.EndpointStartRequest
import io.hydrosphere.mist.utils.Logger

import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global

/**
  * Console interface provider
  */
class CliResponder(
  masterService: MainService,
  workerManager: ActorRef
) extends Actor with Logger {
  
  implicit val timeout = Timeout(10 seconds)

  override def receive: Receive = {
    case ListRoutes =>
      masterService.endpointsInfo.pipeTo(sender())

    case r: RunJobCli =>
      val req = EndpointStartRequest(r.endpointId, r.params, r.extId)
      masterService.runJob(req, JobDetails.Source.Cli).pipeTo(sender())

    case RunningJobs =>
      val f = masterService.jobService.activeJobs()
      f.pipeTo(sender())

    case other =>
      workerManager forward other
  }
  
}

object CliResponder {

  val Name = "cli-responder"

  def props(masterService: MainService, workersManager: ActorRef): Props =
    Props(classOf[CliResponder], masterService, workersManager)

}
