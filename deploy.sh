#!/bin/bash

# Standard deployment script for ProFolio
echo "🚀 Starting deployment process..."

# 1. Build the web app
echo "📦 Building Flutter Web (Release)..."
flutter build web --release

# 2. Deploy to Firebase
echo "☁️ Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo "✅ Deployment complete!"
