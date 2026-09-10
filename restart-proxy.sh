#!/bin/bash

# Script to restart the Claude sandbox proxy, for updating the allow-list live

PROJECT_DIR=. docker compose restart proxy
