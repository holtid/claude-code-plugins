.PHONY: help install uninstall update

MARKETPLACE = holtid/ai-plugins
MARKETPLACE_NAME = ai-plugins
PLUGIN = holgis@ai-plugins

help:
	@echo "Sendify Plugin Management"
	@echo "========================="
	@echo ""
	@echo "Commands:"
	@echo "  make install    - Install plugin from marketplace"
	@echo "  make uninstall  - Uninstall plugin"
	@echo "  make update     - Update plugin to latest version"

install:
	@echo "Installing Claude Code plugin..."
	claude plugin marketplace add $(MARKETPLACE)
	claude plugin install $(PLUGIN)
	@echo ""
	@echo "Done! To authenticate with Sendify MCP, run /mcp in Claude Code."

uninstall:
	@echo "Uninstalling Claude Code plugin..."
	claude plugin uninstall $(PLUGIN)
	claude plugin marketplace remove $(MARKETPLACE_NAME)
	@echo "Done."

update:
	@echo "Updating Claude Code plugin..."
	claude plugin marketplace update $(MARKETPLACE_NAME)
	claude plugin update $(PLUGIN)
	@echo "Done. Restart Claude Code to apply updates."
