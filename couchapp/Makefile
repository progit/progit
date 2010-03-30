# TODO: research wildcard targets

en: figures docs
	cp ../en/*/*.markdown ./_docs/

de: figures docs
	cp ../de/*/*.markdown ./_docs/

# add your target language

figures:
	mkdir -p _attachments/figures/
	cp ../figures/* _attachments/figures/

docs:
	mkdir -p _docs

clean:
	git clean -fdx
