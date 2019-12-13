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

# Known Bugs/Deficiencies
## FR6
Currently, FR6 only works partially. It correctly finds the monthly revenue for each room, split into two columns -
  one for reservations with the same checkin/checkout month, and one for reservations that extend into multiple months.
  It does not add up these "different" and "same" monthly revenues into one, and it also does not add up all months
  into one yearly total.
