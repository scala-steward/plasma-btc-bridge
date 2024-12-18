package org.plasmalabs.bridge.stubs

import cats.effect.IO
import org.plasmalabs.bridge.consensus.shared.{PeginSessionInfo, PeginSessionState, SessionInfo}
import org.plasmalabs.bridge.consensus.subsystems.monitor.SessionManagerAlgebra

class BaseSessionManagerAlgebra extends SessionManagerAlgebra[IO] {

  override def createNewSession(
    sessionId:   String,
    sessionInfo: SessionInfo
  ): IO[String] = ???

  override def getSession(sessionId: String): IO[Option[SessionInfo]] = ???

  override def updateSession(
    sessionId:              String,
    sessionInfoTransformer: PeginSessionInfo => SessionInfo
  ): IO[Option[SessionInfo]] = ???

  override def removeSession(
    sessionId:  String,
    finalState: PeginSessionState
  ): IO[Unit] = ???

}
