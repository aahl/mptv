#!/bin/sh

[ -f config.toml ] || cp config.example.toml storage/config.toml && ln -sf storage/config.toml config.toml
uv run streamlit run ./webui/Main.py --browser.serverAddress=127.0.0.1 --server.enableCORS=True --browser.gatherUsageStats=False &
uv run main.py