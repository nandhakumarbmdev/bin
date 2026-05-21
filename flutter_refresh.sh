#!/bin/bash

set -e

echo "Cleaning Flutter project..."
flutter clean

echo "Getting packages..."
flutter pub get

echo "Done."