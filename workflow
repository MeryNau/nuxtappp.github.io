name: Build and Deploy Nuxt.js App

on:
  push:
    branches: [ main ]  # Trigger on pushes to the main branch

jobs:
  build-and-deploy:
    runs-on: windows-latest  # Run on Windows machines

    steps:
      - uses: actions/checkout@v3  # Checkout repository code (latest version)

      - name: Set up Node.js (optional)
        uses: actions/setup-node@v3  # Set up Node.js if not pre-installed (latest version)
        with:
          cache: 'npm'  # Cache dependencies for faster builds (optional)
          node-version: 'v20.10.0'  # Or adjust based on project requirements

      - name: Install dependencies
        run: yarn install  # Install dependencies using Yarn

      - name: Build project
        run: yarn run build  # Build the Nuxt.js application

      - name: Generate static content (optional)
        run: yarn run generate  # Generate static content (if using SSG)

      - name: Set environment variable
        run: echo "NUXT_PUBLIC_BASE_URL=${{ secrets.NUXT_PUBLIC_BASE_URL }}" >> .env

      - name: Deploy to GitHub Pages (if applicable)
        uses: JamesIves/deploy-pages@v4.3.1  # Use the latest stable action
        with:
          ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}  # Use personal access token with repo scope
          FOLDER: dist  # Specify the build output folder
          BRANCH: main  # Deploy to the gh-pages branch by default

      - name: Deploy to external hosting (optional)
        run: rsync -avz --delete dist/ user@host:/path/to/destination
        env:  NUXT_PUBLIC_BASE_URL: ${{ secrets.NUXT_PUBLIC_BASE_URL }}
          # Replace with your actual deployment command and environment variables
          # (e.g., NUXT_DEPLOY_TOKEN for a personal access token)
