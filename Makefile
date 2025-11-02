PROJECT_DIR=/Users/winsensid/AzurePipelineDemo
DEPLOY=./deploy.sh
FSWATCH_BIN=$(shell which fswatch 2>/dev/null || true)

.PHONY: deploy watch

deploy:
	$(DEPLOY) -o

watch:
	@if [ -n "$(FSWATCH_BIN)" ]; then \
	  echo "Watching $(PROJECT_DIR) for changes (press Ctrl+C to stop)"; \
	  fswatch -o "$(PROJECT_DIR)" | xargs -n1 -I{} $(DEPLOY); \
	else \
	  echo "fswatch not installed. Install with: brew install fswatch"; exit 1; \
	fi
