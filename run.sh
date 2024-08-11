#!/bin/bash

MIN_RAM="1G"
MAX_RAM="10G"
SERVER_JAR="server.jar"

# Optional
SERVER_PORT=25565

# Start
java -jar -Xms$MIN_RAM -Xmx$MAX_RAM $SERVER_JAR nogui --port $SERVER_PORT