name: Build and Deploy

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: windows-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '20'

      - name: Install dependencies
        run: yarn install

      - name: Build project
        run: yarn run build

      - name: Deploy to hosting
        run: |
          sed -i "s|NUXT_PUBLIC_BASE_URL.*|NUXT_PUBLIC_BASE_URL=${{ secrets.NUXT_PUBLIC_BASE_URL }}|" .env
          # Hier fügst du den Befehl ein, um deine Website zu deployen, z.B. rsync, FTP usw.
