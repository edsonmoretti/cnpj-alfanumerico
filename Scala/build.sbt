name := "cnpj-alfanumerico"
version := "0.1.0"
scalaVersion := "2.13.8"

organization := "com.edsonmoretti"
description := "Validação e cálculo de dígitos verificadores para CNPJ alfanumérico"

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "3.2.14" % Test
)

Compile / mainClass := Some("com.edsonmoretti.cnpj.Main")

assembly / assemblyJarName := "cnpj-alfanumerico.jar"
