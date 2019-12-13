# Team Members
Malcolm Craney, Dylan Halland, and Owen Kehlenbeck


# Running the Application

# Option 1
## Using the Run Script
. ./run.sh

# Option 2
## Setting Up Environment Variables
`
export CLASSPATH=$CLASSPATH:mysql-connector-java-8.0.16.jar:.
export LAB7_JDBC_URL=jdbc:mysql://db.labthreesixfive.com/your_username_here?autoReconnect=true&useSSL=false
export LAB7_JDBC_USER=
export LAB7_JDBC_PW=
``

## Compiling
javac *.java

## Running
java Main
