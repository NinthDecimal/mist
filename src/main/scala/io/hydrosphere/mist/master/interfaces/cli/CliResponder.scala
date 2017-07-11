package io.hydrosphere.mist.master.interfaces.cli

import akka.pattern.pipe
import akka.actor.{Actor, ActorRef, Props}
import akka.util.Timeout
import io.hydrosphere.mist.Messages.{ListRoutes, RunJobCli, StatusMessages}
import io.hydrosphere.mist.jobs.JobDetails.Source
import io.hydrosphere.mist.master.MasterService
import io.hydrosphere.mist.master.models.JobStartRequest
import io.hydrosphere.mist.utils.Logger

import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global

/**
  * Console interface provider
  */
class CliResponder(
  masterService: MasterService,
  workerManager: ActorRef
) extends Actor with Logger {
  
  implicit val timeout = Timeout.durationToTimeout(10.seconds)

  override def receive: Receive = {
    case ListRoutes =>
      sender ! masterService.routeDefinitions()

    case r: RunJobCli =>
      val req = JobStartRequest(r.endpointId, r.params, r.extId)
      masterService.runJob(req, Source.Cli).pipeTo(sender())

    case StatusMessages.RunningJobs =>
      val f = masterService.activeJobs()
      f.pipeTo(sender())

    case other =>
      workerManager forward other
  }
  
}

object CliResponder {

  def props(masterService: MasterService, workersManager: ActorRef): Props =
    Props(classOf[CliResponder], masterService, workersManager)

}