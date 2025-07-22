#!/bin/bash

# 8000번 포트 확인
if lsof -i:8000 -t >/dev/null; then
  echo "Port 8000 is in use. Terminating the process..."
  kill $(lsof -i:8000 -t)
  sleep 1
fi

exec java -jar /app/app.jar
