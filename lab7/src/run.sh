#!/bin/sh
export LAB7_JDBC_URL=jdbc:mysql://db.labthreesixfive.com/mjcraney?useSSL=true
export LAB7_JDBC_USER=
export LAB7_JDBC_PW=
javac *.java
java -classpath ./mysql-connector-java-8.0.16.jar:. Main
