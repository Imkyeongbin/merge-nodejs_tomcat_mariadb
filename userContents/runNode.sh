cd /nodeApp && npm run build && PORT=$WEBUI_PORT pm2 start /userContents/ecosystem.config.js --only UI$ALL_CORE
cd /