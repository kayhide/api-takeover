dev:
	ghcid --command "stack ghci --ghci-options -fdiagnostics-color=always" --test "DevMain.run"
.PHONY: dev

watch:
	stack build --fast --file-watch
.PHONY: dev

benchmark:
	@echo "*** Requesting to the old server"
	@echo
	httperf --port=4567 --num-calls=500 --uri=/
	@echo
	@echo "*** Requesting to the new server"
	@echo
	httperf --port=8080 --num-calls=500 --uri=/
.PHONY: benchmark
