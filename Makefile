.PHONY: help install uninstall update

MARKETPLACE = holtid/holgis-plugins
MARKETPLACE_NAME = holgis-plugins
PLUGIN = holgis@holgis-plugins

help:
	@echo "Holgis Plugin Management"
	@echo "========================"
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
	@echo "Done! Run /mcp in Claude Code to configure MCP servers."

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
