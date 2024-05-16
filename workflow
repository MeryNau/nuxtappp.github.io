name: Deploy Nuxt.js App

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: windows-latest

    steps:
      - uses: actions/checkout@v3

      - name: Set up Node.js (optional)
        uses: actions/setup-node@v3
        with:
          cache: 'npm'
          node-version: 'v16.x'

      - name: Install dependencies
        run: yarn install

      - name: Build project
        run: yarn run build

      - name: Generate static content (optional)
        run: yarn run generate

      - name: Set environment variable
        run: echo "NUXT_PUBLIC_BASE_URL=${{ secrets.NUXT_PUBLIC_BASE_URL }}" >> .env

      - name: Deploy to external hosting
        run: rsync -avz --delete dist/ user@host:/path/to/destination
        env:
          NUXT_DEPLOY_TOKEN: ${{ secrets.NUXT_DEPLOY_TOKEN }}  # Use the PAT instead of SSH_KEY
